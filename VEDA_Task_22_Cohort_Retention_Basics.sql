USE veda_task22;

DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS customers;

CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    signup_date DATE
);

CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);
INSERT INTO customers (customer_id, signup_date) VALUES
(1, '2026-01-10'),
(2, '2026-01-15'),
(3, '2026-02-05'),
(4, '2026-02-20'),
(5, '2026-03-01');
INSERT INTO orders (order_id, customer_id, order_date) VALUES
(101, 1, '2026-01-12'),
(102, 1, '2026-02-10'),
(103, 2, '2026-01-20'),
(104, 2, '2026-03-05'),
(105, 3, '2026-02-15'),
(106, 3, '2026-03-10'),
(107, 3, '2026-03-20'),
(108, 4, '2026-02-25'),
(109, 5, '2026-03-15'),
(110, 5, '2026-03-25');
SELECT * FROM customers;
SELECT * FROM orders;
SELECT
    c.customer_id,
    DATE_FORMAT(c.signup_date, '%Y-%m') AS signup_month,
    COUNT(DISTINCT o.order_id) AS order_count
FROM customers c
LEFT JOIN orders o
    ON c.customer_id = o.customer_id
GROUP BY c.customer_id, signup_month
ORDER BY signup_month, c.customer_id;
SELECT
    DATE_FORMAT(c.signup_date, '%Y-%m') AS signup_month,
    COUNT(DISTINCT c.customer_id) AS customers,
    COUNT(DISTINCT o.customer_id) AS customers_with_orders,
    ROUND(
        COUNT(DISTINCT o.customer_id) * 100.0 /
        COUNT(DISTINCT c.customer_id), 2
    ) AS retention_percent
FROM customers c
LEFT JOIN orders o
    ON c.customer_id = o.customer_id
GROUP BY signup_month
ORDER BY signup_month;
SELECT
    DATE_FORMAT(c.signup_date, '%Y-%m') AS signup_month,
    DATE_FORMAT(o.order_date, '%Y-%m') AS order_month,
    COUNT(DISTINCT c.customer_id) AS customers
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
GROUP BY signup_month, order_month
ORDER BY signup_month, order_month;
SELECT
    DATE_FORMAT(c.signup_date, '%Y-%m') AS signup_month,
    COUNT(DISTINCT c.customer_id) AS total_customers,
    COUNT(DISTINCT CASE
        WHEN o.order_date >= c.signup_date
        THEN o.customer_id
    END) AS retained_customers,
    ROUND(
        COUNT(DISTINCT CASE
            WHEN o.order_date >= c.signup_date
            THEN o.customer_id
        END) * 100.0
        / COUNT(DISTINCT c.customer_id), 2
    ) AS retention_percent
FROM customers c
LEFT JOIN orders o
    ON c.customer_id = o.customer_id
GROUP BY signup_month
ORDER BY signup_month;
SELECT
    DATE_FORMAT(c.signup_date, '%Y-%m') AS signup_month,
    DATE_FORMAT(o.order_date, '%Y-%m') AS order_month,
    COUNT(DISTINCT o.customer_id) AS active_customers
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
GROUP BY
    DATE_FORMAT(c.signup_date, '%Y-%m'),
    DATE_FORMAT(o.order_date, '%Y-%m')
ORDER BY
    signup_month,
    order_month;