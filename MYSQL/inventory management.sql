-- ============================================================
-- CREATE DATABASE
-- ============================================================

DROP DATABASE IF EXISTS inventory_management;

CREATE DATABASE inventory_management
CHARACTER SET utf8mb4
COLLATE utf8mb4_0900_ai_ci;

USE inventory_management;

SET FOREIGN_KEY_CHECKS = 0;


-- 1. stores

CREATE TABLE stores (
    store_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    store_name VARCHAR(150) NOT NULL,
    city VARCHAR(100) NOT NULL,
    state VARCHAR(100) NOT NULL,
    store_manager VARCHAR(150),
    contact_number VARCHAR(20),
    status ENUM('OPEN','CLOSED') DEFAULT 'OPEN',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    update_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


-- 2. staff_members

CREATE TABLE staff_members (
    staff_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    store_id BIGINT NOT NULL,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    role VARCHAR(100) NOT NULL,
    salary DECIMAL(10,2) NOT NULL,
    hire_date DATE NOT NULL,
    status ENUM('ACTIVE','INACTIVE') DEFAULT 'ACTIVE',
    FOREIGN KEY (store_id) REFERENCES stores(store_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;



-- 3. items

CREATE TABLE items (
    item_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    item_name VARCHAR(150) NOT NULL,
    brand VARCHAR(100),
    category VARCHAR(100) NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    stock_available INT NOT NULL,
    reorder_point INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    update_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;



-- 4. clients

CREATE TABLE clients (
    client_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    client_name VARCHAR(150) NOT NULL,
    email VARCHAR(150),
    phone VARCHAR(20),
    city VARCHAR(100),
    membership_type ENUM('BASIC','GOLD','PLATINUM'),
    loyalty_points INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    update_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 5. invoices

CREATE TABLE invoices (
    invoice_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    client_id BIGINT NOT NULL,
    staff_id BIGINT NOT NULL,
    invoice_date DATE NOT NULL,
    total_amount DECIMAL(12,2) NOT NULL,
    payment_mode VARCHAR(50),
    invoice_status ENUM('PAID','PENDING','CANCELLED'),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    update_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (client_id) REFERENCES clients(client_id),
    FOREIGN KEY (staff_id) REFERENCES staff_members(staff_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;



-- 6. invoice_details

CREATE TABLE invoice_details (
    detail_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    invoice_id BIGINT NOT NULL,
    item_id BIGINT NOT NULL,
    quantity INT NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    discount DECIMAL(5,2) DEFAULT 0,
    tax DECIMAL(5,2) DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    update_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (invoice_id) REFERENCES invoices(invoice_id),
    FOREIGN KEY (item_id) REFERENCES items(item_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

SET FOREIGN_KEY_CHECKS = 1;

-- ============================================================
-- SAMPLE DATA FOR inventory_management
-- ============================================================

-- ------------------------------------------------------------
-- 1. stores
-- ------------------------------------------------------------
INSERT INTO stores 
(store_name, city, state, store_manager, contact_number, status)
VALUES
('Phoenix Retail Hub', 'Chennai', 'Tamil Nadu', 'Vikram Rao', '9001112222', 'OPEN'),
('Metro Shopping Point', 'Bangalore', 'Karnataka', 'Lakshmi Devi', '9003334444', 'OPEN'),
('City Plaza Mart', 'Hyderabad', 'Telangana', 'Imran Khan', '9005556666', 'CLOSED');


-- ------------------------------------------------------------
-- 2. staff_members
-- ------------------------------------------------------------
INSERT INTO staff_members
(store_id, first_name, last_name, role, salary, hire_date, status)
VALUES
(1, 'Aravind', 'Kumar', 'Cashier', 22000, '2023-02-10', 'ACTIVE'),
(1, 'Sneha', 'Reddy', 'Sales Executive', 28000, '2023-05-18', 'ACTIVE'),
(2, 'Manoj', 'Verma', 'Store Supervisor', 45000, '2022-12-01', 'ACTIVE'),
(2, 'Priya', 'Shah', 'Cashier', 24000, '2023-07-22', 'ACTIVE'),
(3, 'Rohit', 'Patil', 'Sales Executive', 26000, '2023-09-15', 'INACTIVE');


-- ------------------------------------------------------------
-- 3. items
-- ------------------------------------------------------------
INSERT INTO items
(item_name, brand, category, unit_price, stock_available, reorder_point)
VALUES
('Gaming Laptop', 'HP', 'Electronics', 75000, 15, 5),
('Wireless Mouse', 'Logitech', 'Accessories', 1200, 80, 15),
('LED Monitor', 'Samsung', 'Electronics', 18000, 20, 5),
('Office Desk', 'Godrej', 'Furniture', 9000, 10, 3),
('USB Keyboard', 'Dell', 'Accessories', 800, 60, 10),
('Laser Printer', 'Canon', 'Electronics', 14000, 6, 4);


-- ------------------------------------------------------------
-- 4. clients
-- ------------------------------------------------------------
INSERT INTO clients
(client_name, email, phone, city, membership_type, loyalty_points)
VALUES
('TechNova Solutions', 'contact@technova.com', '9011111111', 'Chennai', 'PLATINUM', 750),
('Bright Future Ltd', 'info@brightfuture.com', '9022222222', 'Bangalore', 'GOLD', 420),
('Urban Retailers', 'sales@urbanretail.com', '9033333333', 'Hyderabad', 'BASIC', 120),
('Elite Traders', 'elite@traders.com', '9044444444', 'Chennai', 'GOLD', 300),
('NextGen Corp', 'support@nextgen.com', '9055555555', 'Bangalore', 'PLATINUM', 900);


-- ------------------------------------------------------------
-- 5. invoices
-- ------------------------------------------------------------
INSERT INTO invoices
(client_id, staff_id, invoice_date, total_amount, payment_mode, invoice_status)
VALUES
(1, 1, '2024-01-12', 75000, 'CARD', 'PAID'),
(2, 3, '2024-02-05', 18000, 'UPI', 'PAID'),
(3, 2, '2024-03-10', 2400, 'CASH', 'PENDING'),
(4, 4, '2024-03-25', 14000, 'CARD', 'PAID'),
(5, 1, '2024-04-02', 9000, 'UPI', 'CANCELLED');


-- ------------------------------------------------------------
-- 6. invoice_details
-- ------------------------------------------------------------
INSERT INTO invoice_details
(invoice_id, item_id, quantity, price, discount, tax)
VALUES
(1, 1, 1, 75000, 5, 18),        -- Gaming Laptop
(2, 3, 1, 18000, 0, 18),        -- LED Monitor
(3, 2, 2, 1200, 10, 18),        -- Wireless Mouse
(4, 6, 1, 14000, 0, 18),        -- Laser Printer
(5, 4, 1, 9000, 0, 18);         -- Office Desk


--  INNER JOIN 
CREATE OR REPLACE VIEW view_invoice_complete_details AS
SELECT 
    i.invoice_id,
    c.client_name,
    s.first_name,
    st.store_name,
    it.item_name,
    id.quantity
FROM invoices i
INNER JOIN clients c 
ON i.client_id = c.client_id
INNER JOIN staff_members s 
ON i.staff_id = s.staff_id
INNER JOIN stores st 
ON s.store_id = st.store_id
INNER JOIN invoice_details id 
ON i.invoice_id = id.invoice_id
INNER JOIN items it
ON id.item_id = it.item_id;
    
-- LEFT JOIN
CREATE OR REPLACE VIEW view_all_clients_invoices AS
SELECT 
    c.client_name,
    i.invoice_id,
    i.total_amount
FROM clients c
LEFT JOIN invoices i
ON c.client_id = i.client_id;

-- right join
CREATE OR REPLACE VIEW view_all_items_sales AS
SELECT 
    it.item_name,
    id.invoice_id,
    id.quantity
FROM invoice_details id
RIGHT JOIN items it
ON id.item_id = it.item_id;
    
-- full outer join 
CREATE OR REPLACE VIEW view_staff_invoice_full AS
SELECT 
    s.staff_id,
    s.first_name,
    i.invoice_id
FROM staff_members s
LEFT JOIN invoices i
ON s.staff_id = i.staff_id
UNION
SELECT 
    s.staff_id,
    s.first_name,
    i.invoice_id
FROM staff_members s
RIGHT JOIN invoices i
ON s.staff_id = i.staff_id;
    
-- left + left
CREATE OR REPLACE VIEW view_store_wise_sales AS
SELECT 
    st.store_name,
    i.invoice_id,
    i.total_amount
FROM stores st
LEFT JOIN staff_members s
ON st.store_id = s.store_id
LEFT JOIN invoices i
ON s.staff_id = i.staff_id;

-- innner + subqueryIN    
CREATE OR REPLACE VIEW view_high_value_clients AS
SELECT 
    client_name,
    membership_type
FROM clients
WHERE client_id IN (
    SELECT client_id
    FROM invoices
    WHERE total_amount > 20000
);

CREATE OR REPLACE VIEW view_total_sales_per_store AS
SELECT 
    st.store_name,
    SUM(i.total_amount) AS total_sales
FROM stores st
INNER JOIN staff_members s
    ON st.store_id = s.store_id
INNER JOIN invoices i
    ON s.staff_id = i.staff_id
GROUP BY st.store_name;

CREATE OR REPLACE VIEW view_paid_items AS
SELECT 
    it.item_name,
    id.quantity,
    i.invoice_status
FROM items it
LEFT JOIN invoice_details id
ON it.item_id = id.item_id
LEFT JOIN invoices i
    ON id.invoice_id = i.invoice_id
WHERE i.invoice_status = 'PAID';