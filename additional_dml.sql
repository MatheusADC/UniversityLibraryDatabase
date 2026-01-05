INSERT INTO authors (first_name, last_name, birth_date)
VALUES ('João', 'Silva', '1975-04-12');

INSERT INTO authors (first_name, last_name, birth_date)
VALUES ('Maria', 'Oliveira', '1980-11-30');

UPDATE authors
SET last_name = 'Pereira'
WHERE author_id = 1;

DELETE FROM authors
WHERE author_id = 2;

SELECT * FROM books;

DELETE FROM books
WHERE author_id = 2;

SELECT * FROM book_copies;

INSERT INTO books (title, author_id, publisher_id, genre_id, pub_year, isbn)
VALUES ('Aprendendo SQL', 1, 1, 3, 2021, '9781234567890');

INSERT INTO books (title, author_id, publisher_id, genre_id, pub_year, isbn)
VALUES ('Design Patterns', 3, 2, 1, 2018, '9780987654321');

INSERT INTO loans (copy_id, member_id, loan_date, due_date, return_date)
VALUES (1, 1, NOW(), CURRENT_DATE + INTERVAL '14 days', NULL);

INSERT INTO loans (copy_id, member_id, loan_date, due_date, return_date)
VALUES (3, 1, NOW() - INTERVAL '7 days', CURRENT_DATE + INTERVAL '7 days', NULL);