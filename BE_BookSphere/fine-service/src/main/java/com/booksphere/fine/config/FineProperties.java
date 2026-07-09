package com.booksphere.fine.config;

import java.math.BigDecimal;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.context.annotation.Configuration;

@Configuration
@ConfigurationProperties(prefix = "booksphere.fine")
public class FineProperties {

    private BigDecimal amountPerDay = new BigDecimal("5000");

    public BigDecimal getAmountPerDay() {
        return amountPerDay;
    }

    public void setAmountPerDay(BigDecimal amountPerDay) {
        this.amountPerDay = amountPerDay;
    }
}
