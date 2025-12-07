-- v_books_status
CREATE OR REPLACE VIEW v_books_status AS
SELECT 
    b.book_id,
    b.title,
    c.category_name,
    b.total_copies,
    b.available_copies,
    ROUND((b.available_copies / b.total_copies) * 100, 1) AS availability_pct
FROM 
    BOOK b
JOIN 
    CATEGORY c ON b.category_id = c.category_id;
    
    
-- v_active_loans 
CREATE OR REPLACE VIEW v_active_loans AS
SELECT 
    l.loan_id,
    m.full_name AS member_name, 
    m.email,
    b.title AS book_title,
    l.issue_date,
    l.due_date,
    CASE 
        WHEN CURDATE() > l.due_date THEN 'Overdue'
        ELSE 'Active'
    END AS status
FROM 
    Loan l 
JOIN 
    Member m ON l.member_id = m.member_id 
JOIN 
    Book b ON l.book_id = b.book_id
WHERE 
    l.return_date IS NULL;
    
    

-- v_overdue_fines 
CREATE OR REPLACE VIEW v_overdue_fines AS
SELECT 
    m.member_id,
    m.full_name AS member_name,
    b.title AS book_title,
    p.amount AS fine_amount,
    p.remarks AS fine_reason,
    DATEDIFF(l.return_date, l.due_date) AS days_overdue
FROM 
    Payment p 
JOIN 
    Loan l ON p.loan_id = l.loan_id
JOIN 
    Member m ON l.member_id = m.member_id
JOIN 
    Book b ON l.book_id = b.book_id
WHERE 
    p.remarks LIKE '%Late%'; 