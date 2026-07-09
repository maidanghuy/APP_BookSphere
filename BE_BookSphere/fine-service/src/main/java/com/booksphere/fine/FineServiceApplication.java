package com.booksphere.fine;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cloud.client.discovery.EnableDiscoveryClient;

@EnableDiscoveryClient
@SpringBootApplication
public class FineServiceApplication {

    public static void main(String[] args) {
        SpringApplication.run(FineServiceApplication.class, args);
    }
}
