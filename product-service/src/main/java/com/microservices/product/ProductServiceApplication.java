package com.microservices.product;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cloud.client.discovery.EnableDiscoveryClient;
import org.springframework.scheduling.annotation.EnableScheduling;

/**
 * Product Service Application
 * Ürün yönetimi için microservice
 */
@SpringBootApplication
@EnableDiscoveryClient  // Eureka'ya kayıt olmak için
@EnableScheduling  // Scheduled job'lar için
public class ProductServiceApplication {

    public static void main(String[] args) {
        SpringApplication.run(ProductServiceApplication.class, args);
    }
}

