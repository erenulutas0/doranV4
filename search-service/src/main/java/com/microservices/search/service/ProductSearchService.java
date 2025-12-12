package com.microservices.search.service;

import java.util.Collections;
import java.util.List;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.elasticsearch.core.ElasticsearchOperations;
import org.springframework.data.elasticsearch.core.SearchHit;
import org.springframework.data.elasticsearch.core.SearchHits;
import org.springframework.data.elasticsearch.core.query.Criteria;
import org.springframework.data.elasticsearch.core.query.CriteriaQuery;
import org.springframework.data.elasticsearch.core.query.Query;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import com.microservices.search.dto.ProductDto;
import com.microservices.search.model.ProductDocument;
import com.microservices.search.repository.ProductSearchRepository;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class ProductSearchService {

    private final ProductSearchRepository repository;
    private final ElasticsearchOperations operations;
    private final RestTemplate restTemplate;

    @Value("${product.service.base-url:http://product-service:8082/products}")
    private String productServiceBaseUrl;

    public List<ProductDocument> search(String query, int size) {
        if (query == null || query.isBlank()) {
            return Collections.emptyList();
        }
        
        // Use CriteriaQuery for Spring Data Elasticsearch 5.x
        Criteria criteria = new Criteria("name").contains(query)
                .or(new Criteria("description").contains(query))
                .or(new Criteria("category").contains(query))
                .or(new Criteria("brand").contains(query));
        
        Query searchQuery = new CriteriaQuery(criteria)
                .setPageable(PageRequest.of(0, size));

        SearchHits<ProductDocument> hits = operations.search(searchQuery, ProductDocument.class);
        return hits.getSearchHits().stream()
                .map(SearchHit::getContent)
                .collect(Collectors.toList());
    }

    public long reindexAll() {
        ProductDto[] products = restTemplate.getForObject(productServiceBaseUrl, ProductDto[].class);
        if (products == null || products.length == 0) {
            return 0;
        }
        List<ProductDocument> docs = java.util.Arrays.stream(products)
                .filter(p -> p.getIsActive() == null || Boolean.TRUE.equals(p.getIsActive()))
                .map(this::mapToDocument)
                .collect(Collectors.toList());
        repository.deleteAll();
        repository.saveAll(docs);
        return docs.size();
    }

    private ProductDocument mapToDocument(ProductDto dto) {
        return ProductDocument.builder()
                .id(dto.getId())
                .name(dto.getName())
                .description(dto.getDescription())
                .category(dto.getCategory())
                .brand(dto.getBrand())
                .price(dto.getPrice())
                .imageUrl(dto.getImageUrl())
                .isActive(dto.getIsActive())
                .averageRating(dto.getAverageRating())
                .createdAt(dto.getCreatedAt())
                .build();
    }
}

