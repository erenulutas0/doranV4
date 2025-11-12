package com.microservices.product.Config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.client.RestTemplate;

/**
 * RestTemplate Configuration
 * Rating senkronizasyonu için RestTemplate bean'i
 */
@Configuration
public class RestTemplateConfig {
    
    @Bean
    public RestTemplate restTemplate() {
        return new RestTemplate();
    }
}

