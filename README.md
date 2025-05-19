# Cyclistic-Bike-Share-Project


## 🧭 Overview

This project analyses the 12-month ride history of Cyclistic, a bike-share company based in Chicago. Cyclistic’s long-term goal is to increase annual memberships by converting more casual riders into loyal, paying members. This project documents my end-to-end data journey using 12 months of historical ride data from 2024. From manual cleanup in Excel to building a cloud-based data pipeline in Google BigQuery, this project was a hands-on experience in real-world data wrangling and analysis..

---

## 💡 Why I Loved This Project

Working with data brings me joy — but more importantly, being able to transform raw data into **actionable insights** is what truly excites me. This project allowed me to not only apply my SQL and analytical skills but also troubleshoot data quality issues and build a pipeline from scratch.

## 📖 Scenario

You are a Data analyst at Cyclistic, a bike-share company that operates in Chicago. The director of marketing believes that maximising annual memberships is key to long-term profitability. She has tasked your team with understanding how casual riders use Cyclistic compared to members — and using this insight to inform a targeted marketing campaign.

---

## ❓ Defining the Problem

Cyclistic offers three types of bikes and two types of riders: **casual** and **members**. While annual members generate more predictable revenue, casual riders represent a large untapped opportunity.

The question is:  
- > **How do annual members and casual riders use Cyclistic differently?**
- > **Why would casual riders buy Cyclistic annual memberships?**
- > **How can Cyclistic use digital media to influence casual riders to become members?**
---

## 🎯 Business Task

- Analyse historical ride data (2024) to compare casual vs. member usage patterns.
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
- Afterward, I:
- Reformatted date columns to ISO standard
- Cleaned nulls
- Added new calculated fields for deeper insights:
  - `ride_length`
  - `ride_date`
  - `day_of_week`
  - `ride_month`
  - `ride_year`
  - `ride_start_time`
  - `ride_end_time`
  - `ride_distance_km`

- Saved each file as `.xlsx`, then converted back to `.csv` for BigQuery compatibility.


### Issue: `ride_length` calculation errors
The formula `D2 - C2` was generating values above 24 hours, e.g. `25:09:23`.  
To fix this in Excel, I used:

```excel
=IF(D2 > C2, D2 - C2, C2 - D2)

```



## ☁️ Further cleaning and EDA on Google cloud(BigQuery)
Due to the size of the full-year dataset, I migrated all 12 files into Google Cloud Storage and created a bucket named Connect_ai. I converted all files back to .csv for BigQuery compatibility.

BigQuery Setup:
Created a project: cyclistic-project-449621

Created monthly Dataset and tables: 
- cyclistic_data_01_2024.csv
- cyclistic_data_02_2024.csv
- cyclistic_data_03_2024.csv
- cyclistic_data_04_2024.csv
- cyclistic_data_05_2024.csv
- cyclistic_data_06_2024.csv
- cyclistic_data_07_2024.csv
- cyclistic_data_08_2024.csv
- cyclistic_data_09_2024.csv
- cyclistic_data_10_2024.csv
- cyclistic_data_11_2024.csv
- cyclistic_data_12_2024.csv


### ⚠ Issues Encountered
| Problem | Fix |
|--------|-----|
| Inconsistent column headers | Standardized manually before import |
| `ride_length` values > 24h | Filtered out with logic |
| Missing coordinates | Rows excluded from distance-based analysis |
| Schema errors | Used custom schema templates and `SAFE_CAST` |

## Some SQL statements used in fixing issues encountered while working on the dataset before mergering it quarterly:
which had to do some research on the Big query documentation : (<https://cloud.google.com/bigquery/docs/managing-table-schemas#change_a_columns_data_type>)

```
-- Cast a column to change the data type.
SELECT ride_id, rideable_type, started_at,ended_at,start_station_name, start_station_id,end_station_name, End_Station_ID,start_lat, start_lng, end_lat, end_lng, member_casual, CAST(ride_length AS string) AS ride_length, Day_of_week, ride_date, ride_distance_km, ride_Month, ride_Year, ride_start_time, ride_end_time,
FROM cyclistic_data_02.cyclistic_data_02_2024;

-- Handled Invalid time string
SAFE_CAST(ride_length AS TIME)

-- when ride_length was NULL, it impacted ride_distance_km.
UPDATE cyclistic_Q2.quarterly_Q2
SET ride_distance_km = NULL
WHERE ride_length IS NULL;

-- Repeated for Q3 and Q4



```
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

```
## 📊 Quarterly EDA Script

I performed exploratory data analysis (EDA) on each quarterly dataset to identify trends in ride length, usage patterns by day of the week, bike type preferences, and seasonal behavior differences between casual riders and members.

🔗 [Click here to view the SQL script for Quarterly EDA](Scripts/)

- Quarterly_Q1
- Quarterly_Q2
- Quarterly_Q3
- Quarterly_Q4


## 📈 Full-Year EDA Script

After cleaning and merging all quarterly datasets, I conducted a comprehensive full-year analysis to uncover deeper behavioral insights. This included average ride time, peak usage periods, bike type trends, and usage differences between casual riders and members across all of 2024.

🔗 [Click here to view the SQL script for Full-Year EDA](Scripts/Full-year-EDA.sql)

- cyclistic_full_Year.Trip_data_full_Year

## Conclusion 
This project pushed me to not only clean and organize messy datasets, but also navigate schema challenges in BigQuery, research real-time fixes, and build a full SQL-based analysis pipeline from scratch.


# Visualisation Using Python 

## Tools used 
 - Python
 - VS code studio
 - jupyter Notebook
 - Bash

I created a virtual environment for my project, install all the necessary libraries, 

- pandas
- matplotlib
- seaborn
- Plotly

🔗 [Click here to view the Visualisation images](visualisation/)


Next : I will be writing a comprehensive report showcasing, problem, insights, use case and recommendations. 
I'm open for colloboration and contributions. 


## 🚀 Thanks for reading!
Want to connect or collaborate? Let’s chat on <a href="https://www.linkedin.com/in/anderson-igbah?utm_source=share&utm_campaign=share_via&utm_content=profile&utm_medium=ios_app">LinkedIn</a> 



