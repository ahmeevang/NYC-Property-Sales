--Exploring data from property sales in New York City to find insights
--September 2016 to September 2017


SELECT *
FROM property_sales;


--Average price properties sold for
--by zipcode
SELECT zip_code, AVG(sale_price)
FROM property_sales
WHERE zip_code != 0
GROUP BY zip_code;

--by borough
SELECT borough, AVG(sale_price)
FROM property_sales
GROUP BY borough;


--Separating out the month that each property was sold
SELECT address, apartment_number, zip_code, borough, strftime('%m', sale_date) AS month_sold
FROM property_sales
ORDER BY month_sold;


--Creating a CTE
--View months in previous query by name
WITH month_cte AS
(
SELECT *, strftime('%m', sale_date) AS month
FROM property_sales
)

SELECT address, apartment_number, zip_code, borough,
    CASE
        WHEN month = '01' THEN 'January'
        WHEN month = '02' THEN 'February'
        WHEN month = '03' THEN 'March'
        WHEN month = '04' THEN 'April'
        WHEN month = '05' THEN 'May'
        WHEN month = '06' THEN 'June'
        WHEN month = '07' THEN 'July'
        WHEN month = '08' THEN 'August'
        WHEN month = '09' THEN 'September'
        WHEN month = '10' THEN 'October'
        WHEN month = '11' THEN 'November'
        WHEN month = '12' THEN 'December'
        END AS month_sold
FROM month_CTE
JOIN property_sales
    ON month_CTE.id = property_sales.id
ORDER BY month;


--Monthly count on how many properties were sold
WITH month_cte AS
(
SELECT *, strftime('%m', sale_date) AS month
FROM property_sales
)

SELECT
    CASE
        WHEN month = '01' THEN 'January'
        WHEN month = '02' THEN 'February'
        WHEN month = '03' THEN 'March'
        WHEN month = '04' THEN 'April'
        WHEN month = '05' THEN 'May'
        WHEN month = '06' THEN 'June'
        WHEN month = '07' THEN 'July'
        WHEN month = '08' THEN 'August'
        WHEN month = '09' THEN 'September'
        WHEN month = '10' THEN 'October'
        WHEN month = '11' THEN 'November'
        WHEN month = '12' THEN 'December'
        END AS month_sold,
COUNT(CASE
        WHEN month = '01' THEN 'January'
        WHEN month = '02' THEN 'February'
        WHEN month = '03' THEN 'March'
        WHEN month = '04' THEN 'April'
        WHEN month = '05' THEN 'May'
        WHEN month = '06' THEN 'June'
        WHEN month = '07' THEN 'July'
        WHEN month = '08' THEN 'August'
        WHEN month = '09' THEN 'September'
        WHEN month = '10' THEN 'October'
        WHEN month = '11' THEN 'November'
        WHEN month = '12' THEN 'December'
        END) AS properties_sold
FROM month_CTE
JOIN property_sales
    ON month_CTE.id = property_sales.id
GROUP BY month_sold
ORDER BY month;


--How many properties were sold
--based on building class
SELECT building_class_category, COUNT(building_class_category) AS properties_sold
FROM property_sales
GROUP BY building_class_category
ORDER BY properties_sold DESC;


--How many properties were sold and average price
--based on building class
SELECT building_class_category, COUNT(building_class_category) AS properties_sold, AVG(sale_price) AS average_sale_price
FROM property_sales
GROUP BY building_class_category
ORDER BY properties_sold DESC;


--Number of properties sold
--categorized by year built
SELECT year_built, COUNT(year_built) AS properties_sold, AVG(sale_price) AS average_property_price
FROM property_sales
WHERE year_built != 0
GROUP BY year_built
ORDER BY properties_sold DESC;


--Number of properties sold
--in each borough
SELECT COUNT(borough) AS properties_sold,
    CASE
        WHEN borough = 1 THEN 'Manhattan'
        WHEN borough = 2 THEN 'Bronx'
        WHEN borough = 3 THEN 'Brooklyn'
        WHEN borough = 4 THEN 'Queens'
        WHEN borough = 5 THEN 'Staten Island'
        END AS bourough_name
FROM property_sales
GROUP BY borough
ORDER BY properties_sold DESC;


--Number of properties sold
--in each borough and the average sale price
SELECT COUNT(borough) AS properties_sold,
    CASE
        WHEN borough = 1 THEN 'Manhattan'
        WHEN borough = 2 THEN 'Bronx'
        WHEN borough = 3 THEN 'Brooklyn'
        WHEN borough = 4 THEN 'Queens'
        WHEN borough = 5 THEN 'Staten Island'
        END AS bourough_name, AVG(sale_price) AS average_property_price
FROM property_sales
GROUP BY borough
ORDER BY properties_sold DESC;


--When sale price is very low (< 100) = house was transferred to another person
SELECT address, zip_code, sale_price, borough
FROM property_sales
WHERE sale_price < 100;

--Counting the amount of transferred properties using a CTE
--by zipcode
WITH transferred_sales_CTE AS
(
SELECT *
FROM property_sales
WHERE sale_price < 100
)

SELECT COUNT(borough) AS transfers, zip_code
FROM transferred_sales_CTE
WHERE zip_code != 0
GROUP BY zip_code;
