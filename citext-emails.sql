-- user emails with citext

begin;

create extension if not exists citext;

create table citext_emails (
  id serial primary key,
  email citext not null unique
);
-- \d citext_emails
--                          Table "public.citext_emails"
--  Column |  Type   |                         Modifiers
-- --------+---------+------------------------------------------------------------
--  id     | integer | not null default nextval('citext_emails_id_seq'::regclass)
--  email  | citext  | not null
-- Indexes:
--     "citext_emails_pkey" PRIMARY KEY, btree (id)
--     "citext_emails_email_key" UNIQUE CONSTRAINT, btree (email)

insert into citext_emails (email)
values
  ('LizLemon@nbc.com'),
  ('kennethparcell@nbc.com'),
  ('JACK_DONAGHY@NBC.COM')
;

select * from citext_emails where email = 'lizlemon@nbc.com';
--  id |      email
-- ----+------------------
--   1 | LizLemon@nbc.com

select * from citext_emails where email like '%donaghy%';
--  id |        email
-- ----+----------------------
--   3 | JACK_DONAGHY@NBC.COM

--insert into citext_emails (email) values ('KENNETHparcell@nbc.COM');
-- ERROR:  duplicate key value violates unique constraint "citext_emails_email_key"
-- DETAIL:  Key (email)=(KENNETHparcell@nbc.COM) already exists.
