CREATE TABLE staff (
    staff_id        integer NOT NULL PRIMARY KEY,
    staff_name      text NOT NULL,
    staff_login     text NOT NULL UNIQUE,
    password_hash   text NOT NULL,
    staff_type      text NOT NULL CHECK (staff_type in ('Instructor / Guard', 'Deck Coordinator', 'Admin'))
);

CREATE TABLE certification_types (
    id              integer GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    cert_name       text UNIQUE NOT NULL
);

CREATE TABLE staff_certifications (
    staff_id        integer NOT NULL references staff (staff_id) ON DELETE CASCADE,
    cert_id         integer NOT NULL references certification_types (id) ON DELETE RESTRICT,
    issued          date NOT NULL,
    expires         date CHECK (expires >= issued),
    PRIMARY KEY (staff_id, cert_id)
);

CREATE TABLE positions (
    id              integer GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    position_name   text UNIQUE NOT NULL
);

CREATE TABLE position_requirements (
    position_id     integer NOT NULL references positions (id) ON DELETE RESTRICT,
    cert_id         integer NOT NULL references certification_types (id) ON DELETE RESTRICT,
    PRIMARY KEY (position_id, cert_id)
); 