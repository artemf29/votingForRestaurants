DROP TABLE votes IF EXISTS;
DROP TABLE user_roles IF EXISTS;
DROP TABLE dishes IF EXISTS;
DROP TABLE menus IF EXISTS;
DROP TABLE restaurants IF EXISTS;
DROP TABLE users IF EXISTS;
DROP SEQUENCE global_seq IF EXISTS;

CREATE SEQUENCE GLOBAL_SEQ AS INTEGER START WITH 100000;

CREATE TABLE users
(
    id         INTEGER GENERATED BY DEFAULT AS SEQUENCE GLOBAL_SEQ PRIMARY KEY,
    name       VARCHAR(255)            NOT NULL,
    email      VARCHAR(255)            NOT NULL,
    password   VARCHAR(255)            NOT NULL,
    registered TIMESTAMP DEFAULT now() NOT NULL,
    enabled    BOOLEAN   DEFAULT TRUE  NOT NULL
);
CREATE UNIQUE INDEX users_unique_email_idx
    ON USERS (email);

CREATE TABLE user_roles
(
    user_id INTEGER NOT NULL,
    role    VARCHAR(255),
    CONSTRAINT user_roles_unique_idx UNIQUE (user_id, role),
    FOREIGN KEY (user_id) REFERENCES USERS (id) ON DELETE CASCADE
);

CREATE TABLE restaurants
(
    id   INTEGER GENERATED BY DEFAULT AS SEQUENCE GLOBAL_SEQ PRIMARY KEY,
    name VARCHAR(255) NOT NULL
);
CREATE UNIQUE INDEX restaurant_unique_name_idx
    ON RESTAURANTS (name);

CREATE TABLE menus
(
    id      INTEGER GENERATED BY DEFAULT AS SEQUENCE GLOBAL_SEQ PRIMARY KEY,
    date    DATE DEFAULT now() NOT NULL,
    rest_id INTEGER            NOT NULL,
    CONSTRAINT rest_unique_menu_date_idx UNIQUE (rest_id, date),
    FOREIGN KEY (rest_id) REFERENCES RESTAURANTS (id) ON DELETE CASCADE
);

CREATE TABLE dishes
(
    id          INTEGER GENERATED BY DEFAULT AS SEQUENCE GLOBAL_SEQ PRIMARY KEY,
    name        VARCHAR(255)                          NOT NULL,
    price       INT                                   NOT NULL,
    description VARCHAR(255) DEFAULT 'No description' NOT NULL,
    menu_id     INTEGER                               NOT NULL,
    CONSTRAINT menu_unique_dish_name_idx UNIQUE (menu_id, name),
    FOREIGN KEY (menu_id) REFERENCES MENUS (id) ON DELETE CASCADE
);

CREATE TABLE votes
(
    id        INTEGER GENERATED BY DEFAULT AS SEQUENCE GLOBAL_SEQ PRIMARY KEY,
    vote_date DATE DEFAULT now() NOT NULL,
    user_id   INTEGER            NOT NULL,
    rest_id   INTEGER            NOT NULL,
    CONSTRAINT vote_unique_date_user_idx UNIQUE (user_id, vote_date),
    FOREIGN KEY (user_id) REFERENCES USERS (id) ON DELETE CASCADE,
    FOREIGN KEY (rest_id) REFERENCES RESTAURANTS (id) ON DELETE CASCADE
);