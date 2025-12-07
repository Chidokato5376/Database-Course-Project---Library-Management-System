-- check view_book_status
SELECT * FROM v_books_status
ORDER BY book_id ASC;

-- check most borrowed books:
SELECT 
	b.book_id,
    b.title, 
    c.category_name, 
    COUNT(l.loan_id) AS times_borrowed
FROM Book b
JOIN Loan l ON b.book_id = l.book_id
JOIN Category c ON b.category_id = c.category_id
GROUP BY b.book_id, b.title, c.category_name
ORDER BY times_borrowed DESC;

-- check stored_procedures:
CALL sp_monthly_activity_report(2025, 6);

-- check total inventory and available books:
SELECT c.category_name, 
SUM(b.total_copies) as 'Total Books', 
SUM(b.available_copies) as 'Available Now'
FROM Book b
JOIN Category c ON b.category_id = c.category_id
GROUP BY c.category_name;
        
-- check trigger impact:
SELECT 
            p.amount as Fine_Amount,
            p.remarks,  
            m.member_id,
            m.full_name
        FROM Payment p
        JOIN Loan l ON p.loan_id = l.loan_id
        JOIN Member m ON l.member_id = m.member_id
        WHERE p.remarks LIKE '%Late%' OR p.remarks LIKE 'Auto-fine%';

