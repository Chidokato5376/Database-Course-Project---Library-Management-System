DELIMITER //

DROP TRIGGER IF EXISTS trg_after_loan_update //
CREATE TRIGGER trg_after_loan_update
AFTER UPDATE ON Loan
FOR EACH ROW
BEGIN
    DECLARE v_days_overdue INT;
    DECLARE v_fine_per_day DECIMAL(10,2) DEFAULT 2.00; 

    IF OLD.return_date IS NULL AND NEW.return_date IS NOT NULL THEN
        
        UPDATE Book 
        SET available_copies = available_copies + 1
        WHERE book_id = NEW.book_id;

        IF NEW.return_date > NEW.due_date THEN
            SET v_days_overdue = DATEDIFF(NEW.return_date, NEW.due_date);
            
            INSERT INTO Payment (loan_id, amount, payment_method, remarks)
            VALUES (
                NEW.loan_id, 
                (v_days_overdue * v_fine_per_day), 
                'Cash', 
                CONCAT('Auto-fine: Late ', v_days_overdue, ' days')
            );
        END IF;
        
    END IF;
END //

DELIMITER ;