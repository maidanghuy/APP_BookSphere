package com.booksphere.gateway.filter;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.core.Ordered;
import org.springframework.http.HttpMethod;
import org.springframework.http.HttpStatusCode;
import org.springframework.stereotype.Component;
import org.springframework.web.server.ServerWebExchange;
import org.springframework.web.server.WebFilter;
import org.springframework.web.server.WebFilterChain;
import reactor.core.publisher.Mono;
import reactor.core.publisher.SignalType;

@Component
public class RequestLoggingFilter implements WebFilter, Ordered {

    private static final Logger log = LoggerFactory.getLogger(RequestLoggingFilter.class);

    @Override
    public Mono<Void> filter(ServerWebExchange exchange, WebFilterChain chain) {
        HttpMethod requestMethod = exchange.getRequest().getMethod();
        String method = requestMethod != null ? requestMethod.name() : "UNKNOWN";
        String path = exchange.getRequest().getPath().pathWithinApplication().value();
        long startTime = System.currentTimeMillis();

        return chain.filter(exchange)
                .doOnError(error -> logRequest(exchange, method, path, startTime))
                .doFinally(signalType -> {
                    if (signalType != SignalType.ON_ERROR) {
                        logRequest(exchange, method, path, startTime);
                    }
                });
    }

    private void logRequest(ServerWebExchange exchange, String method, String path, long startTime) {
        HttpStatusCode statusCode = exchange.getResponse().getStatusCode();
        int responseStatus = statusCode != null ? statusCode.value() : 200;
        long duration = System.currentTimeMillis() - startTime;

        log.info("Gateway request: method={}, path={}, status={}, duration={}ms",
                method, path, responseStatus, duration);
    }

    @Override
    public int getOrder() {
        return Ordered.HIGHEST_PRECEDENCE;
    }
}
