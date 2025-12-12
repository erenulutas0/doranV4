package com.microservices.search.controller;

import java.util.List;

import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotBlank;

import org.springframework.http.ResponseEntity;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.microservices.search.model.ProductDocument;
import com.microservices.search.service.ProductSearchService;

import lombok.RequiredArgsConstructor;

@RestController
@RequestMapping("/search")
@Validated
@RequiredArgsConstructor
public class SearchController {

    private final ProductSearchService searchService;

    @GetMapping
    public ResponseEntity<List<ProductDocument>> search(
            @RequestParam("q") @NotBlank String query,
            @RequestParam(value = "size", defaultValue = "10") @Min(1) @Max(50) int size) {
        return ResponseEntity.ok(searchService.search(query, size));
    }

    @PostMapping("/reindex")
    public ResponseEntity<String> reindex() {
        long count = searchService.reindexAll();
        return ResponseEntity.ok("Reindexed products: " + count);
    }
}

