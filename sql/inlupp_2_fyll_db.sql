USE
webbshop_db;

insert into Category (name)
values ('Kängor'),
       ('Sneakers'),
       ('Sandaler'),
       ('Löparskor'),
       ('Stövlar'),
       ('Badskor'),
       ('Herrskor'),
       ('Läderskor');

insert into Shoe (brand, name, colour, size, price, stock)
values ('Lundhags', 'Trekking Boot', 'Padje Light', 42, 5299.99, 10),
       ('Lundhags', 'Trekking Boot', 'Padje Light', 45, 5299.99, 7),
       ('Lundhags', 'Trekking Boot', 'Padje Dark', 39, 5299.99, 10),
       ('Lundhags', 'Trail Boot', 'Tived', 42, 3249.99, 2),
       ('Meindl', 'Capri', 'Ljusbrun', 45, 1699.00, 4),
       ('Meindl', 'Capri', 'Ljusbrun', 42, 1699.00, 2),
       ('Meindl', 'Ascona Identity', 'Mörkbrun', 42, 3499.00, 6),
       ('Nike', 'Alpha Fly 3', 'Neongrön', 45, 2137.00, 2),
       ('Nike', 'Alpha Fly 3', 'Rosa och vit', 45, 2137.00, 2),
       ('Nike', 'Alpha Fly 3', 'Marinblå', 45, 2137.00, 2),
       ('Birkenstock', 'Shinjuku', 'Basalt Grey', 45, 2650.00, 3),
       ('Birkenstock', 'Shinjuku 2 Strap', 'Black', 43, 2650.00, 2),
       ('Birkenstock', 'Arizona', 'Dark Brown', 45, 1100.00, 10),
       ('Adidas', 'Adilette', 'Blue/White', 45, 389.99, 6),
       ('Adidas', 'Adilette Ayoon', 'Beige', 40, 464.00, 8),
       ('Adidas', 'Campus', 'Core-black/Off-white', 45, 869.00, 10),
       ('Timberland', 'Stone street', 'Wheat', 41, 2246.00, 9);

insert into ShoeCategory (shoe_id, category_id)
select s.shoe_id, c.category_id
from Shoe s
         join Category c on true
where (s.brand = 'Lundhags' and c.name = 'Kängor')
   or (s.brand = 'Meindl' and c.name = 'Läderskor')
   or (s.brand = 'Nike' and c.name = 'Löparskor')
   or (s.brand = 'Birkenstock' and c.name = 'Sandaler')
   or (s.brand = 'Adidas' and s.name = 'Adilette' and c.name = 'Badskor')
   or (s.brand = 'Adidas' and s.name = 'Campus' and c.name = 'Sneakers')
   or (s.brand = 'Timberland' and c.name = 'Stövlar');