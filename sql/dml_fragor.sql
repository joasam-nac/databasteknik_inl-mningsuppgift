USE
webbshop_db;

-- kunder som köpt ett visst märke och storlek
SELECT DISTINCT cu.id, cu.name
FROM Customer cu
         JOIN CustomerOrder co ON co.customer_id = cu.id
         JOIN OrderItem oi ON oi.order_id = co.id
         JOIN Shoe s ON s.id = oi.shoe_id
         JOIN Brand b ON b.id = s.brand_id
WHERE co.status = 'BETALD'
  AND b.name = 'Birkenstock'
  AND s.size = 45;

-- antal skor per kategori
SELECT c.name AS category, SUM(oi.quantity) AS shoes_sold
FROM CustomerOrder co
         JOIN OrderItem oi ON oi.order_id = co.id
         JOIN Shoe s ON s.id = oi.shoe_id
         JOIN ShoeCategory sc ON sc.shoe_id = s.id
         JOIN Category c ON c.id = sc.category_id
WHERE co.status = 'BETALD'
GROUP BY c.id, c.name
ORDER BY shoes_sold DESC, c.name;

-- pengar spenderat per användare (price lives on Shoe now, not OrderItem)
DROP TABLE IF EXISTS customerdata;

CREATE TABLE customerdata AS
SELECT cu.id, cu.name, COALESCE(SUM(oi.quantity * s.price), 0) AS total_spent
FROM Customer cu
         LEFT JOIN CustomerOrder co ON co.customer_id = cu.id AND co.status = 'BETALD'
         LEFT JOIN OrderItem oi ON oi.order_id = co.id
         LEFT JOIN Shoe s ON s.id = oi.shoe_id
GROUP BY cu.id, cu.name;

SELECT *
FROM customerdata
ORDER BY total_spent DESC, name;

-- pengar från varje stad
SELECT cu.city, COALESCE(SUM(oi.quantity * s.price), 0) AS total_spent
FROM Customer cu
         LEFT JOIN CustomerOrder co ON co.customer_id = cu.id AND co.status = 'BETALD'
         LEFT JOIN OrderItem oi ON oi.order_id = co.id
         LEFT JOIN Shoe s ON s.id = oi.shoe_id
GROUP BY cu.city
ORDER BY total_spent DESC, cu.city;

-- alla städer som spenderat mer än 2000
SELECT cu.city, SUM(oi.quantity * s.price) AS total_spent
FROM Customer cu
         JOIN CustomerOrder co ON co.customer_id = cu.id AND co.status = 'BETALD'
         JOIN OrderItem oi ON oi.order_id = co.id
         JOIN Shoe s ON s.id = oi.shoe_id
GROUP BY cu.city
HAVING SUM(oi.quantity * s.price) > 2000
ORDER BY total_spent DESC, cu.city;

-- topp 5 skor
SELECT s.id, b.name AS brand, s.color, s.size, SUM(oi.quantity) AS units_sold
FROM CustomerOrder co
         JOIN OrderItem oi ON oi.order_id = co.id
         JOIN Shoe s ON s.id = oi.shoe_id
         JOIN Brand b ON b.id = s.brand_id
WHERE co.status = 'BETALD'
GROUP BY s.id, b.name, s.color, s.size
ORDER BY units_sold DESC, s.id LIMIT 5;

-- bästa månaden
SELECT YEAR (co.date) AS year, MONTH (co.date) AS month, SUM (oi.quantity) AS units_sold
FROM CustomerOrder co
    JOIN OrderItem oi
ON oi.order_id = co.id
WHERE co.status = 'BETALD'
GROUP BY YEAR (co.date), MONTH (co.date)
ORDER BY units_sold DESC, year DESC, month DESC
    LIMIT 1;