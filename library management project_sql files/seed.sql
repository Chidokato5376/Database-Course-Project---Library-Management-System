-- ==========================================================
-- SEED DATA - VARIED DISTRIBUTION
-- ==========================================================
USE LibraryManagementDB;

-- 1. INSERT CATEGORIES
INSERT INTO Category (category_name, description) VALUES 
('Science', 'Physics, Chemistry, Biology and Astronomy'),
('Literature', 'Classic novels, poetry, and plays'),
('IT', 'Information Technology, Programming, and AI'),
('Business', 'Economics, Management, and Finance'),
('History', 'World history, biographies, and ancient civilizations');

-- 2. INSERT STAFF
INSERT INTO Staff (full_name, position, email, assigned_section) VALUES 
('Alice Walker', 'Head Librarian', 'alice.w@lib.com', 'Administration'),
('Bob Miller', 'Assistant Librarian', 'bob.m@lib.com', 'Circulation'),
('Charlie Puth', 'IT Specialist', 'charlie.p@lib.com', 'IT Support'),
('David Beckham', 'Archivist', 'david.b@lib.com', 'Archives'),
('Eva Green', 'Accountant', 'eva.g@lib.com', 'Finance');

-- 3. INSERT MEMBERS 
INSERT INTO Member (full_name, email, phone_number, member_type) VALUES 
('John Smith', 'john.s@uni.edu', '555-001', 'Student'),
('Emily Davis', 'emily.d@uni.edu', '555-002', 'Student'),
('Michael Brown', 'michael.b@uni.edu', '555-003', 'Student'),
('Sarah Wilson', 'sarah.w@uni.edu', '555-004', 'Student'),
('Kevin White', 'kevin.w@uni.edu', '555-005', 'Student'),
('Laura Martin', 'laura.m@uni.edu', '555-006', 'Student'),
('Chris Lee', 'chris.l@uni.edu', '555-007', 'Student'),
('Anna Scott', 'anna.s@uni.edu', '555-008', 'Student'),
('Dr. Alan Grant', 'alan.g@uni.edu', '555-009', 'Faculty'),
('Prof. Minerva', 'minerva.m@uni.edu', '555-010', 'Faculty'),
('Dr. Strange', 'stephen.s@uni.edu', '555-011', 'Faculty'),
('Prof. X', 'charles.x@uni.edu', '555-012', 'Faculty'),
('Tony Stark', 'tony.s@uni.edu', '555-013', 'Staff'),
('Bruce Wayne', 'bruce.w@uni.edu', '555-014', 'Staff'),
('Clark Kent', 'clark.k@uni.edu', '555-015', 'Staff');


-- 4. INSERT BOOKS
INSERT INTO Book (title, author, category_id, total_copies, available_copies, isbn) VALUES
('A Brief History of Time', 'Stephen Hawking', 1, 5, 5, 'ISBN-001'),
('Cosmos', 'Carl Sagan', 1, 3, 2, 'ISBN-002'),
('The Selfish Gene', 'Richard Dawkins', 1, 4, 4, 'ISBN-003'),
('Silent Spring', 'Rachel Carson', 1, 2, 1, 'ISBN-004'),
('The Origin of Species', 'Charles Darwin', 1, 5, 5, 'ISBN-005'),
('The Great Gatsby', 'F. Scott Fitzgerald', 2, 5, 3, 'ISBN-006'),
('Pride and Prejudice', 'Jane Austen', 2, 4, 4, 'ISBN-007'),
('To Kill a Mockingbird', 'Harper Lee', 2, 6, 2, 'ISBN-008'),
('1984', 'George Orwell', 2, 8, 5, 'ISBN-009'),
('Moby Dick', 'Herman Melville', 2, 3, 3, 'ISBN-010'),
('Clean Code', 'Robert C. Martin', 3, 10, 8, 'ISBN-011'),
('The Pragmatic Programmer', 'Andy Hunt', 3, 7, 5, 'ISBN-012'),
('Introduction to Algorithms', 'Thomas H. Cormen', 3, 5, 2, 'ISBN-013'),
('Design Patterns', 'Erich Gamma', 3, 6, 6, 'ISBN-014'),
('Head First Java', 'Kathy Sierra', 3, 8, 7, 'ISBN-015'),
('Rich Dad Poor Dad', 'Robert Kiyosaki', 4, 10, 2, 'ISBN-016'),
('Think and Grow Rich', 'Napoleon Hill', 4, 5, 5, 'ISBN-017'),
('Zero to One', 'Peter Thiel', 4, 4, 3, 'ISBN-018'),
('The Lean Startup', 'Eric Ries', 4, 6, 4, 'ISBN-019'),
('Principles', 'Ray Dalio', 4, 3, 3, 'ISBN-020'),
('Sapiens', 'Yuval Noah Harari', 5, 12, 0, 'ISBN-021'),
('Guns, Germs, and Steel', 'Jared Diamond', 5, 5, 4, 'ISBN-022'),
('The Silk Roads', 'Peter Frankopan', 5, 4, 2, 'ISBN-023'),
('SPQR', 'Mary Beard', 5, 3, 3, 'ISBN-024'),
('Genghis Khan', 'Jack Weatherford', 5, 4, 4, 'ISBN-025');


-- 5. INSERT LOAN RECORDS 

-- Group 1: Returned On Time (12 records) 
INSERT INTO Loan (member_id, book_id, issue_date, due_date, return_date, status) VALUES
(1, 1, '2025-01-05', '2025-01-19', '2025-01-15', 'Returned'),
(2, 2, '2025-01-10', '2025-01-24', '2025-01-20', 'Returned'),
(3, 3, '2025-02-01', '2025-02-15', '2025-02-14', 'Returned'),
(4, 4, '2025-02-15', '2025-03-01', '2025-02-28', 'Returned'),
(5, 5, '2025-03-01', '2025-03-15', '2025-03-10', 'Returned'),
(6, 6, '2025-03-05', '2025-03-19', '2025-03-18', 'Returned'),
(7, 7, '2025-04-01', '2025-04-15', '2025-04-12', 'Returned'),
(8, 8, '2025-04-10', '2025-04-24', '2025-04-24', 'Returned'),
(9, 9, '2025-05-01', '2025-05-15', '2025-05-05', 'Returned'),
(10, 10, '2025-05-05', '2025-05-19', '2025-05-15', 'Returned'),
(11, 11, '2025-05-20', '2025-06-03', '2025-06-01', 'Returned'),
(12, 12, '2025-06-01', '2025-06-15', '2025-06-10', 'Returned');

-- Group 2: Returned Late (8 records) 
INSERT INTO Loan (member_id, book_id, issue_date, due_date, return_date, status) VALUES
(1, 13, '2025-06-01', '2025-06-15', '2025-06-20', 'Returned'), -- Late 5 days
(2, 14, '2025-06-05', '2025-06-19', '2025-06-25', 'Returned'), -- Late 6 days
(3, 15, '2025-07-01', '2025-07-15', '2025-07-20', 'Returned'), -- Late 5 days
(4, 16, '2025-07-10', '2025-07-24', '2025-08-01', 'Returned'), -- Late 8 days
(5, 17, '2025-08-05', '2025-08-19', '2025-08-25', 'Returned'), -- Late 6 days
(6, 18, '2025-08-15', '2025-08-29', '2025-09-05', 'Returned'), -- Late 7 days
(7, 19, '2025-09-01', '2025-09-15', '2025-09-18', 'Returned'), -- Late 3 days
(8, 20, '2025-09-10', '2025-09-24', '2025-10-01', 'Returned'); -- Late 7 days

-- Group 3: Currently Borrowed - Active (7 records) 
INSERT INTO Loan (member_id, book_id, issue_date, due_date, return_date, status) VALUES
(9, 1, CURDATE(), DATE_ADD(CURDATE(), INTERVAL 14 DAY), NULL, 'Borrowed'),
(10, 2, CURDATE(), DATE_ADD(CURDATE(), INTERVAL 14 DAY), NULL, 'Borrowed'),
(11, 3, CURDATE(), DATE_ADD(CURDATE(), INTERVAL 14 DAY), NULL, 'Borrowed'),
(12, 4, CURDATE(), DATE_ADD(CURDATE(), INTERVAL 14 DAY), NULL, 'Borrowed'),
(13, 5, CURDATE(), DATE_ADD(CURDATE(), INTERVAL 14 DAY), NULL, 'Borrowed'),
(14, 6, CURDATE(), DATE_ADD(CURDATE(), INTERVAL 14 DAY), NULL, 'Borrowed'),
(15, 7, CURDATE(), DATE_ADD(CURDATE(), INTERVAL 14 DAY), NULL, 'Borrowed');

-- Group 4: Overdue - Active (4 records)
INSERT INTO Loan (member_id, book_id, issue_date, due_date, return_date, status) VALUES
(1, 21, DATE_SUB(CURDATE(), INTERVAL 30 DAY), DATE_SUB(CURDATE(), INTERVAL 16 DAY), NULL, 'Overdue'),
(2, 22, DATE_SUB(CURDATE(), INTERVAL 30 DAY), DATE_SUB(CURDATE(), INTERVAL 16 DAY), NULL, 'Overdue'),
(3, 23, DATE_SUB(CURDATE(), INTERVAL 30 DAY), DATE_SUB(CURDATE(), INTERVAL 16 DAY), NULL, 'Overdue'),
(4, 24, DATE_SUB(CURDATE(), INTERVAL 30 DAY), DATE_SUB(CURDATE(), INTERVAL 16 DAY), NULL, 'Overdue');


-- 6. INSERT PAYMENTS
INSERT INTO Payment (loan_id, amount, payment_method, remarks) VALUES
(13, 10.00, 'Cash', 'Late fee (5 days)'),   
(14, 12.00, 'Card', 'Late fee (6 days)'),   
(15, 10.00, 'Transfer', 'Late fee (5 days)'),
(16, 16.00, 'Cash', 'Late fee (8 days)'),   
(17, 12.00, 'Cash', 'Late fee (6 days)'),
(18, 14.00, 'Card', 'Late fee (7 days)'),
(19, 6.00, 'Transfer', 'Late fee (3 days)'),
(20, 14.00, 'Cash', 'Late fee (7 days)');