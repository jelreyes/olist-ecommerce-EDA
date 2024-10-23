CREATE DATABASE olist;

CREATE TABLE olist.order_customers (
    customer_pk INT UNSIGNED AUTO_INCREMENT PRIMARY KEY COMMENT "surrogate primary key for customers",
    customer_id VARCHAR(100) UNIQUE NOT NULL COMMENT "unique key for each order",
    customer_unique_id VARCHAR(100) NOT NULL COMMENT "unique key for a customer",
    customer_zip_code_prefix CHAR(5) NOT NULL COMMENT "first five digits of customer zip code",
    customer_city VARCHAR(100) NOT NULL COMMENT "customer city name",
    customer_state VARCHAR(100) NOT NULL COMMENT "two-letter state code"
);		

CREATE TABLE olist.geolocation (
	geolocation_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY COMMENT "surrogate primary key for geolocation data",
    geolocation_zip_code_prefix CHAR(5) NOT NULL COMMENT "first 5 digits of zip code",
    geolocation_lat DOUBLE NOT NULL COMMENT "latitude in decimal degrees",
    geolocation_lng DOUBLE  NOT NULL COMMENT "longitude in decimal degrees",
    geolocation_city VARCHAR(100) NOT NULL COMMENT "city name",
    geolocation_state VARCHAR(100) NOT NULL COMMENT "two-letter state code"
);

CREATE TABLE olist.order_items (
	order_item_pk INT UNSIGNED AUTO_INCREMENT PRIMARY KEY COMMENT "surrogate primary key for order items",
    order_id VARCHAR(100) NOT NULL COMMENT "order unique identifier",
    order_item_id VARCHAR(100) NOT NULL COMMENT "sequential number identifying number of items included in the same order (nth order)",
    product_id VARCHAR(100) NOT NULL COMMENT "product unique identifier",
    seller_id VARCHAR(100) NOT NULL COMMENT "seller unique identifier",
    shipping_limit_date DATETIME NOT NULL COMMENT "seller shipping limit date for handling the order over to the logistic partner",
    price DECIMAL(10,2) NOT NULL COMMENT "item price",
    freight_value DECIMAL(10,2) NOT NULL COMMENT "item freight value item (if an order has more than one item the freight value is splitted between items)"
);

CREATE TABLE olist.order_payments (
	order_payment_id INT AUTO_INCREMENT PRIMARY KEY COMMENT "surrogate primary key for order payments",
    order_id VARCHAR(100) NOT NULL COMMENT "order unique identifier",
    payment_sequential INT UNSIGNED NOT NULL COMMENT "sequential number identifying number of payment methods used by customer to pay an order",
    payment_type VARCHAR(100) NOT NULL COMMENT "method of payment chosen by the customer",
    payment_installments INT UNSIGNED NOT NULL COMMENT "number of installments chosen by the customer",
    payment_value DECIMAL(10,2) NOT NULL COMMENT "transaction value"
);

CREATE TABLE olist.order_reviews (
	review_pk INT AUTO_INCREMENT PRIMARY KEY COMMENT "surrogate primary key for reviews",
    review_id VARCHAR(100) NOT NULL COMMENT "unique review identifier",
    order_id VARCHAR(100) NOT NULL COMMENT "order unique identifier",
    review_score INT NOT NULL COMMENT "ranging from 1 to 5 given by the customer on a satisfaction survey" CHECK (review_score BETWEEN 1 AND 5),
    review_comment_title VARCHAR(100) COMMENT "comment title from the review left by the customer, in Portuguese",
    review_comment_message TEXT COMMENT "comment message from the review left by the customer, in Portuguese",
    review_creation_date datetime NOT NULL COMMENT "date in which the satisfaction survey was sent to the customer",
	review_answer_timestamp datetime NOT NULL COMMENT "satisfaction survey answer timestamp"
);

CREATE TABLE olist.orders (
	order_pk INT AUTO_INCREMENT PRIMARY KEY COMMENT "surrogate primary key for orders",
    order_id VARCHAR(100) UNIQUE NOT NULL COMMENT "order unique identifier",
    customer_id VARCHAR(100) UNIQUE NOT NULL COMMENT "unique key for each order",
    order_status VARCHAR(100) NOT NULL COMMENT "reference to the order status (delivered, shipped, etc)",
    order_purchase_timestamp datetime NOT NULL COMMENT "purchase timestamp",
    order_approved_at datetime COMMENT "payment approval timestamp",
    order_delivered_carrier_date datetime COMMENT "order posting timestamp when it was handled to the logistic partner",
	order_delivered_customer_date datetime COMMENT "actual order delivery date to the customer",
    order_estimated_delivery_date datetime NOT NULL COMMENT "estimated delivery date that was informed to customer at the purchase moment"
);

CREATE TABLE olist.products (
	product_pk INT AUTO_INCREMENT PRIMARY KEY COMMENT "surrogate primary key for product",
    product_id VARCHAR(100) UNIQUE NOT NULL COMMENT "order unique identifier",
    product_category_name VARCHAR(100) COMMENT "root category of product, in Portuguese",
    product_name_length INT UNSIGNED COMMENT "number of characters extracted from the product name",
    product_description_length INT UNSIGNED COMMENT "number of characters extracted from the product description",
    product_photos_qty INT UNSIGNED COMMENT "number of product published photos",
    product_weight_g INT UNSIGNED COMMENT "product weight measured in grams	",
    product_length_cm INT UNSIGNED COMMENT "product length measured in centimeters",
	product_height_cm INT UNSIGNED COMMENT "product height measured in centimeters",
    product_width_cm INT UNSIGNED COMMENT "product width measured in centimeters"
);

CREATE TABLE olist.sellers (
	seller_pk INT UNSIGNED AUTO_INCREMENT PRIMARY KEY COMMENT "surrogate primary key for seller",
    seller_id VARCHAR(100) UNIQUE NOT NULL COMMENT "seller unique identifier",
    seller_zip_code_prefix CHAR(5) NOT NULL COMMENT "first five digits of seller zip code",
    seller_city VARCHAR(100) NOT NULL COMMENT "seller city name",
    seller_state  VARCHAR(100) NOT NULL COMMENT "seller state"
);

CREATE TABLE olist.category_name_translation (
	category_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY COMMENT "surrogate primary key for category_name_translation",
    product_category_name VARCHAR(100) COMMENT "category name in Portuguese",
    product_category_name_english VARCHAR(100) COMMENT "category name in English"
);