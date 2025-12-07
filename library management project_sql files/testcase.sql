SELECT 'Categories' as Entity, COUNT(*) as Total FROM Category
UNION ALL
SELECT 'Books', COUNT(*) FROM Book
UNION ALL
SELECT 'Members', COUNT(*) FROM Member
UNION ALL
SELECT 'Staff', COUNT(*) FROM Staff
UNION ALL
SELECT 'Loans', COUNT(*) FROM Loan
UNION ALL
SELECT 'Payments', COUNT(*) FROM Payment;

SELECT 
    b.book_id,
    b.title,
    c.category_name,
    COUNT(l.loan_id) AS total_borrowed
FROM 
    Book b
JOIN 
    Loan l ON b.book_id = l.book_id
JOIN 
    Category c ON b.category_id = c.category_id
GROUP BY 
    b.book_id, b.title, c.category_name
ORDER BY 
    total_borrowed DESC
LIMIT 5;

SELECT 
    c.category_name AS 'Thể Loại',
    SUM(b.available_copies) AS 'Trong Kho',
    SUM(b.total_copies - b.available_copies) AS 'Đang Mượn',
    SUM(b.total_copies) AS 'Tổng Cộng'
FROM 
    Book b
JOIN
    Category c ON b.category_id = c.category_id
GROUP BY 
    c.category_name
ORDER BY 
    SUM(b.total_copies) DESC;
    

SELECT status, COUNT(*) AS So_luong
FROM v_active_loans
GROUP BY status;


USE LibraryManagementDB;

-- Cập nhật 4 cuốn sách đang Quá hạn (Overdue) thành Đã trả (Returned) ngay hôm nay
-- Hành động này sẽ kích hoạt Trigger 'trg_after_loan_update'
UPDATE Loan 
SET return_date = CURDATE(), status = 'Returned'
WHERE status = 'Overdue';