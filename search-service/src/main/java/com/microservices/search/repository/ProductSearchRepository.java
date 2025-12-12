package com.microservices.search.repository;

import java.util.UUID;

import org.springframework.data.elasticsearch.repository.ElasticsearchRepository;

import com.microservices.search.model.ProductDocument;

public interface ProductSearchRepository extends ElasticsearchRepository<ProductDocument, UUID> {
}

