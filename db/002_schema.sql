CREATE TABLE shifts (
    id          integer GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    shift_start timestamptz NOT NULL,
    shift_end   timestamptz NOT NULL CHECK (shift_end > shift_start)
    position    integer NOT NULL references position (position_id) ON DELETE RESTRICT
);

CREATE TABLE assignments (
    staff_id    integer NOT NULL references staff (staff_id) ON DELETE CASCADE,
    shift_id    integer NOT NULL references shifts (id) ON DELETE CASCADE,
    PRIMARY KEY (staff_id, shift_id)
);