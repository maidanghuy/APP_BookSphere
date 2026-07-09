package com.booksphere.fine.config;

import org.springframework.cloud.openfeign.EnableFeignClients;
import org.springframework.context.annotation.Configuration;

@Configuration
@EnableFeignClients(basePackages = "com.booksphere.fine.client")
public class FeignConfig {
}
