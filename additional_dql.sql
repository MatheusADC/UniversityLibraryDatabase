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