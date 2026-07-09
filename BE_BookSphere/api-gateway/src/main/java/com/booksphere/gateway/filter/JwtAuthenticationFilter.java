package com.booksphere.gateway.filter;

import com.booksphere.gateway.security.JwtService;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import io.jsonwebtoken.Claims;
import io.jsonwebtoken.ExpiredJwtException;
import io.jsonwebtoken.JwtException;
import java.time.Instant;
import java.util.Collection;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;
import org.springframework.core.Ordered;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.server.reactive.ServerHttpRequest;
import org.springframework.stereotype.Component;
import org.springframework.web.server.ServerWebExchange;
import org.springframework.web.server.WebFilter;
import org.springframework.web.server.WebFilterChain;
import reactor.core.publisher.Mono;

@Component
public class JwtAuthenticationFilter implements WebFilter, Ordered {

    private static final String BEARER_PREFIX = "Bearer ";
    private static final Set<String> PUBLIC_AUTH_ENDPOINTS = Set.of(
            "/api/auth/register",
            "/api/auth/login",
            "/api/auth/refresh",
            "/api/auth/logout"
    );

    private final JwtService jwtService;
    private final ObjectMapper objectMapper;

    public JwtAuthenticationFilter(JwtService jwtService, ObjectMapper objectMapper) {
        this.jwtService = jwtService;
        this.objectMapper = objectMapper;
    }

    @Override
    public Mono<Void> filter(ServerWebExchange exchange, WebFilterChain chain) {
        if (!requiresAuthentication(exchange)) {
            return chain.filter(exchange);
        }

        String authorizationHeader = exchange.getRequest().getHeaders().getFirst(HttpHeaders.AUTHORIZATION);
        if (authorizationHeader == null || !authorizationHeader.startsWith(BEARER_PREFIX)) {
            return writeUnauthorizedResponse(
                    exchange,
                    "AUTH_TOKEN_MISSING",
                    "Missing Authorization header."
            );
        }

        String token = authorizationHeader.substring(BEARER_PREFIX.length());

        try {
            Claims claims = jwtService.parseAccessToken(token);
            ServerHttpRequest request = exchange.getRequest().mutate()
                    .header("X-User-Id", requiredClaim(claims, "userId"))
                    .header("X-Username", requiredClaim(claims, "username"))
                    .header("X-User-Email", requiredClaim(claims, "email"))
                    .header("X-User-Role", rolesHeader(claims.get("roles")))
                    .build();

            return chain.filter(exchange.mutate().request(request).build());
        } catch (ExpiredJwtException exception) {
            return writeUnauthorizedResponse(
                    exchange,
                    "AUTH_TOKEN_EXPIRED",
                    "Access token is expired or invalid."
            );
        } catch (JwtException | IllegalArgumentException exception) {
            return writeUnauthorizedResponse(
                    exchange,
                    "AUTH_TOKEN_INVALID",
                    "Access token is expired or invalid."
            );
        }
    }

    private boolean requiresAuthentication(ServerWebExchange exchange) {
        String path = exchange.getRequest().getPath().pathWithinApplication().value();
        HttpMethod method = exchange.getRequest().getMethod();

        if (HttpMethod.OPTIONS.equals(method)) {
            return false;
        }

        if (HttpMethod.GET.equals(method) && "/actuator/health".equals(path)) {
            return false;
        }

        if (HttpMethod.POST.equals(method) && PUBLIC_AUTH_ENDPOINTS.contains(path)) {
            return false;
        }

        return path.startsWith("/api/");
    }

    private String requiredClaim(Claims claims, String claimName) {
        Object value = claims.get(claimName);
        if (value == null || value.toString().isBlank()) {
            throw new IllegalArgumentException("Missing JWT claim: " + claimName);
        }

        return value.toString();
    }

    private String rolesHeader(Object rolesClaim) {
        if (rolesClaim instanceof Collection<?> roles) {
            return roles.stream()
                    .map(String::valueOf)
                    .filter(role -> !role.isBlank())
                    .collect(Collectors.joining(","));
        }

        if (rolesClaim == null || rolesClaim.toString().isBlank()) {
            throw new IllegalArgumentException("Missing JWT claim: roles");
        }

        return rolesClaim.toString();
    }

    private Mono<Void> writeUnauthorizedResponse(
            ServerWebExchange exchange,
            String errorCode,
            String errorMessage
    ) {
        HttpStatus status = HttpStatus.UNAUTHORIZED;
        exchange.getResponse().setStatusCode(status);
        exchange.getResponse().getHeaders().setContentType(MediaType.APPLICATION_JSON);

        GatewayErrorResponse response = new GatewayErrorResponse(
                false,
                "Unauthorized.",
                null,
                List.of(new GatewayError(errorCode, errorMessage)),
                Instant.now(),
                exchange.getRequest().getPath().pathWithinApplication().value(),
                status.value()
        );

        byte[] bytes = serializeResponse(response);
        return exchange.getResponse().writeWith(
                Mono.just(exchange.getResponse().bufferFactory().wrap(bytes))
        );
    }

    private byte[] serializeResponse(GatewayErrorResponse response) {
        try {
            return objectMapper.writeValueAsBytes(response);
        } catch (JsonProcessingException exception) {
            return "{\"success\":false,\"message\":\"Unauthorized.\",\"status\":401}".getBytes();
        }
    }

    @Override
    public int getOrder() {
        return Ordered.HIGHEST_PRECEDENCE + 2;
    }

    private record GatewayError(String code, String message) {
    }

    private record GatewayErrorResponse(
            boolean success,
            String message,
            Object data,
            List<GatewayError> errors,
            Instant timestamp,
            String path,
            int status
    ) {
    }
}
