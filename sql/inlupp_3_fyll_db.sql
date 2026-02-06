USE webbshop_db;

-- Customers
INSERT INTO Customer (name, username, password, city, address)
VALUES ('Joakim Samuelsson', 'joasam', '12345', 'Uppsala', 'Gatuvägen 1'),
       ('Leif GW Perssson', 'gw', 'bulle1', 'Stockholm', 'Gatuvägen 2'),
       ('Alfred Nobel', 'af96', 'dynamit', 'Italien', 'Gatuvägen 3'),
       ('Test Testsson', 'tete', 'tete', 'Stockholm', 'Gatuvägen 4'),
       ('Mikaoj Nossleumas', 'masoaj', '54321', 'Stockholm', 'Gatuvägen 5');

-- Orders
INSERT INTO CustomerOrder (customer_id, status, date)
VALUES ((SELECT id FROM Customer WHERE username = 'joasam'),
        'BETALD', '2026-01-30'),
       ((SELECT id FROM Customer WHERE username = 'joasam'),
        'AKTIV', '2026-01-29'),
       ((SELECT id FROM Customer WHERE username = 'gw'),
        'BETALD', '2026-01-30'),
       ((SELECT id FROM Customer WHERE username = 'af96'),
        'BETALD', '2026-01-28'),
       ((SELECT id FROM Customer WHERE username = 'tete'),
        'AKTIV', '2026-01-30'),
       ((SELECT id FROM Customer WHERE username = 'masoaj'),
        'BETALD', '2026-01-29');

-- joasam BETALD order: 2 items
INSERT INTO OrderItem (order_id, shoe_id, quantity)
SELECT o.id, s.id, x.quantity
FROM (
  SELECT (SELECT o2.id FROM CustomerOrder o2
          JOIN Customer c ON c.id = o2.customer_id
          WHERE c.username = 'joasam' AND o2.status = 'BETALD'
          ORDER BY o2.date ASC LIMIT 1) AS order_id,
         'Lundhags' AS brand, 42.0 AS size, 'Padje Light' AS color, 1 AS quantity
  UNION ALL
  SELECT (SELECT o2.id FROM CustomerOrder o2
          JOIN Customer c ON c.id = o2.customer_id
          WHERE c.username = 'joasam' AND o2.status = 'BETALD'
          ORDER BY o2.date ASC LIMIT 1),
         'Adidas', 45.0, 'Blue/White', 2
) x
JOIN CustomerOrder o ON o.id = x.order_id
JOIN Shoe s ON s.size = x.size AND s.color = x.color
JOIN Brand b ON b.id = s.brand_id AND b.name = x.brand;

-- joasam AKTIV order: 2 items
INSERT INTO OrderItem (order_id, shoe_id, quantity)
SELECT o.id, s.id, x.quantity
FROM (
  SELECT (SELECT o2.id FROM CustomerOrder o2
          JOIN Customer c ON c.id = o2.customer_id
          WHERE c.username = 'joasam' AND o2.status = 'AKTIV'
          LIMIT 1) AS order_id,
         'Adidas' AS brand, 45.0 AS size, 'Core-black/Off-white' AS color, 1 AS quantity
  UNION ALL
  SELECT (SELECT o2.id FROM CustomerOrder o2
          JOIN Customer c ON c.id = o2.customer_id
          WHERE c.username = 'joasam' AND o2.status = 'AKTIV'
          LIMIT 1),
         'Nike', 45.0, 'Marinblå', 1
) x
JOIN CustomerOrder o ON o.id = x.order_id
JOIN Shoe s ON s.size = x.size AND s.color = x.color
JOIN Brand b ON b.id = s.brand_id AND b.name = x.brand;

-- gw BETALD order: 2 items
INSERT INTO OrderItem (order_id, shoe_id, quantity)
SELECT o.id, s.id, x.quantity
FROM (
  SELECT (SELECT o2.id FROM CustomerOrder o2
          JOIN Customer c ON c.id = o2.customer_id
          WHERE c.username = 'gw' AND o2.status = 'BETALD'
          LIMIT 1) AS order_id,
         'Meindl' AS brand, 45.0 AS size, 'Ljusbrun' AS color, 1 AS quantity
  UNION ALL
  SELECT (SELECT o2.id FROM CustomerOrder o2
          JOIN Customer c ON c.id = o2.customer_id
          WHERE c.username = 'gw' AND o2.status = 'BETALD'
          LIMIT 1),
         'Birkenstock', 45.0, 'Dark Brown', 1
) x
JOIN CustomerOrder o ON o.id = x.order_id
JOIN Shoe s ON s.size = x.size AND s.color = x.color
JOIN Brand b ON b.id = s.brand_id AND b.name = x.brand;

-- af96 BETALD order: 1 item
INSERT INTO OrderItem (order_id, shoe_id, quantity)
SELECT o.id, s.id, 1
FROM CustomerOrder o
JOIN Customer cu ON cu.id = o.customer_id
JOIN Shoe s ON s.size = 45.0 AND s.color = 'Basalt Grey'
JOIN Brand b ON b.id = s.brand_id AND b.name = 'Birkenstock'
WHERE cu.username = 'af96'
  AND o.status = 'BETALD'
LIMIT 1;

-- tete AKTIV order: 1 item
INSERT INTO OrderItem (order_id, shoe_id, quantity)
SELECT o.id, s.id, 1
FROM CustomerOrder o
JOIN Customer cu ON cu.id = o.customer_id
JOIN Shoe s ON s.size = 41.0 AND s.color = 'Wheat'
JOIN Brand b ON b.id = s.brand_id AND b.name = 'Timberland'
WHERE cu.username = 'tete'
  AND o.status = 'AKTIV'
LIMIT 1;

-- masoaj BETALD order: 2 items
INSERT INTO OrderItem (order_id, shoe_id, quantity)
SELECT o.id, s.id, x.quantity
FROM (
  SELECT (SELECT o2.id FROM CustomerOrder o2
          JOIN Customer c ON c.id = o2.customer_id
          WHERE c.username = 'masoaj' AND o2.status = 'BETALD'
          LIMIT 1) AS order_id,
         'Adidas' AS brand, 40.0 AS size, 'Beige' AS color, 1 AS quantity
  UNION ALL
  SELECT (SELECT o2.id FROM CustomerOrder o2
          JOIN Customer c ON c.id = o2.customer_id
          WHERE c.username = 'masoaj' AND o2.status = 'BETALD'
          LIMIT 1),
         'Lundhags', 42.0, 'Tived', 1
) x
JOIN CustomerOrder o ON o.id = x.order_id
JOIN Shoe s ON s.size = x.size AND s.color = x.color
JOIN Brand b ON b.id = s.brand_id AND b.name = x.brand;