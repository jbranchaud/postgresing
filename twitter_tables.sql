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
