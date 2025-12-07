package com.microservices.entertainment.repository;

import com.microservices.entertainment.model.Venue;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.math.BigDecimal;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

@Repository
public interface VenueRepository extends JpaRepository<Venue, UUID> {
    
    /**
     * Aktif mekanları getir
     */
    @Query("SELECT v FROM Venue v WHERE v.isActive = true AND v.deletedAt IS NULL ORDER BY v.averageRating DESC, v.createdAt DESC")
    Page<Venue> findActiveVenues(Pageable pageable);
    
    /**
     * Mekan tipine göre aktif mekanları getir
     */
    @Query("SELECT v FROM Venue v WHERE v.isActive = true AND v.venueType = :venueType AND v.deletedAt IS NULL ORDER BY v.averageRating DESC, v.createdAt DESC")
    Page<Venue> findActiveVenuesByType(@Param("venueType") Venue.VenueType venueType, Pageable pageable);
    
    /**
     * Şehre göre aktif mekanları getir
     */
    @Query("SELECT v FROM Venue v WHERE v.isActive = true AND v.city = :city AND v.deletedAt IS NULL ORDER BY v.averageRating DESC, v.createdAt DESC")
    Page<Venue> findActiveVenuesByCity(@Param("city") String city, Pageable pageable);
    
    /**
     * Arama sorgusu ile aktif mekanları getir
     */
    @Query("SELECT v FROM Venue v WHERE v.isActive = true AND v.deletedAt IS NULL AND (LOWER(v.name) LIKE LOWER(CONCAT('%', :query, '%')) OR LOWER(v.description) LIKE LOWER(CONCAT('%', :query, '%')) OR LOWER(v.category) LIKE LOWER(CONCAT('%', :query, '%'))) ORDER BY v.averageRating DESC, v.createdAt DESC")
    Page<Venue> searchActiveVenues(@Param("query") String query, Pageable pageable);
    
    /**
     * Konum bazlı arama (yakındaki mekanlar)
     * PostGIS kullanarak hızlı ve doğru mesafe hesaplama
     */
    @Query(value = "SELECT v.* " +
            "FROM venues v " +
            "WHERE v.is_active = true AND v.deleted_at IS NULL " +
            "AND v.location_point IS NOT NULL " +
            "AND ST_DWithin(v.location_point, CAST(ST_SetSRID(ST_MakePoint(:lng, :lat), 4326) AS geography), :radius * 1000) " +
            "ORDER BY ST_Distance(v.location_point, CAST(ST_SetSRID(ST_MakePoint(:lng, :lat), 4326) AS geography)) ASC", 
            nativeQuery = true)
    List<Venue> findNearbyVenues(@Param("lat") BigDecimal latitude, 
                                 @Param("lng") BigDecimal longitude, 
                                 @Param("radius") double radiusKm);
    
    /**
     * ID'ye göre mekan getir (silinmemiş)
     */
    Optional<Venue> findByIdAndDeletedAtIsNull(UUID id);
}

