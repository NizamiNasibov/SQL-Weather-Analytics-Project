# SQL Weather Analytics Project

## 📌 Project Overview
This project demonstrates advanced SQL skills through the analysis of snowfall data collected from multiple weather stations across different regions.  
The main goal is to identify snowfall patterns, peak periods, and high-impact stations to support data-driven operational decisions.

The project is designed to reflect **real-world analytical tasks** typically handled by a **Middle SQL / Data Analyst**.

---

## 🎯 Business Objective
- Identify regions and stations with the highest snowfall intensity
- Detect peak snowfall days and periods
- Rank stations by snowfall contribution
- Support resource planning and prioritization based on data insights

---

## 🗂 Database Schema

### `weather_stations`
| Column | Type | Description |
|------|------|-------------|
| station_id | INTEGER | Unique station identifier |
| station_name | TEXT | Station name |
| region | TEXT | Geographic region |
| altitude | INTEGER | Station altitude (meters) |

### `snowfall_log`
| Column | Type | Description |
|------|------|-------------|
| log_id | INTEGER | Unique log identifier |
| station_id | INTEGER | Reference to weather station |
| fall_time | DATETIME | Date and time of snowfall |
| snow_mm | REAL | Snowfall amount (mm) |
| flake_type | TEXT | Snowflake type |

---

## 🛠 Technologies Used
- SQL (SQLite)
- CTE (WITH)
- Window Functions
- Views
- Indexes
- Date & Time functions

---

## 📊 Key Analytical Tasks

### 1. Snowfall by Region
Aggregated total snowfall to compare regional intensity.

### 2. Top Stations by Snowfall
Identified stations contributing the most to overall snowfall.

### 3. Daily Snowfall Trends
Analyzed snowfall dynamics by day to detect peak periods.

### 4. Unique Snowflake Types
Calculated diversity of snowflake types per day.

### 5. Ranking & Quartiles
Used window functions (`RANK`, `NTILE`) to rank stations and split them into quartiles based on snowfall volume.

---

## 🪟 Advanced SQL Features

### CTE Example
```sql
WITH daily_totals AS (
  SELECT
    date(fall_time) AS day,
    station_id,
    SUM(snow_mm) AS daily_snow
  FROM snowfall_log
  GROUP BY day, station_id
)
SELECT *
FROM daily_totals;
