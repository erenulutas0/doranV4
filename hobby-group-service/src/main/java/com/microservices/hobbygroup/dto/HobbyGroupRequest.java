package com.microservices.hobbygroup.dto;

import jakarta.validation.constraints.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.util.UUID;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class HobbyGroupRequest {
    
    @NotBlank(message = "Group name is required")
    @Size(min = 3, max = 200, message = "Group name must be between 3 and 200 characters")
    private String name;
    
    @NotBlank(message = "Description is required")
    @Size(max = 2000, message = "Description must not exceed 2000 characters")
    private String description;
    
    @NotBlank(message = "Category is required")
    @Size(min = 2, max = 50, message = "Category must be between 2 and 50 characters")
    private String category;
    
    @Size(max = 100, message = "Location must not exceed 100 characters")
    private String location;
    
    @DecimalMin(value = "-90.0", message = "Latitude must be between -90 and 90")
    @DecimalMax(value = "90.0", message = "Latitude must be between -90 and 90")
    private BigDecimal latitude;
    
    @DecimalMin(value = "-180.0", message = "Longitude must be between -180 and 180")
    @DecimalMax(value = "180.0", message = "Longitude must be between -180 and 180")
    private BigDecimal longitude;
    
    private String rules; // JSON array string
    
    private String tags; // JSON array string
    
    private UUID imageId;
    
    @Min(value = 1, message = "Max members must be at least 1")
    private Integer maxMembers;
}

