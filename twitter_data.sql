-- Twitter Example
-- requires twitter_tables.sql to have been run

begin;

set search_path to aphex_twitter,public;

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
