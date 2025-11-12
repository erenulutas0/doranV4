package com.microservices.product.Config;

import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.PropertyNamingStrategies;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Primary;
import org.springframework.http.converter.json.Jackson2ObjectMapperBuilder;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

/**
 * Jackson Configuration
 * JSON serialization ayarları
 */
@Configuration
public class JacksonConfig implements WebMvcConfigurer {

    @Bean
    @Primary
    public Jackson2ObjectMapperBuilder jackson2ObjectMapperBuilder() {
        Jackson2ObjectMapperBuilder builder = new Jackson2ObjectMapperBuilder();
        builder.serializationInclusion(JsonInclude.Include.ALWAYS); // Null değerleri de serialize et
        builder.propertyNamingStrategy(PropertyNamingStrategies.LOWER_CAMEL_CASE);
        return builder;
    }
    
    @Bean
    @Primary
    public ObjectMapper objectMapper(Jackson2ObjectMapperBuilder builder) {
        return builder.build();
    }
}

