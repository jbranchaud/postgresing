-- valid check constraints

create table boxes (
  id serial primary key,
  length integer not null,
  width integer not null,
  height integer not null
);

alter table boxes add constraint check_valid_length check (length > 0);
alter table boxes add constraint check_valid_width check (width > 0);

insert into boxes (length, width, height) values (1,1,1);
insert into boxes (length, width, height) values (1,1,0);
insert into boxes (length, width, height) values (3,4,5);

alter table boxes add constraint check_valid_height check (height > 0) not valid;
-- \d boxes
--                          Table "public.boxes"
--  Column |  Type   |                     Modifiers
-- --------+---------+----------------------------------------------------
--  id     | integer | not null default nextval('boxes_id_seq'::regclass)
--  length | integer | not null
--  width  | integer | not null
--  height | integer | not null
-- Indexes:
--     "boxes_pkey" PRIMARY KEY, btree (id)
-- Check constraints:
--     "check_valid_height" CHECK (height > 0) NOT VALID
--     "check_valid_length" CHECK (length > 0)
--     "check_valid_width" CHECK (width > 0)

-- not valid to insert after constraint
-- insert into boxes (length, width, height) values (1,1,0);

-- not valid to update after constraint
-- update boxes set height = 0 where id = 3;

-- not valid to validate constraint with conflicting records
-- alter table boxes validate constraint check_valid_height;
-- ERROR:  check constraint "check_valid_height" is violated by some row

-- clear out or fix invalid records
update boxes set height = 2 where id = 2;

-- with a conflict-free table, validate constraint
alter table boxes validate constraint check_valid_height;
-- \d boxes
--                          Table "public.boxes"
--  Column |  Type   |                     Modifiers
-- --------+---------+----------------------------------------------------
--  id     | integer | not null default nextval('boxes_id_seq'::regclass)
--  length | integer | not null
--  width  | integer | not null
--  height | integer | not null
-- Indexes:
--     "boxes_pkey" PRIMARY KEY, btree (id)
-- Check constraints:
--     "check_valid_height" CHECK (height > 0)
--     "check_valid_length" CHECK (length > 0)
--     "check_valid_width" CHECK (width > 0)
