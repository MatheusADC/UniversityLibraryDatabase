CREATE PROCEDURE sp_create_loan(
    p_copy_id   INT,
    p_member_id INT,
    p_days      INT
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO loans(copy_id, member_id, loan_date, due_date)
    VALUES (p_copy_id, p_member_id, NOW(), NOW() + (p_days || ' days')::interval);

    UPDATE book_copies
    SET status = 'loaned'
    WHERE copy_id = p_copy_id;
END;
$$;

CALL sp_create_loan(124, 46, 14);

DO $$
  BEGIN
    INSERT INTO loans(copy_id, member_id, loan_date, due_date)
    VALUES (198, 11, NOW(), NOW() + INTERVAL '14 days');
    SAVEPOINT sp_after_loan;
    UPDATE book_copies
    SET status = 'loaned'
    WHERE copy_id = 198;
  COMMIT;
END;
$$;