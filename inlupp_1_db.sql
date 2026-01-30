CREATE DATABASE IF NOT EXISTS webbshop_db;
USE webbshop_db;

CREATE TABLE Brand (
  brand_id INT NOT NULL AUTO_INCREMENT,
  name VARCHAR(50) NOT NULL,
  PRIMARY KEY (brand_id),
  UNIQUE KEY uk_brand_name (name)
) ENGINE = InnoDB;

CREATE TABLE Category (
  category_id INT NOT NULL AUTO_INCREMENT,
  name VARCHAR(50) NOT NULL,
  PRIMARY KEY (category_id),
  UNIQUE KEY uk_category_name (name)
) ENGINE = InnoDB;

CREATE TABLE Shoe (
  shoe_id INT NOT NULL AUTO_INCREMENT,
  name VARCHAR(50) NOT NULL,
  size INT NOT NULL,
  colour VARCHAR(50) NOT NULL,
  price DECIMAL(10, 2) NOT NULL,
  stock INT NOT NULL DEFAULT 0,
  brand_id INT NOT NULL,
  PRIMARY KEY (shoe_id),
  UNIQUE KEY check_product (name, size, colour, brand_id),
  CONSTRAINT fk_shoe_brand
    FOREIGN KEY (brand_id)
    REFERENCES Brand (brand_id)
    ON UPDATE CASCADE
    ON DELETE RESTRICT
) ENGINE = InnoDB;

CREATE TABLE ShoeCategory (
  shoe_id INT NOT NULL,
  category_id INT NOT NULL,
  PRIMARY KEY (shoe_id, category_id),
  CONSTRAINT fk_shoecategory_shoe
    FOREIGN KEY (shoe_id)
    REFERENCES Shoe (shoe_id)
    ON DELETE CASCADE,
  CONSTRAINT fk_shoecategory_category
    FOREIGN KEY (category_id)
    REFERENCES Category (category_id)
    ON DELETE CASCADE
) ENGINE = InnoDB;

CREATE TABLE Customer (
  customer_id INT NOT NULL AUTO_INCREMENT,
  name VARCHAR(20) NOT NULL,
  surname VARCHAR(50) NOT NULL,
  city VARCHAR(100) NOT NULL,
  username VARCHAR(20) NOT NULL,
  password VARCHAR(255) NOT NULL,
  PRIMARY KEY (customer_id),
  UNIQUE KEY uk_customer_username (username)
) ENGINE = InnoDB;

CREATE TABLE CustomerOrder (
  order_id INT NOT NULL AUTO_INCREMENT,
  customer_id INT NOT NULL,
  order_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  status ENUM('active', 'payed') NOT NULL DEFAULT 'active',

  -- max 1
  active_customer_id INT
    GENERATED ALWAYS AS (
      CASE WHEN status = 'active' THEN customer_id ELSE NULL END
    ) STORED,

  PRIMARY KEY (order_id),
  KEY idx_customerorder_customer (customer_id),
  UNIQUE KEY uk_one_active_order_per_customer (active_customer_id),

  CONSTRAINT fk_customerorder_customer
    FOREIGN KEY (customer_id)
    REFERENCES Customer (customer_id)
    ON DELETE RESTRICT
) ENGINE = InnoDB;

CREATE TABLE CustomerOrderItem (
  order_id INT NOT NULL,
  shoe_id INT NOT NULL,
  quantity INT NOT NULL DEFAULT 1,
  price DECIMAL(10, 2) NOT NULL,
  PRIMARY KEY (order_id, shoe_id),
  CONSTRAINT fk_orderitem_order
    FOREIGN KEY (order_id)
    REFERENCES CustomerOrder (order_id)
    ON DELETE CASCADE,
  CONSTRAINT fk_orderitem_shoe
    FOREIGN KEY (shoe_id)
    REFERENCES Shoe (shoe_id)
    ON DELETE RESTRICT
) ENGINE = InnoDB;

CREATE TABLE OutOfStock (
  oos_id INT NOT NULL AUTO_INCREMENT,
  shoe_id INT NOT NULL,
  oos_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (oos_id),
  KEY idx_oos_shoe_time (shoe_id, oos_time),
  CONSTRAINT fk_oos_shoe
    FOREIGN KEY (shoe_id)
    REFERENCES Shoe (shoe_id)
    ON DELETE CASCADE
) ENGINE = InnoDB;

DELIMITER $$

CREATE TRIGGER shoe_out_of_stock
AFTER UPDATE ON Shoe
FOR EACH ROW
BEGIN
  IF OLD.stock > 0 AND NEW.stock = 0 THEN
    INSERT INTO OutOfStock (shoe_id, oos_time)
    VALUES (NEW.shoe_id, NOW());
  END IF;
END$$

DELIMITER ;