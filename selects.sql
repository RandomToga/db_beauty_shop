USE beauty_shop;

-- a. Запрос с соединением таблиц через WHERE
SELECT 
    o.order_id,
    o.order_date,
    CONCAT(u.last_name, ' ', u.first_name) AS customer_name,
    os.status_name,
    pm.payment_method_name,
    o.total_amount
FROM orders o, users u, order_status os, payment_method pm
WHERE o.user_id = u.user_id
  AND o.status_id = os.status_id
  AND o.payment_method_id = pm.payment_method_id;


-- b. Запрос с использованием INNER JOIN
SELECT 
    o.order_id,
    o.order_date,
    CONCAT(u.last_name, ' ', u.first_name) AS customer_name,
    os.status_name,
    pm.payment_method_name,
    o.total_amount
FROM orders o
INNER JOIN users u 
    ON o.user_id = u.user_id
INNER JOIN order_status os 
    ON o.status_id = os.status_id
INNER JOIN payment_method pm 
    ON o.payment_method_id = pm.payment_method_id;


-- c. Запрос с использованием CASE
SELECT
    product_id,
    product_name,
    price,
    CASE
        WHEN price < 1000 THEN 'Недорогой товар'
        WHEN price BETWEEN 1000 AND 5000 THEN 'Средняя ценовая категория'
        ELSE 'Дорогой товар'
    END AS price_category
FROM product;


-- d. Запрос с использованием GROUP BY и HAVING
SELECT
    b.brand_name,
    COUNT(p.product_id) AS product_count,
    ROUND(AVG(p.price), 2) AS average_price
FROM brand b
INNER JOIN product p
    ON b.brand_id = p.brand_id
GROUP BY b.brand_id, b.brand_name
HAVING COUNT(p.product_id) > 1;


-- e. Запрос с использованием LEFT JOIN
SELECT
    pc.category_id,
    pc.category_name,
    ps.subcategory_id,
    ps.subcategory_name
FROM product_category pc
LEFT JOIN product_subcategory ps
    ON pc.category_id = ps.category_id
ORDER BY pc.category_id;


-- f. Запрос с использованием вложенного подзапроса
SELECT
    product_id,
    product_name,
    price,
    stock_quantity
FROM product
WHERE price > (
    SELECT AVG(price)
    FROM product
);


-- g. Создание представления (VIEW)
CREATE VIEW view_orders_info AS
SELECT 
    o.order_id,
    o.order_date,
    CONCAT(u.last_name, ' ', u.first_name) AS customer_name,
    os.status_name,
    pm.payment_method_name,
    o.total_amount
FROM orders o
INNER JOIN users u 
    ON o.user_id = u.user_id
INNER JOIN order_status os 
    ON o.status_id = os.status_id
INNER JOIN payment_method pm 
    ON o.payment_method_id = pm.payment_method_id;
    

SELECT *
FROM view_orders_info;