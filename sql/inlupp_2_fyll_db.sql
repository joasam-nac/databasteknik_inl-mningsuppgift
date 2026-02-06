use webbshop_db;

insert into brand (name)
values ('Lundhags'),
       ('Meindl'),
       ('Nike'),
       ('Birkenstock'),
       ('Adidas'),
       ('Timberland');

insert into category (name)
values ('Kängor'),
       ('Sneakers'),
       ('Sandaler'),
       ('Löparskor'),
       ('Stövlar'),
       ('Badskor'),
       ('Herrskor'),
       ('Läderskor');


insert into shoe (brand_id, size, color, price, stock)
values ((select id from brand where name = 'Lundhags'), 42, 'Padje Light', 5299.99, 10),
       ((select id from brand where name = 'Lundhags'), 45, 'Padje Light', 5299.99, 7),
       ((select id from brand where name = 'Lundhags'), 39, 'Padje Dark', 5299.99, 10),
       ((select id from brand where name = 'Lundhags'), 42, 'Tived', 3249.99, 2),

       ((select id from brand where name = 'Meindl'), 45, 'Ljusbrun', 1699.00, 4),
       ((select id from brand where name = 'Meindl'), 42, 'Ljusbrun', 1699.00, 2),
       ((select id from brand where name = 'Meindl'), 42, 'Mörkbrun', 3499.00, 6),

       ((select id from brand where name = 'Nike'), 45, 'Neongrön', 2137.00, 2),
       ((select id from brand where name = 'Nike'), 45, 'Rosa och vit', 2137.00, 2),
       ((select id from brand where name = 'Nike'), 45, 'Marinblå', 2137.00, 2),

       ((select id from brand where name = 'Birkenstock'), 45, 'Basalt Grey', 2650.00, 3),
       ((select id from brand where name = 'Birkenstock'), 43, 'Black', 2650.00, 2),
       ((select id from brand where name = 'Birkenstock'), 45, 'Dark Brown', 1100.00, 10),

       ((select id from brand where name = 'Adidas'), 45, 'Blue/White', 389.99, 6),
       ((select id from brand where name = 'Adidas'), 40, 'Beige', 464.00, 8),
       ((select id from brand where name = 'Adidas'), 45, 'Core-black/Off-white', 869.00, 10),

       ((select id from brand where name = 'Timberland'), 41, 'Wheat', 2246.00, 9);


insert into shoecategory (shoe_id, category_id)
select s.id, c.id
from shoe s
         join brand b on s.brand_id = b.id
         join category c on true
where (b.name = 'Lundhags' and c.name = 'Kängor')
   or (b.name = 'Meindl' and c.name = 'Läderskor')
   or (b.name = 'Nike' and c.name = 'Löparskor')
   or (b.name = 'Birkenstock' and c.name = 'Sandaler')
   or (b.name = 'Adidas' and s.price < 500 and c.name = 'Badskor')
   or (b.name = 'Adidas' and s.price = 464.00 and c.name = 'Badskor')
   or (b.name = 'Adidas' and s.price = 869.00 and c.name = 'Sneakers')
   or (b.name = 'Timberland' and c.name = 'Stövlar');