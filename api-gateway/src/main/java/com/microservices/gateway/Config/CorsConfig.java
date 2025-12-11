package com.microservices.gateway.Config;

import org.springframework.boot.context.properties.EnableConfigurationProperties;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.cors.CorsConfiguration;
import org.springframework.web.cors.reactive.CorsWebFilter;
import org.springframework.web.cors.reactive.UrlBasedCorsConfigurationSource;

import java.util.Arrays;
import java.util.List;
import java.util.Objects;

/**
 * Global CORS Configuration for API Gateway
 * 
 * This configuration allows cross-origin requests from Flutter app
 * and other frontend applications.
 */
@Configuration
@EnableConfigurationProperties(CorsProps.class)
public class CorsConfig {

    private final CorsProps corsProps;

    public CorsConfig(CorsProps corsProps) {
        this.corsProps = corsProps;
    }

    @Bean
    public CorsWebFilter corsWebFilter() {
        CorsConfiguration corsConfig = new CorsConfiguration();
        
        // Prefer explicit origins; if not set, fall back to allow-all for dev
        if (corsProps.getAllowedOrigins() != null && !corsProps.getAllowedOrigins().isEmpty()) {
            corsConfig.setAllowedOrigins(corsProps.getAllowedOrigins());
        } else {
            corsConfig.setAllowedOriginPatterns(List.of("*"));
        }
        
        // Allowed methods
        if (corsProps.getAllowedMethods() != null && !corsProps.getAllowedMethods().isEmpty()) {
            corsConfig.setAllowedMethods(corsProps.getAllowedMethods());
        } else {
            corsConfig.setAllowedMethods(Arrays.asList("GET", "POST", "PUT", "PATCH", "DELETE", "OPTIONS", "HEAD"));
        }
        
        // Allowed headers
        if (corsProps.getAllowedHeaders() != null && !corsProps.getAllowedHeaders().isEmpty()) {
            corsConfig.setAllowedHeaders(corsProps.getAllowedHeaders());
        } else {
            corsConfig.setAllowedHeaders(List.of("*"));
        }
        
        // Expose custom headers to client
        if (corsProps.getExposedHeaders() != null && !corsProps.getExposedHeaders().isEmpty()) {
            corsConfig.setExposedHeaders(corsProps.getExposedHeaders());
        } else {
            corsConfig.setExposedHeaders(Arrays.asList(
                "X-RateLimit-Remaining",
                "X-RateLimit-Limit", 
                "X-RateLimit-Reset",
                "X-Content-Type-Options",
                "X-Frame-Options"
            ));
        }
        
        // Allow credentials (cookies, authorization headers)
        corsConfig.setAllowCredentials(Objects.requireNonNullElse(corsProps.getAllowCredentials(), true));
        
        // Cache preflight response for 1 hour
        corsConfig.setMaxAge(Objects.requireNonNullElse(corsProps.getMaxAge(), 3600L));
        
        UrlBasedCorsConfigurationSource source = new UrlBasedCorsConfigurationSource();
        source.registerCorsConfiguration("/**", corsConfig);
        
        return new CorsWebFilter(source);
    }
}


