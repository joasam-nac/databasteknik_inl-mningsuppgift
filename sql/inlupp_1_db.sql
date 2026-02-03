/* create database if not exists webbshop_db; */

use webbshop_db;

create table Brand (
  brand_id int not null auto_increment,
  name varchar(50) not null,
  primary key (brand_id),
  unique key uk_brand_name (name)
);

create table Category (
  category_id int not null auto_increment,
  name varchar(50) not null,
  primary key (category_id),
  unique key uk_category_name (name)
);

create table Shoe (
  shoe_id int not null auto_increment,
  name varchar(50) not null,
  size int not null,
  colour varchar(50) not null,
  price decimal(10, 2) not null,
  stock int not null default 0,
  brand_id int not null,
  primary key (shoe_id),
  unique key uk_shoe_variant (name, size, colour, brand_id),
  key idx_shoe_brand (brand_id),
  constraint chk_shoe_stock_nonneg check (stock >= 0),
  constraint chk_shoe_price_nonneg check (price >= 0),
  constraint fk_shoe_brand foreign key (brand_id) references Brand (brand_id) on update cascade on delete restrict
);

create table ShoeCategory (
  shoe_id int not null,
  category_id int not null,
  primary key (shoe_id, category_id),
  key idx_shoecategory_category (category_id),
  constraint fk_shoecategory_shoe foreign key (shoe_id) references Shoe (shoe_id) on delete cascade,
  constraint fk_shoecategory_category foreign key (category_id) references Category (category_id) on delete cascade
);

create table Customer (
  customer_id int not null auto_increment,
  name varchar(20) not null,
  surname varchar(50) not null,
  city varchar(100) not null,
  username varchar(20) not null,
  password varchar(255) not null,
  primary key (customer_id),
  unique key uk_customer_username (username)
);

create table CustomerOrder (
  order_id int not null auto_increment,
  customer_id int not null,
  order_date datetime not null default current_timestamp,
  status enum('active', 'payed') not null default 'active',
  active_customer_id int generated always as (
    case
      when status = 'active' then customer_id
      else null
    end
  ) stored,
  primary key (order_id),
  key idx_customerorder_customer (customer_id),
  unique key uk_one_active_order_per_customer (active_customer_id),
  constraint fk_customerorder_customer foreign key (customer_id) references Customer (customer_id) on delete restrict
);

create table CustomerOrderItem (
  order_id int not null,
  shoe_id int not null,
  quantity int not null default 1,
  price decimal(10, 2) not null,
  primary key (order_id, shoe_id),
  key idx_orderitem_shoe (shoe_id),
  constraint chk_orderitem_qty_pos check (quantity > 0),
  constraint chk_orderitem_price_nonneg check (price >= 0),
  constraint fk_orderitem_order foreign key (order_id) references CustomerOrder (order_id) on delete cascade,
  constraint fk_orderitem_shoe foreign key (shoe_id) references Shoe (shoe_id) on delete restrict
);

create table OutOfStock (
  oos_id int not null auto_increment,
  shoe_id int not null,
  oos_time datetime not null default current_timestamp,
  primary key (oos_id),
  key idx_oos_shoe_time (shoe_id, oos_time),
  constraint fk_oos_shoe foreign key (shoe_id) references Shoe (shoe_id) on delete cascade
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