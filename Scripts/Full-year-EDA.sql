
/*
Cyclistic Case Study: Exploratory Data Analysis, full_year
Windows Functions, Aggregate Functions, Converting Data Types
*/

-- Selecting full_year data to preview

SELECT
        ride_id,
        started_at,
        ended_at,
        ride_length,
        day_of_week, 
        start_station_name,
        end_station_name,
        member_casual
FROM
        `cyclistic-project-449621.cyclistic_full_Year.Trip_data_full_Year`
ORDER BY
        ride_id DESC;
        -- ride_length DESC


-- Total Trips: Members vs Casual 
-- Looking at overall, annual member and casual rider totals

SELECT
        TotalTrips,
        TotalMemberTrips,
        TotalCasualTrips,
        ROUND(TotalMemberTrips/TotalTrips,2)*100 AS MemberPercentage,
        ROUND(TotalCasualTrips/TotalTrips,2)*100 AS CasualPercentage
FROM 
        (
        SELECT
                COUNT(ride_id) AS TotalTrips,
                COUNTIF(member_casual = 'member') AS TotalMemberTrips,
                COUNTIF(member_casual = 'casual') AS TotalCasualTrips
        FROM
                `cyclistic-project-449621.cyclistic_full_Year.Trip_data_full_Year`
        );


-- Avergage Ride Lengths: Members vs Casual  
-- Looking at overall, member and casual average ride lengths

SELECT
        (
        SELECT
              AVG(ride_length)
        FROM
              `cyclistic-project-449621.cyclistic_full_Year.Trip_data_full_Year` 
        ) AS AvgRideLength_Overall,
        (
        SELECT
              AVG(ride_length)
        FROM
              `cyclistic-project-449621.cyclistic_full_Year.Trip_data_full_Year`
        WHERE
              member_casual = 'member'
        ) AS AvgRideLength_Member,
        (
        SELECT
              AVG(ride_length)
        FROM
              `cyclistic-project-449621.cyclistic_full_Year.Trip_data_full_Year`
        WHERE
              member_casual = 'casual' ) AS AvgRideLength_Casual;
 

-- Max Ride Lengths: Members vs Casual  
-- Looking at max ride lengths to check for outliers

SELECT
        member_casual,
        MAX(ride_length) AS ride_length_MAX
FROM
        `cyclistic-project-449621.cyclistic_full_Year.Trip_data_full_Year`
GROUP BY
        member_casual
ORDER BY
        ride_length_MAX;


-- Sorting by ride length to confirm there are multiple
-- outliers for casual rider trips:

SELECT
      ride_id,
      member_casual,
      ride_length,
      day_of_week
FROM
      `cyclistic-project-449621.cyclistic_full_Year.Trip_data_full_Year`
WHERE 
      member_casual = 'casual'
ORDER BY
      ride_length DESC;


-- Median Ride Lengths: Members vs Casual 
-- Looking at median because of outliers influence on AVG

SELECT
        DISTINCT median_ride_length,
        member_casual
FROM 
        (
        SELECT
                ride_id,
                member_casual,
                ride_length,
                PERCENTILE_DISC(ride_length, 0.5 IGNORE NULLS) OVER(PARTITION BY member_casual) AS median_ride_length
        FROM
                `cyclistic-project-449621.cyclistic_full_Year.Trip_data_full_Year`)
ORDER BY
        median_ride_length DESC
LIMIT 2;


-- Rides per day: member and casual
-- Looking at which days have the highest number of rides

SELECT
        member_casual,
        day_of_week AS mode_day_of_week -- Top number of day_of_week
FROM 
        (
        SELECT
              DISTINCT member_casual,
              day_of_week,
              ROW_NUMBER() OVER (PARTITION BY member_casual ORDER BY COUNT(day_of_week) DESC) rn
        FROM
              `cyclistic-project-449621.cyclistic_full_Year.Trip_data_full_Year`
        GROUP BY
              member_casual,
              day_of_week 
        )
WHERE
        rn = 1
ORDER BY
        member_casual DESC
LIMIT 2;


-- Looking at average ride length per day of week

SELECT
        day_of_week,
        AVG(ride_length) AS average_ride_length
FROM 
        `cyclistic-project-449621.cyclistic_full_Year.Trip_data_full_Year`
GROUP BY
        day_of_week
ORDER BY
        average_ride_length DESC
LIMIT 7;

  
-- How about the median ride length per day of week?

SELECT
        DISTINCT median_ride_length,
        day_of_week
FROM 
        (
        SELECT
              ride_id,
              day_of_week,
              ride_length,
              PERCENTILE_DISC(ride_length, 0.5 IGNORE NULLS) OVER(PARTITION BY day_of_week) AS median_ride_length
        FROM
              `cyclistic-project-449621.cyclistic_full_Year.Trip_data_full_Year`
        )
ORDER BY
        median_ride_length DESC
LIMIT 7;


-- Looking at AVG ride length per day of week for casual and annual

SELECT
        member_casual,
        day_of_week,
        AVG(ride_length) AS average_ride_length
FROM 
        `cyclistic-project-449621.cyclistic_full_Year.Trip_data_full_Year`
GROUP BY
        day_of_week,
        member_casual
ORDER BY
        average_ride_length DESC
LIMIT 14;


-- Looking at median ride lengths per day

SELECT
        DISTINCT median_ride_length,
        member_casual,
        day_of_week
FROM 
        (
        SELECT
                ride_id,
                member_casual,
                day_of_week,
                ride_length,
                PERCENTILE_DISC(ride_length, 0.5 IGNORE NULLS) OVER(PARTITION BY day_of_week) AS median_ride_length
        FROM
                `cyclistic-project-449621.cyclistic_full_Year.Trip_data_full_Year`
        )
ORDER BY
        median_ride_length DESC
LIMIT 7;
 

-- Overall trips per day
-- Looking at total number of trips per day_of_week

SELECT
        day_of_week,
        COUNT(DISTINCT ride_id) AS TotalTrips,
        (COUNT(DISTINCT ride_id)/TotalTrips_Overall)*100 AS PercentageOfTotal
FROM
        (
        SELECT
              COUNT(ride_id) AS TotalTrips_Overall
        FROM
              `cyclistic-project-449621.cyclistic_full_Year.Trip_data_full_Year`
        ),
        `cyclistic-project-449621.cyclistic_full_Year.Trip_data_full_Year`
GROUP BY
        day_of_week, TotalTrips_Overall
ORDER BY
        TotalTrips DESC
LIMIT 7;


-- Overall, member, casual
-- Looking at total number of trips per day 

SELECT  
        day_of_week,
        COUNT(DISTINCT ride_id) AS TotalTrips,
        SUM(CASE WHEN member_casual = 'member' THEN 1 ELSE 0 END) AS MemberTrips,
        SUM(CASE WHEN member_casual = 'casual' THEN 1 ELSE 0 END) AS CasualTrips
FROM 
        `cyclistic-project-449621.cyclistic_full_Year.Trip_data_full_Year`
GROUP BY 
        1
ORDER BY 
        TotalTrips DESC 
LIMIT 7;


-- Overall: member and casual
-- Looking at total number of trips per day 

SELECT
        day_of_week,
        member_casual,
        COUNT(DISTINCT ride_id) AS TotalTrips,
        (COUNT(DISTINCT ride_id)/TotalTrips_Overall)*100 AS PercentageOfTotal
FROM
        (
        SELECT
            COUNT(ride_id) AS TotalTrips_Overall
        FROM
            `cyclistic-project-449621.cyclistic_full_Year.Trip_data_full_Year`
        WHERE 
            member_casual = 'member'
            -- member_casual = 'casual'
        ),
      `cyclistic-project-449621.cyclistic_full_Year.Trip_data_full_Year`
WHERE
      member_casual = 'member'
      -- member_casual = 'casual'
GROUP BY
  day_of_week, member_casual, TotalTrips_Overall
ORDER BY
  TotalTrips DESC
LIMIT
  7;


-- Looking at most popular bike types
-- Overall counts

SELECT 
        COUNTIF(rideable_type = rideable_type) AS `Rows`, 
        rideable_type,
        member_casual
FROM
        `cyclistic-project-449621.cyclistic_full_Year.Trip_data_full_Year`
GROUP BY 
        rideable_type, 
        member_casual
ORDER BY 
        `Rows`

 DESC
LIMIT 5;


-- Looking at bike types for member and casual
 
SELECT
        member_casual,
        rideable_type AS bike_type
FROM
        `cyclistic-project-449621.cyclistic_full_Year.Trip_data_full_Year`
WHERE 
        member_casual = 'member'
        -- member_casual = 'casual'
GROUP BY 
        1,2;


-- Looking at average ride length by bike type

SELECT
        rideable_type,
        AVG(ride_length) AS ride_length_AVG
FROM
        `cyclistic-project-449621.cyclistic_full_Year.Trip_data_full_Year`
GROUP BY 
        1
LIMIT 
        3;


-- Looking at max ride length by bike type

SELECT
        rideable_type,
        MAX(ride_length) AS ride_length_MAX
FROM
        `cyclistic-project-449621.cyclistic_full_Year.Trip_data_full_Year`
GROUP BY 
        1;
 
 
-- Start stations: member vs casual
-- Looking at start station counts

SELECT 
        DISTINCT start_station_name,
        SUM(
            CASE WHEN ride_id = ride_id AND start_station_name = start_station_name THEN 1 ELSE 0 END
            ) AS total,
        SUM(
            CASE WHEN member_casual = 'member' AND start_station_name = start_station_name THEN 1 ELSE 0 END
            ) AS member,
        SUM(
            CASE WHEN member_casual = 'casual' AND start_station_name = start_station_name THEN 1 ELSE 0 END
            ) AS casual
FROM 
        `cyclistic-project-449621.cyclistic_full_Year.Trip_data_full_Year`
GROUP BY 
        start_station_name
ORDER BY 
        total DESC;
        -- member DESC
        -- casual DESC


-- End stations: member vs casual
-- Looking at end station counts

SELECT 
        DISTINCT end_station_name,
        SUM(
            CASE WHEN ride_id = ride_id AND end_station_name = end_station_name THEN 1 ELSE 0 END
            ) AS total,
        SUM(
            CASE WHEN member_casual = 'member' AND end_station_name = end_station_name THEN 1 ELSE 0 END
            ) AS member,
        SUM(
            CASE WHEN member_casual = 'casual' AND end_station_name = end_station_name THEN 1 ELSE 0 END
            ) AS casual
FROM 
        `cyclistic-project-449621.cyclistic_full_Year.Trip_data_full_Year`
GROUP BY 
        end_station_name
ORDER BY 
        total DESC;
        -- member DESC
        -- casual DESC


-- Looking at most popular start and end station combos

SELECT 
        start_station_name, 
        end_station_name,
        COUNT(*) AS combination_cnt
FROM
        `cyclistic-project-449621.cyclistic_full_Year.Trip_data_full_Year`
WHERE 
        start_station_name IS NOT NULL 
        AND end_station_name IS NOT NULL
GROUP BY 
        1,2
ORDER BY 
        combination_cnt DESC;


-- Looking at most popular start and end station combos
-- Filtering by member or casual 

SELECT 
        start_station_name, 
        end_station_name,
        COUNT(*) AS combination_cnt,
        member_casual
FROM
        `cyclistic-project-449621.cyclistic_full_Year.Trip_data_full_Year`
WHERE 
        start_station_name IS NOT NULL 
        AND end_station_name IS NOT NULL
        -- AND member_casual = 'member'
        -- AND member_casual = 'casual'
GROUP BY 
        1,2,4
ORDER BY 
        combination_cnt DESC;


-- Looking at most popular start and end station combos 
-- Overall count

SELECT 
        COUNTIF(end_station_name = end_station_name AND start_station_name = start_station_name) AS `Rows`, 
        start_station_name, 
        end_station_name
FROM
        `cyclistic-project-449621.cyclistic_full_Year.Trip_data_full_Year`
GROUP BY 
        start_station_name, 
        end_station_name
ORDER BY 
        `Rows` DESC
        ;
 
-- Looking at total trip data 

SELECT
        TotalTrips,
        TotalMemberTrips,
        TotalCasualTrips,
        ride_date
        
FROM 
        (
        SELECT
                COUNT(ride_id) AS TotalTrips,
                COUNTIF(member_casual = 'member') AS TotalMemberTrips,
                COUNTIF(member_casual = 'casual') AS TotalCasualTrips,
                ride_date
               
        FROM
                `cyclistic-project-449621.cyclistic_full_Year.Trip_data_full_Year`
        WHERE 
                ride_date = ride_date
        GROUP BY
                ride_date
                
        )
GROUP BY 
        1,2,3,4
ORDER BY 
        ride_date ASC;
 
 
-- trips per day 

SELECT
        TotalTrips,
        member_casual,
        ride_date
      
FROM 
        (
        SELECT
                COUNT(ride_id) AS TotalTrips,
                member_casual,
                ride_date
                
        FROM
                `cyclistic-project-449621.cyclistic_full_Year.Trip_data_full_Year`
        WHERE 
                ride_date = ride_date
        GROUP BY
                member_casual,
                ride_date
                
        )
GROUP BY 
        1,2,3
ORDER BY 
        ride_date ASC;

 
-- Trips per day along with running percentage

SELECT
        ride_date,
        TotalTrips_both,
        TotalMemberTrips,
        TotalCasualTrips,
        ROUND(CAST(TotalMemberTrips/TotalTrips_both AS NUMERIC),2)*100 AS MemberPercentage,
        ROUND(CAST(TotalCasualTrips/TotalTrips_both AS NUMERIC),2)*100 AS CasualPercentage
FROM 
        (
        SELECT
                ride_date,
                COUNT(ride_id) AS TotalTrips_both,
                COUNTIF(member_casual = 'member') AS TotalMemberTrips,
                COUNTIF(member_casual = 'casual') AS TotalCasualTrips
        FROM
                `cyclistic-project-449621.cyclistic_full_Year.Trip_data_full_Year`
        WHERE 
                ride_date = ride_date
        GROUP BY 
                ride_date
        )
GROUP BY 
        1,2,3,4
ORDER BY 
        ride_date;


-- Average start hour along with running percentage

SELECT
        start_hour,
        total_trips,
        member_casual
FROM 
        (
        SELECT
                EXTRACT(HOUR FROM started_at) as start_hour,
                COUNT(ride_id) AS total_trips,
                member_casual
        FROM
                `cyclistic-project-449621.cyclistic_full_Year.Trip_data_full_Year`
        WHERE 
                ride_id = ride_id
        GROUP BY 
                start_hour,
                member_casual
        )
GROUP BY 
        1,2,3
ORDER BY 
        start_hour;

