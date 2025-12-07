DELIMITER //

-- sp_borrow_book(member_id, book_id)
DROP PROCEDURE IF EXISTS sp_borrow_book //
CREATE PROCEDURE sp_borrow_book(
    IN p_member_id INT, 
    IN p_book_id INT
)
BEGIN
    DECLARE v_available INT;
    SELECT available_copies INTO v_available 
    FROM Book WHERE book_id = p_book_id;

    IF v_available > 0 THEN
        INSERT INTO Loan (member_id, book_id, issue_date, due_date, status)
        VALUES (p_member_id, p_book_id, CURDATE(), DATE_ADD(CURDATE(), INTERVAL 14 DAY), 'Borrowed');
        UPDATE Book 
        SET available_copies = available_copies - 1 
        WHERE book_id = p_book_id;
        
        SELECT 'Book borrowed successfully.' AS message;
    ELSE
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Error: Book is not available.';
    END IF;
END //



-- sp_monthly_activity_report(year, month)
DROP PROCEDURE IF EXISTS sp_monthly_activity_report //
CREATE PROCEDURE sp_monthly_activity_report(
    IN p_year INT, 
    IN p_month INT
)
BEGIN
    SELECT 
        COUNT(l.loan_id) AS total_borrowed,
        SUM(CASE WHEN return_date IS NOT NULL THEN 1 ELSE 0 END) AS total_returned,
        SUM(CASE WHEN return_date > due_date THEN 1 ELSE 0 END) AS total_overdue_returns,
        COALESCE(SUM(p.amount), 0) AS total_fines_collected
    FROM 
        Loan l
    LEFT JOIN 
        Payment p ON l.loan_id = p.loan_id
    WHERE 
        YEAR(l.issue_date) = p_year 
        AND MONTH(l.issue_date) = p_month;
END //

DELIMITER ;