CREATE DATABASE IF NOT EXISTS beauty_shop;
USE beauty_shop;

SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS order_item;
DROP TABLE IF EXISTS cart_item;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS delivery_address;
DROP TABLE IF EXISTS cart;
DROP TABLE IF EXISTS product;
DROP TABLE IF EXISTS product_subcategory;
DROP TABLE IF EXISTS product_category;
DROP TABLE IF EXISTS brand;
DROP TABLE IF EXISTS payment_method;
DROP TABLE IF EXISTS order_status;
DROP TABLE IF EXISTS users;
DROP TABLE IF EXISTS role_of_user;

SET FOREIGN_KEY_CHECKS = 1;


CREATE TABLE role_of_user (
    role_id INT NOT NULL AUTO_INCREMENT,
    role_name VARCHAR(100) NOT NULL,

    CONSTRAINT role_of_user_pk PRIMARY KEY (role_id),
    CONSTRAINT role_of_user_role_name_un UNIQUE (role_name)
);


CREATE TABLE users (
    user_id INT NOT NULL AUTO_INCREMENT,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL,
    phone VARCHAR(20) NOT NULL,
    password_hash VARCHAR(500) NOT NULL,
    registration_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    role_id INT NOT NULL,

    CONSTRAINT users_pk PRIMARY KEY (user_id),
    CONSTRAINT users_email_un UNIQUE (email),
    CONSTRAINT users_phone_un UNIQUE (phone),
    CONSTRAINT users_role_fk FOREIGN KEY (role_id)
        REFERENCES role_of_user (role_id)
);


CREATE TABLE cart (
    cart_id INT NOT NULL AUTO_INCREMENT,
    creation_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    update_date TIMESTAMP NULL,
    user_id INT NOT NULL,

    CONSTRAINT cart_pk PRIMARY KEY (cart_id),
    CONSTRAINT cart_user_un UNIQUE (user_id),
    CONSTRAINT cart_user_fk FOREIGN KEY (user_id)
        REFERENCES users (user_id)
);


CREATE TABLE order_status (
    status_id INT NOT NULL AUTO_INCREMENT,
    status_name VARCHAR(100) NOT NULL,
    status_description VARCHAR(500),

    CONSTRAINT order_status_pk PRIMARY KEY (status_id),
    CONSTRAINT order_status_name_un UNIQUE (status_name)
);


CREATE TABLE payment_method (
    payment_method_id INT NOT NULL AUTO_INCREMENT,
    payment_method_name VARCHAR(100) NOT NULL,

    CONSTRAINT payment_method_pk PRIMARY KEY (payment_method_id),
    CONSTRAINT payment_method_name_un UNIQUE (payment_method_name)
);


CREATE TABLE brand (
    brand_id INT NOT NULL AUTO_INCREMENT,
    brand_name VARCHAR(200) NOT NULL,
    brand_country VARCHAR(100),
    brand_description VARCHAR(500),

    CONSTRAINT brand_pk PRIMARY KEY (brand_id),
    CONSTRAINT brand_name_un UNIQUE (brand_name)
);


CREATE TABLE product_category (
    category_id INT NOT NULL AUTO_INCREMENT,
    category_name VARCHAR(100) NOT NULL,
    category_description VARCHAR(500),

    CONSTRAINT product_category_pk PRIMARY KEY (category_id),
    CONSTRAINT product_category_name_un UNIQUE (category_name)
);


CREATE TABLE product_subcategory (
    subcategory_id INT NOT NULL AUTO_INCREMENT,
    subcategory_name VARCHAR(150) NOT NULL,
    subcategory_description VARCHAR(500),
    category_id INT NOT NULL,

    CONSTRAINT product_subcategory_pk PRIMARY KEY (subcategory_id),
    CONSTRAINT product_subcategory_category_fk FOREIGN KEY (category_id)
        REFERENCES product_category (category_id)
);


CREATE TABLE product (
    product_id INT NOT NULL AUTO_INCREMENT,
    product_name VARCHAR(200) NOT NULL,
    product_description VARCHAR(1000),
    composition VARCHAR(1000),
    purpose VARCHAR(500),
    skin_type VARCHAR(100),
    price DECIMAL(10,2) NOT NULL,
    stock_quantity INT NOT NULL,
    product_image VARCHAR(1000),
    brand_id INT NOT NULL,
    subcategory_id INT NOT NULL,

    CONSTRAINT product_pk PRIMARY KEY (product_id),
    CONSTRAINT product_price_chk CHECK (price > 0),
    CONSTRAINT product_stock_quantity_chk CHECK (stock_quantity >= 0),
    CONSTRAINT product_brand_fk FOREIGN KEY (brand_id)
        REFERENCES brand (brand_id),
    CONSTRAINT product_subcategory_fk FOREIGN KEY (subcategory_id)
        REFERENCES product_subcategory (subcategory_id)
);


CREATE TABLE delivery_address (
    address_id INT NOT NULL AUTO_INCREMENT,
    city VARCHAR(100) NOT NULL,
    street VARCHAR(150) NOT NULL,
    house VARCHAR(20) NOT NULL,
    apartment VARCHAR(20),

    CONSTRAINT delivery_address_pk PRIMARY KEY (address_id)
);


CREATE TABLE orders (
    order_id INT NOT NULL AUTO_INCREMENT,
    order_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    total_amount DECIMAL(10,2) NOT NULL,
    user_id INT NOT NULL,
    status_id INT NOT NULL,
    payment_method_id INT NOT NULL,
    delivery_address_id INT NOT NULL,

    CONSTRAINT orders_pk PRIMARY KEY (order_id),
    CONSTRAINT orders_total_amount_chk CHECK (total_amount >= 0),
    CONSTRAINT orders_user_fk FOREIGN KEY (user_id)
        REFERENCES users (user_id),
    CONSTRAINT orders_status_fk FOREIGN KEY (status_id)
        REFERENCES order_status (status_id),
    CONSTRAINT orders_payment_method_fk FOREIGN KEY (payment_method_id)
        REFERENCES payment_method (payment_method_id),
    CONSTRAINT orders_delivery_address_fk FOREIGN KEY (delivery_address_id)
        REFERENCES delivery_address (address_id)
);


CREATE TABLE cart_item (
    cart_item_id INT NOT NULL AUTO_INCREMENT,
    cart_id INT NOT NULL,
    product_id INT NOT NULL,
    product_quantity INT NOT NULL,

    CONSTRAINT cart_item_pk PRIMARY KEY (cart_item_id),
    CONSTRAINT cart_item_quantity_chk CHECK (product_quantity > 0),
    CONSTRAINT cart_item_cart_fk FOREIGN KEY (cart_id)
        REFERENCES cart (cart_id),
    CONSTRAINT cart_item_product_fk FOREIGN KEY (product_id)
        REFERENCES product (product_id)
);


CREATE TABLE order_item (
    order_item_id INT NOT NULL AUTO_INCREMENT,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    product_quantity INT NOT NULL,
    product_price_at_order DECIMAL(10,2) NOT NULL,

    CONSTRAINT order_item_pk PRIMARY KEY (order_item_id),
    CONSTRAINT order_item_quantity_chk CHECK (product_quantity > 0),
    CONSTRAINT order_item_price_chk CHECK (product_price_at_order >= 0),
    CONSTRAINT order_item_order_fk FOREIGN KEY (order_id)
        REFERENCES orders (order_id),
    CONSTRAINT order_item_product_fk FOREIGN KEY (product_id)
        REFERENCES product (product_id)
);