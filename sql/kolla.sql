use Webbshop_Db;

select count(*)
        from orderitem o
        where o.order_id = 2;