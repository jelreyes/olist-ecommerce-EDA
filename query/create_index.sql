CREATE UNIQUE INDEX unique_orders ON olist.orders (customer_id, order_id);
CREATE UNIQUE INDEX unique_customer_orders ON olist.order_customers (customer_id,customer_unique_id);
CREATE UNIQUE INDEX unique_order_review ON olist.order_reviews (review_id, order_id);
CREATE UNIQUE INDEX unique_location ON olist.geolocation (geolocation_zip_code_prefix, geolocation_city, geolocation_state);

ALTER TABLE `olist`.`order_items` ADD CONSTRAINT `fk_orders_orditems_order`
FOREIGN KEY (`order_id`) REFERENCES `olist`.`orders` (`order_id`);

ALTER TABLE `olist`.`order_items` ADD CONSTRAINT `fk_sellers_orditems_seller`
FOREIGN KEY (`seller_id`) REFERENCES `olist`.`sellers` (`seller_id`);

ALTER TABLE `olist`.`orders` ADD CONSTRAINT `fk_customers_orders_customer`
FOREIGN KEY (`customer_id`) REFERENCES `olist`.`order_customers` (`customer_id`);

ALTER TABLE `olist`.`order_reviews` ADD CONSTRAINT `fk_orders_reviews_order`
FOREIGN KEY (`order_id`) REFERENCES `olist`.`orders` (`order_id`);

ALTER TABLE `olist`.`order_payments` ADD CONSTRAINT `fk_orders_payments_order`
FOREIGN KEY (`order_id`) REFERENCES `olist`.`orders` (`order_id`);

ALTER TABLE `olist`.`order_items` ADD CONSTRAINT `fk_products_orditems_product`
FOREIGN KEY (`product_id`) REFERENCES `olist`.`products` (`product_id`);