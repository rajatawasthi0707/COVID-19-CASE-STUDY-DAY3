# COVID-19-CASE-STUDY-DAY3
Case Study on Covid-19 Dataset-DAY3
# COVID-19 Dataset SQL Case Study

## Overview

This repository contains a SQL case study conducted on the COVID-19 dataset from Kaggle. The analysis explores various aspects of the dataset, including total cases, deaths, recoveries, and active cases across different countries and dates. The dataset used is named `full_grouped` and includes columns such as `Date`, `Country/Region`, `Confirmed`, `Deaths`, `Recovered`, and more.

## Dataset

- **Table Name**: `full_grouped`
- **Columns**:
  - `Date`: The date of the record.
  - `Country/Region`: The country or region where the data was recorded.
  - `Confirmed`: The number of confirmed COVID-19 cases.
  - `Deaths`: The number of deaths caused by COVID-19.
  - `Recovered`: The number of recovered COVID-19 cases.
  - `Active`: The number of active COVID-19 cases.
  - `New cases`: The number of new confirmed cases.
  - `New deaths`: The number of new deaths.
  - `New recovered`: The number of new recoveries.
  - `WHO Region`: The World Health Organization region of the country or region.

## SQL Queries

```sql
-- Question 1: What is the total number of records in the dataset?
SELECT COUNT(*) FROM full_grouped;

-- Question 2: List all the unique countries present in the dataset.
SELECT DISTINCT(`Country/Region`) FROM full_grouped;

-- Question 3: How many total cases were reported each month?
SELECT DATE_FORMAT(Date, '%m') AS MonthNumber, SUM(Confirmed) 
FROM full_grouped
GROUP BY MonthNumber;

-- Question 4: On which date was the highest number of new cases reported globally?
SELECT Date, SUM(Confirmed) AS num 
FROM full_grouped
GROUP BY Date
ORDER BY num DESC
LIMIT 1;

-- Question 5: Which country has reported the highest number of total cases?
SELECT `Country/Region`, SUM(Confirmed) AS num 
FROM full_grouped
GROUP BY `Country/Region`
ORDER BY num DESC
LIMIT 1;

-- Question 6: List the top 5 countries with the least number of deaths.
SELECT `Country/Region`, SUM(Deaths) AS num 
FROM full_grouped
GROUP BY `Country/Region`
ORDER BY num
LIMIT 5;

-- Question 7: What is the average recovery rate across all countries?
SELECT AVG(Recovered / Confirmed) * 100 
FROM full_grouped
WHERE Confirmed > 0;

-- Question 8: What is the average recovery rate by country?
SELECT `Country/Region`, AVG(Recovered / Confirmed) * 100 
FROM full_grouped
GROUP BY `Country/Region`;

-- Question 9: Calculate the average death rate for each country.
SELECT `Country/Region`, AVG(Deaths / Confirmed) * 100 
FROM full_grouped
GROUP BY `Country/Region`;

-- Question 10: How many active cases are there in total?
SELECT SUM(Active) FROM full_grouped;

-- Question 11: Which country has the highest number of active cases?
SELECT `Country/Region`, SUM(Active) AS num 
FROM full_grouped
GROUP BY `Country/Region`
ORDER BY num DESC
LIMIT 1;

-- Question 12: How have the total number of cases changed over time globally?
SELECT `WHO Region`, SUM(Active) 
FROM full_grouped
GROUP BY `WHO Region`;

-- Question 13: Identify any dates where there was a significant spike in cases globally.
WITH DailyCases AS (
    SELECT Date,
           TotalConfirmed,
           LAG(TotalConfirmed, 1, 0) OVER (ORDER BY Date) AS PreviousDayTotal,
           TotalConfirmed - LAG(TotalConfirmed, 1, 0) OVER (ORDER BY Date) AS DailyNewCases
    FROM (
        SELECT Date, SUM(Confirmed) AS TotalConfirmed
        FROM full_grouped
        GROUP BY Date
        ORDER BY Date
    ) AS GlobalDailyCases
),
Stats AS (
    SELECT AVG(DailyNewCases) AS AvgDailyNewCases, 
           STDDEV(DailyNewCases) AS StdDevDailyNewCases
    FROM DailyCases
)
SELECT DailyCases.Date, DailyCases.DailyNewCases
FROM DailyCases, Stats
WHERE DailyCases.DailyNewCases > Stats.AvgDailyNewCases + 2 * Stats.StdDevDailyNewCases
ORDER BY DailyCases.DailyNewCases DESC;

-- Question 14: Identify and handle any missing values in the dataset.
SELECT *
FROM full_grouped
WHERE Date IS NULL 
   OR `Country/Region` IS NULL 
   OR Confirmed IS NULL 
   OR Deaths IS NULL 
   OR Recovered IS NULL 
   OR Active IS NULL 
   OR `New cases` IS NULL 
   OR `New deaths` IS NULL 
   OR `New recovered` IS NULL 
   OR `WHO Region` IS NULL;
Notes
The dataset may require preprocessing, such as handling missing values and ensuring consistency in column names and formats.
Adjust queries based on the specific structure and column names in your dataset if they differ from the assumptions made here.
