-- USE covid

-- Question 1 < What is the total number of records in the dataset?

SELECT COUNT(*) FROM full_grouped;

-- Question 2 < List all the unique countries present in the dataset.

SELECT DISTINCT(`Country/Region`) FROM full_grouped;

-- Question 3 < How many total cases were reported each month?

SELECT DATE_FORMAT(Date, '%m') AS MonthNumber,SUM(Confirmed) FROM full_grouped
GROUP BY MonthNumber;

-- Question 4 < On which date was the highest number of new cases reported globally?

SELECT Date,SUM(Confirmed) AS num FROM full_grouped
GROUP BY Date
ORDER BY num DESC
LIMIT 1;

-- Question 5 < Which country has reported the highest number of total cases?

SELECT `Country/Region`,SUM(Confirmed) as num FROM full_grouped
GROUP BY `Country/Region`
ORDER BY num DESC
LIMIT 1;

-- Question 6 < List the top 5 countries with the least number of deaths.

SELECT `Country/Region`,SUM(Deaths) AS num FROM full_grouped
GROUP BY `Country/Region`
ORDER BY num
LIMIT 1;

-- Question 7 < What is the average recovery rate across all countries?

SELECT AVG(Recovered/Confirmed)*100 FROM full_grouped
WHERE Confirmed >0;

-- Question 7 < What is the average recovery rate across country by country?

SELECT `Country/Region`,AVG(Recovered/Confirmed)*100 FROM full_grouped
GROUP BY `Country/Region`;

-- Question 8 < Calculate the AVG death rate for each country.

SELECT `Country/Region`,AVG(Deaths/Confirmed)*100 FROM full_grouped
GROUP BY `Country/Region`;

-- Question 9 < How many active cases are there in total?

SELECT SUM(Active) FROM full_grouped;

-- Question 10 < Which country has the highest number of active cases?

SELECT `Country/Region`,SUM(Active) AS num FROM full_grouped
GROUP BY `Country/Region`
ORDER BY num DESC
LIMIT 1;

-- Question 11 < How have the total number of cases changed over time globally?

SELECT `WHO Region`,SUM(Active) FROM full_grouped
GROUP BY `WHO Region`;

-- Question 12 < Identify any dates where there was a significant spike in cases globally.

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
    SELECT AVG(DailyNewCases) AS AvgDailyNewCases, STDDEV(DailyNewCases) AS StdDevDailyNewCases
    FROM DailyCases
)
SELECT DailyCases.Date, DailyCases.DailyNewCases
FROM DailyCases, Stats
WHERE DailyCases.DailyNewCases > Stats.AvgDailyNewCases + 2 * Stats.StdDevDailyNewCases
ORDER BY DailyCases.DailyNewCases DESC;


-- Question 13 < Identify and handle any missing values in the dataset.

SELECT *
FROM full_grouped
WHERE Date IS NULL OR `Country/Region` IS NULL OR Confirmed IS NULL OR Deaths IS NULL OR Recovered IS NULL OR Active IS NULL OR `New cases` IS NULL OR `New deaths` IS NULL OR `New recovered` IS NULL OR `WHO Region` IS NULL
;



 
