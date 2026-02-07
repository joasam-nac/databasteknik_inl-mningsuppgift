use webbshop_db;


insert into customer (name, username, password, city, address)
values ('Joakim Samuelsson', 'joasam', '12345', 'Uppsala', 'Gatuvägen 1'),
       ('Leif GW Perssson', 'gw', 'bulle1', 'Stockholm', 'Gatuvägen 2'),
       ('Alfred Nobel', 'af96', 'dynamit', 'Sanremo', 'Gatuvägen 3'),
       ('Test Testsson', 'tete', 'tete', 'Stockholm', 'Gatuvägen 4'),
       ('Mikaoj Nossleumas', 'masoaj', '54321', 'Stockholm', 'Gatuvägen 5');


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


insert into orderitem (order_id, shoe_id, quantity)
select o.id, s.id, x.quantity
from (select (select o2.id
              from customerorder o2
                       join customer c on c.id = o2.customer_id
              where c.username = 'joasam'
                and o2.status = 'BETALD'
              order by o2.created_at asc
              limit 1)     as order_id,
             'Lundhags'    as brand,
             42.0          as size,
             'Padje Light' as colour,
             1             as quantity
      union all
      select (select o2.id
              from customerorder o2
                       join customer c on c.id = o2.customer_id
              where c.username = 'joasam'
                and o2.status = 'BETALD'
              order by o2.created_at asc
              limit 1),
             'Adidas',
             45.0,
             'Blue/White',
             2) x
         join customerorder o on o.id = x.order_id
         join shoe s on s.size = x.size and s.colour = x.colour
         join brand b on b.id = s.brand_id and b.name = x.brand;

-- joasam AKTIV
insert into orderitem (order_id, shoe_id, quantity)
select o.id, s.id, x.quantity
from (select (select o2.id
              from customerorder o2
                       join customer c on c.id = o2.customer_id
              where c.username = 'joasam'
                and o2.status = 'AKTIV'
              limit 1)              as order_id,
             'Adidas'               as brand,
             45.0                   as size,
             'Core-black/Off-white' as colour,
             1                      as quantity
      union all
      select (select o2.id
              from customerorder o2
                       join customer c on c.id = o2.customer_id
              where c.username = 'joasam'
                and o2.status = 'AKTIV'
              limit 1),
             'Nike',
             45.0,
             'Marinblå',
             1) x
         join customerorder o on o.id = x.order_id
         join shoe s on s.size = x.size and s.colour = x.colour
         join brand b on b.id = s.brand_id and b.name = x.brand;


insert into orderitem (order_id, shoe_id, quantity)
select o.id, s.id, x.quantity
from (select (select o2.id
              from customerorder o2
                       join customer c on c.id = o2.customer_id
              where c.username = 'gw'
                and o2.status = 'BETALD'
              limit 1)  as order_id,
             'Meindl'   as brand,
             45.0       as size,
             'Ljusbrun' as colour,
             1          as quantity
      union all
      select (select o2.id
              from customerorder o2
                       join customer c on c.id = o2.customer_id
              where c.username = 'gw'
                and o2.status = 'BETALD'
              limit 1),
             'Birkenstock',
             45.0,
             'Dark Brown',
             1) x
         join customerorder o on o.id = x.order_id
         join shoe s on s.size = x.size and s.colour = x.colour
         join brand b on b.id = s.brand_id and b.name = x.brand;


insert into orderitem (order_id, shoe_id, quantity)
select o.id, s.id, 1
from customerorder o
         join customer cu on cu.id = o.customer_id
         join shoe s on s.size = 45.0 and s.colour = 'Basalt Grey'
         join brand b on b.id = s.brand_id and b.name = 'Birkenstock'
where cu.username = 'af96'
  and o.status = 'BETALD'
limit 1;

-- tete AKTIV
insert into orderitem (order_id, shoe_id, quantity)
select o.id, s.id, 1
from customerorder o
         join customer cu on cu.id = o.customer_id
         join shoe s on s.size = 41.0 and s.colour = 'Wheat'
         join brand b on b.id = s.brand_id and b.name = 'Timberland'
where cu.username = 'tete'
  and o.status = 'AKTIV'
limit 1;


insert into orderitem (order_id, shoe_id, quantity)
select o.id, s.id, x.quantity
from (select (select o2.id
              from customerorder o2
                       join customer c on c.id = o2.customer_id
              where c.username = 'masoaj'
                and o2.status = 'BETALD'
              limit 1) as order_id,
             'Adidas'  as brand,
             40.0      as size,
             'Beige'   as colour,
             1         as quantity
      union all
      select (select o2.id
              from customerorder o2
                       join customer c on c.id = o2.customer_id
              where c.username = 'masoaj'
                and o2.status = 'BETALD'
              limit 1),
             'Lundhags',
             42.0,
             'Tived',
             1) x
         join customerorder o on o.id = x.order_id
         join shoe s on s.size = x.size and s.colour = x.colour
         join brand b on b.id = s.brand_id and b.name = x.brand;