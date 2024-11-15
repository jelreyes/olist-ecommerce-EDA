# Olist E-Commerce Sales Insights

## Overview
This project analyzes  the sales performance of Olist, a major online marketplace in Brazil, from 2016-2018. Olist connects small Brazilian businesses to various marketplaces, enabling seamless logistics and delivery to customers. After purchase, customers provide feedback through a satisfaction survey.

The goal is to **prepare and structure the data for analysis, identify trends, and generate actionable recommendations to enhance Olist's sales performance and data integrity**.

## Dashboard
This dashboard aggregates sales data, offering insights into key performance indicators (KPIs) such as total sales, order counts, and customer demographics.
![sales (1)_page-0001](https://github.com/user-attachments/assets/05919302-c2ae-4eff-aa43-c442e569ddb8)
![Untitled design](https://github.com/user-attachments/assets/456263b4-e170-418c-92f8-d6cefbd2baa4)

## Summary of Insights
### 1. Sales Overview
- There was a significant spike in both orders and sales on November 24, 2017, corresponding to Brazil’s Black Friday, highlighting the strong impact of promotional events on Olist's performance.
- This suggests that customers are highly responsive to sales events, with Black Friday being especially effective in driving demand.

### 2. Customer Demographics
- Most customers are located in major cities, including São Paulo, Rio de Janeiro, and Belo Horizonte, with these top 10 cities representing a significant portion of Olist’s customer base.
- This indicates that Olist's reach is currently stronger in major urban centers compared to smaller towns or rural areas.

### 3. Best-Selling Products
- Product categories such as “Bed & Bath,” “Health & Beauty,” and “Sports & Leisure” lead in sales, showing customer preference for these types of products.

### 4. Shopping Cart Overview
- A high percentage (97%) of orders are completed, indicating effective logistics and customer satisfaction.
Returns and cancellations are low at 0.6%, suggesting low customer dissatisfaction.
- However, 2.3% of orders are pending, potentially indicating opportunities to improve processing or delivery speeds.

### 5. Order and Sales Trends
- There’s a consistent growth trend in orders over time, with noticeable sales and order spikes aligning, likely due to seasonal demand or targeted promotional activities.


## Recommendations and Next Steps
- **Annual Black Friday Campaigns and Key Shopping Holidays Planning**: Given the strong impact of Black Friday, Olist should incorporate this event as a central element of its annual sales strategy. Coordinating with Marketing and Inventory teams to plan well in advance—setting up promotions, ensuring stock of popular items, and boosting marketing efforts—could help replicate or surpass the 2017 performance.
- - **Market Expansion**: Collaborate with the Logistics and Partnerships teams to assess distribution options and consider adjusting product offerings or forming partnerships with local businesses to facilitate this expansion. Since most customers are concentrated in major cities, Olist could explore strategies to reach smaller towns or rural areas.
- **Targeted Promotions for High-Demand Categories**: Given the popularity of categories like “Health & Beauty” and “Bed & Bath,” Olist could boost sales by implementing seasonal promotions, bundling offers, or loyalty rewards in these areas. Collaborating with the Marketing team to develop exclusive offerings within these categories could attract more customers.
- **Pending Order Resolution Improvement**: Engage with the Operations and Customer Service teams to investigate and address reasons behind pending orders, particularly during high-traffic periods. This could uncover process improvements that enhance customer satisfaction and reduce delays.
- **Enhanced Customer Segmentation**: Use demographic data to refine customer segments and personalize marketing efforts. Work with the Marketing Analytics team to create targeted campaigns (e.g., promoting “Health & Beauty” products to younger demographics) to drive higher engagement and conversion rates.
- **Promotional Strategy Analysis**: Analyze customer behavior from the 2017 Black Friday spike, focusing on top products, purchase timing, and average spend, to inform future promotional strategies. Collaborate with the Marketing teams to apply these insights for tailored promotions that maximize customer response.
- **Data quality improvement**: Work with the Data Governance, Database Administrators, and Data Engineering teams to standardize ```geolocation_city data```, reducing duplicates and discrepancies. Implement data cleaning and normalization practices in the database architecture to enhance data accuracy and consistency.

## Future Updates
This project will continue to evolve with the addition of deeper insights and recommendations based on ongoing data analysis. Future updates will focus on:
- Evaluating the impact of customer feedback on sales.

## Technical Process
### 1. Tech Stack
- **Database Management**: **MySQL** is used for efficient data storage and indexing
- **Data Preparation**: **Python**, along with the **pandas** library, is used for data cleaning and preparation, enabling flexible handling of various data transformations.
- **Data Visualization**: **Microsoft Power BI** is utilized to create an interactive self-service dashboard that presents key insights in a visually appealing manner.

### 2. Data Source
Brazilian E-Commerce Public Dataset by Olist downloaded from [kaggle](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce/data):
- Contains information on over **100,000 orders** from **2016** to **2018**
- Spans multiple order aspects and transactional data from multiple dimensions, such as order status, pricing, customer location, and product reviews.
- Note: All company names and partner names in customer reviews have been replaced with fictional names from Game of Thrones.

### 3. Data Preparation

#### 3.1. Database Creation
Before loading the data, a database named ```olist``` is created, and tables are set up with appropriate schemas to store each dataset component.

**Query snippet:**

```sql
CREATE DATABASE olist;

CREATE TABLE olist.order_customers (
    customer_pk INT UNSIGNED AUTO_INCREMENT PRIMARY KEY COMMENT "surrogate primary key for customers",
    customer_id VARCHAR(100) UNIQUE NOT NULL COMMENT "unique key for each order",
    customer_unique_id VARCHAR(100) NOT NULL COMMENT "unique key for a customer",
    customer_zip_code_prefix CHAR(5) NOT NULL COMMENT "first five digits of customer zip code",
    customer_city VARCHAR(100) NOT NULL COMMENT "customer city name",
    customer_state VARCHAR(100) NOT NULL COMMENT "two-letter state code"
);	
```

#### 3.2. Indexing

Each table has unique indices to avoid duplicate entries and improve data retrieval.

**Query snippet:**
```sql

CREATE UNIQUE INDEX unique_orders ON olist.orders (customer_id, order_id);
CREATE UNIQUE INDEX unique_customer_orders ON olist.order_customers (customer_id, customer_unique_id);
```

Foreign keys are also set up between tables to establish relationships.

**Query snippet:**
```sql
ALTER TABLE `olist`.`order_items` ADD CONSTRAINT `fk_orders_orditems_order`
FOREIGN KEY (`order_id`) REFERENCES `olist`.`orders` (`order_id`);
```

**Data schema:**

![EER_diagram](photos/EER_diagram.png)

```category_name_translation``` table was not foreign-keyed to ```products``` due to some missing ```product_category_name``` values.

#### 3.3. Data Loading

Each CSV file is loaded into a separate table within the olist database.

**Query snippet:**

```sql
LOAD DATA INFILE 'my_directory/olist_order_customers_dataset.csv'
INTO TABLE olist.order_customers
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n' 
IGNORE 1 ROWS
(customer_id,customer_unique_id,customer_zip_code_prefix, customer_city, customer_state);
```

#### 3.4. Data Cleaning
[```data_cleanup.py```](data_cleanup.py) performs the following data preparation steps:

1. **Column inspection and renaming:** All columns are inspected for data types, with misspelled columns renamed to avoid future errors (e.g., product_name_lenght to product_name_length).
2. **Handling duplicates:** Duplicate rows across dataframes are identified and removed.
3. **Handling invalid characters:** Identified non-alphanumeric characters in text columns, allowing for review and cleaning as needed.
   
    - Any cells with empty strings or spaces are replaced with NaN values to standardize missing data handling.
   
    - To handle inconsistencies in city names (e.g., special characters in geolocation_city), city names are converted to their closest ASCII equivalents using unidecode, and duplicates are dropped based on geolocation_zip_code_prefix, geolocation_state, and geolocation_city.
