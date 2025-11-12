package com.microservices.review.repository;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import com.microservices.review.model.Review;

/**
 * Review Repository
 * Review veritabanı işlemleri için repository
 */
@Repository
public interface ReviewRepository extends JpaRepository<Review, UUID> {
    
    /**
     * Ürüne ait tüm yorumları getir (onaylanmış olanlar)
     */
    List<Review> findByProductIdAndIsApprovedTrueOrderByCreatedAtDesc(UUID productId);
    
    /**
     * Kullanıcının yorumlarını getir
     */
    List<Review> findByUserIdOrderByCreatedAtDesc(UUID userId);
    
    /**
     * Kullanıcının belirli bir ürün için yorumunu getir
     */
    Optional<Review> findByProductIdAndUserId(UUID productId, UUID userId);
    
    /**
     * Ürün için ortalama rating hesapla
     */
    @Query("SELECT AVG(r.rating) FROM Review r WHERE r.productId = :productId AND r.isApproved = true")
    Double calculateAverageRating(@Param("productId") UUID productId);
    
    /**
     * Ürün için toplam yorum sayısı
     */
    @Query("SELECT COUNT(r) FROM Review r WHERE r.productId = :productId AND r.isApproved = true")
    Long countByProductId(@Param("productId") UUID productId);
    
    /**
     * Belirli bir rating değerine sahip yorum sayısı
     */
    @Query("SELECT COUNT(r) FROM Review r WHERE r.productId = :productId AND r.rating = :rating AND r.isApproved = true")
    Long countByProductIdAndRating(@Param("productId") UUID productId, @Param("rating") Integer rating);
}

