-- Total number of COVID-19 cases and deaths reported globally.
Select sum(New_cases) as Total_cases_global, 
sum(New_deaths) as Total_deaths_global 
from covid19_global ;

-- country having reported the highest cumulative cases and deaths.
select Country 
from covid19_global
group by Country
having avg(New_cases)
order by avg(New_cases) desc
limit 5 ; 

-- The top 5 countries by average new cases per day.
select Country
from covid19_global
group by Country 
having max(Cumulative_cases) and 
max(Cumulative_deaths) 
order by max(Cumulative_cases) and max(Cumulative_deaths) desc 
 limit 1 ; 
 
 -- Total days of data available for each country
 select 
count(distinct ï»¿Date_reported ) as no_of_days 
from covid19_global 
group by Country 
Limit 1 ; 

--   Date and country having highest number of new cases globally.
select ï»¿Date_reported as Highest_Date,
Country 
from covid19_global 
group by ï»¿Date_reported ,Country
having max(New_cases)
Limit 1 ;

-- Fastest rising cases by time across WHO regions.

Select WHO_region,
Max(str_to_date( ï»¿Date_reported, "%d-%m-%Y")) as EndDate,
min(str_to_date(ï»¿Date_reported,"%d-%m-%Y") )as MinDate ,
Min(Cumulative_cases) as Startcase,
Max(Cumulative_cases) as Endcase ,
Round((Max(Cumulative_cases)-Min(Cumulative_cases))/ datediff(Max(str_to_date( ï»¿Date_reported, "%d-%m-%Y")),min(str_to_date(ï»¿Date_reported,"%d-%m-%Y") )), 3) as AvgCaseIncrease 
from covid19_global
group by WHO_region
order by AvgCaseIncrease desc ; 