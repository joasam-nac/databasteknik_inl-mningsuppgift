create
DATABASE IF not exists webbshop_db;

USE
webbshop_db;

create table Category
(
    category_id INT         not null AUTO_INCREMENT,
    name        VARCHAR(50) not null,
    primary key (category_id),
    unique key uk_category_name (name)
);

create table Shoe
(
    shoe_id     INT            not null AUTO_INCREMENT,
    name        VARCHAR(50)    not null,
    brand       VARCHAR(50)    not null,
    size        INT            not null,
    colour      VARCHAR(50)    not null,
    price       DECIMAL(10, 2) not null,
    stock       INT            not null default 0,
    category_id INT            not null,
    primary key (shoe_id),
    unique key uk_shoe_variant (name, size, colour, brand),
    KEY         idx_shoe_category (category_id),
    constraint chk_shoe_stock_nonneg check (stock >= 0),
    constraint chk_shoe_price_nonneg check (price >= 0),
    constraint fk_shoe_category foreign key (category_id) references Category (category_id) on update cascade on delete restrict
);

create table Customer
(
    customer_id INT          not null AUTO_INCREMENT,
    name        VARCHAR(20)  not null,
    surname     VARCHAR(50)  not null,
    city        VARCHAR(100) not null,
    username    VARCHAR(20)  not null,
    password    VARCHAR(255) not null,
    primary key (customer_id),
    unique key uk_customer_username (username)
);

create table CustomerOrder
(
    order_id           INT      not null AUTO_INCREMENT,
    customer_id        INT      not null,
    order_date         DATETIME not null default current_timestamp,
    status             ENUM('AKTIV', 'BETALD') not null default 'AKTIV',
    active_customer_id INT generated always as ( case when status = 'AKTIV' then customer_id else null end ) STORED,
    primary key (order_id),
    unique key uk_one_active_order (active_customer_id),
    KEY                idx_customerorder_customer (customer_id),
    constraint fk_customerorder_customer foreign key (customer_id) references Customer (customer_id) on delete restrict
);

create table CustomerOrderItem
(
    order_id INT            not null,
    shoe_id  INT            not null,
    quantity INT            not null default 1,
    price    DECIMAL(10, 2) not null,
    primary key (order_id, shoe_id),
    KEY      idx_orderitem_shoe (shoe_id),
    constraint chk_orderitem_qty_pos check (quantity > 0),
    constraint chk_orderitem_price_nonneg check (price >= 0),
    constraint fk_orderitem_order foreign key (order_id) references CustomerOrder (order_id) on delete cascade,
    constraint fk_orderitem_shoe foreign key (shoe_id) references Shoe (shoe_id) on delete restrict
);

create table OutOfStock
(
    oos_id   INT      not null AUTO_INCREMENT,
    shoe_id  INT      not null,
    oos_time DATETIME not null default current_timestamp,
    primary key (oos_id),
    KEY      idx_oos_shoe_time (shoe_id, oos_time),
    constraint fk_oos_shoe foreign key (shoe_id) references Shoe (shoe_id) on delete cascade
);

DELIMITER
$$
create trigger shoe_out_of_stock
    after update
    on Shoe
    for each row
begin
    IF old.stock > 0 and new.stock = 0 then
        insert into OutOfStock (shoe_id, oos_time)
        values (new.shoe_id, NOW());
end IF;
END$$
DELIMITER ;