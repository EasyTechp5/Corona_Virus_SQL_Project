CREATE TABLE coronaDB (Province varchar,
					   "Country/Region" varchar,
					   Latitude float,
					   Longitude float,
					   Date date,
					   Confirmed int,
					   Deaths int,
					   Recovered int
)

SELECT * FROM public.coronadb
DROP TABLE coronadb

-- Question 1: check out the null values 

SELECT * FROM public.coronadb
WHERE
Province IS NULL OR
"Country/Region" IS NULL OR
Latitude IS NULL OR
Longitude IS NULL OR
Date IS NULL OR
Confirmed IS NULL OR
Deaths IS NULL OR
Recovered IS NULL 

-- Question 2: Check out the total number of rows present in our data

SELECT COUNT(*) FROM public.coronadb number_of_rows
-- we have 36,563 rows

SELECT COUNT(DISTINCT province) 
FROM coronadb

-- Question 3: check when the start and the end date

SELECT MIN(date) starting_date, MAX(date) end_date
FROM coronadb

-- Question 4: number of months present in the dataset
SELECT COUNT(DISTINCT TO_CHAR(date, 'YYYY-MM')) AS year_month
FROM coronadb;
-- we have 18 months

-- Question 5: find monthly average death, confirmed and recovered cases
SELECT 
ROUND(AVG(confirmed),2), 
AVG(deaths), 
AVG(recovered)
FROM coronadb

SELECT * FROM coronadb

SELECT 
	EXTRACT(Month FROM date), 
	ROUND(AVG(confirmed),2), 
	ROUND(AVG(deaths)), 
	ROUND(AVG(recovered))
FROM coronadb
GROUP BY EXTRACT(Month FROM date)
ORDER BY EXTRACT(Month FROM date)

-- or to see the month in form of month name
SELECT 
    TO_CHAR(date, 'Month') AS month_name, 
    ROUND(AVG(confirmed), 2) AS avg_confirmed, 
    ROUND(AVG(deaths)) AS avg_deaths, 
    ROUND(AVG(recovered)) AS avg_recovered
FROM coronadb
GROUP BY EXTRACT(MONTH FROM date), TO_CHAR(date, 'Month')
ORDER BY EXTRACT(MONTH FROM date);


-- Question 6: find the yearly average death, confirmed and recovered cases
SELECT 
	EXTRACT(YEAR FROM date) AS YEAR, 
	ROUND(MIN(confirmed)) AS Min_confirmed, 
	ROUND(MIN(deaths)) AS Min_death, 
	ROUND(MIN(recovered)) AS Min_recovered
FROM coronadb
WHERE confirmed != 0 AND deaths != 0 AND recovered != 0 
GROUP BY YEAR
ORDER BY YEAR DESC

-- Question 7: The total number of confirmed, deaths and recovered each month

SELECT 
	TO_CHAR(date, 'Month') AS Month,
	SUM(confirmed) AS total_confirmed,
	SUM(deaths) AS total_death,
	SUM(recovered) AS total_recovered
FROM coronadb
GROUP BY EXTRACT(MONTH FROM date), TO_CHAR(date, 'Month')
ORDER BY EXTRACT(MONTH FROM date); 

-- Question 8: Find country having the highest confirmed cases

SELECT 
	"Country/Region" AS country, SUM(confirmed) totalConfirmed
	FROM coronadb
GROUP BY country
ORDER BY totalConfirmed DESC
LIMIT 1

-- or using CTE

WITH country_totals AS (
    SELECT 
        "Country/Region" AS country, 
        SUM(confirmed) AS totalConfirmed
    FROM coronadb
    GROUP BY country
)
SELECT 
    country, 
    totalConfirmed
FROM country_totals
ORDER BY totalConfirmed DESC
LIMIT 1;

-- using CTE and ranking 
SELECT 
    "Country/Region" AS country, 
    SUM(confirmed) AS totalConfirmed,
    RANK() OVER (ORDER BY SUM(confirmed) DESC) AS rank
FROM coronadb
GROUP BY country
ORDER BY totalConfirmed DESC;


-- Question 9: Find country with the lowest of the death case
SELECT 
"Country/Region" as country, 
SUM(deaths) AS lowest_death,
RANK() OVER(ORDER BY SUM(deaths) ASC)
FROM coronadb
GROUP BY country
LIMIT 1

/*-- Question 10: check out how corona virus spread out with respect to confirm cases 
(e.g total confirmed cases, their average, variance and STDEV) */

SELECT 
    ROUND(SUM(confirmed)) AS total_confirmed_cases,
    ROUND(AVG(confirmed)) AS average_confirmed_cases,
    ROUND(VARIANCE(confirmed)) AS variance_confirmed_cases,
    ROUND(STDDEV(confirmed)) AS stdev_confirmed_cases
FROM coronadb;

/*-- Question 11: check out corona virus spread with respect to death case per month
(E.g total confirmed case, their average, variance and STDEV) */


SELECT 
	TO_CHAR(date, 'Month')  AS Month,
	SUM(confirmed) total_death,
	ROUND(AVG(deaths),2) AVg_death
FROM coronadb
GROUP BY EXTRACT(MONTH FROM date), TO_CHAR(date, 'Month')
ORDER BY EXTRACT(MONTH FROM date); 

