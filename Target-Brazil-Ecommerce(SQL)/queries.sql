
-- Target Brazil E-Commerce SQL EDA

/* QUESTION 1: Exploratory Analysis */

-- 1. Get the time range between which the orders were placed
SELECT MIN(order_purchase_timestamp) AS first_order,
       MAX(order_purchase_timestamp) AS last_order
FROM `Business_Case_Target_SQL.orders`;

-- 2. Count the Cities & States of customers who ordered during the given period
SELECT COUNT(DISTINCT c.customer_state) AS state_count,
       COUNT(DISTINCT c.customer_city) AS city_count
FROM `Business_Case_Target_SQL.customers` c
JOIN `Business_Case_Target_SQL.orders` o
  ON c.customer_id = o.customer_id;


/* QUESTION 2: In-depth Exploration */

-- 1. Is there a growing trend in the number of orders placed over the past years?
SELECT EXTRACT(YEAR FROM order_purchase_timestamp) AS year,
       COUNT(customer_id) AS no_of_orders_placed
FROM `Business_Case_Target_SQL.orders`
GROUP BY year
ORDER BY year;

-- 2. Can we see monthly seasonality in terms of orders placed?
SELECT EXTRACT(YEAR FROM order_purchase_timestamp) AS year,
       EXTRACT(MONTH FROM order_purchase_timestamp) AS month,
       COUNT(customer_id) AS no_of_orders_placed
FROM `Business_Case_Target_SQL.orders`
GROUP BY year, month
ORDER BY year, month;

-- 3. During what time of the day do Brazilian customers mostly place their orders?
WITH hour_detail AS (
    SELECT EXTRACT(HOUR FROM order_purchase_timestamp) AS hour,
           customer_id
    FROM `Business_Case_Target_SQL.orders`
),
grouping_by_time AS (
    SELECT CASE
               WHEN hour BETWEEN 0 AND 6 THEN 'Dawn'
               WHEN hour BETWEEN 7 AND 12 THEN 'Morning'
               WHEN hour BETWEEN 13 AND 18 THEN 'Afternoon'
               ELSE 'Night'
           END AS time,
           COUNT(customer_id) AS orders_placed
    FROM hour_detail
    GROUP BY hour
)
SELECT time,
       SUM(orders_placed) AS total_orders
FROM grouping_by_time
GROUP BY time
ORDER BY total_orders DESC
LIMIT 1;


/* QUESTION 3: Evolution of E-commerce Orders */

-- 1. Get the month-on-month number of orders placed in each state
SELECT c.customer_state,
       EXTRACT(MONTH FROM o.order_purchase_timestamp) AS month,
       COUNT(c.customer_id) AS no_of_orders_placed
FROM `Business_Case_Target_SQL.orders` o
JOIN `Business_Case_Target_SQL.customers` c
  ON o.customer_id = c.customer_id
GROUP BY c.customer_state, month
ORDER BY c.customer_state, month;

-- 2. How are the customers distributed across all the states?
SELECT customer_state,
       COUNT(customer_id) AS customer_count
FROM `Business_Case_Target_SQL.customers`
GROUP BY customer_state
ORDER BY customer_count;


/* QUESTION 4: Impact on Economy */

-- 1. Get the % increase in the cost of orders from 2017 to 2018 (Jan-Aug only)
WITH each_year_price_value AS (
    SELECT SUM(p.payment_value) AS total_value,
           EXTRACT(YEAR FROM o.order_purchase_timestamp) AS year
    FROM `Business_Case_Target_SQL.orders` o
    JOIN `Business_Case_Target_SQL.payments` p
      ON o.order_id = p.order_id
    WHERE EXTRACT(YEAR FROM o.order_purchase_timestamp) IN (2017, 2018)
      AND EXTRACT(MONTH FROM o.order_purchase_timestamp) BETWEEN 1 AND 8
    GROUP BY year
)
SELECT ROUND(((SUM(CASE WHEN year = 2018 THEN total_value END) - 
                SUM(CASE WHEN year = 2017 THEN total_value END)) / 
                SUM(CASE WHEN year = 2017 THEN total_value END)) * 100, 2) AS increased_percentage
FROM each_year_price_value;

-- 2. Calculate the Total & Average order price for each state
SELECT c.customer_state, 
       ROUND(SUM(oi.price), 2) AS total, 
       ROUND(AVG(oi.price), 2) AS average
FROM `Business_Case_Target_SQL.orders` o
JOIN `Business_Case_Target_SQL.order_items` oi ON o.order_id = oi.order_id
JOIN `Business_Case_Target_SQL.customers` c ON o.customer_id = c.customer_id
GROUP BY c.customer_state
ORDER BY total DESC, average DESC;

-- 3. Calculate the Total & Average order freight for each state
SELECT c.customer_state, 
       ROUND(SUM(oi.freight_value), 2) AS total, 
       ROUND(AVG(oi.freight_value), 2) AS average
FROM `Business_Case_Target_SQL.orders` o
JOIN `Business_Case_Target_SQL.order_items` oi ON o.order_id = oi.order_id
JOIN `Business_Case_Target_SQL.customers` c ON o.customer_id = c.customer_id
GROUP BY c.customer_state
ORDER BY total DESC, average DESC;


/* QUESTION 5: Sales, Freight, and Delivery Time Analysis */

-- 1. Calculate delivery time and difference between estimated & actual delivery date
SELECT order_id, customer_id, 
       DATE_DIFF(order_delivered_customer_date, order_purchase_timestamp, DAY) AS time_to_deliver, 
       DATE_DIFF(order_delivered_customer_date, order_estimated_delivery_date, DAY) AS diff_estimated_delivery
FROM `Business_Case_Target_SQL.orders`;

-- 2. Top 5 states with lowest average freight value
SELECT c.customer_state, ROUND(AVG(oi.freight_value), 2) AS average_freight_value
FROM `Business_Case_Target_SQL.orders` o
JOIN `Business_Case_Target_SQL.customers` c ON o.customer_id = c.customer_id
JOIN `Business_Case_Target_SQL.order_items` oi ON o.order_id = oi.order_id
GROUP BY c.customer_state
ORDER BY average_freight_value
LIMIT 5;

-- 3. Top 5 states with highest average freight value
SELECT c.customer_state, ROUND(AVG(oi.freight_value), 2) AS average_freight_value
FROM `Business_Case_Target_SQL.orders` o
JOIN `Business_Case_Target_SQL.customers` c ON o.customer_id = c.customer_id
JOIN `Business_Case_Target_SQL.order_items` oi ON o.order_id = oi.order_id
GROUP BY c.customer_state
ORDER BY average_freight_value DESC
LIMIT 5;

-- 4. Top 5 states with lowest average delivery time
SELECT c.customer_state, 
       ROUND(AVG(DATE_DIFF(o.order_delivered_customer_date, o.order_purchase_timestamp, DAY)), 2) AS average_delivery_time
FROM `Business_Case_Target_SQL.orders` o
JOIN `Business_Case_Target_SQL.customers` c ON o.customer_id = c.customer_id
GROUP BY c.customer_state
ORDER BY average_delivery_time
LIMIT 5;

-- 5. Top 5 states with highest average delivery time
SELECT c.customer_state, 
       ROUND(AVG(DATE_DIFF(o.order_delivered_customer_date, o.order_purchase_timestamp, DAY)), 2) AS average_delivery_time
FROM `Business_Case_Target_SQL.orders` o
JOIN `Business_Case_Target_SQL.customers` c ON o.customer_id = c.customer_id
GROUP BY c.customer_state
ORDER BY average_delivery_time DESC
LIMIT 5;

-- 6. Top 5 states with fastest delivery compared to estimated date
SELECT c.customer_state, 
       ROUND(AVG(DATE_DIFF(o.order_estimated_delivery_date, o.order_delivered_customer_date, DAY)), 2) AS average_faster_delivery
FROM `Business_Case_Target_SQL.orders` o
JOIN `Business_Case_Target_SQL.customers` c ON o.customer_id = c.customer_id
GROUP BY c.customer_state
ORDER BY average_faster_delivery DESC
LIMIT 5;


/* QUESTION 6: Payment Analysis */

-- 1. Month-on-month number of orders placed using different payment types
SELECT EXTRACT(MONTH FROM o.order_purchase_timestamp) AS month, 
       p.payment_type, 
       COUNT(*) AS no_of_orders
FROM `Business_Case_Target_SQL.orders` o
JOIN `Business_Case_Target_SQL.payments` p ON o.order_id = p.order_id
GROUP BY month, p.payment_type
ORDER BY month, no_of_orders;

-- 2. Number of orders placed based on payment installments
SELECT payment_installments, COUNT(DISTINCT order_id) AS no_of_orders
FROM `Business_Case_Target_SQL.payments`
GROUP BY payment_installments
ORDER BY no_of_orders DESC;

