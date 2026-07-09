package com.booksphere.gateway.resolver;

import com.booksphere.gateway.config.RateLimitProperties.KeyType;
import java.net.InetSocketAddress;
import org.springframework.http.HttpHeaders;
import org.springframework.stereotype.Component;
import org.springframework.web.server.ServerWebExchange;

@Component
public class RateLimitKeyResolver {

    private static final String USER_ID_HEADER = "X-User-Id";
    private static final String FORWARDED_FOR_HEADER = "X-Forwarded-For";
    private static final String REAL_IP_HEADER = "X-Real-IP";

    public ResolvedKey resolve(ServerWebExchange exchange, KeyType keyType) {
        String ipAddress = resolveIpAddress(exchange);
        String userId = resolveUserId(exchange);

        if (KeyType.IP.equals(keyType)) {
            return new ResolvedKey("ip:" + ipAddress, ipAddress, userId);
        }

        if ((KeyType.USER.equals(keyType) || KeyType.IP_OR_USER.equals(keyType)) && !userId.isBlank()) {
            return new ResolvedKey("user:" + userId, ipAddress, userId);
        }

        return new ResolvedKey("ip:" + ipAddress, ipAddress, userId);
    }

    public String resolveUserId(ServerWebExchange exchange) {
        String userId = exchange.getRequest().getHeaders().getFirst(USER_ID_HEADER);
        return userId == null ? "" : userId.trim();
    }

    public String resolveIpAddress(ServerWebExchange exchange) {
        HttpHeaders headers = exchange.getRequest().getHeaders();

        String forwardedFor = headers.getFirst(FORWARDED_FOR_HEADER);
        if (forwardedFor != null && !forwardedFor.isBlank()) {
            return forwardedFor.split(",")[0].trim();
        }

        String realIp = headers.getFirst(REAL_IP_HEADER);
        if (realIp != null && !realIp.isBlank()) {
            return realIp.trim();
        }

        InetSocketAddress remoteAddress = exchange.getRequest().getRemoteAddress();
        if (remoteAddress != null && remoteAddress.getAddress() != null) {
            return remoteAddress.getAddress().getHostAddress();
        }
        if (remoteAddress != null && remoteAddress.getHostString() != null && !remoteAddress.getHostString().isBlank()) {
            return remoteAddress.getHostString();
        }

        return "unknown";
    }

    public record ResolvedKey(String key, String ipAddress, String userId) {
    }
}
