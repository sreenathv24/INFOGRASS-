USE startersql;
SELECT * FROM users;
INSERT INTO users (id, name, email, gender, date_of_birth, salary) VALUES
(1,'Charlie', 'charlie@example.com', 'Other', '1988-02-17', 15000),
(2,'David', 'david@example.com', 'Male', '2000-08-09', 20000),
(3,'Eva', 'eva@example.com', 'Female', '1993-12-30', 350000),
(4,'Bob', 'bob@example.com', 'Male', '1990-11-23', 45000),
(5,'job', 'job@example.com', 'Male', '1991-12-22', 50000),
(6,'Bb', 'bb@example.com', 'Other', '1999-11-23', 60000),
(7,'smithi', 'smithi@example.com', 'Female', '1888-11-23', 75000);

USE startersql;
SELECT * FROM addresses;
INSERT INTO addresses (user_id, address_type, street, city, state, country, pincode) VALUES
(1, 'Home',   'Gandhinagar 1st Street', 'Chennai',   'Tamil Nadu', 'India', '600001'),
(1, 'Office', 'T Nagar Main Road',      'Chennai',   'Tamil Nadu', 'India', '600017'),
(2, 'Home',   'Parrys Corner',           'Chennai',   'Tamil Nadu', 'India', '600001'),
(3, 'Home',   'BTM Layout 2nd Stage',    'Bengaluru', 'Karnataka',  'India', '560076'),
(3, 'Office', 'Electronic City Phase 1','Bengaluru', 'Karnataka',  'India', '560100'),
(4, 'Home',   'Ashok Nagar',             'Bengaluru', 'Karnataka',  'India', '560050'),
(5, 'Other',  'Jayanagar 4th Block',     'Bengaluru', 'Karnataka',  'India', '560041');
SELECT * FROM admin_users;
INSERT INTO admin_users (id, name, email, gender, date_of_birth, salary) VALUES
(105, 'Anil Kumar', 'anil@example.com', 'Male', '1985-04-12', 60000),
(106, 'Pooja Sharma', 'pooja@example.com', 'Female', '1992-09-20', 58000),
(107, 'Rakesh Yadav', 'rakesh@example.com', 'Male', '1989-11-05', 54000),
(108, 'Fatima Begum', 'fatima@example.com', 'Female', '1990-06-30', 62000);


