use webbshop_db;

insert into Brand (name)
values ('Lundhags'),
    ('Meindl'),
    ('Nike'),
    ('Birkenstock'),
    ('Adidas'),
    ('Timberland');

insert into Category (name)
values ('Kängor'),
    ('Sneakers'),
    ('Sandaler'),
    ('Löparskor'),
    ('Stövlar'),
    ('Badskor'),
    ('Herrskor'),
    ('Läderskor');

insert into Shoe (brand_id, name, colour, size, price, stock)
values (
        (
            select brand_id
            from Brand
            where name = 'Lundhags'
        ),
        'Trekking Boot',
        'Padje Light',
        42,
        5299.99,
        10
    ),
    (
        (
            select brand_id
            from Brand
            where name = 'Lundhags'
        ),
        'Trekking Boot',
        'Padje Light',
        45,
        5299.99,
        7
    ),
    (
        (
            select brand_id
            from Brand
            where name = 'Lundhags'
        ),
        'Trekking Boot',
        'Padje Dark',
        39,
        5299.99,
        10
    ),
    (
        (
            select brand_id
            from Brand
            where name = 'Lundhags'
        ),
        'Trail Boot',
        'Tived',
        42,
        3249.99,
        2
    ),
    (
        (
            select brand_id
            from Brand
            where name = 'Meindl'
        ),
        'Capri',
        'Ljusbrun',
        45,
        1699.00,
        4
    ),
    (
        (
            select brand_id
            from Brand
            where name = 'Meindl'
        ),
        'Capri',
        'Ljusbrun',
        42,
        1699.00,
        2
    ),
    (
        (
            select brand_id
            from Brand
            where name = 'Meindl'
        ),
        'Ascona Identity',
        'Mörkbrun',
        42,
        3499.00,
        6
    ),
    (
        (
            select brand_id
            from Brand
            where name = 'Nike'
        ),
        'Alpha Fly 3',
        'Neongrön',
        45,
        2137.00,
        2
    ),
    (
        (
            select brand_id
            from Brand
            where name = 'Nike'
        ),
        'Alpha Fly 3',
        'Rosa och vit',
        45,
        2137.00,
        2
    ),
    (
        (
            select brand_id
            from Brand
            where name = 'Nike'
        ),
        'Alpha Fly 3',
        'Marinblå',
        45,
        2137.00,
        2
    ),
    (
        (
            select brand_id
            from Brand
            where name = 'Birkenstock'
        ),
        'Shinjuku',
        'Basalt Grey',
        45,
        2650.00,
        3
    ),
    (
        (
            select brand_id
            from Brand
            where name = 'Birkenstock'
        ),
        'Shinjuku 2 Strap',
        'Black',
        43,
        2650.00,
        2
    ),
    (
        (
            select brand_id
            from Brand
            where name = 'Birkenstock'
        ),
        'Arizona',
        'Dark Brown',
        45,
        1100.00,
        10
    ),
    (
        (
            select brand_id
            from Brand
            where name = 'Adidas'
        ),
        'Adilette',
        'Blue/White',
        45,
        389.99,
        6
    ),
    (
        (
            select brand_id
            from Brand
            where name = 'Adidas'
        ),
        'Adilette Ayoon',
        'Beige',
        40,
        464.00,
        8
    ),
    (
        (
            select brand_id
            from Brand
            where name = 'Adidas'
        ),
        'Campus',
        'Core-black/Off-white',
        45,
        869.00,
        10
    ),
    (
        (
            select brand_id
            from Brand
            where name = 'Timberland'
        ),
        'Stone street',
        'Wheat',
        41,
        2246.00,
        9
    );

insert into ShoeCategory (shoe_id, category_id)
select s.shoe_id,
    c.category_id
from Shoe s
    join Category c on c.name in ('Herrskor', 'Kängor')
where s.name in ('Trekking Boot', 'Trail Boot');

insert into ShoeCategory (shoe_id, category_id)
select s.shoe_id,
    c.category_id
from Shoe s
    join Category c on c.name in ('Herrskor', 'Läderskor', 'Kängor')
where s.brand_id = (
        select brand_id
        from Brand
        where name = 'Meindl'
    );

insert into ShoeCategory (shoe_id, category_id)
select s.shoe_id,
    c.category_id
from Shoe s
    join Category c on c.name in ('Herrskor', 'Löparskor')
where s.brand_id = (
        select brand_id
        from Brand
        where name = 'Nike'
    );

insert into ShoeCategory (shoe_id, category_id)
select s.shoe_id,
    c.category_id
from Shoe s
    join Category c on c.name in ('Herrskor', 'Sandaler')
where s.brand_id = (
        select brand_id
        from Brand
        where name = 'Birkenstock'
    );

insert into ShoeCategory (shoe_id, category_id)
select s.shoe_id,
    c.category_id
from Shoe s
    join Category c on c.name in ('Herrskor', 'Badskor')
where s.name like 'Adilette%';

insert into ShoeCategory (shoe_id, category_id)
select s.shoe_id,
    c.category_id
from Shoe s
    join Category c on c.name in ('Herrskor', 'Sneakers')
where s.name = 'Campus';

insert into ShoeCategory (shoe_id, category_id)
select s.shoe_id,
    c.category_id
from Shoe s
    join Category c on c.name in ('Herrskor', 'Stövlar')
where s.name = 'Stone street';