SELECT *
FROM books b
WHERE (
    SELECT COUNT(*)
    FROM loans l
    JOIN book_copies bc ON l.copy_id = bc.copy_id
    WHERE bc.book_id = b.book_id
) > 10;

SELECT *
FROM members m
WHERE NOT EXISTS (
    SELECT 1
    FROM loans l
    WHERE l.member_id = m.member_id
);

SELECT *
FROM book_copies bc
WHERE GREATEST(
    COALESCE((SELECT MAX(loan_date) FROM loans WHERE copy_id = bc.copy_id), '1900-01-01'),
    COALESCE((SELECT MAX(reservation_date) FROM reservations WHERE copy_id = bc.copy_id), '1900-01-01')
) < CURRENT_DATE - INTERVAL '60 days';

WITH loan_counts AS (
    SELECT bc.book_id,
           COUNT(*) AS total_loans
    FROM loans l
    JOIN book_copies bc ON l.copy_id = bc.copy_id
    GROUP BY bc.book_id
)
SELECT b.title, lc.total_loans
FROM loan_counts lc
JOIN books b ON b.book_id = lc.book_id
ORDER BY lc.total_loans DESC
LIMIT 5;

WITH active_res AS (
  SELECT member_id
  FROM reservations
  WHERE status = 'active'
),
res_counts AS (
  SELECT member_id, COUNT(*) AS cnt
  FROM active_res
  GROUP BY member_id
)
SELECT m.full_name, rc.cnt
FROM res_counts rc
JOIN members m ON m.member_id = rc.member_id
ORDER BY rc.cnt DESC;

SELECT member_id, full_name, 'loan' AS activity
FROM members
WHERE member_id IN (SELECT DISTINCT member_id FROM loans)
UNION
SELECT member_id, full_name, 'reservation' AS activity
FROM members
WHERE member_id IN (SELECT DISTINCT member_id FROM reservations);

SELECT member_id
FROM loans
INTERSECT
SELECT member_id
FROM reservations;

SELECT member_id
FROM reservations
EXCEPT
SELECT member_id
FROM loans;

SELECT
  l.loan_id,
  l.member_id,
  l.loan_date,
  ROW_NUMBER() OVER (PARTITION BY l.member_id ORDER BY l.loan_date) AS rn
FROM loans l;

SELECT
  b.book_id,
  b.title,
  COUNT(*) AS total_loans,
  RANK() OVER (ORDER BY COUNT(*) DESC) AS loan_rank
FROM loans l
JOIN book_copies bc ON l.copy_id = bc.copy_id
JOIN books b ON bc.book_id = b.book_id
GROUP BY b.book_id, b.title;

SELECT
  loan_id,
  member_id,
  loan_date,
  LAG(loan_date) OVER (PARTITION BY member_id ORDER BY loan_date) AS prev_loan_date
FROM loans;

SELECT
  l.loan_id,
  bc.book_id,
  l.loan_date,
  l.due_date,
  LEAD(due_date) OVER (PARTITION BY bc.book_id ORDER BY l.loan_date) AS next_due_date
FROM loans l
JOIN book_copies bc ON l.copy_id = bc.copy_id;