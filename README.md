### Coffee Shop Sales Analysis (SQL Project)
# Project Overview

This project focuses on cleaning and analyzing a Coffee Shop Sales dataset using MySQL.
The goal is to demonstrate data cleaning, transformation, and business analysis queries that help extract meaningful insights such as sales trends, order behavior, and product performance.

# Dataset Description

• The dataset (coffee_shop_sales.csv) contains the following columns:

• transaction_id → Unique ID of each transaction

• transaction_date → Date of transaction (originally in MM/DD/YYYY format)

• transaction_time → Time of transaction

• store_location → Location of the store

• product_category → Product category (Coffee, Tea, etc.)

• product_type → Specific product type (e.g., Latte, Espresso)

• unit_price → Price per unit

• transaction_qty → Quantity sold

# Data Cleaning

Steps performed:

• Renamed the table for consistency (coffee shop sales (1) → coffee_shop_sales).

• Fixed BOM character issue in transaction_id.

• Converted transaction_date from text to DATE format.

• Converted transaction_time from text to TIME format.

• Standardized column names for better readability.

# Analysis Performed
1. Total Sales Analysis

(i) Monthly total sales

(ii) Month-on-month (MoM) sales difference

(iii) MoM sales growth percentage

2. Total Orders Analysis

(i) Monthly number of orders

(ii) MoM order difference

(iii) MoM order growth percentage

3. Quantity Sold Analysis

(i) Monthly total quantity sold

(ii) nMoM quantity difference

(iii) MoM quantity growth percentage

4. Sales Insights

(i) Sales comparison: Weekdays vs Weekends

(ii) Sales by store location

(iii) Daily sales vs average daily sales

(iv) Sales distribution across days of the week

(v) Hourly sales trends

5. Product-Level Insights

(i) Sales by product category

(ii) Top 10 selling products in the Coffee category

# Example Business Questions Answered

1) Which month generated the highest sales revenue?

2) How did sales grow or decline month-over-month?

3) Do customers order more on weekends or weekdays?

4) Which store location performs the best?

5) What are the top-selling products?

6) What are the peak hours for sales?


