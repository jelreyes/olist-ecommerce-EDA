LOAD DATA INFILE 'your_directory/olist_order_customers_dataset.csv'
INTO TABLE olist.order_customers
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n' 
IGNORE 1 ROWS
(customer_id,customer_unique_id,customer_zip_code_prefix, customer_city, customer_state);

LOAD DATA INFILE 'your_directory/olist_geolocation_dataset.csv'
INTO TABLE olist.geolocation
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n' 
IGNORE 1 ROWS
(geolocation_zip_code_prefix,geolocation_lat,geolocation_lng,geolocation_city,geolocation_state);

LOAD DATA INFILE 'your_directory/olist_order_items_dataset.csv'
INTO TABLE olist.order_items
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n' 
IGNORE 1 ROWS
(order_id,order_item_id,product_id,seller_id,shipping_limit_date,price,freight_value);

LOAD DATA INFILE 'your_directory/olist_order_payments_dataset.csv'
INTO TABLE olist.order_payments
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n' 
IGNORE 1 ROWS
(order_id,payment_sequential,payment_type,payment_installments,payment_value);

LOAD DATA INFILE 'your_directory/olist_order_reviews_dataset.csv'
INTO TABLE olist.order_reviews
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(review_id, order_id, review_score, review_comment_title, review_comment_message, review_creation_date, review_answer_timestamp);

LOAD DATA INFILE 'your_directory/olist_orders_dataset.csv'
INTO TABLE olist.orders
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n' 
IGNORE 1 ROWS
(order_id, customer_id, order_status, order_purchase_timestamp, @approved_at, @carrier_date, @customer_date, order_estimated_delivery_date);

LOAD DATA INFILE 'your_directory/olist_products_dataset.csv'
INTO TABLE olist.products
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(product_id, product_category_name, product_name_length, product_description_length, product_photos_qty, product_weight_g, product_length_cm, product_height_cm, product_width_cm)

LOAD DATA INFILE 'your_directory/olist_sellers_dataset.csv'
INTO TABLE olist.sellers
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n' 
IGNORE 1 ROWS
(seller_id,seller_zip_code_prefix,seller_city,seller_state);

LOAD DATA INFILE 'your_directory/product_category_name_translation.csv'
INTO TABLE olist.category_name_translation
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n' 
IGNORE 1 ROWS
(product_category_name,product_category_name_english);
