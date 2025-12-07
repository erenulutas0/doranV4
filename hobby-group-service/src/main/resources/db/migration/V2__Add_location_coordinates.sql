-- Hobby Group Service - Add Location Coordinates
-- Migration: V2__Add_location_coordinates.sql
-- Description: Adds latitude and longitude columns to hobby_groups table for geospatial queries

-- Add latitude and longitude columns
ALTER TABLE hobby_groups 
ADD COLUMN IF NOT EXISTS latitude DECIMAL(10, 7),
ADD COLUMN IF NOT EXISTS longitude DECIMAL(10, 7);

-- Add constraints for valid coordinates (IF NOT EXISTS not supported, so we check first)
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_constraint WHERE conname = 'chk_latitude' AND conrelid = 'hobby_groups'::regclass
    ) THEN
        ALTER TABLE hobby_groups ADD CONSTRAINT chk_latitude CHECK (latitude IS NULL OR (latitude >= -90.0 AND latitude <= 90.0));
    END IF;
    
    IF NOT EXISTS (
        SELECT 1 FROM pg_constraint WHERE conname = 'chk_longitude' AND conrelid = 'hobby_groups'::regclass
    ) THEN
        ALTER TABLE hobby_groups ADD CONSTRAINT chk_longitude CHECK (longitude IS NULL OR (longitude >= -180.0 AND longitude <= 180.0));
    END IF;
END $$;

-- Add index for location queries
CREATE INDEX IF NOT EXISTS idx_hobby_groups_location_coords ON hobby_groups(latitude, longitude) 
WHERE latitude IS NOT NULL AND longitude IS NOT NULL;

-- Create PostGIS geography column for efficient geospatial queries
ALTER TABLE hobby_groups 
ADD COLUMN IF NOT EXISTS location_point GEOGRAPHY(POINT, 4326);

-- Create GIST index for geospatial queries (much faster than lat/lng comparison)
CREATE INDEX IF NOT EXISTS idx_hobby_groups_location_point ON hobby_groups USING GIST(location_point) 
WHERE location_point IS NOT NULL;

-- Function to update location_point when latitude/longitude changes
CREATE OR REPLACE FUNCTION update_hobby_group_location_point()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.latitude IS NOT NULL AND NEW.longitude IS NOT NULL THEN
        NEW.location_point := ST_SetSRID(ST_MakePoint(NEW.longitude, NEW.latitude), 4326)::geography;
    ELSE
        NEW.location_point := NULL;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger to automatically update location_point
DROP TRIGGER IF EXISTS trigger_update_hobby_group_location_point ON hobby_groups;
CREATE TRIGGER trigger_update_hobby_group_location_point
    BEFORE INSERT OR UPDATE OF latitude, longitude ON hobby_groups
    FOR EACH ROW
    EXECUTE FUNCTION update_hobby_group_location_point();

-- Update existing rows (if any) to populate location_point
UPDATE hobby_groups 
SET location_point = ST_SetSRID(ST_MakePoint(longitude, latitude), 4326)::geography
WHERE latitude IS NOT NULL AND longitude IS NOT NULL AND location_point IS NULL;


