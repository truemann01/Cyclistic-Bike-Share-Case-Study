# Cyclistic-Bike-Share-Case-Study


## 🧭 Overview

This case study analyzes the 12-month ride history of Cyclistic, a fictional bike-share company based in Chicago. The objective is to uncover insights into user behavior and provide data-driven recommendations to help convert casual riders into annual members.

---

## 📖 Scenario

You are a junior data analyst at Cyclistic, a bike-share company that operates in Chicago. The director of marketing believes that maximizing annual memberships is key to long-term profitability. She has tasked your team with understanding how casual riders use Cyclistic compared to members — and using this insight to inform a targeted marketing campaign.

---

## ❓ Defining the Problem

Cyclistic offers three types of bikes and two types of riders: **casual** and **members**. While annual members generate more predictable revenue, casual riders represent a large untapped opportunity.

The question is:  
> **How do annual members and casual riders use Cyclistic differently?**

---

## 🎯 Business Task

- Analyze historical ride data (2024) to compare casual vs. member usage patterns.
- Identify key behavioral differences that could inform marketing strategies.
- Recommend tactics to encourage more casual riders to become members.

---

## 🗃 Dataset

- **Source**: [Divvy Trip Data (Chicago)](https://divvy-tripdata.s3.amazonaws.com/index.html)
- **Format**: 12 `.csv` files, one per month (Jan 2024 – Dec 2024)
- **License**: Open Data Commons Public Domain Dedication and License (ODC-PDDL)

Each file includes:
- Ride ID, bike type, timestamps
- Start/end stations and geolocation
- Rider type: `casual` or `member`

✅ The dataset meets the **ROCCC** standard: Reliable, Original, Comprehensive, Current, Cited.

---

## 🧹 Initial Data Cleaning in Microsoft Excel

- Opened each `.csv` in Excel and reviewed column consistency.
- Reformatted date/time fields to ISO standard.
- Checked for obvious nulls and anomalies.
- Saved each file as `.xlsx`, then converted back to `.csv` for BigQuery compatibility.

---

## ☁️ Further Cleaning in Google Cloud Storage + BigQuery

- Uploaded all 12 `.csv` files to a **GCS bucket**.
- Imported each file as a separate table into **Google BigQuery**.
- Standardized schema using `SAFE_CAST()` and manual templates.
- Created new calculated columns:
  - `ride_length` = duration in seconds
  - `ride_date`, `ride_month`, `ride_year`, `day_of_week`
  - `ride_start_time`, `ride_end_time`
  - `ride_distance_km` using haversine formula

### ⚠ Issues Encountered
| Problem | Fix |
|--------|-----|
| Inconsistent column headers | Standardized manually before import |
| `ride_length` values > 24h | Filtered out with logic |
| Missing coordinates | Rows excluded from distance-based analysis |
| Schema errors | Used custom schema templates and `SAFE_CAST` |

---

## 🧩 Joining Tables Quarterly

To simplify analysis, I combined data into quarterly chunks:

```sql

CREATE TABLE cyclistic_Q1.quarterly_Q1 AS
SELECT * FROM cyclistic_data_01.cyclistic_data_01_2024
UNION ALL
SELECT * FROM cyclistic_data_02.cyclistic_data_02_2024
UNION ALL
SELECT * FROM cyclistic_data_03.cyclistic_data_03_2024;


CREATE TABLE cyclistic_Q2.quarterly_Q2 AS
SELECT * FROM cyclistic_data_04.cyclistic_data_04_2024
UNION ALL
SELECT * FROM cyclistic_data_05.cyclistic_data_05_2024
UNION ALL
SELECT * FROM cyclistic_data_06.cyclistic_data_06_2024;


CREATE TABLE cyclistic_Q3.quarterly_Q3 AS
SELECT * FROM cyclistic_data_07.cyclistic_data_07_2024
UNION ALL
SELECT * FROM cyclistic_data_08.cyclistic_data_08_2024
UNION ALL
SELECT * FROM cyclistic_data_09.cyclistic_data_09_2024;


CREATE TABLE cyclistic_Q4.quarterly_Q4 AS
SELECT * FROM cyclistic_data_10.cyclistic_data_10_2024
UNION ALL
SELECT * FROM cyclistic_data_11.cyclistic_data_11_2024
UNION ALL
SELECT * FROM cyclistic_data_12.cyclistic_data_12_2024;
