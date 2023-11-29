-- Retail Store Chain Sales Analysis for Jan-March 2019 Sales data
-- Data Cleaning & Transformation

-- Creating Table with new column names, specifying data type and constraints

IF OBJECT_ID(N'Sales', N'U')
IS NULL
CREATE TABLE Sales(
	invoice_id VARCHAR(30) NOT NULL PRIMARY KEY,
    branch VARCHAR(5) NOT NULL,
    city VARCHAR(30) NOT NULL,
    customer_type VARCHAR(30) NOT NULL,
    gender VARCHAR(30) NOT NULL,
    product_line VARCHAR(100) NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    quantity INT NOT NULL,
    tax_amount DECIMAL(6,4) NOT NULL,
    total DECIMAL(12, 4) NOT NULL,
    date DATETIME NOT NULL,
    time TIME NOT NULL,
    payment VARCHAR(15) NOT NULL,
    rating DECIMAL(10, 2)
);

-- Inserting Sales Data into created Table

INSERT INTO [Retail Store Chain]..Sales(
	invoice_id, branch, city, customer_type, gender, product_line, unit_price, quantity, tax_amount,
	total, date, time, payment, rating)
SELECT [Invoice ID], Branch, City, [Customer type], Gender, [Product line], [Unit price], Quantity,
	[Tax 5%], Total, Date, Time, Payment, Rating
FROM [Retail Store Chain]..Sales_Data


-- Overview of Sales Table 

SELECT * FROM [Retail Store Chain]..Sales

-- Adding calculated columns to Sales Table for analysis

ALTER TABLE [Retail Store Chain]..Sales
ADD cogs DECIMAL(10,2),
	gross_margin_pct DECIMAL(11,9),
	gross_income DECIMAL(10,2),
	tax_pct DECIMAL(10,4)

UPDATE [Retail Store Chain]..Sales
SET cogs = unit_price * quantity,
	gross_income = total - COALESCE(cogs, 0),
	gross_margin_pct = (gross_income/total)*100,
	tax_pct = (tax_amount/total)*100

-- Extracting and adding date & time relevant columns for analysis & visualisation

ALTER TABLE [Retail Store Chain]..Sales
ADD time_of_day VARCHAR(10),
	day_name VARCHAR(10),
	month_name VARCHAR(10)

UPDATE [Retail Store Chain]..Sales
SET time_of_day = CASE 
					WHEN time BETWEEN '00:00:00' AND '12:00:00' THEN 'Morning'
					WHEN time BETWEEN '12:01:00' AND '16:00:00' THEN 'Afternoon'
					ELSE 'Evening'
					END	

UPDATE [Retail Store Chain]..Sales
SET day_name = DATENAME(WEEKDAY, date),
	month_name = DATENAME(MONTH, date)


-- Exploratory Data Analysis (EDA)
-- High-level Overview of dataset

SELECT SUM(total) AS total_revenue, SUM(quantity) AS quantity_sold
FROM [Retail Store Chain]..Sales

SELECT SUM(cogs) AS total_cogs
FROM [Retail Store Chain]..Sales

SELECT (SUM(total) - SUM(cogs)) AS gross_profit
FROM [Retail Store Chain]..Sales

SELECT COUNT(DISTINCT invoice_id) AS total_transactions
FROM [Retail Store Chain]..Sales

SELECT DISTINCT product_line 
FROM [Retail Store Chain]..Sales

SELECT DISTINCT city, branch
FROM [Retail Store Chain]..Sales

-- Product Analysis --

-- Distinct Product Lines

SELECT DISTINCT product_line
FROM [Retail Store Chain]..Sales

-- Quantity Sold for each Product Line

SELECT product_line, COUNT(*) AS frequency
FROM [Retail Store Chain]..Sales
GROUP BY product_line 
ORDER BY COUNT(*) DESC

-- Revenue for each Product Line 

SELECT product_line, SUM(total) AS total_revenue
FROM [Retail Store Chain]..Sales
GROUP BY product_line
ORDER BY total_revenue DESC

-- Product Lines with revenue and quantity sold greater than respective averages

WITH product_line_metrics AS
(
SELECT product_line, SUM(total) AS total_revenue, SUM(quantity) AS quantity_sold
FROM [Retail Store Chain]..Sales
GROUP BY product_line
)
SELECT product_line, total_revenue, quantity_sold  
FROM product_line_metrics
WHERE total_revenue > (SELECT AVG(total_revenue) FROM product_line_metrics) AND 
	  quantity_sold > (SELECT AVG(quantity_sold) FROM product_line_metrics)


-- Branch with revenue greater than respective average

SELECT branch, SUM(total) AS total_revenue
FROM [Retail Store Chain]..Sales
GROUP BY branch
HAVING SUM(total) > (SELECT SUM(total)/COUNT(DISTINCT branch) FROM [Retail Store Chain]..Sales)
ORDER BY SUM(total) DESC


-- Preferred Product Line by Gender

CREATE VIEW Gender_behaviour AS
SELECT gender, product_line, 
COUNT(product_line) AS purchase_frequency, 
RANK() OVER (PARTITION BY gender ORDER BY COUNT(product_line) DESC) AS purchase_preference
FROM [Retail Store Chain]..Sales
GROUP BY gender, product_line;

SELECT gender, product_line, purchase_frequency
FROM Gender_behaviour
WHERE purchase_preference = 1

-- Average Rating for each Product Line

SELECT product_line, ROUND(CAST(AVG(rating) AS float), 2) AS avg_rating
FROM [Retail Store Chain]..Sales
GROUP BY product_line
ORDER BY avg_rating DESC

-- Customer Analysis --

-- Sales per weekday respective to each time of day

SELECT day_name, time_of_day, SUM(quantity) AS quantity_sold
FROM [Retail Store Chain]..Sales
GROUP BY day_name, time_of_day
ORDER BY quantity_sold DESC

-- Preferred Payment Methods

SELECT payment, COUNT(*) AS frequency
FROM [Retail Store Chain]..Sales
GROUP BY payment 
ORDER BY COUNT(*) DESC

-- City and Branch with respective revenue generated

SELECT city, branch, SUM(total) AS total_revenue
FROM [Retail Store Chain]..Sales
GROUP BY city, branch
ORDER BY total_revenue DESC

-- Revenue and count of Transactions with respect to customer type

SELECT customer_type, SUM(total) AS total_revenue, COUNT(*) AS transactions
FROM [Retail Store Chain]..Sales
GROUP BY customer_type
ORDER BY total_revenue DESC

-- Gender distribution respective to Branch

WITH Gender_distribution(branch, city, gender, gender_count) AS
(SELECT branch, city, gender, COUNT(gender) AS gender_count
FROM [Retail Store Chain]..Sales
GROUP BY branch, city, gender
)
SELECT a.branch, a.city, 
ROUND((CAST(a.gender_count AS float))/(CAST(b.gender_count AS float)), 3) AS male_female_ratio 
FROM Gender_distribution AS a
INNER JOIN Gender_distribution AS b
ON a.branch = b.branch AND a.city = b.city AND a.gender = 'male' AND b.gender = 'female'

-- Average rating for each weekday respective to time of day

SELECT day_name, time_of_day, AVG(rating) AS avg_rating
FROM [Retail Store Chain]..Sales
GROUP BY day_name, time_of_day
ORDER BY avg_rating DESC

-- Sales Analysis --

-- Total Revenue and Total COGS by Month

SELECT month_name, SUM(total) AS total_revenue, SUM(cogs) AS total_cogs
FROM [Retail Store Chain]..Sales
GROUP BY month_name
ORDER BY total_revenue DESC

-- Weekday Sales vs Weekend Sales Comparison

WITH weekday_sales(weekdays, total_revenue)  AS 
(
SELECT day_name AS weekdays, SUM(total) AS total_revenue
FROM [Retail Store Chain]..Sales
WHERE day_name != 'Saturday' AND day_name != 'Sunday'
GROUP BY day_name),

weekend_sales(weekends, total_revenue)  AS
(
SELECT day_name AS weekends, SUM(total) AS total_revenue
FROM [Retail Store Chain]..Sales
WHERE day_name = 'Saturday' OR day_name = 'Sunday'
GROUP BY day_name)

SELECT AVG(weekday_sales.total_revenue) AS weekday_avg_sales, 
AVG(weekend_sales.total_revenue) AS weekend_avg_sales
FROM weekday_sales, weekend_sales

-- Total Revenue respective to each time of day

SELECT time_of_day, SUM(total) AS total_revenue
FROM [Retail Store Chain]..Sales
GROUP BY time_of_day
ORDER BY total_revenue DESC

-- Rolling Revenue Total partitioned by month and ordered by day

SELECT date, day_name, month_name, total, 
SUM(total) OVER (PARTITION BY month_name ORDER BY date) AS rolling_revenue_per_day
FROM [Retail Store Chain]..Sales
ORDER BY date


SELECT * 
FROM [Retail Store Chain]..Sales
