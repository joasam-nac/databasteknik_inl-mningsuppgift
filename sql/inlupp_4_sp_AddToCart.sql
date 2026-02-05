use Webbshop_Db;

delimiter //
create procedure Addtocart(
    in In_Customer_Id INT,
    in In_Shoe_Id INT
)
begin
    declare V_Order_Id INT;
    declare Error_Msg VARCHAR(200);

    start transaction;

    -- kollar om kund finns
    if not exists (select 1
                   from Customer
                   where Customer_Id = In_Customer_Id) then
        set Error_Msg = concat(
                'Customer with id: ', In_Customer_Id,
                ' does not exist. ', now()
                        );
        signal sqlstate '45000' set message_text = Error_Msg;
    end if;

    -- kollar om sko finns
    if not exists (select 1
                   from Shoe
                   where Shoe_Id = In_Shoe_Id) then
        set Error_Msg = concat(
                'Shoe with id: ', In_Shoe_Id,
                ' does not exist. ', now()
                        );
        signal sqlstate '45000' set message_text = Error_Msg;
    end if;

    -- hämta aktiv order eller skapa ny
    select Order_Id
    into V_Order_Id
    from Customerorder
    where Customer_Id = In_Customer_Id
      and Status = 'AKTIV'
    limit 1;

    if V_Order_Id is null then
        insert into Customerorder (Customer_Id)
        values (In_Customer_Id);
        set V_Order_Id = last_insert_id();
    end if;

    -- uppdaterar lager
    update Shoe
    set Stock = Stock - 1
    where Shoe_Id = In_Shoe_Id
      and Stock > 0;

    if row_count() = 0 then
        rollback;
        set Error_Msg = concat(
                'Shoe with id: ', In_Shoe_Id,
                ' is out of stock. ', now()
                        );
        signal sqlstate '45000' set message_text = Error_Msg;
    end if;

    -- lägger till vara
    insert into Customerorderitem (Order_Id, Shoe_Id, Quantity, Price)
    values (V_Order_Id,
            In_Shoe_Id,
            1,
            (select Price from Shoe where Shoe_Id = In_Shoe_Id))
    on duplicate key update Quantity = Quantity + 1;
    commit;
end//
delimiter ;