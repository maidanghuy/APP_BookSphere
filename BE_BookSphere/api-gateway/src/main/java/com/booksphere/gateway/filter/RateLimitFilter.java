package com.booksphere.gateway.filter;

import com.booksphere.gateway.config.RateLimitProperties;
import com.booksphere.gateway.config.RateLimitProperties.Policy;
import com.booksphere.gateway.dto.ApiResponse;
import com.booksphere.gateway.dto.ApiResponse.ErrorDetail;
import com.booksphere.gateway.resolver.RateLimitKeyResolver;
import com.booksphere.gateway.resolver.RateLimitKeyResolver.ResolvedKey;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import java.time.Duration;
import java.time.Instant;
import java.time.ZoneOffset;
import java.time.format.DateTimeFormatter;
import java.util.Comparator;
import java.util.List;
import java.util.Optional;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.cloud.gateway.filter.GatewayFilterChain;
import org.springframework.cloud.gateway.filter.GlobalFilter;
import org.springframework.core.Ordered;
import org.springframework.data.redis.core.ReactiveStringRedisTemplate;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.server.PathContainer;
import org.springframework.stereotype.Component;
import org.springframework.web.server.ServerWebExchange;
import org.springframework.web.util.pattern.PathPatternParser;
import reactor.core.publisher.Mono;

@Component
public class RateLimitFilter implements GlobalFilter, Ordered {

    private static final Logger log = LoggerFactory.getLogger(RateLimitFilter.class);
    private static final String RATE_LIMIT_EXCEEDED = "RATE_LIMIT_EXCEEDED";
    private static final Duration MINUTE_TTL = Duration.ofSeconds(70);
    private static final Duration HOUR_TTL = Duration.ofSeconds(3700);
    private static final DateTimeFormatter MINUTE_FORMATTER = DateTimeFormatter.ofPattern("yyyyMMddHHmm")
            .withZone(ZoneOffset.UTC);
    private static final DateTimeFormatter HOUR_FORMATTER = DateTimeFormatter.ofPattern("yyyyMMddHH")
            .withZone(ZoneOffset.UTC);
    private static final PathPatternParser PATH_PATTERN_PARSER = new PathPatternParser();

    private final ReactiveStringRedisTemplate redisTemplate;
    private final RateLimitProperties rateLimitProperties;
    private final RateLimitKeyResolver keyResolver;
    private final ObjectMapper objectMapper;

    public RateLimitFilter(
            ReactiveStringRedisTemplate redisTemplate,
            RateLimitProperties rateLimitProperties,
            RateLimitKeyResolver keyResolver,
            ObjectMapper objectMapper
    ) {
        this.redisTemplate = redisTemplate;
        this.rateLimitProperties = rateLimitProperties;
        this.keyResolver = keyResolver;
        this.objectMapper = objectMapper;
    }

    @Override
    public Mono<Void> filter(ServerWebExchange exchange, GatewayFilterChain chain) {
        String path = exchange.getRequest().getPath().pathWithinApplication().value();
        HttpMethod method = exchange.getRequest().getMethod();

        if (!rateLimitProperties.isEnabled() || isInternalPath(path)) {
            return chain.filter(exchange);
        }

        Optional<Policy> matchedPolicy = findPolicy(method, path);
        if (matchedPolicy.isEmpty()) {
            return chain.filter(exchange);
        }

        Policy policy = matchedPolicy.get();
        ResolvedKey resolvedKey = keyResolver.resolve(exchange, policy.getKeyType());
        Instant now = Instant.now();

        String minuteKey = redisKey(policy, resolvedKey, "minute", MINUTE_FORMATTER.format(now));
        String hourKey = redisKey(policy, resolvedKey, "hour", HOUR_FORMATTER.format(now));

        return Mono.zip(
                        incrementCounter(minuteKey, MINUTE_TTL),
                        incrementCounter(hourKey, HOUR_TTL)
                )
                .flatMap(counts -> {
                    long minuteCount = counts.getT1();
                    long hourCount = counts.getT2();
                    addRateLimitHeaders(exchange, policy, minuteCount, hourCount);

                    if (minuteCount > policy.getLimitPerMinute() || hourCount > policy.getLimitPerHour()) {
                        log.warn(
                                "Rate limit exceeded: method={}, path={}, policy={}, keyType={}, key={}, ipAddress={}, userId={}, minuteCount={}/{}, hourCount={}/{}, timestamp={}",
                                methodName(method),
                                path,
                                policy.getId(),
                                policy.getKeyType(),
                                resolvedKey.key(),
                                resolvedKey.ipAddress(),
                                resolvedKey.userId(),
                                minuteCount,
                                policy.getLimitPerMinute(),
                                hourCount,
                                policy.getLimitPerHour(),
                                now
                        );
                        return writeRateLimitResponse(exchange, path);
                    }

                    return chain.filter(exchange);
                })
                .onErrorResume(exception -> {
                    log.warn(
                            "Rate limit check failed, allowing request: method={}, path={}, error={}",
                            methodName(method),
                            path,
                            exception.getMessage(),
                            exception
                    );
                    return chain.filter(exchange);
                });
    }

    private Optional<Policy> findPolicy(HttpMethod method, String path) {
        return rateLimitProperties.getPolicies().stream()
                .filter(policy -> isValidPolicy(policy) && policy.matchesMethod(method))
                .filter(policy -> matchesPath(policy.getPath(), path))
                .max(Comparator.comparingInt(this::specificity));
    }

    private boolean isValidPolicy(Policy policy) {
        return policy.getId() != null
                && !policy.getId().isBlank()
                && policy.getPath() != null
                && !policy.getPath().isBlank()
                && policy.getLimitPerMinute() > 0
                && policy.getLimitPerHour() > 0;
    }

    private boolean matchesPath(String pattern, String path) {
        try {
            return PATH_PATTERN_PARSER.parse(pattern).matches(PathContainer.parsePath(path));
        } catch (IllegalArgumentException exception) {
            log.warn("Invalid rate limit path pattern: {}", pattern, exception);
            return false;
        }
    }

    private int specificity(Policy policy) {
        String path = policy.getPath();
        int wildcardPenalty = count(path, '*') * 100 + count(path, '{') * 50;
        int defaultPenalty = "/**".equals(path) ? 10_000 : 0;
        int exactBonus = wildcardPenalty == 0 ? 1_000 : 0;
        return exactBonus + path.length() - wildcardPenalty - defaultPenalty;
    }

    private int count(String value, char character) {
        int count = 0;
        for (int index = 0; index < value.length(); index++) {
            if (value.charAt(index) == character) {
                count++;
            }
        }
        return count;
    }

    private Mono<Long> incrementCounter(String key, Duration ttl) {
        return redisTemplate.opsForValue()
                .increment(key)
                .flatMap(count -> {
                    if (count != null && count == 1) {
                        return redisTemplate.expire(key, ttl)
                                .doOnNext(expired -> {
                                    if (!Boolean.TRUE.equals(expired)) {
                                        log.warn("Rate limit Redis key expire was not set: key={}", key);
                                    }
                                })
                                .thenReturn(count);
                    }
                    return Mono.just(count == null ? 0 : count);
                });
    }

    private String redisKey(Policy policy, ResolvedKey resolvedKey, String window, String timestamp) {
        return "booksphere:rate-limit:%s:%s:%s:%s".formatted(
                sanitize(policy.getId()),
                sanitize(resolvedKey.key()),
                window,
                timestamp
        );
    }

    private String sanitize(String value) {
        if (value == null || value.isBlank()) {
            return "unknown";
        }
        return value.replaceAll("[^A-Za-z0-9:_@.\\-]", "_");
    }

    private void addRateLimitHeaders(ServerWebExchange exchange, Policy policy, long minuteCount, long hourCount) {
        HttpHeaders headers = exchange.getResponse().getHeaders();
        headers.set("X-RateLimit-Limit-Minute", String.valueOf(policy.getLimitPerMinute()));
        headers.set("X-RateLimit-Remaining-Minute", String.valueOf(Math.max(0, policy.getLimitPerMinute() - minuteCount)));
        headers.set("X-RateLimit-Limit-Hour", String.valueOf(policy.getLimitPerHour()));
        headers.set("X-RateLimit-Remaining-Hour", String.valueOf(Math.max(0, policy.getLimitPerHour() - hourCount)));
    }

    private Mono<Void> writeRateLimitResponse(ServerWebExchange exchange, String path) {
        HttpStatus status = HttpStatus.TOO_MANY_REQUESTS;
        exchange.getResponse().setStatusCode(status);
        exchange.getResponse().getHeaders().setContentType(MediaType.APPLICATION_JSON);

        ApiResponse<Void> response = ApiResponse.failure(
                "Too many requests. Please try again later.",
                List.of(new ErrorDetail(RATE_LIMIT_EXCEEDED, "Rate limit exceeded for this route.")),
                path,
                status.value()
        );

        byte[] bytes = serialize(response);
        return exchange.getResponse().writeWith(
                Mono.just(exchange.getResponse().bufferFactory().wrap(bytes))
        );
    }

    private byte[] serialize(ApiResponse<Void> response) {
        try {
            return objectMapper.writeValueAsBytes(response);
        } catch (JsonProcessingException exception) {
            return "{\"success\":false,\"message\":\"Too many requests. Please try again later.\",\"errors\":[{\"code\":\"RATE_LIMIT_EXCEEDED\",\"message\":\"Rate limit exceeded for this route.\"}],\"status\":429}".getBytes();
        }
    }

    private boolean isInternalPath(String path) {
        return "/internal".equals(path) || path.startsWith("/internal/");
    }

    private String methodName(HttpMethod method) {
        return method == null ? "UNKNOWN" : method.name();
    }

    @Override
    public int getOrder() {
        return Ordered.HIGHEST_PRECEDENCE + 20;
    }
}
