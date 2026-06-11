USE beauty_shop;

-- триггер 1. Уменьшение остатка товара на складе
DELIMITER //
USE beauty_shop;
DROP TRIGGER IF EXISTS decrease_stock;
DELIMITER //
CREATE TRIGGER decrease_stock
AFTER INSERT ON order_item
FOR EACH ROW
BEGIN
UPDATE product
SET stock_quantity = stock_quantity - NEW.product_quantity
WHERE product_id = NEW.product_id;
END//
DELIMITER ;

-- тест
INSERT INTO orders (order_id, total_amount, user_id, status_id, payment_method_id, delivery_address_id)
VALUES (8, 12500.00, 2, 1, 1, 2); -- создала чтоб не нарушать логику (нельзя добавлять уже к созданным заказам)

INSERT INTO order_item (order_item_id, order_id, product_id, product_quantity, product_price_at_order)
VALUES (11, 8, 1, 1, 12500.00); -- после этого insert сработает триггер


-- триггер 2. Обновление даты изменения корзины
DELIMITER //
CREATE TRIGGER update_cart_date
AFTER INSERT ON cart_item
FOR EACH ROW
BEGIN
UPDATE cart
SET update_date = CURRENT_TIMESTAMP
WHERE cart_id = NEW.cart_id;
END//

DELIMITER ;


-- тест
INSERT INTO cart_item (cart_id, product_id, product_quantity)
VALUES (2, 4, 1);
