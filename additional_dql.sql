SELECT *
FROM loans
WHERE return_date IS NULL
    AND due_date < CURRENT_DATE;

SELECT b.title, g.name AS genre
FROM books b
JOIN genres g USING(genre_id)
WHERE b.genre_id IN (3,4,5);

SELECT *
FROM reservations
WHERE reservation_date BETWEEN '2025-06-01' AND '2025-06-30'
    OR status = 'active';

SELECT *
FROM members
WHERE (full_name ILIKE '%Ana%' OR email LIKE '%@uni.edu')
    AND phone IS NOT NULL;

SELECT *
FROM books
WHERE genre_id <> 1
    AND pub_year BETWEEN 1990 AND 2000;

SELECT *
FROM authors
WHERE last_name ILIKE 'Pe%'
    AND birth_date IS NOT NULL;

SELECT *
FROM members
WHERE membership_end > CURRENT_DATE
    OR membership_end IS NULL;

SELECT *
FROM book_copies
WHERE branch_id IN (1,3)
    AND status <> 'available';

SELECT *
FROM loans
WHERE return_date IS NULL
    AND due_date < CURRENT_DATE - INTERVAL '7 days';

SELECT *
FROM books
WHERE title ILIKE '%data%'
    OR title ILIKE '%science%';

SELECT *
FROM reservations
WHERE status NOT IN ('fulfilled','cancelled');

SELECT b.*
FROM books b
WHERE EXISTS (
    SELECT 1
    FROM book_copies bc
    WHERE bc.book_id = b.book_id
        AND bc.status = 'lost'
);

SELECT m.*
FROM members m
WHERE NOT EXISTS (
    SELECT 1
    FROM books b
    WHERE b.author_id = 5
        AND NOT EXISTS (
            SELECT 1
            FROM loans l
            JOIN book_copies bc ON bc.copy_id = l.copy_id
            WHERE bc.book_id = b.book_id
                AND l.member_id = m.member_id
        )
);

SELECT *
FROM librarians
WHERE branch_id = ANY(ARRAY[2,3,4]);

SELECT *
FROM books
WHERE isbn LIKE '9780%'
    AND pub_year > 2010;

SELECT *
FROM publishers
WHERE address LIKE '%Av.%'
    AND (is_active IS TRUE OR is_active IS NULL);

SELECT *
FROM loans
WHERE EXTRACT(DOW FROM loan_date) IN (0,6);

SELECT r.*
FROM reservations r
JOIN members m USING (member_id)
WHERE r.reservation_date >= (CURRENT_DATE - INTERVAL '1 month')
    AND m.email LIKE '%.edu';

SELECT *
FROM books
WHERE title NOT LIKE '% %';

SELECT b.title,
       COUNT(*) AS total_loans
FROM loans l
JOIN book_copies bc USING(copy_id)
JOIN books b        USING(book_id)
GROUP BY b.title
ORDER BY total_loans DESC;

SELECT MIN(loan_date) AS first_loan,
       MAX(loan_date) AS last_loan
FROM loans;

SELECT AVG((due_date - loan_date)) AS avg_loan_duration_days
FROM loans
WHERE return_date IS NOT NULL;

SELECT SUM(
    CASE WHEN status = 'active' THEN 1 ELSE 0 END
) AS total_active_reservations
FROM reservations;

SELECT b.title,
       COUNT(*) AS times_loaned
FROM loans l
JOIN book_copies bc USING(copy_id)
JOIN books b        USING(book_id)
GROUP BY b.title
ORDER BY times_loaned DESC
LIMIT 5;

SELECT m.full_name,
       COUNT(r.*) AS reservations_count
FROM members m
LEFT JOIN reservations r USING(member_id)
GROUP BY m.full_name
ORDER BY reservations_count DESC;

SELECT lb.name,
       COUNT(*) AS available_copies
FROM book_copies bc
JOIN library_branches lb USING(branch_id)
WHERE bc.status = 'available'
GROUP BY lb.name
ORDER BY available_copies DESC;
