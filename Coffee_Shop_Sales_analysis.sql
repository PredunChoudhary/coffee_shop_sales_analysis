ALTER TABLE coffee shop sales (1) 
RENAME TO to coffee_shop_sales;

-- Creating a data base. 

create database coffee_database;

-- Changing the format of Date and its Type. 

DESCRIBE coffee_shop_sales;

SELECT DISTINCT transaction_date from coffee_shop_sales;

UPDATE coffee_shop_sales
SET transaction_date = STR_TO_DATE(transaction_date, '%m/%d/%Y');

ALTER TABLE coffee_shop_sales
MODIFY COLUMN transaction_date DATE;

-- Changing the format of time and Type. 

SELECT DISTINCT transaction_time from coffee_shop_sales;

UPDATE coffee_shop_sales
SET transaction_time = STR_TO_DATE(transaction_time, '%H:%i:%s');

ALTER TABLE coffee_shop_sales
MODIFY COLUMN transaction_time TIME;

-- Changing the column name. 

ALTER TABLE coffee_shop_sales
CHANGE COLUMN ï»¿transaction_id transaction_id INT;

DESCRIBE coffee_shop_sales;

-- DATA CLEANING PART HAS BEEN DONE NOW WE ARE MOVING TO ANALYZE THE DATA. 

SELECT * FROM coffee_shop_sales;

-- SECTION 1- TOTAL SALES ANALYSIS 
--       Q 1- CALCULATE THE TOTAL SALES FOR EACH RESPECTIVE MONTH. 

SELECT 
	DISTINCT MONTH(transaction_date) AS Months, 
    CONCAT((ROUND(SUM(unit_price*transaction_qty)))/1000 , 'K') AS Total_Sales
FROM coffee_shop_sales
GROUP BY MONTHS;


--       Q 2- DETERMINE THE MONTH-ON-MONTH INCREASE OR DECREASE IN SALES.

SELECT 	
	DISTINCT MONTH (transaction_date) AS Months,
    ROUND(SUM(unit_price*transaction_qty)) AS TOTAL_SALES,
	ROUND(SUM(unit_price*transaction_qty) - LAG(SUM(unit_price*transaction_qty),1) OVER(ORDER BY(MONTH(transaction_date))))
	AS mom_Difference
FROM coffee_shop_sales 
GROUP BY Months
ORDER BY Months;

--       Q 3- CALCULATE THE DIFFERENCE IN SALES BETWEEN THE SELECTED MONTH AND THE PREVIOUS MONTH.

SELECT 	
	DISTINCT MONTH (transaction_date) AS Months,
    ROUND(SUM(unit_price*transaction_qty)) AS TOTAL_SALES,
	(SUM(unit_price*transaction_qty) - LAG(SUM(unit_price*transaction_qty),1) OVER(ORDER BY(MONTH(transaction_date))))
    / LAG(SUM(unit_price*transaction_qty),1) OVER(ORDER BY(MONTH(transaction_date))) * 100 AS mom_Increase_Percentage
FROM coffee_shop_sales 
WHERE MONTH (transaction_date) IN (5,6)
GROUP BY Months
ORDER BY Months;


-- SECTION 2- TOTAL ORDER ANALYSIS 
--       Q 1- CALCULATE THE TOTAL NO. OF ORDERS FOR EACH RESPECTIVE MONTH.

SELECT 
	DISTINCT MONTH(transaction_date) AS Months,
    CONCAT(ROUND(COUNT(transaction_id)/1000) , ' K') AS Total_Orders
FROM coffee_shop_sales
GROUP BY Months
ORDER BY Months;
 
--       Q 2- DETERMINE THE MONTH-ON-MONTH INCREASE OR DECREASE IN THE NUMBER OF ORDERS.

SELECT
	MONTH (transaction_date) AS Months,
    CONCAT(ROUND(COUNT(transaction_id)/1000) , ' k'),
    (COUNT(transaction_id) - LAG(COUNT(transaction_id), 1) OVER(ORDER BY (MONTH (transaction_date))))
FROM coffee_shop_sales
GROUP BY Months
ORDER BY  Months;

--       Q 3- CALCULATE THE DIFFERENCE IN THE NUMBER OF ORDERS BETWEEN THE SELECTED MONTH AND THE PREVIOUS MONTH.

SELECT
	MONTH (transaction_date) AS Months,
    CONCAT(ROUND(COUNT(transaction_id)/1000) , ' k'),
    (COUNT(transaction_id) - LAG(COUNT(transaction_id), 1) OVER(ORDER BY (MONTH (transaction_date))))
    / LAG(COUNT(transaction_id), 1) OVER(ORDER BY (MONTH (transaction_date))) *100 AS mom_order_difference
FROM coffee_shop_sales
WHERE MONTH (transaction_date) IN (5,6)
GROUP BY Months
ORDER BY  Months;

-- SECTION 3- TOTAL QUANTITY SOLD ANALYSIS 
--       Q 1- CALCULATE THE TOTAL QUANTITY SOLD FOR EACH RESPECTIVE MONTH.

SELECT 
	DISTINCT MONTH(transaction_date) AS Months,
    CONCAT(ROUND(SUM(transaction_qty) /1000) , ' K') AS Total_Qty_Sold
FROM coffee_shop_sales
GROUP BY Months
ORDER BY Months;

--       Q 2- DETERMINE THE MONTH-ON-MONTH INCREASE OR DECREASE IN THE TOTAL QUANTITY SOLD.

SELECT 
	DISTINCT MONTH(transaction_date) AS Months,
    CONCAT(ROUND(SUM(transaction_qty) /1000) , ' K') AS Total_Qty_Sold,
    SUM(transaction_qty) - LAG(SUM(transaction_qty)) OVER(ORDER BY (MONTH(transaction_date)))
FROM coffee_shop_sales
GROUP BY Months
ORDER BY Months;
--       Q 3- CALCULATE THE DIFFERENCE IN THE TOTAL QUANTITY SOLD BETWEEN THE SELECTED MONTH AND THE PREVIOUS MONTH.

SELECT 
	DISTINCT MONTH(transaction_date) AS Months,
    CONCAT(ROUND(SUM(transaction_qty) /1000) , ' K') AS Total_Qty_Sold,
    (SUM(transaction_qty) - LAG(SUM(transaction_qty)) OVER(ORDER BY (MONTH(transaction_date))))
    / LAG(SUM(transaction_qty)) OVER(ORDER BY (MONTH(transaction_date))) * 100 AS mom_qty_diff_percentage
FROM coffee_shop_sales
WHERE MONTH(transaction_date) IN (5,6)
GROUP BY Months
ORDER BY Months;

-- SALES ANALYSIS BY WEEKDAYS AND WEEKEND. 

SELECT 
	CASE WHEN DAYOFWEEK(transaction_date) IN (1,7) 
	THEN 'Weekends'
	ELSE 'Weekdays'
    END AS day_type,
    CONCAT(ROUND(SUM(unit_price*transaction_qty)/1000, 1), ' k') AS Total_sales
FROM coffee_shop_sales
WHERE MONTH(transaction_date) = 5
GROUP BY day_type ;

-- SALES ANALYSIS BY STORE LOCATION FOR SELECTED MONTH

SELECT
    store_location,
    CONCAT(ROUND(SUM(unit_price*transaction_qty)/1000,1), ' k') AS Total_sales_store_location
FROM coffee_shop_sales
WHERE MONTH (transaction_date) = 5
GROUP BY store_location
ORDER BY Total_sales_store_location DESC
;

-- DAILY SALES ANALYSIS WITH AVERAGE LINE

SELECT
	CONCAT(ROUND(AVG(total_sales)/1000 , 1), ' k') AS Avg_Sales
FROM  
	(
	SELECT SUM(unit_price*transaction_qty) AS total_sales 
		FROM coffee_shop_sales 
	  WHERE MONTH(transaction_date) = 5 
      GROUP BY transaction_date )
      AS internal_query
;

-- DAILY SALES ANALYSIS

SELECT 
	DAY(transaction_date) AS Day_of_month,
	SUM(transaction_qty * unit_price)
FROM coffee_shop_sales
WHERE Month(transaction_date) = 5
GROUP BY transaction_date 
ORDER BY transaction_date
;

-- COMPARING DAILY SALES WITH AVERAGE SALES – IF GREATER THAN “ABOVE AVERAGE” and LESSER THAN “BELOW AVERAGE”

SELECT 
	day_of_month,
    CASE 
		WHEN total_sales > avg_sales THEN " Above Average"
        WHEN total_sales < avg_sales THEN " Below Average"
        ELSE "Average"
        END AS sales_status,
        total_sales
FROM 
	(
    SELECT 
		DAY(transaction_date) AS day_of_month,
        SUM(unit_price*transaction_qty) AS total_sales,
        AVG(SUM(unit_price*transaction_qty)) OVER() AS avg_sales
	FROM coffee_shop_sales
    WHERE MONTH(transaction_date) = 5
    GROUP BY transaction_date)
AS sales_data
ORDER BY day_of_month
;

-- SALES BY WEEKDAY / WEEKEND

SELECT 
	CASE 
		WHEN DAYOFWEEK(transaction_date) IN (1,7) THEN 'Weekdays'
        ELSE 'Weekends'
        END AS day_type,
        CONCAT(ROUND(SUM( unit_price * transaction_qty ) /1000, 1), ' k') AS total_sales
FROM coffee_shop_sales
WHERE MONTH(transaction_date) = 5
GROUP BY 
		CASE 	
			WHEN DAYOFWEEK(transaction_date) IN (1,7) THEN 'Weekdays'
			ELSE 'Weekends'
        END;
        
-- SALES BY DAY | HOUR

SELECT
	CONCAT(ROUND(SUM( unit_price*transaction_qty)/1000,1), ' K') AS total_sales,
    SUM(transaction_qty) AS Total_qty,
    COUNT(*) AS Total_orders
FROM coffee_shop_sales
WHERE 	
	DAYOFWEEK(transaction_date) = 3 
    AND HOUR(transaction_time) = 12 
    AND MONTH(transaction_date) = 5;

-- SALES FROM MONDAY TO SUNDAY FOR MONTH

SELECT
	CASE 
		WHEN DAYOFWEEK(transaction_date) = 2 THEN 'Monday'
        WHEN DAYOFWEEK(transaction_date) = 3 THEN 'Tuesday'
        WHEN DAYOFWEEK(transaction_date) = 4 THEN 'Wednesday'
        WHEN DAYOFWEEK(transaction_date) = 5 THEN 'Thursday'
        WHEN DAYOFWEEK(transaction_date) = 6 THEN 'Friday'
        WHEN DAYOFWEEK(transaction_date) = 7 THEN 'Satday'
		ELSE 'Sunday'
        END AS Day_of_Week,
        CONCAT(ROUND(SUM(unit_price*transaction_qty)/1000,1), ' k') AS total_sales
FROM coffee_shop_sales
WHERE MONTH(transaction_date) = 5
GROUP BY 
	CASE 
		WHEN DAYOFWEEK(transaction_date) = 2 THEN 'Monday'
        WHEN DAYOFWEEK(transaction_date) = 3 THEN 'Tuesday'
        WHEN DAYOFWEEK(transaction_date) = 4 THEN 'Wednesday'
        WHEN DAYOFWEEK(transaction_date) = 5 THEN 'Thursday'
        WHEN DAYOFWEEK(transaction_date) = 6 THEN 'Friday'
        WHEN DAYOFWEEK(transaction_date) = 7 THEN 'Satday'
		ELSE 'Sunday'
        END
;     

-- SALES FOR ALL HOURS FOR MONTH 

SELECT 	
	HOUR(transaction_time),
	CONCAT(ROUND(SUM(unit_price*transaction_qty)/1000,1), ' k') AS total_sales
FROM coffee_shop_sales
WHERE MONTH(transaction_date) = 5
GROUP BY HOUR(transaction_time)
ORDER BY HOUR(transaction_time)
;


-- SALES BY PRODUCT CATEGORY

SELECT 
	product_category,
    CONCAT(ROUND(SUM(unit_price*transaction_qty)/1000 ,1), ' k') AS total_sales
FROM coffee_shop_sales
WHERE MONTH(transaction_date) = 5
GROUP BY product_category
ORDER BY SUM(unit_price*transaction_qty) DESC
;

-- SALES BY PRODUCTS (TOP 10)

SELECT 
	product_type,
    CONCAT(ROUND(SUM(unit_price*transaction_qty)/1000 ,1), ' k') AS total_sales
FROM coffee_shop_sales
WHERE MONTH(transaction_date) = 5
AND product_category = 'Coffee'
GROUP BY product_type
ORDER BY SUM(unit_price*transaction_qty) DESC
LIMIT 10
;