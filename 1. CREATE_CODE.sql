DROP DATABASE IF EXISTS item_ranking;
CREATE DATABASE item_ranking;
USE item_ranking;

CREATE TABLE ITEM_INFO (
	item_index INT NOT NULL PRIMARY KEY,
    item_code VARCHAR(20) NOT NULL,
    item_title VARCHAR(200) NOT NULL,
	item_provider VARCHAR(50) NOT NULL,
    original_price INT NOT NULL
);

CREATE TABLE ITEM_DISCOUNT (
    item_index INT NOT NULL PRIMARY KEY,
	discount_rate INT NOT NULL,
	discount_price INT NOT NULL,
    FOREIGN KEY (item_index) REFERENCES ITEM_INFO(item_index)
);

CREATE TABLE ITEM_COUNT (
	item_index INT NOT NULL,
    item_count INT NOT NULL,
    FOREIGN KEY (item_index) REFERENCES ITEM_INFO(item_index)
);

CREATE TABLE CUSTOMER_INFO (
	customer_index INT NOT NULL PRIMARY KEY,
    customer_id VARCHAR(20) NOT NULL,
    customer_age INT NOT NULL,
    customer_gender VARCHAR(10)
);

CREATE TABLE ITEM_BUY_INFO (
    customer_index INT NOT NULL,
	item_index INT NOT NULL,
	FOREIGN KEY (customer_index) REFERENCES CUSTOMER_INFO(customer_index),
    FOREIGN KEY (item_index) REFERENCES ITEM_INFO(item_index)
);

CREATE TABLE SCORE (
	item_index INT NOT NULL PRIMARY KEY,
    discount_rate INT NOT NULL,
    click_number INT NOT NULL,
    buy_number INT NOT NULL,
    score INT NOT NULL,
    FOREIGN KEY (item_index) REFERENCES ITEM_DISCOUNT(item_index)
);