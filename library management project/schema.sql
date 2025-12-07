DROP DATABASE IF EXISTS LibraryManagementDB;
CREATE DATABASE LibraryManagementDB;
USE LibraryManagementDB;

-- 1.1 Table Category
CREATE TABLE Category (
    category_id INT AUTO_INCREMENT PRIMARY KEY,
    category_name VARCHAR(100) NOT NULL UNIQUE,
    description VARCHAR(255)
);

-- 1.2 Table Staff
CREATE TABLE Staff (
    staff_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    position VARCHAR(50),
    phone_number VARCHAR(20),
    email VARCHAR(100) UNIQUE,
    assigned_section VARCHAR(50)
);

-- 1.3 Table Member
CREATE TABLE Member (
    member_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    date_of_birth DATE,
    gender ENUM('Male', 'Female', 'Other') DEFAULT 'Other',
    phone_number VARCHAR(20) NOT NULL,
    email VARCHAR(100) UNIQUE,
    address TEXT,
    member_type ENUM('Student', 'Faculty', 'Staff') NOT NULL,
    registration_date DATE DEFAULT (CURRENT_DATE)
);

-- 1.4 Table Book
CREATE TABLE Book (
    book_id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    author VARCHAR(100) NOT NULL,
    publisher VARCHAR(100),
    publication_year INT,
    isbn VARCHAR(20) UNIQUE,
    total_copies INT DEFAULT 1,
    available_copies INT DEFAULT 1,
    category_id INT,
    FOREIGN KEY (category_id) REFERENCES Category(category_id) ON DELETE SET NULL ON UPDATE CASCADE
);

-- 1.5 Table Loan
CREATE TABLE Loan (
    loan_id INT AUTO_INCREMENT PRIMARY KEY,
    member_id INT NOT NULL,
    book_id INT NOT NULL,
    issue_date DATE NOT NULL,
    due_date DATE NOT NULL,
    return_date DATE,
    status ENUM('Borrowed', 'Returned', 'Overdue') DEFAULT 'Borrowed',
    FOREIGN KEY (member_id) REFERENCES Member(member_id) ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (book_id) REFERENCES Book(book_id) ON DELETE RESTRICT ON UPDATE CASCADE
);

-- 1.6 Table Payment 
CREATE TABLE Payment (
    payment_id INT AUTO_INCREMENT PRIMARY KEY,
    loan_id INT NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    payment_date DATE DEFAULT (CURRENT_DATE),
    payment_method ENUM('Cash', 'Card', 'Transfer') DEFAULT 'Cash',
    remarks VARCHAR(255),
    FOREIGN KEY (loan_id) REFERENCES Loan(loan_id) ON DELETE RESTRICT ON UPDATE CASCADE
);



