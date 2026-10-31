CREATE EXTENSION IF NOT EXISTS btree_gist;

CREATE TABLE pools (
    id      integer GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    pool_name   text NOT NULL UNIQUE
);

CREATE TABLE shifts (
    id              integer GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    shift_start     timestamptz NOT NULL,
    shift_end       timestamptz NOT NULL CHECK (shift_end > shift_start),

    position        integer NOT NULL references positions (id) ON DELETE RESTRICT,
    staff_quantity  integer NOT NULL CHECK (staff_quantity > 0),
    pool_id         integer NOT NULL references pools (id) ON DELETE RESTRICT,

    active          BOOLEAN NOT NULL DEFAULT TRUE,

    UNIQUE (id, shift_start, shift_end, active)
);

CREATE TABLE assignments (
    staff_id        integer NOT NULL references staff (staff_id) ON DELETE RESTRICT,
    shift_id        integer NOT NULL,
    shift_start     timestamptz NOT NULL,
    shift_end       timestamptz NOT NULL,
    shift_active    BOOLEAN NOT NULL,

    PRIMARY KEY (staff_id, shift_id),

    FOREIGN KEY (shift_id, shift_start, shift_end, shift_active)
        REFERENCES shifts (id, shift_start, shift_end, active)
        ON UPDATE CASCADE ON DELETE CASCADE,

    EXCLUDE USING gist (staff_id WITH =, tstzrange(shift_start, shift_end) WITH &&)
        WHERE (shift_active)
);