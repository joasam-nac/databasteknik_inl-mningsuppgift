use webbshop_db;

delimiter //

create procedure getactivecart(in in_customer_id int)
begin
    declare get_order_id int;


    SELECT co.id INTO get_order_id
    FROM customerorder co
    WHERE co.customer_id = in_customer_id AND co.status = 'AKTIV'
    ORDER BY co.id DESC
    LIMIT 1;

    -- fixar en ny order om ingen aktiv kassa finns
    IF get_order_id IS NULL THEN
        INSERT INTO customerorder (customer_id) VALUES (in_customer_id);
        SET get_order_id = LAST_INSERT_ID();
    END IF;

    -- ger åtminstone tillbaka order_id så det blir simpelt på javasidan
    SELECT
        get_order_id AS order_id,
        s.id AS shoe_id,
        b.name AS brand_name,
        s.name AS shoe_name,
        s.size,
        s.colour,
        s.price,
        o.quantity
    FROM customerorder co
             LEFT JOIN orderitem o ON o.order_id = co.id
             LEFT JOIN shoe s ON s.id = o.shoe_id
             LEFT JOIN brand b ON b.id = s.brand_id
    WHERE co.id = get_order_id
    ORDER BY o.id;
end //

delimiter ;

delimiter $$
create procedure checkout(in in_customer int)
    begin
        declare get_order_id int;
        declare get_item_count int default 0;
        declare get_insufficient int default 0;
        declare error_msg varchar(200) default 'Checkout failed.';

        declare exit handler for sqlstate '45000'
            begin
                rollback;
                signal sqlstate '45000' set message_text = error_msg;
            end;

        start transaction;

        -- letar efter aktiv order
        select c.id
            into get_order_id
        from customerorder c
        where c.customer_id = in_customer and c.status = 'AKTIV'
        order by c.id
        limit 1;

        if get_order_id is null then
            rollback;
            set error_msg = 'No cart found.';
            signal sqlstate '45000' set message_text = error_msg;
        end if;

        -- kollar om ordern är tom
        select count(*)
            into get_item_count
        from orderitem o
        where o.order_id = get_order_id;

        if get_item_count = 0 then
            rollback;
            set error_msg = 'Cart has no items.';
            signal sqlstate '45000' set message_text = error_msg;
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
            set error_msg = 'Not enough stock for this order';
            signal sqlstate '45000' set message_text = error_msg;
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

delimiter //
create procedure createuser(in in_name varchar(100), in in_username varchar(100), in in_city varchar(100), in in_address varchar(100), in in_password varchar(100))
begin
    declare user_exists int default 0;
    declare error_msg varchar(200) default 'Failed to create new user.';

    declare exit handler for sqlstate '45000'
        begin
            rollback;
            signal sqlstate '45000' set message_text = error_msg;
        end;

    start transaction;

    -- kollar om användarnamn finns
    select count(*)
        into user_exists
    from customer c
    where c.username = in_username
    for update;

    if user_exists > 0 then
        rollback;
        set error_msg = 'Username already exists';
        signal sqlstate '45000' set message_text = error_msg;
    end if;

    -- skapa användare
    insert into customer(name, username, city, address, password) values
                                                                      (in_name, in_username, in_city, in_address, in_password);
    commit;

    select last_insert_id() as customer_id;
end //
delimiter ;