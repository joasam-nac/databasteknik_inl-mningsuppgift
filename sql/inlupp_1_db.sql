CREATE TABLE Brand (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE Category (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE Shoe (
  id INT AUTO_INCREMENT PRIMARY KEY,
  brand_id INT NOT NULL,
  size DECIMAL(4,1) NOT NULL,
  color VARCHAR(30) NOT NULL,
  price DECIMAL(8,2) NOT NULL,
  stock INT NOT NULL DEFAULT 0,
  FOREIGN KEY (brand_id) REFERENCES Brand(id)
);

CREATE TABLE ShoeCategory (
  shoe_id INT,
  category_id INT,
  PRIMARY KEY (shoe_id, category_id),
  FOREIGN KEY (shoe_id) REFERENCES Shoe(id),
  FOREIGN KEY (category_id) REFERENCES Category(id)
);

CREATE TABLE Customer (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  username VARCHAR(50) NOT NULL,
  city VARCHAR(100) NOT NULL,
  address VARCHAR(100) NOT NULL,
  password VARCHAR(255) NOT NULL
);

CREATE TABLE CustomerOrder (
  id INT AUTO_INCREMENT PRIMARY KEY,
  customer_id INT NOT NULL,
  date DATE NOT NULL,
  status ENUM('AKTIV','BETALD') NOT NULL DEFAULT 'AKTIV',
  active_lock INT GENERATED ALWAYS AS (IF(status='AKTIV', customer_id, NULL)) STORED,
  UNIQUE (active_lock),
  FOREIGN KEY (customer_id) REFERENCES Customer(id)
);

CREATE TABLE OrderItem (
  id INT AUTO_INCREMENT PRIMARY KEY,
  order_id INT NOT NULL,
  shoe_id INT NOT NULL,
  quantity INT NOT NULL DEFAULT 1,
  UNIQUE KEY uq_order_shoe (order_id, shoe_id),
  FOREIGN KEY (order_id) REFERENCES CustomerOrder(id),
  FOREIGN KEY (shoe_id) REFERENCES Shoe(id)
);

CREATE TABLE OutOfStock (
  id INT AUTO_INCREMENT PRIMARY KEY,
  shoe_id INT NOT NULL,
  out_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (shoe_id) REFERENCES Shoe(id)
);

DELIMITER //
CREATE TRIGGER trg_out_of_stock
AFTER UPDATE ON Shoe
FOR EACH ROW
BEGIN
  IF NEW.stock = 0 AND OLD.stock > 0 THEN
    INSERT INTO OutOfStock (shoe_id) VALUES (NEW.id);
  END IF;
END;//
DELIMITER ;