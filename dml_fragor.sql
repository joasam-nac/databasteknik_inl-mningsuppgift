use webbshop_db;

-- kunder som köpt ett visst märke och storlek
select distinct cu.customer_id,
  cu.name,
  cu.surname
from customer cu
  join customerorder co on co.customer_id = cu.customer_id
  join customerorderitem coi on coi.order_id = co.order_id
  join shoe s on s.shoe_id = coi.shoe_id
  join brand b on b.brand_id = s.brand_id
where co.status = 'payed'
  and b.name = 'Birkenstock'
  and s.size = 45;

-- antal skor per kategori
select c.name as category,
  sum(coi.quantity) as shoes_sold
from customerorder co
  join customerorderitem coi on coi.order_id = co.order_id
  join shoecategory sc on sc.shoe_id = coi.shoe_id
  join category c on c.category_id = sc.category_id
where co.status = 'payed'
group by c.category_id,
  c.name
order by shoes_sold desc,
  c.name;

-- pengar spenderat per användare
drop table if exists customerdata;

create table customerdata as
select cu.customer_id,
  cu.name,
  cu.surname,
  coalesce(sum(coi.quantity * coi.price), 0) as total_spent
from customer cu
  left join customerorder co on co.customer_id = cu.customer_id
  and co.status = 'payed'
  left join customerorderitem coi on coi.order_id = co.order_id
group by cu.customer_id,
  cu.name,
  cu.surname;

select *
from customerdata
order by total_spent desc,
  surname,
  name;

-- pengar från varje stad
select cu.city,
  coalesce(sum(coi.quantity * coi.price), 0) as total_spent
from customer cu
  left join customerorder co on co.customer_id = cu.customer_id
  and co.status = 'payed'
  left join customerorderitem coi on coi.order_id = co.order_id
group by cu.city
order by total_spent desc,
  cu.city;

-- alla städer som spenderat mer än 2000
select cu.city,
  sum(coi.quantity * coi.price) as total_spent
from customer cu
  join customerorder co on co.customer_id = cu.customer_id
  and co.status = 'payed'
  join customerorderitem coi on coi.order_id = co.order_id
group by cu.city
having sum(coi.quantity * coi.price) > 2000
order by total_spent desc,
  cu.city;

-- topp 5 skor
select s.shoe_id,
  b.name as brand,
  s.name as shoe_name,
  s.colour,
  s.size,
  sum(coi.quantity) as units_sold
from customerorder co
  join customerorderitem coi on coi.order_id = co.order_id
  join shoe s on s.shoe_id = coi.shoe_id
  join brand b on b.brand_id = s.brand_id
where co.status = 'payed'
group by s.shoe_id,
  b.name,
  s.name,
  s.colour,
  s.size
order by units_sold desc,
  s.shoe_id
limit 5;

-- bästa månaden
select year(co.order_date) as year,
  month(co.order_date) as month,
  sum(coi.quantity) as units_sold
from customerorder co
  join customerorderitem coi on coi.order_id = co.order_id
where co.status = 'payed'
group by year(co.order_date),
  month(co.order_date)
order by units_sold desc,
  year desc,
  month desc
limit 1;