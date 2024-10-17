USE shopee_ecommerce;

-- DATA CLEANING
-- ---------------------------
-- Staging

CREATE TABLE purchase_staging
LIKE purchase_copy;

SELECT *
FROM purchase_staging;

INSERT purchase_staging
SELECT*
FROM purchase_copy;


-- -------------------------------------------------------
-- 1. Identify Duplicates
SELECT order_id, COUNT(*)
FROM purchase_staging
GROUP BY order_id
HAVING COUNT(*) > 1;


-- -------------------------------------------------------------
-- 2. Standardizing Data

SELECT *
FROM purchase_staging;

SELECT DISTINCT(product_name) 
FROM purchase_staging;

SELECT DISTINCT(customer_id) 
FROM purchase_staging;

SELECT DISTINCT(order_id) 
FROM purchase_staging;

-- fix order_date
SELECT 
    order_date,
    CASE
        -- Handle the DD-MM-YYYY format
        WHEN order_date LIKE '%-%-%' THEN STR_TO_DATE(order_date, '%d-%m-%Y')
        -- Handle the MM/DD/YYYY format
        WHEN order_date LIKE '%/%/%' THEN STR_TO_DATE(order_date, '%m/%d/%Y')
        -- If neither format applies, return NULL
        ELSE NULL
    END AS NEW_order_date
FROM purchase_staging;

ALTER TABLE purchase_staging
ADD COLUMN NEW_order_date DATE;

UPDATE purchase_staging
SET NEW_order_date = CASE
    WHEN order_date LIKE '%-%-%' THEN STR_TO_DATE(order_date, '%d-%m-%Y')
    WHEN order_date LIKE '%/%/%' THEN STR_TO_DATE(order_date, '%m/%d/%Y')
    ELSE NULL
END
WHERE order_date IS NOT NULL;

-- fix shipping_date
SELECT 
    shipping_date,
    CASE
        -- Handle the DD-MM-YYYY format
        WHEN shipping_date LIKE '%-%-%' THEN STR_TO_DATE(shipping_date, '%d-%m-%Y')
        -- Handle the MM/DD/YYYY format
        WHEN shipping_date LIKE '%/%/%' THEN STR_TO_DATE(shipping_date, '%m/%d/%Y')
        -- If neither format applies, return NULL
        ELSE NULL
    END AS NEW_shipping_date
FROM purchase_staging;

ALTER TABLE purchase_staging
ADD COLUMN NEW_shipping_date DATE;

UPDATE purchase_staging
SET NEW_shipping_date = CASE
    WHEN shipping_date LIKE '%-%-%' THEN STR_TO_DATE(shipping_date, '%d-%m-%Y')
    WHEN shipping_date LIKE '%/%/%' THEN STR_TO_DATE(shipping_date, '%m/%d/%Y')
    ELSE NULL
END
WHERE shipping_date IS NOT NULL;


-- -------------------------------------------------------
-- Step 3: Working with null values and blank values

SELECT *
FROM purchase_staging;

SELECT *
FROM purchase_staging
WHERE shipping_cost IS NULL; 	-- order_id, customer_id, product_name, price, discount, tax, quantity, shipping_cost

SELECT DISTINCT product_name
FROM purchase_staging;


-- -------------------------------------------------------
-- 4. Remove Columns or Rows

SELECT *
FROM purchase_staging;

ALTER TABLE purchase_staging
DROP COLUMN `description`,
DROP COLUMN order_date,
DROP COLUMN shipping_date;



-- -------------------------------------------------------
-- EDA/ Exploratory Data Analysis
-- -------------------------------------------------------

SELECT *
FROM purchase_staging;

-- Total Sales
SELECT (price * quantity) - (price * quantity * (discount / 100)) 
    + (price * quantity * (tax / 100)) + shipping_cost AS total_sales
FROM purchase_staging;

ALTER TABLE purchase_staging
ADD COLUMN total_sales DECIMAL(10, 2);

UPDATE purchase_staging
SET total_sales = (price * quantity) 
                - (price * quantity * (discount / 100)) 
                + (price * quantity * (tax / 100)) 
                + shipping_cost;

-- MAX total sales: 49957.79
SELECT MAX(total_sales)
FROM purchase_staging;

-- MIN total sales: 29.80
SELECT MIN(total_sales)
FROM purchase_staging;

-- what product has the most sales
SELECT product_name, SUM(total_sales)
FROM purchase_staging
GROUP BY product_name
ORDER BY 2 DESC;

-- AVG products sold
SELECT product_name, AVG(total_sales)
FROM purchase_staging
GROUP BY product_name
ORDER BY 2 DESC;

-- MAX quantity sold: 10
SELECT MAX(quantity)
FROM purchase_staging;

-- MIN quantity sold: 1
SELECT MIN(quantity)
FROM purchase_staging;

-- AVG quantity sold: 5.4976
SELECT AVG(quantity)
FROM purchase_staging;


-- --------------------------------------------------
-- Delivery Time from Order

SELECT *
FROM purchase_staging;

SELECT NEW_order_date, NEW_shipping_date, 
       DATEDIFF(NEW_shipping_date, NEW_order_date) AS delivery_days
FROM purchase_staging;

ALTER TABLE purchase_staging
ADD COLUMN delivery_days INT;

UPDATE purchase_staging
SET delivery_days = DATEDIFF(NEW_shipping_date, NEW_order_date);

-- MAX delivery time
SELECT MAX(delivery_days)
FROM purchase_staging;

-- MIN delivery time
SELECT MIN(delivery_days)
FROM purchase_staging;

-- AVG delivery time
SELECT AVG(delivery_days)
FROM purchase_staging;

-- -----------------------
