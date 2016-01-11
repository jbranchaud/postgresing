-- Twitter Example
-- requires twitter_tables.sql and twitter_data.sql to have been run

begin;

-- for 'lizlemon' who already has an entry in pinned_tweets

select * from pinned_tweets where user_handle = 'lizlemon';

with upsert as (
  update pinned_tweets
  set (tweet_id, pinned_at) = (2, clock_timestamp())
  where user_handle = 'lizlemon'
  returning *
)
insert into pinned_tweets (user_handle, tweet_id, pinned_at)
select 'lizlemon', 2, clock_timestamp()
where not exists (
  select 1
  from upsert
  where upsert.user_handle = 'lizlemon'
);

select * from pinned_tweets where user_handle = 'lizlemon';


-- for 'tracy' who already has an entry in pinned_tweets

select * from pinned_tweets where user_handle = 'tracy';

with upsert as (
  update pinned_tweets
  set (tweet_id, pinned_at) = (6, clock_timestamp())
  where user_handle = 'tracy'
  returning *
)
insert into pinned_tweets (user_handle, tweet_id, pinned_at)
select 'tracy', 6, clock_timestamp()
where not exists (
  select 1
  from upsert
  where upsert.user_handle = 'tracy'
);

select * from pinned_tweets where user_handle = 'tracy';
