create table some_funs(id serial primary key, name varchar not null, code varchar);
-- CREATE TABLE
-- Time: 67.086 ms

insert into some_funs (name, code) values ('josh', '123');
-- INSERT 0 1
-- Time: 5.599 ms

insert into some_funs (name, code) values ('josh', null);
-- INSERT 0 1
-- Time: 2.086 ms

create unique index only_one_null_per_person
  on some_funs(name)
  where (code is null);
-- CREATE INDEX
-- Time: 6.172 ms

insert into some_funs (name, code) values ('josh', null);
-- ERROR:  duplicate key value violates unique constraint "only_one_null_per_person"
-- DETAIL:  Key (name)=(josh) already exists.
-- Time: 0.973 ms

insert into some_funs (name, code) values ('josh', '456');
-- INSERT 0 1
-- Time: 2.116 ms
