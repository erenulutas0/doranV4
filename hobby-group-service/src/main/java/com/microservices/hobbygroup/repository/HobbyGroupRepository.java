package com.microservices.hobbygroup.repository;

import com.microservices.hobbygroup.model.HobbyGroup;
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
public interface HobbyGroupRepository extends JpaRepository<HobbyGroup, UUID> {
    
    /**
     * Oluşturucunun gruplarını getir (silinmemiş)
     */
    List<HobbyGroup> findByCreatorIdAndDeletedAtIsNullOrderByCreatedAtDesc(UUID creatorId);
    
    /**
     * Aktif grupları getir
     */
    @Query("SELECT hg FROM HobbyGroup hg WHERE hg.status = 'ACTIVE' AND hg.isActive = true AND hg.deletedAt IS NULL ORDER BY hg.memberCount DESC, hg.createdAt DESC")
    Page<HobbyGroup> findActiveGroups(Pageable pageable);
    
    /**
     * Kategoriye göre aktif grupları getir
     */
    @Query("SELECT hg FROM HobbyGroup hg WHERE hg.status = 'ACTIVE' AND hg.isActive = true AND hg.category = :category AND hg.deletedAt IS NULL ORDER BY hg.memberCount DESC, hg.createdAt DESC")
    Page<HobbyGroup> findActiveGroupsByCategory(@Param("category") String category, Pageable pageable);
    
    /**
     * Konuma göre aktif grupları getir
     */
    @Query("SELECT hg FROM HobbyGroup hg WHERE hg.status = 'ACTIVE' AND hg.isActive = true AND hg.location = :location AND hg.deletedAt IS NULL ORDER BY hg.memberCount DESC, hg.createdAt DESC")
    Page<HobbyGroup> findActiveGroupsByLocation(@Param("location") String location, Pageable pageable);
    
    /**
     * Arama sorgusu ile aktif grupları getir
     */
    @Query("SELECT hg FROM HobbyGroup hg WHERE hg.status = 'ACTIVE' AND hg.isActive = true AND hg.deletedAt IS NULL AND (LOWER(hg.name) LIKE LOWER(CONCAT('%', :query, '%')) OR LOWER(hg.description) LIKE LOWER(CONCAT('%', :query, '%')) OR LOWER(hg.category) LIKE LOWER(CONCAT('%', :query, '%'))) ORDER BY hg.memberCount DESC, hg.createdAt DESC")
    Page<HobbyGroup> searchActiveGroups(@Param("query") String query, Pageable pageable);
    
    /**
     * Oluşturucunun belirli bir grubunu getir
     */
    Optional<HobbyGroup> findByIdAndCreatorIdAndDeletedAtIsNull(UUID id, UUID creatorId);
    
    /**
     * ID'ye göre grup getir (silinmemiş)
     */
    Optional<HobbyGroup> findByIdAndDeletedAtIsNull(UUID id);
    
    /**
     * Konum bazlı arama (yakındaki hobi grupları)
     * PostGIS kullanarak hızlı ve doğru mesafe hesaplama
     */
    @Query(value = "SELECT hg.* " +
            "FROM hobby_groups hg " +
            "WHERE hg.status = 'ACTIVE' AND hg.is_active = true AND hg.deleted_at IS NULL " +
            "AND hg.location_point IS NOT NULL " +
            "AND ST_DWithin(hg.location_point, CAST(ST_SetSRID(ST_MakePoint(:lng, :lat), 4326) AS geography), :radius * 1000) " +
            "ORDER BY ST_Distance(hg.location_point, CAST(ST_SetSRID(ST_MakePoint(:lng, :lat), 4326) AS geography)) ASC", 
            nativeQuery = true)
    List<HobbyGroup> findNearbyGroups(@Param("lat") BigDecimal latitude, 
                                      @Param("lng") BigDecimal longitude, 
                                      @Param("radius") double radiusKm);
}

