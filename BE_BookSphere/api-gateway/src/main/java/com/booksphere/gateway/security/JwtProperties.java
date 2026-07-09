package com.booksphere.gateway.security;

import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.stereotype.Component;

@Component
@ConfigurationProperties(prefix = "booksphere.jwt")
public class JwtProperties {

    private String secret;
    private long accessTokenExpirationMinutes = 15;

    public String getSecret() {
        return secret;
    }

    public void setSecret(String secret) {
        this.secret = secret;
    }

    public long getAccessTokenExpirationMinutes() {
        return accessTokenExpirationMinutes;
    }

    public void setAccessTokenExpirationMinutes(long accessTokenExpirationMinutes) {
        this.accessTokenExpirationMinutes = accessTokenExpirationMinutes;
    }
}
