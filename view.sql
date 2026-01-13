CREATE VIEW available_copies_per_branch AS
SELECT
  lb.name        AS branch,
  b.title,
  COUNT(*)       AS available_count
FROM book_copies bc
JOIN books b USING(book_id)
JOIN library_branches lb USING(branch_id)
WHERE bc.status = 'available'
GROUP BY lb.name, b.title;

SELECT * FROM available_copies_per_branch
WHERE available_count > 5
ORDER BY branch, available_count DESC;

CREATE TEMP TABLE today_loan_stats AS
SELECT
  COUNT(*)                      AS total_loans,
  COUNT(DISTINCT member_id)     AS distinct_members,
  MIN(loan_date)                AS first_loan,
  MAX(loan_date)                AS last_loan
FROM loans
WHERE loan_date::date = CURRENT_DATE;

SELECT * FROM today_loan_stats;