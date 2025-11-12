package com.microservices.review;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cache.annotation.EnableCaching;
import org.springframework.cloud.client.discovery.EnableDiscoveryClient;

/**
 * Review Service Application
 * Ürün değerlendirme ve yorum yönetimi için microservice
 * 
 * Özellikler:
 * - Ürün yorumları ve değerlendirmeleri
 * - Rating hesaplama ve özet bilgiler
 * - Review moderation
 * - Review helpful votes
 */
@SpringBootApplication
@EnableDiscoveryClient  // Eureka'ya kayıt olmak için
@EnableCaching         // Cache aktif et
public class ReviewServiceApplication {

    public static void main(String[] args) {
        SpringApplication.run(ReviewServiceApplication.class, args);
    }
}

