-- Twitter Example
-- Tables:
-- - users
-- - tweets
-- - pinned_tweets

begin;

create schema if not exists aphex_twitter;
set search_path to aphex_twitter,public;

-- we have users
create table users (
  handle varchar primary key,
  name varchar not null,
  bio varchar not null default '',
  created_at timestamptz not null default now()
);

-- we have tweets
create table tweets (
  id serial primary key,
  content varchar not null,
  user_handle varchar references users (handle),
  created_at timestamptz not null default now(),
  unique (id, user_handle)
);

-- each user can have a pinned tweet, but doesn't have to have one
create table pinned_tweets (
  tweet_id integer not null,
  user_handle varchar not null,
  pinned_at timestamptz not null default now(),
  primary key (user_handle),
  foreign key (tweet_id, user_handle) references tweets (id, user_handle)
);

-- create a couple users
insert into users (handle, name) values ('lizlemon', 'Liz Lemon');
insert into users (handle, name) values ('jack', 'Jack Donaghy');
insert into users (handle, name) values ('tracy', 'Tracy Jordan');

-- create some tweets for those users
insert into tweets (user_handle, content)
  values ('lizlemon', 'Why are my arms so weak? It’s like I did that push-up last year for nothing!');
insert into tweets (user_handle, content)
  values ('lizlemon', 'I love America. Just because I think gay dudes should be allowed to adopt kids and we should all have hybrid cars doesn’t mean I don’t love America.');
insert into tweets (user_handle, content)
  values ('jack', 'There are no bad ideas, @lizlemon. Only good ideas that go horribly wrong.');
insert into tweets (user_handle, content)
  values ('tracy', 'So, here’s some advice I wish I woulda got when I was your age: Live every week like it’s Shark Week.');
insert into tweets (user_handle, content)
  values ('jack', 'Human empathy. It’s as useless as the Winter Olympics.');
insert into tweets (user_handle, content)
  values ('tracy', 'Stop eating people’s old french fries, pigeon! Have some self respect! Don’t you know you can fly?');

select * from tweets;
select * from tweets where user_handle = 'lizlemon';

select id, user_handle from tweets;
--   id | user_handle
--  ----+-------------
--    1 | lizlemon
--    2 | lizlemon
--    3 | jack
--    4 | tracy
--    5 | jack
--    6 | tracy

-- pin some tweets
insert into pinned_tweets (tweet_id, user_handle)
select id, user_handle from tweets
where user_handle = 'lizlemon'
order by created_at desc
limit 1;

insert into pinned_tweets (tweet_id, user_handle)
select id, user_handle from tweets
where user_handle = 'jack'
order by created_at desc
limit 1;

select * from pinned_tweets;
--   tweet_id | user_handle |           pinned_at
--  ----------+-------------+-------------------------------
--          1 | lizlemon    | 2016-01-09 13:26:32.832481-06
--          3 | jack        | 2016-01-09 13:26:32.832481-06

-- now we want to update the tweet pinned by jack from 3 to 5
update pinned_tweets
set (tweet_id, pinned_at) = (5, clock_timestamp())
where user_handle = 'jack';

select * from pinned_tweets;
--   tweet_id | user_handle |           pinned_at
--  ----------+-------------+-------------------------------
--          1 | lizlemon    | 2016-01-09 13:34:00.585644-06
--          5 | jack        | 2016-01-09 13:34:00.610894-06

-- now we want to update the tweet pinned by tracy
-- we can try to do an update, but it won't update any rows because there is
-- no existing row for 'tracy' at this point.
-- update pinned_tweets set (tweet_id, pinned_at) = (6, clock_timestamp())
-- where user_handle = 'tracy';
-- UPDATE 0
insert into pinned_tweets (tweet_id, user_handle, pinned_at)
values (6, 'tracy', clock_timestamp());

select * from pinned_tweets;
--   tweet_id | user_handle |           pinned_at
--  ----------+-------------+-------------------------------
--          1 | lizlemon    | 2016-01-09 15:33:21.35631-06
--          5 | jack        | 2016-01-09 15:33:21.382326-06
--          6 | tracy       | 2016-01-09 15:33:21.382885-06

-- Let's unpin lizlemon's tweet now.
delete from pinned_tweets where user_handle = 'lizlemon';

select * from pinned_tweets;
--   tweet_id | user_handle |           pinned_at
--  ----------+-------------+-------------------------------
--          5 | jack        | 2016-01-09 15:52:23.096699-06
--          6 | tracy       | 2016-01-09 15:52:23.097216-06

-- In general, our application code won't know if we are dealing with a user
-- that already has a pinned_tweet or a user with no pinned tweet. If it is
-- a user with no pinned tweet, then we need to do an insert. If it is a
-- user with a pinned tweet, then we need to do an update. Either way we'll
-- have to query the pinned_tweets table to check.
select * from pinned_tweets where user_handle = 'lizlemon';
-- If the result set is empty, we do an insert. If the result set has
-- something, then we will do an update.

-- Fortunately, with the addition of the *upsert* functionality in
-- PostgreSQL 9.5, we can collapse this situation into a single statement.
-- By using `insert ... on conflict ...` we are able to handle both
-- insert and update.
insert into pinned_tweets (tweet_id, user_handle, pinned_at)
values (1, 'lizlemon', clock_timestamp())
on conflict (user_handle)
do update set (tweet_id, pinned_at) = (1, clock_timestamp())
where pinned_tweets.user_handle = 'lizlemon';

select * from pinned_tweets;
--   tweet_id | user_handle |           pinned_at
--  ----------+-------------+-------------------------------
--          5 | jack        | 2016-01-09 16:00:05.190022-06
--          6 | tracy       | 2016-01-09 16:00:05.190529-06
--          1 | lizlemon    | 2016-01-09 16:00:05.191596-06

-- We can use the same statement to update the pinned_tweet for 'lizlemon'
insert into pinned_tweets (tweet_id, user_handle, pinned_at)
values (2, 'lizlemon', clock_timestamp())
on conflict (user_handle)
do update set (tweet_id, pinned_at) = (2, clock_timestamp())
where pinned_tweets.user_handle = 'lizlemon';

select * from pinned_tweets;
