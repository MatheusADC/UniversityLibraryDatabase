CREATE DATABASE sistema_biblioteca_universitaria;

CREATE TABLE authors (
    author_id       SERIAL PRIMARY KEY,
    first_name      VARCHAR(50) NOT NULL,
    last_name       VARCHAR(50) NOT NULL,
    birth_date      DATE
);

CREATE TABLE publishers (
    publisher_id   SERIAL PRIMARY KEY,
    name           VARCHAR(100) NOT NULL UNIQUE,
    address        TEXT
);

CREATE TABLE genres (
    genre_id       SERIAL PRIMARY KEY,
    name           VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE books (
    book_id        SERIAL PRIMARY KEY,
    title          VARCHAR(200) NOT NULL,
    author_id      INT NOT NULL REFERENCES authors(author_id),
    publisher_id   INT NOT NULL REFERENCES publishers(publisher_id),
    genre_id       INT NOT NULL REFERENCES genres(genre_id),
    pub_year       INT,
    isbn           CHAR(13) UNIQUE
);

CREATE TABLE library_branches (
    branch_id      SERIAL PRIMARY KEY,
    name           VARCHAR(100) NOT NULL,
    address        TEXT
);

CREATE TABLE book_copies (
    copy_id        SERIAL PRIMARY KEY,
    book_id        INT NOT NULL REFERENCES books(book_id),
    branch_id      INT NOT NULL REFERENCES library_branches(branch_id),
    status         VARCHAR(20) NOT NULL DEFAULT 'available'
);

CREATE TABLE members (
    member_id          SERIAL PRIMARY KEY,
    full_name          VARCHAR(100) NOT NULL,
    email              VARCHAR(100) UNIQUE NOT NULL,
    phone              VARCHAR(20),
    membership_start   DATE NOT NULL,
    membership_end     DATE
);

CREATE TABLE loans (
    loan_id        SERIAL PRIMARY KEY,
    copy_id        INT NOT NULL REFERENCES book_copies(copy_id),
    member_id      INT NOT NULL REFERENCES members(member_id),
    loan_date      TIMESTAMP NOT NULL DEFAULT now(),
    due_date       DATE NOT NULL,
    return_date    DATE
);

CREATE TABLE reservations (
    reservation_id    SERIAL PRIMARY KEY,
    copy_id           INT NOT NULL REFERENCES book_copies(copy_id),
    member_id         INT NOT NULL REFERENCES members(member_id),
    reservation_date  TIMESTAMP NOT NULL DEFAULT now(),
    status            VARCHAR(20) NOT NULL DEFAULT 'active'
);

CREATE TABLE librarians (
    librarian_id   SERIAL PRIMARY KEY,
    full_name      VARCHAR(100) NOT NULL,
    email          VARCHAR(100) UNIQUE NOT NULL,
    branch_id      INT NOT NULL REFERENCES library_branches(branch_id)
);

INSERT INTO authors (first_name, last_name, birth_date)
SELECT
    'AuthorFirst' || i,
    'AuthorLast' || i,
    DATE '1950-01-01' + (floor(random() * 20000)::int || ' days')::interval
FROM generate_series(1,50) AS s(i);

INSERT INTO publishers (name, address)
SELECT
    'Publisher ' || i,
    (i || ' Publisher St, City ' || i)
FROM generate_series(1,20) AS s(i);

INSERT INTO genres (name)
VALUES
    ('Fiction'),
    ('Non-Fiction'),
    ('Sci-Fi'),
    ('Fantasy'),
    ('Mystery'),
    ('Romance'),
    ('Biography'),
    ('History'),
    ('Science'),
    ('Art');

INSERT INTO books (title, author_id, publisher_id, genre_id, pub_year, isbn)
SELECT
    'Book Title ' || i,
    (floor(random() * 50) + 1)::int,
    (floor(random() * 20) + 1)::int,
    (floor(random() * 10) + 1)::int,
    (floor(random() * (2025-1950)) + 1950)::int,
    lpad((floor(random() * 1e13))::bigint::text, 13, '0')
FROM generate_series(1,300) AS s(i);

INSERT INTO library_branches (name, address)
VALUES
    ('Central Library', '123 Main St'),
    ('East Branch', '456 East Ave'),
    ('West Branch', '789 West Blvd');

INSERT INTO book_copies (book_id, branch_id, status)
SELECT
    (floor(random() * 300) + 1)::int,
    (floor(random() * 3) + 1)::int,
    (ARRAY['available','loaned','reserved','lost'])[ceil(random() * 4)]
FROM generate_series(1,1000) AS s(i);

INSERT INTO members (full_name, email, phone, membership_start, membership_end)
SELECT
    'Member ' || i,
    'member' || i || '@uni.edu',
    '555-01' || lpad(i::text, 3, '0'),
    current_date - ((floor(random() * 365))::int || ' days')::interval,
    current_date + ((365 - floor(random() * 30))::int || ' days')::interval
FROM generate_series(1,200) AS s(i);

INSERT INTO loans (copy_id, member_id, loan_date, due_date, return_date)
SELECT
    (floor(random() * 1000) + 1)::int,
    (floor(random() * 200) + 1)::int,
    now() - ((floor(random() * 365))::int || ' days')::interval AS loan_date,
    (now() - ((floor(random() * 365))::int || ' days')::interval) + INTERVAL '14 days' AS due_date,
    CASE
        WHEN random() < 0.8 THEN
            (now() - ((floor(random() * 365))::int || ' days')::interval)
            + ((-5 + floor(random() * 15))::int || ' days')::interval
        ELSE
            NULL
    END
FROM generate_series(1,1200) AS s(i);

INSERT INTO reservations (copy_id, member_id, reservation_date, status)
SELECT
    (floor(random() * 1000) + 1)::int,
    (floor(random() * 200) + 1)::int,
    now() - ((floor(random() * 365))::int || ' days')::interval,
    (ARRAY['active','fulfilled','cancelled'])[ceil(random() * 3)]
FROM generate_series(1,400) AS s(i);

INSERT INTO librarians (full_name, email, branch_id)
SELECT
    'Librarian ' || i,
    'librarian' || i || '@uni.edu',
    (floor(random() * 3) + 1)::int
FROM generate_series(1,10) AS s(i);
