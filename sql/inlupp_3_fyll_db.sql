USE
webbshop_db;

insert into Customer (name, surname, city, username, password)
values ('Joakim', 'Samuelsson', 'Uppsala', 'joasam', '12345'),
       ('Leif', 'GW Perssson', 'Stockholm', 'gw', 'bulle1'),
       ('Alfred', 'Nobel', 'Italien', 'af96', 'dynamit'),
       ('Test', 'Testsson', 'Stockholm', 'tete', 'tete'),
       ('Mikaoj', 'Nossleumas', 'Stockholm', 'masoaj', '54321');

insert into CustomerOrder (customer_id, status, order_date)
values (( select customer_id from Customer where username = 'joasam' ),
        'BETALD', '2026-01-30 12:15:00'),
       (( select customer_id from Customer where username = 'joasam' ),
        'AKTIV', '2026-01-29 19:30:00'),
       (( select customer_id from Customer where username = 'gw' ),
        'BETALD', '2026-01-30 09:00:00'),
       (( select customer_id from Customer where username = 'af96' ),
        'BETALD', '2026-01-28 18:45:00'),
       (( select customer_id from Customer where username = 'tete' ),
        'AKTIV', '2026-01-30 20:05:00'),
       (( select customer_id from Customer where username = 'masoaj' ),
        'BETALD', '2026-01-29 14:10:00');

-- joasam BETALD order: 2 skor
insert into CustomerOrderItem (order_id, shoe_id, quantity, price)
select o.order_id, s.shoe_id, x.quantity, s.price
from ( select ( select order_id
                from CustomerOrder
                where customer_id = ( select customer_id from Customer where username = 'joasam' )
                  and status = 'BETALD'
                order by order_date
                    asc LIMIT 1 ) as order_id, 'Lundhags' as brand, 'Trekking Boot' as name, 42 as size, 'Padje Light' as colour, 1 as quantity
union all
select ( select order_id
         from CustomerOrder
         where customer_id = ( select customer_id from Customer where username = 'joasam' )
           and status = 'BETALD'
         order by order_date asc LIMIT 1 ), 'Adidas', 'Adilette', 45, 'Blue/White', 2
) x
join CustomerOrder o
on o.order_id = x.order_id join Shoe s on s.brand = x.brand and s.name = x.name and s.size = x.size and s.colour = x.colour;

-- joasam AKTIV order
insert into CustomerOrderItem (order_id, shoe_id, quantity, price)
select o.order_id, s.shoe_id, x.quantity, s.price
from ( select ( select order_id
                from CustomerOrder
                where customer_id = ( select customer_id from Customer where username = 'joasam' )
                  and status = 'AKTIV' LIMIT 1 ) as order_id, 'Adidas' as brand, 'Campus' as name, 45 as size, 'Core-black/Off-white' as colour, 1 as quantity
union all
select ( select order_id
         from CustomerOrder
         where customer_id = ( select customer_id from Customer where username = 'joasam' )
           and status = 'AKTIV' LIMIT 1 ), 'Nike', 'Alpha Fly 3', 45, 'Marinblå', 1
) x
join CustomerOrder o
on o.order_id = x.order_id join Shoe s on s.brand = x.brand and s.name = x.name and s.size = x.size and s.colour = x.colour;

-- gw BETALD order: 2 skor
insert into CustomerOrderItem (order_id, shoe_id, quantity, price)
select o.order_id, s.shoe_id, x.quantity, s.price
from ( select ( select order_id
                from CustomerOrder
                where customer_id = ( select customer_id from Customer where username = 'gw' )
                  and status = 'BETALD' LIMIT 1 ) as order_id, 'Meindl' as brand, 'Capri' as name, 45 as size, 'Ljusbrun' as colour, 1 as quantity
union all
select ( select order_id
         from CustomerOrder
         where customer_id = ( select customer_id from Customer where username = 'gw' )
           and status = 'BETALD' LIMIT 1 ), 'Birkenstock', 'Arizona', 45, 'Dark Brown', 1
) x
join CustomerOrder o
on o.order_id = x.order_id join Shoe s on s.brand = x.brand and s.name = x.name and s.size = x.size and s.colour = x.colour;

-- af96 BETALD order
insert into CustomerOrderItem (order_id, shoe_id, quantity, price)
select o.order_id, s.shoe_id, 1, s.price
from CustomerOrder o
         join Customer cu on cu.customer_id = o.customer_id
         join Shoe s on s.brand = 'Birkenstock' and s.name = 'Shinjuku' and s.size = 45 and s.colour = 'Basalt Grey'
where cu.username = 'af96'
  and o.status = 'BETALD' LIMIT 1;

-- tete AKTIV order
insert into CustomerOrderItem (order_id, shoe_id, quantity, price)
select o.order_id, s.shoe_id, 1, s.price
from CustomerOrder o
         join Customer cu on cu.customer_id = o.customer_id
         join Shoe s on s.brand = 'Timberland' and s.name = 'Stone street' and s.size = 41 and s.colour = 'Wheat'
where cu.username = 'tete'
  and o.status = 'AKTIV' LIMIT 1;

-- masoaj BETALD order: 2 skor
insert into CustomerOrderItem (order_id, shoe_id, quantity, price)
select o.order_id, s.shoe_id, x.quantity, s.price
from ( select ( select order_id
                from CustomerOrder
                where customer_id = ( select customer_id from Customer where username = 'masoaj' )
                  and status = 'BETALD' LIMIT 1 ) as order_id, 'Adidas' as brand, 'Adilette Ayoon' as name, 40 as size, 'Beige' as colour, 1 as quantity
union all
select ( select order_id
         from CustomerOrder
         where customer_id = ( select customer_id from Customer where username = 'masoaj' )
           and status = 'BETALD' LIMIT 1 ), 'Lundhags', 'Trail Boot', 42, 'Tived', 1
) x
join CustomerOrder o
on o.order_id = x.order_id join Shoe s on s.brand = x.brand and s.name = x.name and s.size = x.size and s.colour = x.colour;