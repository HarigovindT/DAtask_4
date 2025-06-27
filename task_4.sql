CREATE TABLE customers (
    id INTEGER PRIMARY KEY,
    name TEXT,
    email TEXT,
    country TEXT
);

CREATE TABLE orders (
    id INTEGER PRIMARY KEY,
    customer_id INTEGER,
    order_date TEXT,
    total_amount REAL,
    FOREIGN KEY (customer_id) REFERENCES customers(id)
);

CREATE TABLE products (
    id INTEGER PRIMARY KEY,
    name TEXT,
    price REAL,
    category TEXT
);

CREATE TABLE order_items (
    id INTEGER PRIMARY KEY,
    order_id INTEGER,
    product_id INTEGER,
    quantity INTEGER,
    price REAL,
    FOREIGN KEY (order_id) REFERENCES orders(id),
    FOREIGN KEY (product_id) REFERENCES products(id)
);

INSERT INTO customers VALUES (1, 'Alice', 'alice@example.com', 'India');
INSERT INTO customers VALUES (2, 'Bob', 'bob@example.com', 'USA');
INSERT INTO customers VALUES (3, 'Charlie', 'charlie@example.com', 'India');
INSERT INTO customers VALUES (4, 'Diana', 'diana@example.com', 'Canada');

INSERT INTO orders VALUES (1, 1, '2024-03-10', 250.0);
INSERT INTO orders VALUES (2, 2, '2024-04-15', 120.0);
INSERT INTO orders VALUES (3, 1, '2024-05-20', 320.0);
INSERT INTO orders VALUES (4, 3, '2024-06-01', 180.0);

INSERT INTO products VALUES (1, 'Laptop', 1000.0, 'Electronics');
INSERT INTO products VALUES (2, 'Mouse', 25.0, 'Electronics');
INSERT INTO products VALUES (3, 'Book', 15.0, 'Books');

INSERT INTO order_items VALUES (1, 1, 1, 1, 1000.0);
INSERT INTO order_items VALUES (2, 2, 2, 2, 25.0);
INSERT INTO order_items VALUES (3, 3, 3, 3, 15.0);
INSERT INTO order_items VALUES (4, 4, 1, 1, 1000.0);


SELECT * FROM customers WHERE country = 'India';

SELECT * FROM orders
WHERE order_date BETWEEN '2024-01-01' AND '2024-12-31'
ORDER BY order_date DESC;

SELECT SUM(total_amount) AS total_revenue FROM orders;

SELECT c.country, AVG(o.total_amount) AS avg_order_value
FROM customers c
JOIN orders o ON c.id = o.customer_id
GROUP BY c.country;

SELECT c.name, SUM(o.total_amount) AS total_spent
FROM customers c
JOIN orders o ON c.id = o.customer_id
GROUP BY c.id
ORDER BY total_spent DESC
LIMIT 5;

SELECT p.name, SUM(oi.quantity) AS units_sold
FROM products p
JOIN order_items oi ON p.id = oi.product_id
GROUP BY p.id
ORDER BY units_sold DESC;

SELECT name, email FROM customers
WHERE id IN (
    SELECT customer_id FROM orders
    GROUP BY customer_id
    HAVING SUM(total_amount) > (
        SELECT AVG(total_amount) FROM orders
    )
);

CREATE VIEW sales_by_category AS
SELECT p.category, SUM(oi.quantity * oi.price) AS revenue
FROM products p
JOIN order_items oi ON p.id = oi.product_id
GROUP BY p.category;

SELECT * FROM sales_by_category
ORDER BY revenue DESC
LIMIT 3;

CREATE INDEX idx_orders_customer_id ON orders(customer_id);
CREATE INDEX idx_order_items_product_id ON order_items(product_id);
