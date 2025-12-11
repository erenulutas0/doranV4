package com.microservices.order.Config;

import org.springframework.amqp.core.Binding;
import org.springframework.amqp.core.BindingBuilder;
import org.springframework.amqp.core.DirectExchange;
import org.springframework.amqp.core.Queue;
import org.springframework.amqp.rabbit.connection.ConnectionFactory;
import org.springframework.amqp.rabbit.core.RabbitTemplate;
import org.springframework.amqp.support.converter.Jackson2JsonMessageConverter;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.datatype.jsr310.JavaTimeModule;

import java.util.HashMap;
import java.util.Map;

/**
 * RabbitMQ Configuration
 * 
 * Exchange, Queue'ları ve message converter'ı yapılandırır
 * 
 * Exchange:
 * - order.events.exchange: Tüm order event'lerinin gönderildiği exchange
 * 
 * Queue'lar:
 * - order.created: Sipariş oluşturulduğunda gönderilir
 * - order.status.changed: Sipariş durumu değiştiğinde gönderilir
 */
@Configuration
public class RabbitMQConfig {

    // Exchange ismi (Notification Service ile aynı olmalı)
    public static final String ORDER_EXCHANGE = "order.events.exchange";
    public static final String ORDER_DLX = "order.events.dlx";
    
    // Routing Key'ler (Notification Service ile aynı olmalı)
    public static final String ROUTING_KEY_CREATED = "order.created.key";
    public static final String ROUTING_KEY_STATUS_CHANGED = "order.status.changed.key";
    public static final String ROUTING_KEY_DLQ = "order.dlq";
    
    // Queue isimleri
    public static final String ORDER_CREATED_QUEUE = "order.created";
    public static final String ORDER_STATUS_CHANGED_QUEUE = "order.status.changed";
    public static final String ORDER_CREATED_DLQ = "order.created.dlq";
    public static final String ORDER_STATUS_CHANGED_DLQ = "order.status.changed.dlq";

    /**
     * Order Created Queue
     * Sipariş oluşturulduğunda mesaj gönderilir
     */
    @Bean
    public Queue orderCreatedQueue() {
        Map<String, Object> args = new HashMap<>();
        args.put("x-dead-letter-exchange", ORDER_DLX);
        args.put("x-dead-letter-routing-key", ROUTING_KEY_DLQ);
        return new Queue(ORDER_CREATED_QUEUE, true, false, false, args);  // durable: true
    }

    /**
     * Order Status Changed Queue
     * Sipariş durumu değiştiğinde mesaj gönderilir
     */
    @Bean
    public Queue orderStatusChangedQueue() {
        Map<String, Object> args = new HashMap<>();
        args.put("x-dead-letter-exchange", ORDER_DLX);
        args.put("x-dead-letter-routing-key", ROUTING_KEY_DLQ);
        return new Queue(ORDER_STATUS_CHANGED_QUEUE, true, false, false, args);
    }

    /**
     * Direct Exchange
     * Tüm order event'lerinin gönderildiği exchange
     */
    @Bean
    public DirectExchange orderExchange() {
        return new DirectExchange(ORDER_EXCHANGE, true, false); // durable: true, auto-delete: false
    }

    @Bean
    public DirectExchange orderDlx() {
        return new DirectExchange(ORDER_DLX, true, false);
    }

    /**
     * Order Created Queue Binding
     * order.created queue'sunu exchange'e bağlar
     */
    @Bean
    public Binding orderCreatedBinding(@Qualifier("orderCreatedQueue") Queue orderCreatedQueue, DirectExchange orderExchange) {
        return BindingBuilder.bind(orderCreatedQueue)
                             .to(orderExchange)
                             .with(ROUTING_KEY_CREATED);
    }

    /**
     * Order Status Changed Queue Binding
     * order.status.changed queue'sunu exchange'e bağlar
     */
    @Bean
    public Binding orderStatusChangedBinding(@Qualifier("orderStatusChangedQueue") Queue orderStatusChangedQueue, DirectExchange orderExchange) {
        return BindingBuilder.bind(orderStatusChangedQueue)
                             .to(orderExchange)
                             .with(ROUTING_KEY_STATUS_CHANGED);
    }

    // DLQ queues and bindings
    @Bean
    public Queue orderCreatedDlq() {
        return new Queue(ORDER_CREATED_DLQ, true);
    }

    @Bean
    public Queue orderStatusChangedDlq() {
        return new Queue(ORDER_STATUS_CHANGED_DLQ, true);
    }

    @Bean
    public Binding orderCreatedDlqBinding(@Qualifier("orderCreatedDlq") Queue dlq, DirectExchange orderDlx) {
        return BindingBuilder.bind(dlq)
                             .to(orderDlx)
                             .with(ROUTING_KEY_DLQ);
    }

    @Bean
    public Binding orderStatusChangedDlqBinding(@Qualifier("orderStatusChangedDlq") Queue dlq, DirectExchange orderDlx) {
        return BindingBuilder.bind(dlq)
                             .to(orderDlx)
                             .with(ROUTING_KEY_DLQ);
    }

    /**
     * Jackson2JsonMessageConverter
     * Java objelerini JSON'a, JSON'ı Java objelerine çevirir
     * JavaTimeModule: LocalDateTime, LocalDate gibi Java 8 Date/Time API tiplerini destekler
     */
    @Bean
    public Jackson2JsonMessageConverter jsonMessageConverter() {
        ObjectMapper objectMapper = new ObjectMapper();
        objectMapper.registerModule(new JavaTimeModule()); // LocalDateTime desteği için
        return new Jackson2JsonMessageConverter(objectMapper);
    }

    /**
     * RabbitTemplate
     * Mesaj göndermek için kullanılır
     * JSON formatında mesaj göndermek için Jackson2JsonMessageConverter kullanılır
     */
    @Bean
    public RabbitTemplate rabbitTemplate(ConnectionFactory connectionFactory, Jackson2JsonMessageConverter jsonMessageConverter) {
        RabbitTemplate rabbitTemplate = new RabbitTemplate(connectionFactory);
        rabbitTemplate.setMessageConverter(jsonMessageConverter);
        return rabbitTemplate;
    }
}

