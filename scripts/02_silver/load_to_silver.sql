/*
DDL Script: Create Tables

Script Purpose:
============================================================================
	1. Creates 'amazon_brazil' schema if it does not exist.
    2. Creates tables in 'amazon_brazil' schema if not already exists.
============================================================================
*/

CREATE SCHEMA IF NOT EXISTS amazon_brazil;

CREATE TABLE IF NOT EXISTS amazon_brazil.customers (
    customer_id                   VARCHAR(100) PRIMARY KEY,
    customer_unique_id            VARCHAR(100),
    customer_zip_code_prefix      INT
);

CREATE TABLE IF NOT EXISTS amazon_brazil.orders (
    order_id      			 		VARCHAR(100) PRIMARY KEY,
    customer_id       				VARCHAR(100),
    order_status     				VARCHAR(50),
    order_purchase_timestamp 		TIMESTAMP,
    order_approved_at   			TIMESTAMP,
	order_delivered_carrier_date 	TIMESTAMP,
	order_delivered_customer_date 	TIMESTAMP,
	order_estimated_delivery_date 	TIMESTAMP
);

CREATE TABLE IF NOT EXISTS amazon_brazil.payments (
    order_id  				VARCHAR(100),
    payment_sequential 		INT,
    payment_type  			VARCHAR(50),
    payment_installments 	INT,
    payment_value  			NUMERIC
);

CREATE TABLE IF NOT EXISTS amazon_brazil.sellers (
    seller_id   			VARCHAR(100) PRIMARY KEY,
    seller_zip_code_prefix 	INT
);

CREATE TABLE IF NOT EXISTS amazon_brazil.order_items (
    order_id   			VARCHAR(100),
    order_item_id 		INT,
	product_id 			VARCHAR(100),
	seller_id  			VARCHAR(100),
	shipping_limit_date TIMESTAMP,
	price 				NUMERIC,
	freight_value 		NUMERIC
);

CREATE TABLE IF NOT EXISTS amazon_brazil.products (
    product_id           		VARCHAR(100) PRIMARY KEY,
    product_category_name       VARCHAR(100),
    product_name_lenght       	INT,
    product_description_lenght  INT,
	product_photos_qty 			INT,
	product_weight_g 			INT,
	product_length_cm		 	INT,
	product_height_cm 			INT,
	product_width_cm 			INT
);

CREATE TABLE IF NOT EXISTS amazon_brazil.sellers (
    seller_id   			VARCHAR(100) PRIMARY KEY,
    seller_zip_code_prefix 	INT
);

CREATE TABLE IF NOT EXISTS amazon_brazil.order_items (
    order_id   			VARCHAR(100),
    order_item_id 		INT,
	product_id 			VARCHAR(100),
	seller_id  			VARCHAR(100),
	shipping_limit_date TIMESTAMP,
	price 				NUMERIC,
	freight_value 		NUMERIC
);

CREATE TABLE IF NOT EXISTS amazon_brazil.products (
    product_id           		VARCHAR(100) PRIMARY KEY,
    product_category_name       VARCHAR(100),
    product_name_lenght       	INT,
    product_description_lenght  INT,
	product_photos_qty 			INT,
	product_weight_g 			INT,
	product_length_cm		 	INT,
	product_height_cm 			INT,
	product_width_cm 			INT
);
/*
========================================================================================
DQL Script: Analysis - I

Script Purpose:
========================================================================================
	1. To simplify its financial reports, Amazon India needs to standardize 
	   payment values. Display the average payment values for each payment_type.
	   Round the average payment values to integer (no decimal) and display the 
	   results sorted in ascending order. 
*/

SELECT 
	payment_type,
	ROUND(AVG(payment_value),0) AS rounded_avg_payment
FROM amazon_brazil.payments
WHERE payment_type <> 'not_defined'
GROUP BY payment_type
ORDER BY rounded_avg_payment ASC;
/*
========================================================================================

	2. To refine its payment strategy, Amazon India wants to know the 
	   distribution of orders by payment type. Calculate the percentage 
	   of total orders for each payment type, rounded to one decimal place, 
	   and display them in descending order
*/
SELECT payment_type,
       ROUND(COUNT(DISTINCT o.order_id)*100.0/
       (SELECT COUNT(DISTINCT o.order_id)
        FROM amazon_brazil.payments p 
		JOIN amazon_brazil.orders o 
			ON p.order_id = o.order_id
        WHERE p.payment_type <> 'not_defined'),1) AS percentage_orders
FROM amazon_brazil.payments p 
JOIN amazon_brazil.orders o 
	ON p.order_id = o.order_id
WHERE p.payment_type <> 'not_defined'
GROUP BY p.payment_type
ORDER BY percentage_orders DESC;
/*
========================================================================================
	3. Amazon India seeks to create targeted promotions for products within
	   specific price ranges. Identify all products priced between 100 and 
	   500 BRL that contain the word 'Smart' in their name. 
	   Display these products, sorted by price in descending order.
*/

SELECT 
	oi.product_id,
	MAX(oi.price) AS price
FROM amazon_brazil.order_items oi 
JOIN amazon_brazil.products p 
	ON oi.product_id = p.product_id
WHERE p.product_category_name ILIKE '%Smart%'
	AND oi.price BETWEEN 100 AND 500
GROUP BY oi.product_id
ORDER BY price DESC;
/*
========================================================================================
	4.To identify seasonal sales patterns, Amazon India needs to focus on
	  the most successful months. Determine the top 3 months with the 
	  highest total sales value, rounded to the nearest integer.
*/

SELECT 
	TO_CHAR(order_purchase_timestamp,'Month') AS month,
	ROUND(SUM(oi.price + oi.freight_value),0) AS total_sales
FROM amazon_brazil.orders o 
JOIN amazon_brazil.order_items oi
	ON oi.order_id = o.order_id
WHERE o.order_status NOT IN ('canceled', 'unavailable')
GROUP BY month
ORDER BY total_sales DESC
LIMIT 3;

/*
========================================================================================
	5. Amazon India is interested in product categories with significant 
	   price variations. Find categories where the difference between 
	   the maximum and minimum product prices is greater than 500 BRL.	   
*/

SELECT 
	p.product_category_name,
	MAX(oi.price)-MIN(oi.price) AS price_difference
FROM amazon_brazil.order_items oi 
JOIN amazon_brazil.products p 
	ON oi.product_id = p.product_id
WHERE p.product_category_name IS NOT NULL
GROUP BY p.product_category_name
HAVING MAX(oi.price) - MIN(oi.price) > 500
ORDER BY price_difference DESC;
/*
========================================================================================
	6. To enhance the customer experience, Amazon India wants to find which
	   payment types have the most consistent transaction amounts. Identify 
	   the payment types with the least variance in transaction amounts, 
	   sorting by the smallest standard deviation first.   
*/

SELECT 
	payment_type,
	ROUND(STDDEV(payment_value),2) AS std_deviation
FROM amazon_brazil.payments
WHERE payment_type <> 'not_defined'
GROUP BY payment_type
ORDER BY std_deviation ASC;
/*
========================================================================================
	7. Amazon India wants to identify products that may have incomplete 
	   name in order to fix it from their end. Retrieve the list of products 
	   where the product category name is missing or contains only a single
	   character.  
*/

SELECT 
	product_id, 
	product_category_name
FROM amazon_brazil.products
WHERE product_category_name IS NULL
OR LENGTH(TRIM(product_category_name)) = 1
ORDER BY product_category_name;
/*
========================================================================================
DQL Script: Analysis - II

Script Purpose:
========================================================================================
	1. Amazon India wants to understand which payment types are most popular across 
	   different order value segments (e.g., low, medium, high). Segment order values 
	   into three ranges: orders less than 200 BRL, between 200 and 1000 BRL, and 
	   over 1000 BRL. Calculate the count of each payment type within these ranges 
	   and display the results in descending order of count.*/
	   
WITH order_value_table AS (
SELECT order_id ,SUM(price + freight_value) AS order_value
FROM amazon_brazil.order_items
GROUP BY order_id
)

SELECT 	
	CASE WHEN ov.order_value < 200 THEN 'low'
		 WHEN ov.order_value BETWEEN 200 AND 1000 THEN 'medium'
		 ELSE 'high'
		 END AS order_value_segment,
	p.payment_type,
	COUNT(DISTINCT ov.order_id) AS count
FROM order_value_table ov
JOIN amazon_brazil.payments p ON ov.order_id = p.order_id
WHERE p.payment_type <> 'not_defined'
GROUP BY order_value_segment,p.payment_type
ORDER BY count DESC;
/*
========================================================================================
	2. Amazon India wants to analyse the price range and average price for 
	   each product category. Calculate the minimum, maximum, and average 
	   price for each category, and list them in descending order by the 
	   average price.*/
	   
SELECT 
	p.product_category_name,
	MIN(oi.price) AS min_price,
	MAX(oi.price) AS max_price,
	ROUND(AVG(oi.price),2) AS avg_price
FROM amazon_brazil.order_items oi
JOIN amazon_brazil.products p 
	ON oi.product_id = p.product_id
GROUP BY p.product_category_name
ORDER BY avg_price DESC;
/*
========================================================================================
	3. Amazon India wants to identify the customers who have placed multiple 
	   orders over time. Find all customers with more than one order, and 
	   display their customer unique IDs along with the total number of 
	   orders they have placed.*/

SELECT 
	c.customer_unique_id,
	COUNT(DISTINCT o.order_id) AS total_orders
FROM amazon_brazil.customers c
JOIN amazon_brazil.orders o
	ON o.customer_id = c.customer_id
GROUP BY c.customer_unique_id
HAVING COUNT(*) > 1
ORDER BY total_orders DESC;
/*
========================================================================================
	4. Amazon India wants to categorize customers into different types 
	   ('New – order qty. = 1' ;  'Returning' –order qty. 2 to 4;  'Loyal' – order qty. >4) 
	   based on their purchase history. Use a temporary table to define these categories and 
	   join it with the customers table to update and display the customer types.*/

CREATE TEMP TABLE customer_type AS
SELECT 
	customer_id,
	CASE WHEN total_orders = 1 THEN 'New'
		 WHEN total_orders BETWEEN 2 AND 4 THEN 'Returning'
		 ELSE 'Loyal'
	END AS customer_type
FROM(
	SELECT 
	customer_id,
	COUNT(DISTINCT order_id) AS total_orders
FROM amazon_brazil.orders
GROUP BY customer_id
) t;

SELECT 
    c.customer_unique_id,
    ct.customer_type
FROM amazon_brazil.customers c
JOIN customer_type ct
    ON c.customer_id = ct.customer_id;

