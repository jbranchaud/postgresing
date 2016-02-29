-- crypto users

begin;

-- need the pgcrypto extension
create extension if not exists pgcrypto;

-- create a table for users with password digest
create table if not exists crypto_users (
  id serial primary key,
  email varchar not null unique,
  password_digest varchar not null
);

-- insert a couple users
insert into crypto_users
(
  email,
  password_digest
)
values
(
  'lizlemon@nbc.com',
  crypt('cheesyblasters', gen_salt('bf'))
);

insert into crypto_users
(
  email,
  password_digest
)
values
(
  'kennethparcell@nbc.com',
  crypt('sonnycrockett', gen_salt('bf'))
);

insert into crypto_users
(
  email,
  password_digest
)
values
(
  'jackdonaghy@nbc.com',
  crypt('reganomics', gen_salt('bf'))
);

-- check some passwords
select
  (password_digest = crypt('cheesyblasters', password_digest)) as password_match 
from crypto_users
where email = 'lizlemon@nbc.com';

select
  (password_digest = crypt('cheesyblasters', password_digest)) as password_match 
from crypto_users
where email = 'kennethparcell@nbc.com';
