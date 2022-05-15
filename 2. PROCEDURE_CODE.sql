DELIMITER //


CREATE PROCEDURE CHANGE_PRICE(item_id INT, change_discount_rate INT, change_price INT)
BEGIN
	DECLARE original_discount_rate INT;
	DECLARE new_score INT;
        
	SET original_discount_rate = (SELECT discount_rate
		FROM ITEM_DISCOUNT
		WHERE item_index = item_id);
    
	SET new_score = (SELECT score
		FROM SCORE
		WHERE item_index = item_id);
	SET new_score = new_score - original_discount_rate + change_discount_rate;

	UPDATE ITEM_DISCOUNT
	SET discount_rate = change_discount_rate, discount_price = change_price
	WHERE item_index = item_id;
    
	UPDATE SCORE
	SET discount_rate = change_discount_rate, score = new_score
	WHERE item_index = item_id;
END//


CREATE PROCEDURE CHANGE_ITEM_COUNT(item_id INT, change_item_count INT)
BEGIN
	UPDATE ITEM_COUNT
	SET item_count = change_item_count
	WHERE item_index = item_id;
END//


CREATE PROCEDURE GET_CUSTOMER_CLICK(customer_id INT, item_id INT)
BEGIN
	DECLARE new_click_number INT;
    DECLARE new_score INT;

    SET new_click_number = (SELECT click_number
		FROM SCORE
        WHERE item_index = item_id);
    SET new_click_number = new_click_number + 1;
    
	SET new_score = (SELECT score
		FROM SCORE
        WHERE item_index = item_id);
    SET new_score = new_score + 1;
    
    UPDATE SCORE
	SET click_number = new_click_number, score = new_score
    WHERE item_index = item_id;
END//


CREATE PROCEDURE GET_CUSTOMER_BUY(customer_id INT, item_id INT)
BEGIN
	DECLARE new_item_count INT;
	DECLARE new_buy_number INT;
    DECLARE new_score INT;

	SET new_item_count = (SELECT item_count
		FROM ITEM_COUNT
        WHERE item_index = item_id);
	
    IF (new_item_count > 0)
    THEN 
		SET new_item_count = new_item_count - 1;

		SET new_buy_number = (SELECT buy_number
			FROM SCORE
			WHERE item_index = item_id);
		SET new_buy_number = new_buy_number + 1;
		
		SET new_score = (SELECT score
			FROM SCORE
			WHERE item_index = item_id);
		SET new_score = new_score + 10;
		
        UPDATE ITEM_COUNT
        SET item_count = new_item_count
        WHERE item_index = item_id;
        
		UPDATE SCORE
		SET buy_number = new_buy_number, score = new_score
		WHERE item_index = item_id;
        
        INSERT INTO ITEM_BUY_INFO VALUES(customer_id, item_id);
	END IF;
END//


DELIMITER ;