USE webbshop_db;

-- Brands
INSERT INTO Brand (name)
VALUES ('Lundhags'),
       ('Meindl'),
       ('Nike'),
       ('Birkenstock'),
       ('Adidas'),
       ('Timberland');

-- Categories
INSERT INTO Category (name)
VALUES ('Kängor'),
       ('Sneakers'),
       ('Sandaler'),
       ('Löparskor'),
       ('Stövlar'),
       ('Badskor'),
       ('Herrskor'),
       ('Läderskor');

-- Shoes (note: shoe "name" no longer exists in the schema)
INSERT INTO Shoe (brand_id, size, color, price, stock)
VALUES
  -- Lundhags
  ((SELECT id FROM Brand WHERE name = 'Lundhags'), 42, 'Padje Light', 5299.99, 10),
  ((SELECT id FROM Brand WHERE name = 'Lundhags'), 45, 'Padje Light', 5299.99, 7),
  ((SELECT id FROM Brand WHERE name = 'Lundhags'), 39, 'Padje Dark', 5299.99, 10),
  ((SELECT id FROM Brand WHERE name = 'Lundhags'), 42, 'Tived', 3249.99, 2),
  -- Meindl
  ((SELECT id FROM Brand WHERE name = 'Meindl'), 45, 'Ljusbrun', 1699.00, 4),
  ((SELECT id FROM Brand WHERE name = 'Meindl'), 42, 'Ljusbrun', 1699.00, 2),
  ((SELECT id FROM Brand WHERE name = 'Meindl'), 42, 'Mörkbrun', 3499.00, 6),
  -- Nike
  ((SELECT id FROM Brand WHERE name = 'Nike'), 45, 'Neongrön', 2137.00, 2),
  ((SELECT id FROM Brand WHERE name = 'Nike'), 45, 'Rosa och vit', 2137.00, 2),
  ((SELECT id FROM Brand WHERE name = 'Nike'), 45, 'Marinblå', 2137.00, 2),
  -- Birkenstock
  ((SELECT id FROM Brand WHERE name = 'Birkenstock'), 45, 'Basalt Grey', 2650.00, 3),
  ((SELECT id FROM Brand WHERE name = 'Birkenstock'), 43, 'Black', 2650.00, 2),
  ((SELECT id FROM Brand WHERE name = 'Birkenstock'), 45, 'Dark Brown', 1100.00, 10),
  -- Adidas
  ((SELECT id FROM Brand WHERE name = 'Adidas'), 45, 'Blue/White', 389.99, 6),
  ((SELECT id FROM Brand WHERE name = 'Adidas'), 40, 'Beige', 464.00, 8),
  ((SELECT id FROM Brand WHERE name = 'Adidas'), 45, 'Core-black/Off-white', 869.00, 10),
  -- Timberland
  ((SELECT id FROM Brand WHERE name = 'Timberland'), 41, 'Wheat', 2246.00, 9);

-- ShoeCategory
INSERT INTO ShoeCategory (shoe_id, category_id)
SELECT s.id, c.id
FROM Shoe s
  JOIN Brand b ON s.brand_id = b.id
  JOIN Category c ON TRUE
WHERE (b.name = 'Lundhags' AND c.name = 'Kängor')
   OR (b.name = 'Meindl' AND c.name = 'Läderskor')
   OR (b.name = 'Nike' AND c.name = 'Löparskor')
   OR (b.name = 'Birkenstock' AND c.name = 'Sandaler')
   OR (b.name = 'Adidas' AND s.price < 500 AND c.name = 'Badskor')
   OR (b.name = 'Adidas' AND s.price = 464.00 AND c.name = 'Badskor')
   OR (b.name = 'Adidas' AND s.price = 869.00 AND c.name = 'Sneakers')
   OR (b.name = 'Timberland' AND c.name = 'Stövlar');