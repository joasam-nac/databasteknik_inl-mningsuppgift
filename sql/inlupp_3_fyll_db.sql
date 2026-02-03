use webbshop_db;

insert into Customer (name, surname, city, username, password)
values (
    'Joakim',
    'Samuelsson',
    'Uppsala',
    'joasam',
    '12345'
  ),
  (
    'Leif',
    'GW Perssson',
    'Stockholm',
    'gw',
    'bulle1'
  ),
  ('Alfred', 'Nobel', 'Italien', 'af96', 'dynamit'),
  ('Test', 'Testsson', 'Stockholm', 'tete', 'tete'),
  (
    'Mikaoj',
    'Nossleumas',
    'Stockholm',
    'masoaj',
    '54321'
  );

insert into CustomerOrder (customer_id, status, order_date)
values (
    (
      select customer_id
      from Customer
      where username = 'joasam'
    ),
    'payed',
    '2026-01-30 12:15:00'
  ),
  (
    (
      select customer_id
      from Customer
      where username = 'joasam'
    ),
    'active',
    '2026-01-29 19:30:00'
  ),
  (
    (
      select customer_id
      from Customer
      where username = 'gw'
    ),
    'payed',
    '2026-01-30 09:00:00'
  ),
  (
    (
      select customer_id
      from Customer
      where username = 'af96'
    ),
    'payed',
    '2026-01-28 18:45:00'
  ),
  (
    (
      select customer_id
      from Customer
      where username = 'tete'
    ),
    'active',
    '2026-01-30 20:05:00'
  ),
  (
    (
      select customer_id
      from Customer
      where username = 'masoaj'
    ),
    'payed',
    '2026-01-29 14:10:00'
  );

-- 2 skor
insert into CustomerOrderItem (order_id, shoe_id, quantity, price)
select o.order_id,
  s.shoe_id,
  x.quantity,
  s.price
from (
    select (
        select order_id
        from CustomerOrder
        where customer_id = (
            select customer_id
            from Customer
            where username = 'joasam'
          )
          and status = 'payed'
        order by order_date asc
        limit 1
      ) as order_id,
      'Trekking Boot' as name,
      42 as size,
      'Padje Light' as colour,
      1 as quantity
    union all
    select (
        select order_id
        from CustomerOrder
        where customer_id = (
            select customer_id
            from Customer
            where username = 'joasam'
          )
          and status = 'payed'
        order by order_date asc
        limit 1
      ), 'Adilette', 45, 'Blue/White', 2
  ) x
  join CustomerOrder o on o.order_id = x.order_id
  join Shoe s on s.name = x.name
  and s.size = x.size
  and s.colour = x.colour;

-- aktiv order
insert into CustomerOrderItem (order_id, shoe_id, quantity, price)
select o.order_id,
  s.shoe_id,
  x.quantity,
  s.price
from (
    select (
        select order_id
        from CustomerOrder
        where customer_id = (
            select customer_id
            from Customer
            where username = 'joasam'
          )
          and status = 'active'
        limit 1
      ) as order_id,
      'Campus' as name,
      45 as size,
      'Core-black/Off-white' as colour,
      1 as quantity
    union all
    select (
        select order_id
        from CustomerOrder
        where customer_id = (
            select customer_id
            from Customer
            where username = 'joasam'
          )
          and status = 'active'
        limit 1
      ), 'Alpha Fly 3', 45, 'Marinblå', 1
  ) x
  join CustomerOrder o on o.order_id = x.order_id
  join shoe s on s.name = x.name
  and s.size = x.size
  and s.colour = x.colour;

-- 2 skor
insert into CustomerOrderItem (order_id, shoe_id, quantity, price)
select o.order_id,
  s.shoe_id,
  x.quantity,
  s.price
from (
    select (
        select order_id
        from CustomerOrder
        where customer_id = (
            select customer_id
            from Customer
            where username = 'gw'
          )
          and status = 'payed'
        limit 1
      ) as order_id,
      'Capri' as name,
      45 as size,
      'Ljusbrun' as colour,
      1 as quantity
    union all
    select (
        select order_id
        from CustomerOrder
        where customer_id = (
            select customer_id
            from Customer
            where username = 'gw'
          )
          and status = 'payed'
        limit 1
      ), 'Arizona', 45, 'Dark Brown', 1
  ) x
  join CustomerOrder o on o.order_id = x.order_id
  join Shoe s on s.name = x.name
  and s.size = x.size
  and s.colour = x.colour;

insert into CustomerOrderItem (order_id, shoe_id, quantity, price)
select o.order_id,
  s.shoe_id,
  1 as quantity,
  s.price
from CustomerOrder o
  join Customer cu on cu.customer_id = o.customer_id
  join Shoe s on s.name = 'Shinjuku'
  and s.size = 45
  and s.colour = 'Basalt Grey'
where cu.username = 'af96'
  and o.status = 'payed'
limit 1;

-- aktiv order
insert into CustomerOrderItem (order_id, shoe_id, quantity, price)
select o.order_id,
  s.shoe_id,
  1 as quantity,
  s.price
from CustomerOrder o
  join Customer cu on cu.customer_id = o.customer_id
  join Shoe s on s.name = 'Stone street'
  and s.size = 41
  and s.colour = 'Wheat'
where cu.username = 'tete'
  and o.status = 'active'
limit 1;

-- 2 skor
insert into CustomerOrderItem (order_id, shoe_id, quantity, price)
select o.order_id,
  s.shoe_id,
  x.quantity,
  s.price
from (
    select (
        select order_id
        from CustomerOrder
        where customer_id = (
            select customer_id
            from Customer
            where username = 'masoaj'
          )
          and status = 'payed'
        limit 1
      ) as order_id,
      'Adilette Ayoon' as name,
      40 as size,
      'Beige' as colour,
      1 as quantity
    union all
    select (
        select order_id
        from CustomerOrder
        where customer_id = (
            select customer_id
            from Customer
            where username = 'masoaj'
          )
          and status = 'payed'
        limit 1
      ), 'Trail Boot', 42, 'Tived', 1
  ) x
  join CustomerOrder o on o.order_id = x.order_id
  join Shoe s on s.name = x.name
  and s.size = x.size
  and s.colour = x.colour;