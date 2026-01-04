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