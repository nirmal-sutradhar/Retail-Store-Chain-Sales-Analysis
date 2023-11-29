# Retail-Store-Chain-Sales-Analysis
Description
This project aims to explore the Retail Store Chain Sales Data of XYZ co. for January-March 2019 to understand and ascertain key metrics for Sales, Product performance and Customer behaviour. The project comprises of SQL code which queries mentioned dataset to arrive upon relevant metrics, quantifiers, and indicators. Employing a data driven, exploratory approach, numerous metrics and performance indicators are determined for sales, product and customer facets across multiple dimensions including geographic, demographic and transactional to gain actionable insights and perspective. 
Purpose Of The Project
The primary objective of the project is to analyze, gain insights and ascertain KPIs, key metrics and drivers for Sales trends, Product Performance and Customer Behaviour. 
Data Overview
This dataset contains sales transactions from three different branches of XYZ Retail Store Chain, located in Mandalay, Yangon and Naypyitaw respectively for the period of Jan-Mar 2019. The dataset contains 14 columns and 1000 rows:
Column	Description	Data Type
invoice_id	Invoice of the sales made	VARCHAR(30)
branch	Branch at which sales were made	VARCHAR(5)
city	The location of the branch	VARCHAR(30)
customer_type	The type of customer	VARCHAR(30)
gender	Gender of the customer making purchase	VARCHAR(30)
product_line	Product line of the product sold	VARCHAR(100)
unit_price	The unit price of each product	DECIMAL(10, 2)
quantity	The amount of the product sold	INT
Tax	The amount of tax on the sale	DECIMAL(6, 4)
total	The total amount of the sale	DECIMAL(12, 4)
date	The date on which the sale occurred	DATETIME
time	The time at which the sale occurred	TIME
payment	The method of payment	VARCHAR(15)
rating	Rating given by customer	DECIMAL(10, 2)
Application Used
SQL Server Management Studio 19 (SSMS)
Approach Used
Data Wrangling : This step involves transforming and structuring data from one raw, unorganized form into a desired format with the intent of improving data quality and making it more consumable and useful for data analytics.
- Data Definition Language (DDL)
- Building a database on SSMS 19  
- Creating a new table with desired column names, data types and constraints and assigning a Primary Key
- Inserting data into the table
Feature Engineering : This will help generate some new columns from existing ones for classification and analysis by altering newly created table, creating new columns and inserting values into them by way of manipulation of values from existing columns.
- Data Manipulation Language (DML)
- cogs = unit_price * quantity
- gross_income = total - cogs
- gross_margin_pct = (gross_income / total) * 100
- tax_pct = (tax_amount / total) * 100
- time_of_day  , as in Morning, Afternoon or Evening extracted from time
- day_name  , name of weekdays extracted from date
- month_name  , name of month extracted from date

Exploratory Data Analysis (EDA) : Exploratory data analysis is conducted to identify patterns, outliers and features of the data and summarize their main characteristics. 
- Data Query Language (DQL) has been employed to answer following business questions.
Business Questions & Performance Metrics
Overall KPIs
1.	Total Revenue, Total Quantity Sold
2.	Total COGS
3.	Gross Profit
4.	Total Transactions
5.	Distinct Product Line
6.	Distinct City & Branch
Product Analysis
1.	Distinct Product Lines 
2.	Quantity Sold for each Product Line 
3.	Revenue for each Product Line  
4.	Product Lines with revenue and quantity sold greater than respective averages 
5.	Branch with revenue greater than respective average
6.	Preferred Product Line by Gender 
7.	Average Rating for each Product Line 
Sales Analysis
1.	Total Revenue and Total COGS by Month 
2.	Weekday Sales vs Weekend Sales Comparison 
3.	Total Revenue respective to each time of day 
4.	Rolling Revenue Total partitioned by month and ordered by day 
Customer Analysis
1.	Sales per weekday respective to each time of day 
2.	Preferred Payment Methods 
3.	City and Branch with respective revenue generated 
4.	Revenue and count of Transactions with respect to customer type 
5.	Gender distribution respective to Branch 
6.	Average rating for each weekday respective to time of day 

