-- A Better Null Display Character
-- https://github.com/jbranchaud/til/blob/master/postgres/a-better-null-display-character.md
-- PostgreSQL Best practices

create table nullable_fields (
  id serial primary key,
  first varchar,
  last varchar
);

insert into nullable_fields (first, last) values ('John', 'McCarthy');
insert into nullable_fields (first) values ('Ada');
insert into nullable_fields (first, last) values ('', 'Dijkstra');
insert into nullable_fields (last) values ('Curry');

table nullable_fields;

-- gross,

\pset null 'Ø'

table nullable_fields;

-- add to .psqlrc