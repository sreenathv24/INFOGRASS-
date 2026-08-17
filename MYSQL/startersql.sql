DROP DATABASE IF EXISTS startersql;
CREATE DATABASE startersql;
USE startersql;

CREATE TABLE users (
id INT AUTO_INCREMENT PRIMARY KEY,
name VARCHAR(100) NOT NULL,
email VARCHAR(100) UNIQUE NOT NULL,
gender ENUM('Male', 'Female', 'Other'),
date_of_birth DATE,
salary DECIMAL(10,2),
created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

SELECT * FROM users;
-- Equal to
SELECT * FROM users WHERE gender = 'Female';
SELECT * FROM users WHERE date_of_birth = '1988-02-17';
-- Not equal to
SELECT * FROM users WHERE gender != 'Male';
-- Greater Than / Less Than
SELECT * FROM users WHERE date_of_birth > '1988-02-17';
SELECT * FROM users WHERE date_of_birth < '2000-08-09';
-- Greater Than or Equal / Less Than or Equal
SELECT * FROM users WHERE id >=5;
SELECT * FROM users WHERE id <=5;
-- IS NULL
SELECT * FROM users WHERE date_of_birth IS NULL;
 -- IS NOT NULL
SELECT * FROM users WHERE date_of_birth IS NOT NULL;
-- BETWEEN
SELECT * FROM users WHERE date_of_birth BETWEEN '1990-01-01' AND '2000-12-31';
-- IN 
SELECT * FROM users WHERE gender IN ('Male', 'Other');
-- LIKE(PATTERN MATCHING)
SELECT * FROM users WHERE name LIKE 'A%'; -- Starts with A
SELECT * FROM users WHERE name LIKE '%a'; -- Ends with a
SELECT * FROM users WHERE name LIKE '%li%'; -- Contains 'li'
-- AND/OR
SELECT * FROM users WHERE gender = 'Female' AND date_of_birth > '1990-01-01';
SELECT * FROM users WHERE gender = 'Male' OR gender = 'Other';
-- ORDER BY
SELECT * FROM users ORDER BY date_of_birth ASC;
SELECT * FROM users ORDER BY name DESC;
-- LIMIT
SELECT * FROM users LIMIT 5; -- Top 5 rows
SELECT * FROM users LIMIT 10 OFFSET 5; -- Skip first 5 rows, then get next 10
SELECT * FROM users LIMIT 5, 10; -- Get 10 rows starting from the 6th row (Same as above)
SELECT * FROM users ORDER BY created_at DESC LIMIT 10;
-- PRACTISE
SELECT * FROM users WHERE salary > 60000 ORDER BY created_at DESC LIMIT 5;
SELECT * FROM users ORDER BY salary DESC;
SELECT * FROM users WHERE salary BETWEEN 50000 AND 70000;
-- UPDATE
UPDATE users
SET salary = 70000
WHERE id = 5;

SET SQL_SAFE_UPDATES = 0;
UPDATE users
SET salary = salary + 10000
WHERE salary < 60000;

SELECT * FROM users WHERE id = 3;
-- 1.AGGREATE FUNCTIONS
-- COUNT()
SELECT COUNT(*) FROM users;
SELECT COUNT(*) FROM users WHERE gender = 'Male';
-- MIN() AND MAX()
SELECT MIN(salary) AS min_salary, MAX(salary) AS max_salary FROM users;
-- SUM()
SELECT SUM(salary) AS total_payroll FROM users;
-- AVG()
SELECT AVG(salary) AS total_payroll FROM users;
-- GROUP BY
SELECT gender, AVG(salary) AS avg_salary
FROM users
GROUP BY gender;
-- 2.STRING FUNCTIONS
-- LENGTH()
SELECT name, LENGTH(name) AS name_length FROM users;
-- LOWER()
SELECT name, LOWER(name) AS name_lower FROM users;
-- UPPER()
SELECT name, UPPER(name) AS name_upper FROM users;
-- CONCAT
SELECT CONCAT(name, ' <', email, '>') AS user_contact FROM users;
-- 3.DATE FUNCTIONS
-- NOW()
SELECT NOW();
-- YEAR(), MONTH(), DAY()
SELECT name, YEAR(date_of_birth) AS birth_year FROM users;
-- DATEDIFF()
SELECT name, DATEDIFF(CURDATE(), date_of_birth) AS days_lived FROM users;
 
 UPDATE users 
 SET name = 'Sreenath',
 email = 'sree@example.com',
 gender = 'Male',
 date_of_birth = '2003-10-24',
 salary = 55000
WHERE id = 5;

-- TIMESTAMPDIFF()
SELECT name, TIMESTAMPDIFF(YEAR, date_of_birth, CURDATE()) AS age FROM users;
-- 4.MATHEMATICAL FUNCTIONS
-- Round(), Floor(), Ceil()
SELECT salary,
ROUND(salary) AS rounded,
FLOOR(salary) AS floored,
CEIL(salary) AS ceiled
FROM users;
-- Mod()
SELECT id, MOD(id, 2) AS remainder FROM users;
-- 5.CONDITIONAL FUNCTIONS
-- IF
SELECT name, gender,
IF(gender = 'Male', 'Yes', 'No') AS is_male
FROM users;


DROP TABLE IF EXISTS addresses;
CREATE TABLE addresses (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    address_type ENUM('Home', 'Office', 'Other') DEFAULT 'Home',
    street VARCHAR(255) NOT NULL,
    city VARCHAR(100) NOT NULL,
    state VARCHAR(100) NOT NULL,
    country VARCHAR(100) DEFAULT 'India',
    pincode VARCHAR(10) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_addresses_users
        FOREIGN KEY (user_id)
        REFERENCES users(id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);
-- INNER JOIN
SELECT users.name, addresses.city
FROM users
INNER JOIN addresses ON users.id = addresses.user_id;
-- LEFT JOIN
SELECT users.name, addresses.city
FROM users
LEFT JOIN addresses ON users.id = addresses.user_id;
-- RIGHT JOIN
SELECT users.name, addresses.city
FROM users
RIGHT JOIN addresses ON users.id = addresses.user_id;

CREATE TABLE admin_users (
id INT PRIMARY KEY,
name VARCHAR(100),
email VARCHAR(100),
gender ENUM('Male', 'Female', 'Other'),
date_of_birth DATE,
salary INT
);

-- UNION
SELECT name FROM users
UNION
SELECT name FROM admin_users;
-- UNION ALL
SELECT name FROM users
UNION ALL
SELECT name FROM admin_users;
-- Using More Than One Column
SELECT name, salary FROM users
UNION
SELECT name, salary FROM admin_users;
-- Adding separate roles
SELECT name, 'User' AS role FROM users
UNION
SELECT name, 'Admin' AS role FROM admin_users;
-- Using Order By with UNION
SELECT name FROM users
UNION
SELECT name FROM admin_users
ORDER BY name;
-- -- -- -- -- -- -- -- -- -- -- 
ALTER TABLE users
ADD COLUMN referred_by_id INT;
-- inserting a referal data
UPDATE users SET referred_by_id = 1 WHERE id IN (2, 3); -- User 1 referred Users 2 and 3
UPDATE users SET referred_by_id = 2 WHERE id = 4; -- User 2 referred User 4
-- Use a Self JOIN to Get Referrer Names
SELECT
a.id,
a.name AS user_name,
b.name AS referred_by
FROM users a
INNER JOIN users b ON a.referred_by_id = b.id;

-- creating a view
CREATE VIEW high_salary_users AS
SELECT id, name, salary
FROM users
WHERE salary > 70000;
-- querying a view
SELECT * FROM high_salary_users;
-- updating user salary
UPDATE users
SET salary = 72000
WHERE name = 'Raj';
SELECT * FROM high_salary_users;
-- index
SHOW INDEXES FROM users;
-- creating a Single-Column Index
CREATE INDEX idx_email ON users(email);
SELECT * FROM users WHERE email = 'example@example.com';
-- creating a multi-Column Index
CREATE INDEX idx_gender_salary ON users(gender, salary);
SELECT * FROM users WHERE gender = 'Female' AND salary > 70000;

-- GROUP BY WITH COUNT
SELECT referred_by_id, COUNT(*) AS total_referred
FROM users
WHERE referred_by_id IS NOT NULL
GROUP BY referred_by_id;
-- rollup
SELECT gender, COUNT(*) AS total_users
FROM users
GROUP BY gender WITH ROLLUP;

-- Creating a Procedure with Input Parameters
DELIMITER $$
CREATE PROCEDURE AddUser(
IN p_name VARCHAR(100),
IN p_email VARCHAR(100),
IN p_gender ENUM('Male', 'Female', 'Other'),
IN p_dob DATE,
IN p_salary INT
)
BEGIN
INSERT INTO users (name, email, gender, date_of_birth, salary)
VALUES (p_name, p_email, p_gender, p_dob, p_salary);
END $$
DELIMITER ;
-- CALLING THE PROCEDURE
CALL AddUser('Kiran Sharma', 'kiran@example.com', 'Female', '1994-06-15', 72000);
-- viewing stored procedures
SHOW PROCEDURE STATUS WHERE Db = 'startersql';
-- droping the procedure
DROP PROCEDURE IF EXISTS AddUser;

CREATE TABLE user_log (
id INT AUTO_INCREMENT PRIMARY KEY,
user_id INT,
name VARCHAR(100),
created_on TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
-- TRIGGER
DELIMITER $$
CREATE TRIGGER after_user_insert
AFTER INSERT ON users
FOR EACH ROW
BEGIN
INSERT INTO user_log (user_id, name) VALUES (NEW.id, NEW.name);
END $$
DELIMITER ;

-- test the trigger
CALL AddUser('Ritika Jain', 'ritika@example.com', 'Female', '1996-03-12', 74000);
SELECT * FROM user_log;
-- DISTINCT keyword - used to return unique values
SELECT DISTINCT gender FROM users;

COMMIT;

