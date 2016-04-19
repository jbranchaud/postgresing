create table users (
  id serial primary key,
  email varchar not null
);

-- \d users;
--                               Table "public.users"
--  Column |       Type        |                     Modifiers
-- --------+-------------------+----------------------------------------------------
--  email  | character varying | not null
--  id     | integer           | not null default nextval('users_id_seq'::regclass)
-- Indexes:
--     "users_pkey" PRIMARY KEY, btree (id)

with emails as (
  select 'person' || num || '@example.com'
  from generate_series(1,10000) as num
)
insert into users (email)
select * from emails;

select count(email) from users;
--  count
-- -------
--  10000

-- full sequential scan
explain analyze select * from users where email = 'person1@example.com';
--                                             QUERY PLAN
-- --------------------------------------------------------------------------------------------------
--  Seq Scan on users  (cost=0.00..199.00 rows=1 width=26) (actual time=0.015..2.922 rows=1 loops=1)
--    Filter: ((email)::text = 'person1@example.com'::text)
--    Rows Removed by Filter: 9999
--  Planning time: 0.203 ms
--  Execution time: 2.948 ms

create unique index email_idx on users (email);

-- \d users
--                               Table "public.users"
--  Column |       Type        |                     Modifiers
-- --------+-------------------+----------------------------------------------------
--  email  | character varying | not null
--  id     | integer           | not null default nextval('users_id_seq'::regclass)
-- Indexes:
--     "users_pkey" PRIMARY KEY, btree (id)
--     "email_idx" UNIQUE, btree (email)

-- index scan instead of full sequential scan
explain analyze select * from users where email = 'person1@example.com';
-- -[ RECORD 1 ]----------------------------------------------------------------------------------------------------------------
-- QUERY PLAN | Index Scan using email_idx on users  (cost=0.29..8.30 rows=1 width=26) (actual time=0.043..0.043 rows=1 loops=1)
-- -[ RECORD 2 ]----------------------------------------------------------------------------------------------------------------
-- QUERY PLAN |   Index Cond: ((email)::text = 'person1@example.com'::text)
-- -[ RECORD 3 ]----------------------------------------------------------------------------------------------------------------
-- QUERY PLAN | Planning time: 0.254 ms
-- -[ RECORD 4 ]----------------------------------------------------------------------------------------------------------------
-- QUERY PLAN | Execution time: 0.069 ms

-- Using a function like lower() makes it so that the index cannot be used
-- full sequential scan
explain analyze select * from users where lower(email) = lower('person1@example.com');
--                                              QUERY PLAN
-- ----------------------------------------------------------------------------------------------------
--  Seq Scan on users  (cost=0.00..224.00 rows=50 width=26) (actual time=0.021..11.474 rows=1 loops=1)
--    Filter: (lower((email)::text) = 'person1@example.com'::text)
--    Rows Removed by Filter: 9999
--  Planning time: 0.104 ms
--  Execution time: 11.500 ms

-- let's get a better index
drop index email_idx;
create unique index email_idx on users (lower(email));
-- \d users
--                               Table "public.users"
--  Column |       Type        |                     Modifiers
-- --------+-------------------+----------------------------------------------------
--  id     | integer           | not null default nextval('users_id_seq'::regclass)
--  email  | character varying | not null
-- Indexes:
--     "users_pkey" PRIMARY KEY, btree (id)
--     "email_idx" UNIQUE, btree (lower(email::text))

explain analyze select * from users where lower(email) = lower('person1@example.com');
-- -[ RECORD 1 ]----------------------------------------------------------------------------------------------------------------
-- QUERY PLAN | Index Scan using email_idx on users  (cost=0.29..8.30 rows=1 width=26) (actual time=0.074..0.075 rows=1 loops=1)
-- -[ RECORD 2 ]----------------------------------------------------------------------------------------------------------------
-- QUERY PLAN |   Index Cond: (lower((email)::text) = 'person1@example.com'::text)
-- -[ RECORD 3 ]----------------------------------------------------------------------------------------------------------------
-- QUERY PLAN | Planning time: 0.162 ms
-- -[ RECORD 4 ]----------------------------------------------------------------------------------------------------------------
-- QUERY PLAN | Execution time: 0.104 ms
