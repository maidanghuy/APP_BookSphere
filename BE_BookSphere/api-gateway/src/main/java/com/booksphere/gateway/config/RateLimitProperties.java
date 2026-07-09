package com.booksphere.gateway.config;

import java.util.ArrayList;
import java.util.List;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.http.HttpMethod;

@ConfigurationProperties(prefix = "booksphere.rate-limit")
public class RateLimitProperties {

    private boolean enabled = true;
    private List<Policy> policies = new ArrayList<>();

    public boolean isEnabled() {
        return enabled;
    }

    public void setEnabled(boolean enabled) {
        this.enabled = enabled;
    }

    public List<Policy> getPolicies() {
        return policies;
    }

    public void setPolicies(List<Policy> policies) {
        this.policies = policies;
    }

    public enum KeyType {
        IP,
        USER,
        IP_OR_USER
    }

    public static class Policy {

        private String id;
        private String method = "ALL";
        private String path;
        private KeyType keyType = KeyType.IP_OR_USER;
        private int limitPerMinute;
        private int limitPerHour;

        public String getId() {
            return id;
        }

        public void setId(String id) {
            this.id = id;
        }

        public String getMethod() {
            return method;
        }

        public void setMethod(String method) {
            this.method = method;
        }

        public String getPath() {
            return path;
        }

        public void setPath(String path) {
            this.path = path;
        }

        public KeyType getKeyType() {
            return keyType;
        }

        public void setKeyType(KeyType keyType) {
            this.keyType = keyType;
        }

        public int getLimitPerMinute() {
            return limitPerMinute;
        }

        public void setLimitPerMinute(int limitPerMinute) {
            this.limitPerMinute = limitPerMinute;
        }

        public int getLimitPerHour() {
            return limitPerHour;
        }

        public void setLimitPerHour(int limitPerHour) {
            this.limitPerHour = limitPerHour;
        }

        public boolean matchesMethod(HttpMethod requestMethod) {
            if (method == null || method.isBlank() || "ALL".equalsIgnoreCase(method)) {
                return true;
            }

            return requestMethod != null && method.equalsIgnoreCase(requestMethod.name());
        }
    }
}
