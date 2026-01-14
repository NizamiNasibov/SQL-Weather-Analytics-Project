-- =====================================================
-- Project: SQL Weather Analytics
-- File: schema.sql
-- Description:
-- Database schema definition including tables,
-- constraints and indexes for analytical workloads.
-- =====================================================


-- =====================================================
-- Drop tables if they already exist (for reruns)
-- =====================================================
DROP TABLE IF EXISTS snowfall_log;
DROP TABLE IF EXISTS weather_stations;


-- =====================================================
-- Table: weather_stations
-- Description:
-- Stores metadata about weather stations.
-- =====================================================
CREATE TABLE weather_stations (
    station_id INTEGER PRIMARY KEY,
    station_name TEXT NOT NULL,
    region TEXT NOT NULL,
    altitude INTEGER CHECK (altitude >= 0)
);


-- =====================================================
-- Table: snowfall_log
-- Description:
-- Stores snowfall measurements reported by stations.
-- =====================================================
CREATE TABLE snowfall_log (
    log_id INTEGER PRIMARY KEY,
    station_id INTEGER NOT NULL,
    fall_time DATETIME NOT NULL,
    snow_mm REAL NOT NULL CHECK (snow_mm >= 0),
    flake_type TEXT,
    FOREIGN KEY (station_id)
        REFERENCES weather_stations(station_id)
);


-- =====================================================
-- Indexes
-- Description:
-- Improve performance for joins and time-based filtering.
-- =====================================================
CREATE INDEX idx_snowfall_station
    ON snowfall_log(station_id);

CREATE INDEX idx_snowfall_fall_time
    ON snowfall_log(fall_time);


-- =====================================================
-- End of schema.sql
-- =====================================================

