-- ilike vs lower
-- how to the relative performances of using ilike and lower() for comparing
-- case-insensitive text compare?


-- create a users table with a bunch of records
create table users (
  id serial primary key,
  email text not null unique
);
insert into users (email)
select
  (case (random() * 2)::integer
    when 0 then 'Person'
    when 1 then 'PERSON'
    when 2 then 'person'
  end) || num || '@example.com'
from generate_series(1,10000) as num;


-- find a user
select * from users where email = 'person5000@example.com';
explain analyze select * from users where email = 'person5000@example.com';
-- -[ RECORD 1 ]----------------------------------------------------------------------------------------------------------------------
-- QUERY PLAN | Index Scan using users_email_key on users  (cost=0.29..8.30 rows=1 width=36) (actual time=0.047..0.047 rows=0 loops=1)
-- -[ RECORD 2 ]----------------------------------------------------------------------------------------------------------------------
-- QUERY PLAN |   Index Cond: (email = 'person5000@example.com'::text)
-- -[ RECORD 3 ]----------------------------------------------------------------------------------------------------------------------
-- QUERY PLAN | Planning time: 0.105 ms
-- -[ RECORD 4 ]----------------------------------------------------------------------------------------------------------------------
-- QUERY PLAN | Execution time: 0.082 ms

select * from users where lower(email) = lower('person5000@example.com');
explain analyze select * from users where lower(email) = lower('person5000@example.com');
--                                              QUERY PLAN
-- ----------------------------------------------------------------------------------------------------
--  Seq Scan on users  (cost=0.00..224.00 rows=50 width=26) (actual time=6.723..12.488 rows=1 loops=1)
--    Filter: (lower(email) = 'person5000@example.com'::text)
--    Rows Removed by Filter: 9999
--  Planning time: 0.124 ms
--  Execution time: 12.521 ms

select * from users where email ilike 'person5000@example.com';
explain analyze select * from users where email ilike 'person5000@example.com';
--                                             QUERY PLAN
-- ---------------------------------------------------------------------------------------------------
--  Seq Scan on users  (cost=0.00..199.00 rows=1 width=26) (actual time=9.783..17.518 rows=1 loops=1)
--    Filter: (email ~~* 'person5000@example.com'::text)
--    Rows Removed by Filter: 9999
--  Planning time: 0.291 ms
--  Execution time: 17.550 ms


-- index the lower function
create unique index users_lower_email_idx on users (lower(email));


-- find a user
select * from users where email = 'person5000@example.com';
explain analyze select * from users where email = 'person5000@example.com';
-- -[ RECORD 1 ]----------------------------------------------------------------------------------------------------------------------
-- QUERY PLAN | Index Scan using users_email_key on users  (cost=0.29..8.30 rows=1 width=26) (actual time=0.049..0.049 rows=0 loops=1)
-- -[ RECORD 2 ]----------------------------------------------------------------------------------------------------------------------
-- QUERY PLAN |   Index Cond: (email = 'person5000@example.com'::text)
-- -[ RECORD 3 ]----------------------------------------------------------------------------------------------------------------------
-- QUERY PLAN | Planning time: 0.121 ms
-- -[ RECORD 4 ]----------------------------------------------------------------------------------------------------------------------
-- QUERY PLAN | Execution time: 0.081 ms

select * from users where lower(email) = lower('person5000@example.com');
explain analyze select * from users where lower(email) = lower('person5000@example.com');
-- -[ RECORD 1 ]----------------------------------------------------------------------------------------------------------------------------
-- QUERY PLAN | Index Scan using users_lower_email_idx on users  (cost=0.29..8.30 rows=1 width=26) (actual time=0.048..0.049 rows=1 loops=1)
-- -[ RECORD 2 ]----------------------------------------------------------------------------------------------------------------------------
-- QUERY PLAN |   Index Cond: (lower(email) = 'person5000@example.com'::text)
-- -[ RECORD 3 ]----------------------------------------------------------------------------------------------------------------------------
-- QUERY PLAN | Planning time: 0.130 ms
-- -[ RECORD 4 ]----------------------------------------------------------------------------------------------------------------------------
-- QUERY PLAN | Execution time: 0.078 ms

select * from users where email ilike 'person5000@example.com';
explain analyze select * from users where email ilike 'person5000@example.com';
--                                              QUERY PLAN
-- ----------------------------------------------------------------------------------------------------
--  Seq Scan on users  (cost=0.00..199.00 rows=1 width=26) (actual time=10.063..18.333 rows=1 loops=1)
--    Filter: (email ~~* 'person5000@example.com'::text)
--    Rows Removed by Filter: 9999
--  Planning time: 0.300 ms
--  Execution time: 18.363 ms
