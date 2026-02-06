use webbshop_db;

delimiter //

create procedure addtocart(in in_customer_id int, in in_shoe_id int)
begin
    declare var_cust_id int default null;
    declare v_customer_exists int default null;
    declare shoe_exists int default null;
    declare error_msg varchar(200);

    start transaction;

    -- hitta customer
    select 1
    into v_customer_exists
    from customer
    where id = in_customer_id
    limit 1;

    if v_customer_exists is null then
        rollback;
        set error_msg = concat(
                'Customer with id: ',
                in_customer_id,
                ' does not exist. ',
                now()
                        );
        signal sqlstate '45000' set message_text = error_msg;
    end if;

    -- hitta sko
    select 1
    into shoe_exists
    from shoe
    where id = in_shoe_id
    limit 1;

    if shoe_exists is null then
        rollback;
        set error_msg = concat(
                'Shoe with id: ',
                in_shoe_id,
                ' does not exist. ',
                now()
                        );
        signal sqlstate '45000' set message_text = error_msg;
    end if;

    -- hitta order annars skapa order
    select id
    into var_cust_id
    from customerorder
    where customer_id = in_customer_id
      and status = 'AKTIV'
    limit 1;

    if var_cust_id is null then
        insert into customerorder (customer_id, created_at, status)
        values (in_customer_id, now(), 'AKTIV');
        set var_cust_id = last_insert_id();
    end if;

    -- uppdatera lager
    update shoe
    set stock = stock - 1
    where id = in_shoe_id
      and stock > 0;

    if row_count() = 0 then
        rollback;
        set error_msg = concat(
                'Shoe with id: ',
                in_shoe_id,
                ' is out of stock. ',
                now()
                        );
        signal sqlstate '45000' set message_text = error_msg;
    end if;

    -- öka eller lägga till vara
    insert into orderitem (order_id, shoe_id, quantity)
    values (var_cust_id, in_shoe_id, 1)
    on duplicate key update quantity = quantity + 1;
    commit;
end//

delimiter ;