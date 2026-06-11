USE beauty_shop;

-- процедура 1. оформление заказа из корзины
-- DROP PROCEDURE create_order_from_cart;

DELIMITER //

CREATE PROCEDURE create_order_from_cart (
    IN p_user_id INT, -- p_ - parameter, переданное значение
    IN p_delivery_address_id INT,
    IN p_payment_method_id INT
)
BEGIN
    DECLARE v_cart_id INT; -- v_ - variable, значение использующееся внутри процедуры
    DECLARE v_new_order_id INT;
    DECLARE v_total_amount DECIMAL(10,2);

    SELECT cart_id -- находим корзину пользователя
    INTO v_cart_id
    FROM cart
    WHERE user_id = p_user_id;
    
    SELECT MAX(order_id) + 1 -- создаем номер заказа
	INTO v_new_order_id
	FROM orders;

    SELECT SUM(ci.product_quantity * p.price) -- считаем общую сумму заказа
    INTO v_total_amount
    FROM cart_item ci
    INNER JOIN product p
        ON ci.product_id = p.product_id
    WHERE ci.cart_id = v_cart_id;

    INSERT INTO orders ( -- вставляем в таблицу заказов
		order_id,
        order_date,
        total_amount,
        user_id,
        status_id,
        payment_method_id,
        delivery_address_id
    )
    VALUES (
		v_new_order_id,
        CURRENT_TIMESTAMP,
        v_total_amount,
        p_user_id,
        1,
        p_payment_method_id,
        p_delivery_address_id
    );

    INSERT INTO order_item ( -- вставляем в таблицу позиции заказа
        order_id,
        product_id,
        product_quantity,
        product_price_at_order
    )
    SELECT
        v_new_order_id,
        ci.product_id,
        ci.product_quantity,
        p.price
    FROM cart_item ci
    INNER JOIN product p
        ON ci.product_id = p.product_id
    WHERE ci.cart_id = v_cart_id;

    DELETE FROM cart_item
    WHERE cart_id = v_cart_id;

    UPDATE cart
    SET update_date = CURRENT_TIMESTAMP
    WHERE cart_id = v_cart_id;

    SELECT 
        v_new_order_id AS created_order_id,
        v_total_amount AS total_amount,
        'Заказ успешно оформлен' AS result_message;
END//

DELIMITER ;

-- тест
CALL create_order_from_cart(1, 1, 1);


-- процедура 2. просмотр заказов пользователя

DELIMITER //

CREATE PROCEDURE show_user_orders (
    IN p_user_id INT
)
BEGIN
    SELECT
        o.order_id,
        o.order_date,
        CONCAT(u.last_name, ' ', u.first_name) AS customer_name,
        os.status_name,
        pm.payment_method_name,
        CONCAT(
            da.city, ', ', 
            da.street, ', д. ', 
            da.house,
            IFNULL(CONCAT(', кв. ', da.apartment), '')
        ) AS delivery_address,
        o.total_amount
    FROM orders o
    INNER JOIN users u
        ON o.user_id = u.user_id
    INNER JOIN order_status os
        ON o.status_id = os.status_id
    INNER JOIN payment_method pm
        ON o.payment_method_id = pm.payment_method_id
    INNER JOIN delivery_address da
        ON o.delivery_address_id = da.address_id
    WHERE o.user_id = p_user_id
    ORDER BY o.order_date DESC;
END//

DELIMITER ;

-- тест
CALL show_user_orders(1);
