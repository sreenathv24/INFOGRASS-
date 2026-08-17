CREATE DATABASE IF NOT EXISTS startersql;
USE startersql;

CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    gender ENUM('Male', 'Female', 'Other'),
    date_of_birth DATE,
    salary DECIMAL(10, 2),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

SELECT name, email FROM users;

ALTER TABLE users ADD COLUMN is_active BOOLEAN DEFAULT TRUE;

ALTER TABLE users DROP COLUMN is_active;

ALTER TABLE users MODIFY COLUMN name VARCHAR(150);

ALTER TABLE users MODIFY COLUMN email VARCHAR(100) FIRST;

ALTER TABLE users MODIFY COLUMN gender ENUM('Male', 'Female', 'Other') AFTER name;

ALTER TABLE users MODIFY COLUMN date_of_birth DATE AFTER email;

UPDATE users
SET date_of_birth = '1996-06-15'
WHERE id = 1;

UPDATE users
SET name = 'ravi'
WHERE email = 'aarav@example.com';

DELETE FROM users 
WHERE id = 2;

-- operations like equal to, not equal to, greater than/lesser than, greater than or equal to/lesser then or equal to,IS NULL,IS NOT NULL,BETWEEN, IN, AND, OR

-- EQUAL TO and NOT EQUAL TO
SELECT * FROM users WHERE gender = 'Female';
SELECT * FROM users WHERE gender != 'Male';

-- GREATER THAN/LESSER THAN 
SELECT * FROM users WHERE date_of_birth > '1995-01-01';
SELECT * FROM users WHERE date_of_birth < '1995-01-01';

-- 	GREATER THAN OR EQUAL TO/LESSER THAN OR EQUAL TO 
SELECT * FROM users WHERE salary >= 77000.00;
SELECT * FROM users WHERE salary <= 77000.00;

-- IS NULL 
SELECT * FROM users WHERE date_of_birth IS NULL;

-- IS NOT NULL
SELECT * FROM users WHERE date_of_birth IS NOT NULL;

-- BETWEEN
SELECT * FROM users WHERE salary BETWEEN 77000.00 AND 80000.00;

-- IN
SELECT * FROM users WHERE name IN ('Raj');

-- AND/ OR 
SELECT * FROM users WHERE name = 'Raj' AND gender = 'Male';
SELECT * FROM users WHERE name = 'Na' OR gender = 'Other';

INSERT INTO users (name, email, date_of_birth, gender, salary) VALUES
('Sreenath', 'sreenath@gmail.com', '2003-10-24', 'Other', 82000.00);

SELECT * FROM users;

-- AGGERATE FUNCTIONS
-- COUNT
SELECT COUNT(*) FROM users;
SELECT COUNT(*) FROM users WHERE gender = 'Female';

-- MIN() and MAX()
SELECT MIN(salary) AS min_salary, MAX(salary) AS max_salary FROM users;

-- SUM
SELECT SUM(salary) AS total_payroll FROM users;

-- AVG
SELECT AVG(salary) AS avg_salary FROM users;

-- GROUP BY
SELECT gender, AVG(salary) AS avg_salary
FROM users
GROUP BY gender;

-- STRING FUNCTIONS
-- LENGTH()
SELECT name, LENGTH(name) AS name_length FROM users;

-- LOWER() and UPPER()
SELECT name, LOWER(name) AS lowercase_name FROM users;
SELECT name, UPPER(name) AS uppercase_name FROM users;

-- CONCAT()
SELECT CONCAT(name, ' <', email, '>') AS user_contact FROM users;

-- DATE FUNCTIONS
-- NOW()
SELECT NOW();

-- YEAR() , MONTH() , DAY()
SELECT name, YEAR(date_of_birth) AS birth_year FROM users;

-- DATEDIFF()
SELECT name, DATEDIFF(CURDATE(), date_of_birth) AS days_lived FROM users;

-- TIMESTAMPDIFF()
SELECT name, TIMESTAMPDIFF(YEAR, date_of_birth, CURDATE()) AS age FROM users;

-- MATHEMATICAL FUNCTIONS
-- ROUND() , FLOOR() , CEIL()
SELECT salary,
ROUND(salary) AS rounded,
FLOOR(salary) AS floored,
CEIL(salary) AS ceiled
FROM users;

-- MOD() // FIND EVEN OR ODD USER ID'S
SELECT id, MOD(id, 2) AS remainder FROM users;

-- CONDITIONAL FUNCTION
-- IF()
SELECT name, gender,
IF(gender = 'Female', 'Yes', 'No') AS is_female
FROM users;

-- JOINS
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

-- UNION and UNION ALL
-- UNION
SELECT name, salary FROM users
UNION
SELECT name, salary FROM admin_users;

-- UNION ALL 
SELECT name FROM users
UNION ALL
SELECT name FROM admin_users;

-- VIEWS
CREATE VIEW high_salary_users AS
SELECT id, name, salary
FROM users
WHERE salary > 70000;

SELECT * FROM high_salary_users;

-- INDEXES
SHOW INDEXES FROM users;






