USE retail_orders;

SELECT * 
FROM orders;

DESCRIBE orders;

-- findings: Many columns that have correct or precise data type
ALTER TABLE orders
MODIFY COLUMN order_id INT PRIMARY KEY,
MODIFY COLUMN order_date DATE,
MODIFY COLUMN ship_mode VARCHAR(20),
MODIFY COLUMN segment VARCHAR(20),
MODIFY COLUMN country VARCHAR(20),
MODIFY COLUMN city VARCHAR(20),
MODIFY COLUMN state VARCHAR(20),
MODIFY COLUMN postal_code VARCHAR(20),
MODIFY COLUMN region VARCHAR(20),
MODIFY COLUMN category VARCHAR(20),
MODIFY COLUMN sub_category VARCHAR(20),
MODIFY COLUMN product_id VARCHAR(20),
MODIFY COLUMN quantity INT,
MODIFY COLUMN discount DECIMAL(7,2),
MODIFY COLUMN sale_price DECIMAL(7,2),
MODIFY COLUMN profit DECIMAL(7,2);
-- another way is to create the table yourself and just append the data


-- 1. find top 10 highest reveue generating products 

SELECT product_id , SUM(sale_price) AS sale_price
FROM orders
GROUP BY product_id
ORDER BY 2 DESC
LIMIT 10;


-- 2. find top 5 highest selling products in each region

SELECT DISTINCT region 
FROM orders;

WITH product_per_region AS(
SELECT 
	region, 
	product_id, 
	SUM(sale_price) AS sales,
    DENSE_RANK() OVER(PARTITION BY region ORDER BY SUM(sale_price) DESC) AS prod_num
FROM orders
GROUP BY region, product_id
)
SELECT region, product_id, sales
FROM product_per_region
WHERE prod_num<=5;


-- 3. find month over month growth comparison for 2022 and 2023 sales eg : jan 2022 vs jan 2023

SELECT MIN(order_date) AS first_date, MAX(order_date) AS last_date
FROM orders;
-- 1 Jan 2022 to 31 Dec 2023

WITH monthly_sales AS(
SELECT YEAR(order_date) AS order_year, MONTH(order_date) AS order_month, SUM(sale_price) AS sales
FROM orders
GROUP BY YEAR(order_date), MONTH(order_date) 
-- ORDER BY YEAR(order_date), MONTH(order_date)
)

SELECT order_month,
SUM(CASE WHEN order_year = 2022 THEN sales ELSE 0 END) AS sales_2022,
SUM(CASE WHEN order_year = 2023 THEN sales ELSE 0 END) AS sales_2023
FROM monthly_sales
GROUP BY order_month
ORDER BY order_month;

-- 4. for each category which month had highest sales 
SELECT DISTINCT category
FROM orders;

WITH category_month_sales AS(
SELECT category, DATE_FORMAT(order_date,'%Y%m') AS order_year_month, SUM(sale_price) AS sales,
DENSE_RANK() OVER(PARTITION BY category ORDER BY SUM(sale_price) DESC) AS ranking
FROM orders
GROUP BY category, DATE_FORMAT(order_date,'%Y%m')
)
SELECT category, order_year_month, sales
FROM category_month_sales
WHERE ranking = 1
ORDER BY order_year_month;



-- 5. which sub category had highest growth by profit in 2023 compare to 2022
SELECT DISTINCT sub_category
FROM orders;

WITH subcategory_yearly_sales AS(
SELECT sub_category, YEAR(order_date) AS order_year, SUM(sale_price) AS sales
FROM orders
GROUP BY sub_category,YEAR(order_date) 
-- ORDER BY YEAR(order_date), MONTH(order_date)
),
sub_category_pivot AS (
SELECT sub_category,
SUM(CASE WHEN order_year = 2022 THEN sales ELSE 0 END) AS sales_2022,
SUM(CASE WHEN order_year = 2023 THEN sales ELSE 0 END) AS sales_2023
FROM subcategory_yearly_sales
GROUP BY sub_category
)

SELECT *,
(sales_2023- sales_2022)*100/sales_2022 AS growth_percent
FROM sub_category_pivot
ORDER BY growth_percent DESC
LIMIT 1;


-- 6. What is the revenue contribution of each customer segment (Segment) over time? / What is the total revenue generated by each customer segment (Segment) across all years?

WITH segment_revenue_per_year AS (
SELECT segment, YEAR(order_date) AS order_year ,SUM(sale_price) AS sales
FROM orders
GROUP BY segment, order_year
)
SELECT segment,
SUM(CASE WHEN order_year = 2022 THEN sales ELSE 0 END) AS sales_2022,
SUM(CASE WHEN order_year = 2023 THEN sales ELSE 0 END) AS sales_2023
FROM segment_revenue_per_year
GROUP BY segment
ORDER by sales_2022, sales_2023;

-- 7. Which product or region have the highest profit margins? / Which product have the highest profit margins ((List Price - cost price) / List Price)?

SELECT product_id, ROUND(SUM(profit)*100/SUM(sale_price),2) AS profit_margin
FROM orders
GROUP BY product_id
ORDER BY profit_margin DESC
LIMIT 1;

SELECT region, ROUND(SUM(profit)*100/SUM(sale_price),2) AS profit_margin
FROM orders
GROUP BY region
ORDER BY profit_margin DESC
LIMIT 1;


-- 8. How does the Ship Mode influence sales or profitability? / Which shipping mode (Ship Mode) is used most frequently across all orders?
SELECT ship_mode, SUM(sale_price) as sales
FROM orders
WHERE ship_mode IS NOT NULL
GROUP BY ship_mode
ORDER BY sales DESC;
-- Standard Class generate most revenue over the years
-- lets look at per_year revenue of each shipping mode

WITH ship_mode_year_revenue AS (
	SELECT ship_mode, YEAR(order_date) AS order_year, SUM(sale_price) AS sales
    FROM orders
    WHERE ship_mode IS NOT NULL
    GROUP BY ship_mode, YEAR(order_date)
)
SELECT ship_mode,
SUM(CASE WHEN order_year = 2022 THEN sales ELSE 0 END) AS sales_2022,
SUM(CASE WHEN order_year = 2023 THEN sales ELSE 0 END) AS sales_2023
FROM ship_mode_year_revenue
GROUP BY ship_mode
ORDER BY ship_mode;

-- 9. Compare total sales across seasons
-- The seasons in the United States are: 
-- Winter: December, January, and February
-- Spring: March, April, and May
-- Summer: June, July, and August
-- Fall: September, October, and November

WITH month_year_revenue AS (
SELECT YEAR(order_date) AS order_year, MONTH(order_date) AS order_month, SUM(sale_price) AS sales
FROM orders
GROUP BY order_year, order_month
)
SELECT 
	order_year,
    SUM(CASE WHEN order_month IN (12,1,2) THEN sales ELSE 0 END) AS Winter,
    SUM(CASE WHEN order_month IN (3,4,5) THEN sales ELSE 0 END) AS Spring,
    SUM(CASE WHEN order_month IN (6,7,8) THEN sales ELSE 0 END) AS Summer,
    SUM(CASE WHEN order_month IN (9,10,11) THEN sales ELSE 0 END) AS Fall
FROM month_year_revenue
GROUP BY order_year;

-- 10. Calculate the seasonal sales growth and determine which region performed the best in each season per year.

WITH seasonal_sales AS (
SELECT
	YEAR(order_date) AS order_year, 
    CASE 
		WHEN MONTH(order_date) IN (12,1,2) THEN "Winter"
		WHEN MONTH(order_date) IN (3,4,5) THEN "Spring"
		WHEN MONTH(order_date) IN (6,7,8) THEN "Summer"	
		WHEN MONTH(order_date) IN (9,10,11) THEN "Fall"
        END AS seasons,
    region,
    SUM(sale_price) AS sales
FROM orders
GROUP BY order_year, seasons, region
), seasonal_best AS (
	SELECT *, 
    DENSE_RANK() OVER(PARTITION BY seasons, order_year ORDER BY sales DESC) AS ranking
    FROM seasonal_sales
) 
SELECT order_year, seasons,region,sales
FROM seasonal_best
WHERE ranking = 1;

