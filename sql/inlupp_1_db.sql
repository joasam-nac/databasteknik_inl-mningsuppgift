drop database if exists webbshop_db;
create database webbshop_db;
use webbshop_db;

create table brand
(
    id   int auto_increment primary key,
    name varchar(50) not null unique
);

create table category
(
    id   int auto_increment primary key,
    name varchar(50) not null unique
);

create table shoe
(
    id       int auto_increment primary key,
    brand_id int           not null,
    size     decimal(4, 1) not null,
    colour   varchar(30)   not null,
    price    decimal(8, 2) not null,
    stock    int           not null default 0,
    check (price >= 0),
    check (stock >= 0),
    foreign key (brand_id) references brand (id)
        on delete restrict
        on update cascade
);

create table shoecategory
(
    shoe_id     int not null,
    category_id int not null,
    primary key (shoe_id, category_id),
    foreign key (shoe_id) references shoe (id)
        on delete cascade
        on update cascade,
    foreign key (category_id) references category (id)
        on delete cascade
        on update cascade
);

create table customer
(
    id       int auto_increment primary key,
    name     varchar(100) not null,
    username varchar(50)  not null unique,
    city     varchar(100) not null,
    address  varchar(100) not null,
    password varchar(255) not null
);

create table customerorder
(
    id          int auto_increment primary key,
    customer_id int                      not null,
    created_at  datetime                 not null default current_timestamp,
    status      enum ('AKTIV', 'BETALD') not null default 'AKTIV',
    foreign key (customer_id) references customer (id)
        on delete cascade
        on update cascade
);

create table orderitem
(
    id       int auto_increment primary key,
    order_id int not null,
    shoe_id  int not null,
    quantity int not null default 1,
    unique key uq_order_shoe (order_id, shoe_id),
    check (quantity > 0),
    foreign key (order_id) references customerorder (id)
        on delete cascade
        on update cascade,
    foreign key (shoe_id) references shoe (id)
        on delete restrict
        on update cascade
);

create table outofstock
(
    id      int auto_increment primary key,
    shoe_id int      not null,
    out_at  datetime not null default current_timestamp,
    foreign key (shoe_id) references shoe (id)
        on delete cascade
        on update cascade
);

delimiter //

create trigger out_of_stock
    after update
    on shoe
    for each row
begin
    if new.stock = 0 and old.stock > 0 then
        insert into outofstock (shoe_id) values (new.id);
    end if;
end;
//

delimiter ;