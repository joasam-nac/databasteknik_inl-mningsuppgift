create database if not exists webbshop_db;

use webbshop_db;

CREATE TABLE Brand (
    brand_id INT NOT NULL AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL,
    PRIMARY KEY (brand_id),
    UNIQUE KEY uk_brand_name (name)
);

CREATE TABLE Category (
    category_id INT NOT NULL AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL,
    PRIMARY KEY (category_id),
    UNIQUE KEY uk_category_name (name)
);

CREATE TABLE Shoe (
    shoe_id INT NOT NULL AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL,
    size INT NOT NULL,
    colour VARCHAR(50) NOT NULL,
    price DECIMAL(10 , 2 ) NOT NULL,
    stock INT NOT NULL DEFAULT 0,
    brand_id INT NOT NULL,
    PRIMARY KEY (shoe_id),
    UNIQUE KEY uk_shoe_variant (name , size , colour , brand_id),
    KEY idx_shoe_brand (brand_id),
    CONSTRAINT chk_shoe_stock_nonneg CHECK (stock >= 0),
    CONSTRAINT chk_shoe_price_nonneg CHECK (price >= 0),
    CONSTRAINT fk_shoe_brand FOREIGN KEY (brand_id)
        REFERENCES Brand (brand_id)
        ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE ShoeCategory (
    shoe_id INT NOT NULL,
    category_id INT NOT NULL,
    PRIMARY KEY (shoe_id , category_id),
    KEY idx_shoecategory_category (category_id),
    CONSTRAINT fk_shoecategory_shoe FOREIGN KEY (shoe_id)
        REFERENCES Shoe (shoe_id)
        ON DELETE CASCADE,
    CONSTRAINT fk_shoecategory_category FOREIGN KEY (category_id)
        REFERENCES Category (category_id)
        ON DELETE CASCADE
);

CREATE TABLE Customer (
    customer_id INT NOT NULL AUTO_INCREMENT,
    name VARCHAR(20) NOT NULL,
    surname VARCHAR(50) NOT NULL,
    city VARCHAR(100) NOT NULL,
    username VARCHAR(20) NOT NULL,
    password VARCHAR(255) NOT NULL,
    PRIMARY KEY (customer_id),
    UNIQUE KEY uk_customer_username (username)
);

create table CustomerOrder (
  order_id int not null auto_increment,
  customer_id int not null,
  order_date datetime not null default current_timestamp,
  status enum('AKTIV', 'BETALD') not null default 'AKTIV',
  active_customer_id int generated always as (
    case
      when status = 'AKTIV' then customer_id
      else null
    end
  ) stored,
  primary key (order_id),
  key idx_customerorder_customer (customer_id),
  constraint fk_customerorder_customer foreign key (customer_id) references Customer (customer_id) on delete restrict
);

CREATE TABLE CustomerOrderItem (
    order_id INT NOT NULL,
    shoe_id INT NOT NULL,
    quantity INT NOT NULL DEFAULT 1,
    price DECIMAL(10 , 2 ) NOT NULL,
    PRIMARY KEY (order_id , shoe_id),
    KEY idx_orderitem_shoe (shoe_id),
    CONSTRAINT chk_orderitem_qty_pos CHECK (quantity > 0),
    CONSTRAINT chk_orderitem_price_nonneg CHECK (price >= 0),
    CONSTRAINT fk_orderitem_order FOREIGN KEY (order_id)
        REFERENCES CustomerOrder (order_id)
        ON DELETE CASCADE,
    CONSTRAINT fk_orderitem_shoe FOREIGN KEY (shoe_id)
        REFERENCES Shoe (shoe_id)
        ON DELETE RESTRICT
);

CREATE TABLE OutOfStock (
    oos_id INT NOT NULL AUTO_INCREMENT,
    shoe_id INT NOT NULL,
    oos_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (oos_id),
    KEY idx_oos_shoe_time (shoe_id , oos_time),
    CONSTRAINT fk_oos_shoe FOREIGN KEY (shoe_id)
        REFERENCES Shoe (shoe_id)
        ON DELETE CASCADE
);

delimiter $$
create trigger shoe_out_of_stock
after update on Shoe
for each row
begin
  if old.stock > 0 and new.stock = 0 then
    insert into OutOfStock (shoe_id, oos_time)
    values (new.shoe_id, now());
  end if;
end$$
delimiter ;