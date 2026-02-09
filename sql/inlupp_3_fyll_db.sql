use webbshop_db;

INSERT INTO customer (name, username, password, city, address)
VALUES
  ('Joakim Samuelsson', 'joasam', '12345', 'Uppsala', 'Gatuvägen 1'),
  ('Leif GW Persson', 'gw', 'bulle1', 'Stockholm', 'Gatuvägen 2'),
  ('Alfred Nobel', 'af96', 'dynamit', 'Sanremo', 'Gatuvägen 3'),
  ('Test Testsson', 'tete', 'tete', 'Stockholm', 'Gatuvägen 4'),
  ('Mikaoj Nossleumas', 'masoaj', '54321', 'Stockholm', 'Gatuvägen 5'),
  ('Kim Jong Un', 'kimju', 'nuke123', 'Pyongyang', 'Gatuvägen 6'),
  ('Vladimir Putin', 'vputin', 'su<3', 'Moscow', 'Gatuvägen 7'),
  ('Boris Johnson', 'borisj', 'brexit', 'London', 'Gatuvägen 8'),
  ('Javier Milei', 'jmilei', 'liberty', 'Buenos Aires', 'Gatuvägen 9'),
  ('Richard Feynman', 'rfeynman', 'qu4ntum', 'Pasadena', 'Gatuvägen 10');

insert into customerorder (customer_id, status, created_at)
values ((select id from customer where username = 'joasam'),
        'BETALD',
        '2026-01-30 00:00:00'),
       ((select id from customer where username = 'joasam'),
        'AKTIV',
        '2026-01-29 00:00:00'),
       ((select id from customer where username = 'gw'),
        'BETALD',
        '2026-01-30 00:00:00'),
       ((select id from customer where username = 'af96'),
        'BETALD',
        '2026-01-28 00:00:00'),
       ((select id from customer where username = 'tete'),
        'AKTIV',
        '2026-01-30 00:00:00'),
       ((select id from customer where username = 'masoaj'),
        'BETALD',
        '2026-01-29 00:00:00');

-- joasam BETALD
insert into orderitem (order_id, shoe_id, quantity)
select o.id, s.id, x.quantity
from (select (select o2.id
              from customerorder o2
                       join customer c on c.id = o2.customer_id
              where c.username = 'joasam'
                and o2.status = 'BETALD'
              order by o2.created_at asc
              limit 1)      as order_id,
             'Lundhags'     as brand,
             'Trekking Boot' as shoe_name,
             42.0           as size,
             'Padje Light'  as colour,
             1              as quantity
      union all
      select (select o2.id
              from customerorder o2
                       join customer c on c.id = o2.customer_id
              where c.username = 'joasam'
                and o2.status = 'BETALD'
              order by o2.created_at asc
              limit 1),
             'Adidas',
             'Slides',
             45.0,
             'Blue/White',
             2) x
         join customerorder o on o.id = x.order_id
         join shoe s on s.name = x.shoe_name and s.size = x.size and s.colour = x.colour
         join brand b on b.id = s.brand_id and b.name = x.brand;

-- joasam AKTIV
insert into orderitem (order_id, shoe_id, quantity)
select o.id, s.id, x.quantity
from (select (select o2.id
              from customerorder o2
                       join customer c on c.id = o2.customer_id
              where c.username = 'joasam'
                and o2.status = 'AKTIV'
              limit 1)                as order_id,
             'Adidas'                 as brand,
             'Campus'                 as shoe_name,
             45.0                     as size,
             'Core-black/Off-white'   as colour,
             1                        as quantity
      union all
      select (select o2.id
              from customerorder o2
                       join customer c on c.id = o2.customer_id
              where c.username = 'joasam'
                and o2.status = 'AKTIV'
              limit 1),
             'Nike',
             'Alphafly 3',
             45.0,
             'Marinblå',
             1) x
         join customerorder o on o.id = x.order_id
         join shoe s on s.name = x.shoe_name and s.size = x.size and s.colour = x.colour
         join brand b on b.id = s.brand_id and b.name = x.brand;

-- gw BETALD
insert into orderitem (order_id, shoe_id, quantity)
select o.id, s.id, x.quantity
from (select (select o2.id
              from customerorder o2
                       join customer c on c.id = o2.customer_id
              where c.username = 'gw'
                and o2.status = 'BETALD'
              limit 1)    as order_id,
             'Meindl'     as brand,
             'Badia'      as shoe_name,
             45.0         as size,
             'Ljusbrun'   as colour,
             1            as quantity
      union all
      select (select o2.id
              from customerorder o2
                       join customer c on c.id = o2.customer_id
              where c.username = 'gw'
                and o2.status = 'BETALD'
              limit 1),
             'Birkenstock',
             'Arizona',
             45.0,
             'Dark Brown',
             1) x
         join customerorder o on o.id = x.order_id
         join shoe s on s.name = x.shoe_name and s.size = x.size and s.colour = x.colour
         join brand b on b.id = s.brand_id and b.name = x.brand;

-- af96 BETALD
insert into orderitem (order_id, shoe_id, quantity)
select o.id, s.id, 1
from customerorder o
         join customer cu on cu.id = o.customer_id
         join shoe s on s.name = 'Arizona' and s.size = 45.0 and s.colour = 'Basalt Grey'
         join brand b on b.id = s.brand_id and b.name = 'Birkenstock'
where cu.username = 'af96'
  and o.status = 'BETALD'
limit 1;

-- tete AKTIV
insert into orderitem (order_id, shoe_id, quantity)
select o.id, s.id, 1
from customerorder o
         join customer cu on cu.id = o.customer_id
         join shoe s on s.name = 'Courma' and s.size = 41.0 and s.colour = 'Wheat'
         join brand b on b.id = s.brand_id and b.name = 'Timberland'
where cu.username = 'tete'
  and o.status = 'AKTIV'
limit 1;

-- masoaj BETALD
insert into orderitem (order_id, shoe_id, quantity)
select o.id, s.id, x.quantity
from (select (select o2.id
              from customerorder o2
                       join customer c on c.id = o2.customer_id
              where c.username = 'masoaj'
                and o2.status = 'BETALD'
              limit 1)    as order_id,
             'Adidas'     as brand,
             'Campus'     as shoe_name,
             40.0         as size,
             'Beige'      as colour,
             1            as quantity
      union all
      select (select o2.id
              from customerorder o2
                       join customer c on c.id = o2.customer_id
              where c.username = 'masoaj'
                and o2.status = 'BETALD'
              limit 1),
             'Lundhags',
             'Trail Boot',
             42.0,
             'Tived',
             1) x
         join customerorder o on o.id = x.order_id
         join shoe s on s.name = x.shoe_name and s.size = x.size and s.colour = x.colour
         join brand b on b.id = s.brand_id and b.name = x.brand;

-- GENERERAD EFTER DETTA!
-- 30 new BETALD orders between 2025-10-01 and 2026-01-31
insert into customerorder (customer_id, status, created_at)
values
  ((select id from customer where username = 'joasam'), 'BETALD', '2025-10-03 10:12:00'),
  ((select id from customer where username = 'gw'),     'BETALD', '2025-10-05 18:40:00'),
  ((select id from customer where username = 'af96'),   'BETALD', '2025-10-08 09:05:00'),
  ((select id from customer where username = 'tete'),   'BETALD', '2025-10-12 14:22:00'),
  ((select id from customer where username = 'masoaj'), 'BETALD', '2025-10-16 20:01:00'),

  ((select id from customer where username = 'joasam'), 'BETALD', '2025-10-22 08:33:00'),
  ((select id from customer where username = 'gw'),     'BETALD', '2025-10-27 12:10:00'),
  ((select id from customer where username = 'af96'),   'BETALD', '2025-11-02 16:55:00'),
  ((select id from customer where username = 'tete'),   'BETALD', '2025-11-06 11:27:00'),
  ((select id from customer where username = 'masoaj'), 'BETALD', '2025-11-09 19:44:00'),

  ((select id from customer where username = 'joasam'), 'BETALD', '2025-11-14 13:03:00'),
  ((select id from customer where username = 'gw'),     'BETALD', '2025-11-18 09:48:00'),
  ((select id from customer where username = 'af96'),   'BETALD', '2025-11-23 21:15:00'),
  ((select id from customer where username = 'tete'),   'BETALD', '2025-11-28 07:59:00'),
  ((select id from customer where username = 'masoaj'), 'BETALD', '2025-12-02 17:26:00'),

  ((select id from customer where username = 'joasam'), 'BETALD', '2025-12-06 10:41:00'),
  ((select id from customer where username = 'gw'),     'BETALD', '2025-12-10 15:08:00'),
  ((select id from customer where username = 'af96'),   'BETALD', '2025-12-14 18:31:00'),
  ((select id from customer where username = 'tete'),   'BETALD', '2025-12-18 12:44:00'),
  ((select id from customer where username = 'masoaj'), 'BETALD', '2025-12-22 20:20:00'),

  ((select id from customer where username = 'joasam'), 'BETALD', '2025-12-27 09:11:00'),
  ((select id from customer where username = 'gw'),     'BETALD', '2025-12-30 16:02:00'),
  ((select id from customer where username = 'af96'),   'BETALD', '2026-01-04 11:35:00'),
  ((select id from customer where username = 'tete'),   'BETALD', '2026-01-08 19:09:00'),
  ((select id from customer where username = 'masoaj'), 'BETALD', '2026-01-12 08:18:00'),

  ((select id from customer where username = 'joasam'), 'BETALD', '2026-01-16 14:57:00'),
  ((select id from customer where username = 'gw'),     'BETALD', '2026-01-20 10:06:00'),
  ((select id from customer where username = 'af96'),   'BETALD', '2026-01-24 17:49:00'),
  ((select id from customer where username = 'tete'),   'BETALD', '2026-01-28 12:30:00'),
  ((select id from customer where username = 'masoaj'), 'BETALD', '2026-01-31 21:12:00');

-- Add 2 items per new BETALD order:
-- This targets only the 30 newly inserted orders via the exact created_at timestamps above.
insert into orderitem (order_id, shoe_id, quantity)
select o.id, s.id, x.quantity
from (
  -- 2025-10-03 joasam
  select 'joasam' as username, '2025-10-03 10:12:00' as created_at,
         'Lundhags' as brand, 'Trekking Boot' as shoe_name, 42.0 as size,
         'Padje Light' as colour, 1 as quantity
  union all
  select 'joasam', '2025-10-03 10:12:00', 'Adidas', 'Slides', 45.0, 'Blue/White', 1

  -- 2025-10-05 gw
  union all
  select 'gw', '2025-10-05 18:40:00', 'Meindl', 'Badia', 45.0, 'Ljusbrun', 1
  union all
  select 'gw', '2025-10-05 18:40:00', 'Birkenstock', 'Arizona', 45.0, 'Dark Brown', 1

  -- 2025-10-08 af96
  union all
  select 'af96', '2025-10-08 09:05:00', 'Nike', 'Alphafly 3', 45.0, 'Marinblå', 1
  union all
  select 'af96', '2025-10-08 09:05:00', 'Adidas', 'Campus', 45.0, 'Core-black/Off-white', 1

  -- 2025-10-12 tete
  union all
  select 'tete', '2025-10-12 14:22:00', 'Timberland', 'Courma', 41.0, 'Wheat', 1
  union all
  select 'tete', '2025-10-12 14:22:00', 'Adidas', 'Slides', 45.0, 'Blue/White', 2

  -- 2025-10-16 masoaj
  union all
  select 'masoaj', '2025-10-16 20:01:00', 'Adidas', 'Campus', 40.0, 'Beige', 1
  union all
  select 'masoaj', '2025-10-16 20:01:00', 'Lundhags', 'Trail Boot', 42.0, 'Tived', 1

  -- 2025-10-22 joasam
  union all
  select 'joasam', '2025-10-22 08:33:00', 'Nike', 'Alphafly 3', 45.0, 'Neongrön', 1
  union all
  select 'joasam', '2025-10-22 08:33:00', 'Birkenstock', 'Arizona', 43.0, 'Black', 1

  -- 2025-10-27 gw
  union all
  select 'gw', '2025-10-27 12:10:00', 'Lundhags', 'Trekking Boot', 39.0, 'Padje Dark', 1
  union all
  select 'gw', '2025-10-27 12:10:00', 'Adidas', 'Campus', 45.0, 'Core-black/Off-white', 1

  -- 2025-11-02 af96
  union all
  select 'af96', '2025-11-02 16:55:00', 'Birkenstock', 'Arizona', 45.0, 'Basalt Grey', 1
  union all
  select 'af96', '2025-11-02 16:55:00', 'Adidas', 'Slides', 45.0, 'Blue/White', 1

  -- 2025-11-06 tete
  union all
  select 'tete', '2025-11-06 11:27:00', 'Meindl', 'Badia', 42.0, 'Ljusbrun', 1
  union all
  select 'tete', '2025-11-06 11:27:00', 'Nike', 'Alphafly 3', 45.0, 'Rosa och vit', 1

  -- 2025-11-09 masoaj
  union all
  select 'masoaj', '2025-11-09 19:44:00', 'Lundhags', 'Trail Boot', 42.0, 'Tived', 1
  union all
  select 'masoaj', '2025-11-09 19:44:00', 'Birkenstock', 'Arizona', 45.0, 'Dark Brown', 1

  -- 2025-11-14 joasam
  union all
  select 'joasam', '2025-11-14 13:03:00', 'Adidas', 'Campus', 45.0, 'Core-black/Off-white', 1
  union all
  select 'joasam', '2025-11-14 13:03:00', 'Nike', 'Alphafly 3', 45.0, 'Marinblå', 1

  -- 2025-11-18 gw
  union all
  select 'gw', '2025-11-18 09:48:00', 'Meindl', 'Badia', 42.0, 'Mörkbrun', 1
  union all
  select 'gw', '2025-11-18 09:48:00', 'Adidas', 'Slides', 45.0, 'Blue/White', 1

  -- 2025-11-23 af96
  union all
  select 'af96', '2025-11-23 21:15:00', 'Lundhags', 'Trekking Boot', 45.0, 'Padje Light', 1
  union all
  select 'af96', '2025-11-23 21:15:00', 'Adidas', 'Campus', 40.0, 'Beige', 1

  -- 2025-11-28 tete
  union all
  select 'tete', '2025-11-28 07:59:00', 'Timberland', 'Courma', 41.0, 'Wheat', 1
  union all
  select 'tete', '2025-11-28 07:59:00', 'Birkenstock', 'Arizona', 43.0, 'Black', 1

  -- 2025-12-02 masoaj
  union all
  select 'masoaj', '2025-12-02 17:26:00', 'Nike', 'Alphafly 3', 45.0, 'Neongrön', 1
  union all
  select 'masoaj', '2025-12-02 17:26:00', 'Adidas', 'Slides', 45.0, 'Blue/White', 1

  -- 2025-12-06 joasam
  union all
  select 'joasam', '2025-12-06 10:41:00', 'Birkenstock', 'Arizona', 45.0, 'Dark Brown', 1
  union all
  select 'joasam', '2025-12-06 10:41:00', 'Lundhags', 'Trail Boot', 42.0, 'Tived', 1

  -- 2025-12-10 gw
  union all
  select 'gw', '2025-12-10 15:08:00', 'Adidas', 'Campus', 45.0, 'Core-black/Off-white', 1
  union all
  select 'gw', '2025-12-10 15:08:00', 'Nike', 'Alphafly 3', 45.0, 'Marinblå', 1

  -- 2025-12-14 af96
  union all
  select 'af96', '2025-12-14 18:31:00', 'Meindl', 'Badia', 45.0, 'Ljusbrun', 1
  union all
  select 'af96', '2025-12-14 18:31:00', 'Birkenstock', 'Arizona', 45.0, 'Basalt Grey', 1

  -- 2025-12-18 tete
  union all
  select 'tete', '2025-12-18 12:44:00', 'Adidas', 'Slides', 45.0, 'Blue/White', 1
  union all
  select 'tete', '2025-12-18 12:44:00', 'Nike', 'Alphafly 3', 45.0, 'Rosa och vit', 1

  -- 2025-12-22 masoaj
  union all
  select 'masoaj', '2025-12-22 20:20:00', 'Lundhags', 'Trekking Boot', 42.0, 'Padje Light', 1
  union all
  select 'masoaj', '2025-12-22 20:20:00', 'Birkenstock', 'Arizona', 45.0, 'Dark Brown', 2

  -- 2025-12-27 joasam
  union all
  select 'joasam', '2025-12-27 09:11:00', 'Nike', 'Alphafly 3', 45.0, 'Marinblå', 1
  union all
  select 'joasam', '2025-12-27 09:11:00', 'Adidas', 'Campus', 40.0, 'Beige', 1

  -- 2025-12-30 gw
  union all
  select 'gw', '2025-12-30 16:02:00', 'Timberland', 'Courma', 41.0, 'Wheat', 1
  union all
  select 'gw', '2025-12-30 16:02:00', 'Meindl', 'Badia', 42.0, 'Mörkbrun', 1

  -- 2026-01-04 af96
  union all
  select 'af96', '2026-01-04 11:35:00', 'Adidas', 'Campus', 45.0, 'Core-black/Off-white', 1
  union all
  select 'af96', '2026-01-04 11:35:00', 'Nike', 'Alphafly 3', 45.0, 'Neongrön', 1

  -- 2026-01-08 tete
  union all
  select 'tete', '2026-01-08 19:09:00', 'Birkenstock', 'Arizona', 43.0, 'Black', 1
  union all
  select 'tete', '2026-01-08 19:09:00', 'Adidas', 'Slides', 45.0, 'Blue/White', 1

  -- 2026-01-12 masoaj
  union all
  select 'masoaj', '2026-01-12 08:18:00', 'Meindl', 'Badia', 45.0, 'Ljusbrun', 1
  union all
  select 'masoaj', '2026-01-12 08:18:00', 'Lundhags', 'Trail Boot', 42.0, 'Tived', 1

  -- 2026-01-16 joasam
  union all
  select 'joasam', '2026-01-16 14:57:00', 'Lundhags', 'Trekking Boot', 45.0, 'Padje Light', 1
  union all
  select 'joasam', '2026-01-16 14:57:00', 'Birkenstock', 'Arizona', 45.0, 'Basalt Grey', 1

  -- 2026-01-20 gw
  union all
  select 'gw', '2026-01-20 10:06:00', 'Nike', 'Alphafly 3', 45.0, 'Rosa och vit', 1
  union all
  select 'gw', '2026-01-20 10:06:00', 'Adidas', 'Campus', 45.0, 'Core-black/Off-white', 1

  -- 2026-01-24 af96
  union all
  select 'af96', '2026-01-24 17:49:00', 'Lundhags', 'Trekking Boot', 39.0, 'Padje Dark', 1
  union all
  select 'af96', '2026-01-24 17:49:00', 'Adidas', 'Slides', 45.0, 'Blue/White', 2

  -- 2026-01-28 tete
  union all
  select 'tete', '2026-01-28 12:30:00', 'Timberland', 'Courma', 41.0, 'Wheat', 1
  union all
  select 'tete', '2026-01-28 12:30:00', 'Meindl', 'Badia', 42.0, 'Ljusbrun', 1

  -- 2026-01-31 masoaj
  union all
  select 'masoaj', '2026-01-31 21:12:00', 'Birkenstock', 'Arizona', 45.0, 'Dark Brown', 1
  union all
  select 'masoaj', '2026-01-31 21:12:00', 'Nike', 'Alphafly 3', 45.0, 'Marinblå', 1
) x
join customerorder o
  on o.created_at = x.created_at
 and o.status = 'BETALD'
join customer c
  on c.id = o.customer_id
 and c.username = x.username
join shoe s
  on s.name = x.shoe_name
 and s.size = x.size
 and s.colour = x.colour
join brand b
  on b.id = s.brand_id
 and b.name = x.brand;