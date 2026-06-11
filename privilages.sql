USE beauty_shop;

-- Создание обычного пользователя
CREATE USER 'beauty_user'@'localhost' IDENTIFIED BY 'User_12345';


-- Выдача прав обычному пользователю
-- Обычный пользователь может просматривать данные, добавлять заказы, позиции заказов, адреса доставки и товары в корзину
GRANT SELECT ON beauty_shop.product TO 'beauty_user'@'localhost';
GRANT SELECT ON beauty_shop.product_category TO 'beauty_user'@'localhost';
GRANT SELECT ON beauty_shop.product_subcategory TO 'beauty_user'@'localhost';
GRANT SELECT ON beauty_shop.brand TO 'beauty_user'@'localhost';
GRANT SELECT ON beauty_shop.order_status TO 'beauty_user'@'localhost';
GRANT SELECT ON beauty_shop.payment_method TO 'beauty_user'@'localhost';

GRANT SELECT, INSERT, UPDATE, DELETE ON beauty_shop.cart TO 'beauty_user'@'localhost';
GRANT SELECT, INSERT, UPDATE, DELETE ON beauty_shop.cart_item TO 'beauty_user'@'localhost';
GRANT SELECT, INSERT ON beauty_shop.orders TO 'beauty_user'@'localhost';
GRANT SELECT, INSERT ON beauty_shop.order_item TO 'beauty_user'@'localhost';
GRANT SELECT, INSERT, UPDATE ON beauty_shop.delivery_address TO 'beauty_user'@'localhost';

-- Разрешение пользователю вызывать хранимые процедуры
GRANT EXECUTE ON PROCEDURE beauty_shop.create_order_from_cart TO 'beauty_user'@'localhost';
GRANT EXECUTE ON PROCEDURE beauty_shop.show_user_orders TO 'beauty_user'@'localhost';

-- Создание администратора магазина
CREATE USER 'beauty_admin'@'localhost' IDENTIFIED BY 'Admin_12345';

-- Выдача прав администратору
-- Администратор получает полный доступ ко всем объектам базы данных beauty_shop
GRANT ALL PRIVILEGES ON beauty_shop.* TO 'beauty_admin'@'localhost';


-- Применение изменений
FLUSH PRIVILEGES;


-- Просмотр прав обычного пользователя
SHOW GRANTS FOR 'beauty_user'@'localhost';

-- Просмотр прав администратора
SHOW GRANTS FOR 'beauty_admin'@'localhost';

