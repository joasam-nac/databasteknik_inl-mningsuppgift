DELIMITER //

CREATE PROCEDURE AddToCart(
  IN in_customer_id INT,
  IN in_order_id INT,
  IN in_shoe_id INT
)
BEGIN
  DECLARE v_order_id INT;

  START TRANSACTION;

  -- kollar om kund finns
  IF NOT EXISTS (
    SELECT 1 FROM Customer WHERE customer_id = in_customer_id
  ) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = concat('Kund med id: ', in_customer_id, ' finns inte! ', now());
  END IF;

  -- kollar om sko finns
  IF NOT EXISTS (
    SELECT 1 FROM Shoe WHERE shoe_id = in_shoe_id
  ) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = concat('Skon med id: ', in_shoe_id, ' finns inte! ', now());
  END IF;

  -- kollar om ordern är aktiv
  IF in_order_id IS NOT NULL AND EXISTS (
    SELECT 1
    FROM CustomerOrder
    WHERE order_id = in_order_id
      AND customer_id = in_customer_id
      AND status = 'AKTIV'
  ) THEN
    SET v_order_id = in_order_id;
  ELSE
    -- "byter" till en annan aktiv order
    SELECT order_id
      INTO v_order_id
      FROM CustomerOrder
      WHERE customer_id = in_customer_id
        AND status = 'AKTIV'
      ORDER BY order_id DESC
      LIMIT 1;

    -- skapar en ny order som sista utväg
    IF v_order_id IS NULL THEN
      INSERT INTO CustomerOrder (customer_id)
      VALUES (in_customer_id);
      SET v_order_id = LAST_INSERT_ID();
    END IF;
  END IF;

  -- uppdaterar lager
  UPDATE Shoe
     SET stock = stock - 1
   WHERE shoe_id = in_shoe_id
     AND stock > 0;

  IF ROW_COUNT() = 0 THEN
    ROLLBACK;
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = concat('Skon med id: ', in_shoe_id, ' är ej i lager');
  END IF;

  -- lägger till vara
  INSERT INTO CustomerOrderItem (order_id, shoe_id, quantity, price)
  VALUES (
    v_order_id,
    in_shoe_id,
    1,
    (SELECT price FROM Shoe WHERE shoe_id = in_shoe_id)
  )
  -- i fall bordet redan finns
  ON DUPLICATE KEY UPDATE
    quantity = quantity + 1;

  COMMIT;
END//

DELIMITER ;