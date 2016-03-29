-- A Better Null Display Character
-- https://github.com/jbranchaud/til/blob/master/postgres/a-better-null-display-character.md
-- PostgreSQL Best practices

create table nullable_fields (
  id serial primary key,
  first varchar,
  last varchar
);

insert into nullable_fields (first, last) values ('Bob', 'Burgers');
insert into nullable_fields (first) values ('Gene');
insert into nullable_fields (first, last) values ('', 'Dijkstra')
insert into nullable_fields (last) values ('MacGyver');

table nullable_fields;

-- gross,

\pset null 'Ø'

table nullable_fields;

-- add to .psqlrc