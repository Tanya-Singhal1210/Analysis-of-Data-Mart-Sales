select * from clean_weekly_sales limit 10;

## Data Exploration

## 1.Which week numbers are missing from the dataset?

create table seq100
(x int not null auto_increment primary key);
insert into seq100 values (),(),(),(),(),(),(),(),(),();
insert into seq100 values (),(),(),(),(),(),(),(),(),();
insert into seq100 values (),(),(),(),(),(),(),(),(),();
insert into seq100 values (),(),(),(),(),(),(),(),(),();
insert into seq100 values (),(),(),(),(),(),(),(),(),();
insert into seq100 select x + 50 from seq100;
select * from seq100;
create table seq52 as (select x from seq100 limit 52);
select distinct x as week_day from seq52 where x not in(select distinct week_number from clean_weekly_sales); 

select distinct week_number from clean_weekly_sales;

## 2.How many total transactions were there for each year in the dataset?


SELECT
  calender_year,
  SUM(transactions) AS total_transactions
FROM clean_weekly_sales group by calender_year;

## 3.What are the total sales for each region for each month?

SELECT
  month_number,
  region,
  SUM(sales) AS total_sales
FROM clean_weekly_sales
GROUP BY month_number, region
ORDER BY month_number, region;

## 4.What is the total count of transactions for each platform?

SELECT
  platform,
  SUM(transactions) AS total_transactions
FROM clean_weekly_sales
GROUP BY platform;

## 5.What is the percentage of sales for Retail vs Shopify for each month?

SELECT
  month_number,
  calender_year,
  ROUND(
    100 * MAX(CASE WHEN platform = 'Retail' THEN monthly_sales ELSE NULL END) /
      SUM(monthly_sales),
    2
  ) AS retail_percentage,
  ROUND(
    100 * MAX(CASE WHEN platform = 'Shopify' THEN monthly_sales ELSE NULL END) /
      SUM(monthly_sales),
    2
  ) AS shopify_percentage
FROM (
  SELECT
    month_number,
    calender_year,
    platform,
    SUM(sales) AS monthly_sales
  FROM clean_weekly_sales
  GROUP BY month_number, calender_year, platform
) AS monthly_platform_sales
GROUP BY month_number, calender_year
ORDER BY month_number, calender_year;

## 6.What is the percentage of sales by demographic for each year in the dataset?

select calender_year, demographic, sum(sales) as yearly_sales,
round(100*sum(sales)/ sum(sum(sales)) 
over (partition by demographic),2) as percentage
from clean_weekly_sales
group by calender_year, demographic;

## 7.Which age_band and demographic values contribute the most to Retail sales?

select age_band, demographic,
sum(sales) as total_sales
from clean_weekly_sales
where platform = 'Retail'
group by age_band, demographic
order by total_sales desc;