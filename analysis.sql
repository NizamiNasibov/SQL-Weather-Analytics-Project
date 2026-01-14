-- =====================================================
-- Project: SQL Weather Analytics
-- File: analysis.sql
-- Description:
-- Core analytical queries demonstrating SQL skills:
-- joins, aggregations, CTEs, window functions,
-- date handling and data quality checks.
-- =====================================================


-- =====================================================
-- 1. Total snowfall by region
-- Business question:
-- Which regions receive the highest total snowfall?
-- =====================================================
SELECT
    ws.region,
    SUM(sl.snow_mm) AS total_snow_mm
FROM snowfall_log sl
JOIN weather_stations ws
    ON sl.station_id = ws.station_id
GROUP BY ws.region
ORDER BY total_snow_mm DESC;


-- =====================================================
-- 2. Top 3 weather stations by total snowfall
-- Business question:
-- Which stations contribute the most to snowfall?
-- =====================================================
SELECT
    ws.station_name,
    SUM(sl.snow_mm) AS total_snow_mm
FROM snowfall_log sl
JOIN weather_stations ws
    ON sl.station_id = ws.station_id
GROUP BY ws.station_name
ORDER BY total_snow_mm DESC
LIMIT 3;


-- =====================================================
-- 3. Daily snowfall totals
-- Business question:
-- How does snowfall change day by day?
-- =====================================================
SELECT
    date(sl.fall_time) AS snowfall_day,
    SUM(sl.snow_mm) AS daily_total_snow_mm
FROM snowfall_log sl
GROUP BY snowfall_day
ORDER BY snowfall_day;


-- =====================================================
-- 4. Unique snowflake types per day
-- Business question:
-- How diverse are snowflake types by date?
-- =====================================================
SELECT
    date(fall_time) AS snowfall_day,
    COUNT(DISTINCT flake_type) AS unique_flake_types
FROM snowfall_log
GROUP BY snowfall_day
ORDER BY snowfall_day;


-- =====================================================
-- 5. Day with the maximum snowfall
-- Business question:
-- When was the peak snowfall day?
-- =====================================================
SELECT
    date(fall_time) AS snowfall_day,
    SUM(snow_mm) AS total_snow_mm
FROM snowfall_log
GROUP BY snowfall_day
ORDER BY total_snow_mm DESC
LIMIT 1;


-- =====================================================
-- 6. Stations with no snowfall (0 mm)
-- Business question:
-- Which stations reported zero snowfall?
-- =====================================================
SELECT DISTINCT
    ws.station_name
FROM snowfall_log sl
JOIN weather_stations ws
    ON sl.station_id = ws.station_id
WHERE sl.snow_mm = 0;


-- =====================================================
-- 7. Monthly snowfall trend
-- Business question:
-- How does snowfall vary by month?
-- =====================================================
SELECT
    strftime('%Y-%m', fall_time) AS month,
    SUM(snow_mm) AS monthly_snow_mm
FROM snowfall_log
GROUP BY month
ORDER BY month;


-- =====================================================
-- 8. Snowfall classification using CASE
-- Business question:
-- How intense was snowfall at each log entry?
-- =====================================================
SELECT
    log_id,
    station_id,
    snow_mm,
    CASE
        WHEN snow_mm = 0 THEN 'No snowfall'
        WHEN snow_mm < 10 THEN 'Light snowfall'
        WHEN snow_mm BETWEEN 10 AND 20 THEN 'Moderate snowfall'
        ELSE 'Heavy snowfall'
    END AS snowfall_category
FROM snowfall_log;


-- =====================================================
-- 9. CTE: Daily snowfall per station
-- Business question:
-- What is the maximum daily snowfall for each station?
-- =====================================================
WITH daily_station_snow AS (
    SELECT
        station_id,
        date(fall_time) AS snowfall_day,
        SUM(snow_mm) AS daily_snow_mm
    FROM snowfall_log
    GROUP BY station_id, snowfall_day
),
ranked_days AS (
    SELECT
        station_id,
        snowfall_day,
        daily_snow_mm,
        RANK() OVER (
            PARTITION BY station_id
            ORDER BY daily_snow_mm DESC
        ) AS snowfall_rank
    FROM daily_station_snow
)
SELECT
    ws.station_name,
    r.snowfall_day,
    r.daily_snow_mm
FROM ranked_days r
JOIN weather_stations ws
    ON r.station_id = ws.station_id
WHERE r.snowfall_rank = 1
ORDER BY r.daily_snow_mm DESC;


-- =====================================================
-- 10. Window function: ranking stations within regions
-- Business question:
-- How do stations rank by snowfall inside each region?
-- =====================================================
WITH station_totals AS (
    SELECT
        ws.region,
        ws.station_name,
        SUM(sl.snow_mm) AS total_snow_mm
    FROM snowfall_log sl
    JOIN weather_stations ws
        ON sl.station_id = ws.station_id
    GROUP BY ws.region, ws.station_name
)
SELECT
    region,
    station_name,
    total_snow_mm,
    RANK() OVER (
        PARTITION BY region
        ORDER BY total_snow_mm DESC
    ) AS region_rank
FROM station_totals
ORDER BY region, region_rank;


-- =====================================================
-- 11. Quartile distribution of stations by snowfall
-- Business question:
-- How are stations distributed by snowfall volume?
-- =====================================================
SELECT
    station_name,
    total_snow_mm,
    NTILE(4) OVER (
        ORDER BY total_snow_mm DESC
    ) AS snowfall_quartile
FROM (
    SELECT
        ws.station_name,
        SUM(sl.snow_mm) AS total_snow_mm
    FROM snowfall_log sl
    JOIN weather_stations ws
        ON sl.station_id = ws.station_id
    GROUP BY ws.station_name
);


-- =====================================================
-- 12. Data quality checks
-- Business question:
-- Are there invalid or suspicious records?
-- =====================================================

-- Negative snowfall values
SELECT *
FROM snowfall_log
WHERE snow_mm < 0;

-- Records without station reference
SELECT *
FROM snowfall_log
WHERE station_id IS NULL;
