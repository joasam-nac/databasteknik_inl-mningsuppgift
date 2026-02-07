use webbshop_db;

delimiter //

create procedure getactivecart(in in_customer_id int)
begin
    declare get_order_id int;

    select t_customer.id
        into get_order_id
    from customerorder t_customer
    where t_customer.customer_id = in_customer_id and t_customer.status = 'AKTIV'
    order by t_customer.id
    limit 1;

    -- fixar en ny order om ingen aktiv kassa finns
    if get_order_id is null then
        insert into customerorder (customer_id, created_at, status)
            values (in_customer_id, now(), 'AKTIV');
        set get_order_id = last_insert_id();
    end if;

    select
        get_order_id as order_id,
        s.id as shoe_id,
        b.name as brand,
        s.size, s.colour, s.price, o.quantity
    from orderitem o
        join shoe s on s.id = o.shoe_id
        join brand b on b.id = s.brand_id
    where o.order_id = get_order_id
    order by o.id;
end //

delimiter ;

delimiter $$
create procedure checkout(in in_customer_int int)
    begin
        declare get_order_id int;
        declare get_item_count int default 0;
        declare get_insufficient int default 0;

        declare exit handler for sqlexception
            begin
                rollback;
                signal sqlstate '45000' set message_text = 'Checkout failed.';
            end;

        start transaction;

        -- letar efter aktiv order
        select c.id
            into get_order_id
        from customerorder c
        where c.customer_id = in_customer_int and c.status = 'AKTIV'
        order by c.id
        limit 1;

        if get_order_id is null then
            rollback;
            signal sqlstate '45000' set message_text = 'No cart found.';
        end if;

        -- kollar om ordern är tom
        select count(*)
            into get_item_count
        from orderitem o
        where o.order_id = get_order_id;

        if get_item_count = 0 then
            rollback;
            signal sqlstate '45000' set message_text = 'Cart has no items.';
        end if;

        -- kollar med lagret
        select count(*)
            into get_insufficient
        from orderitem o
        join shoe s on s.id = o.shoe_id
        where o.order_id = get_order_id and s.stock < o.quantity
        for update;

        if get_insufficient > 0 then
            rollback;
            signal sqlstate '45000' set message_text = 'Not enough stock for this order';
        end if;

        -- uppdaterar lager
        update shoe s
            join orderitem o on o.shoe_id = s.id
        set s.stock = s.stock - o.quantity
        where o.order_id = get_order_id;

        -- gör ordern betald
        update customerorder c
        set c.status = 'BETALD'
        where c.id = get_order_id;

        commit;
    end $$
delimiter ;