USE webbshop_db;

DELIMITER //
CREATE PROCEDURE AddToCart(
    IN in_customer_id INT,
    IN in_shoe_id INT
)
BEGIN
    DECLARE v_order_id INT;
    DECLARE error_msg VARCHAR(200);

    START TRANSACTION;

    -- kollar om kund finns
    IF NOT EXISTS (SELECT 1
                   FROM Customer
                   WHERE id = in_customer_id) THEN
        ROLLBACK;
        SET error_msg = CONCAT(
                'Customer with id: ', in_customer_id,
                ' does not exist. ', NOW()
            );
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = error_msg;
    END IF;

    -- kollar om sko finns
    IF NOT EXISTS (SELECT 1
                   FROM Shoe
                   WHERE id = in_shoe_id) THEN
        ROLLBACK;
        SET error_msg = CONCAT(
                'Shoe with id: ', in_shoe_id,
                ' does not exist. ', NOW()
            );
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = error_msg;
    END IF;

    -- hämta aktiv order eller skapa ny
    SELECT id
    INTO v_order_id
    FROM CustomerOrder
    WHERE customer_id = in_customer_id
      AND status = 'AKTIV'
    LIMIT 1;

    IF v_order_id IS NULL THEN
        INSERT INTO CustomerOrder (customer_id, date)
        VALUES (in_customer_id, CURDATE());
        SET v_order_id = LAST_INSERT_ID();
    END IF;

    -- uppdaterar lager
    UPDATE Shoe
    SET stock = stock - 1
    WHERE id = in_shoe_id
      AND stock > 0;

    IF ROW_COUNT() = 0 THEN
        ROLLBACK;
        SET error_msg = CONCAT(
                'Shoe with id: ', in_shoe_id,
                ' is out of stock. ', NOW()
            );
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = error_msg;
    END IF;

    -- lägger till vara eller ökar quantity
    INSERT INTO OrderItem (order_id, shoe_id, quantity)
    VALUES (v_order_id, in_shoe_id, 1)
    ON DUPLICATE KEY UPDATE quantity = quantity + 1;

    COMMIT;
END//
DELIMITER ;