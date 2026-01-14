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
-- =========================
