--  7 days rolling average 
WITH daily_cases AS (
  SELECT
    STR_TO_DATE(`ï»¿Date_reported`, '%d-%m-%Y') AS report_date,
    Country,
    Cumulative_cases,
    Cumulative_cases - LAG(Cumulative_cases) OVER (
      PARTITION BY Country ORDER BY STR_TO_DATE(`ï»¿Date_reported`, '%d-%m-%Y')
    ) AS new_cases
  FROM covid19_global
)

SELECT
  report_date,
  Country,
  new_cases,
  AVG(new_cases) OVER (
    PARTITION BY Country ORDER BY report_date
    ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
  ) AS rolling_avg
FROM daily_cases;

--  Death Growth Rate
WITH death_data AS (
  SELECT
    STR_TO_DATE(`ï»¿Date_reported`, '%d-%m-%Y') AS report_date,
    Country,
    Cumulative_deaths,
    LAG(Cumulative_deaths) OVER (
      PARTITION BY Country ORDER BY STR_TO_DATE(`ï»¿Date_reported`, '%d-%m-%Y')
    ) AS prev_deaths
  FROM covid19_global
)

SELECT
  report_date,
  Country,
  Cumulative_deaths,
  prev_deaths,
  ROUND(
    CASE
      WHEN prev_deaths = 0 OR prev_deaths IS NULL THEN NULL
      ELSE ((Cumulative_deaths - prev_deaths) / prev_deaths) * 100
    END, 2
  ) AS death_growth_rate
FROM death_data
WHERE Country = 'India'
order by death_growth_rate desc 
limit 10 ; 

-- top 15 countries by Case Fatality Rate 
SELECT
  Country,
  MAX(Cumulative_cases) AS total_cases,
  MAX(Cumulative_deaths) AS total_deaths,
  ROUND(
    (MAX(Cumulative_deaths) / NULLIF(MAX(Cumulative_cases), 0)) * 100, 2
  ) AS case_fatality_rate
FROM covid19_global
GROUP BY Country
ORDER BY case_fatality_rate DESC;

