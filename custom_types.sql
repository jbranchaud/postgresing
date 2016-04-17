create type dimensions as (
  width integer,
  height integer,
  depth integer
);

create table moving_boxes (
  id serial primary key,
  dims dimensions not null
);

insert into moving_boxes (dims) values (row(3,4,5)::dimensions);
insert into moving_boxes (dims) values (row(10,10,5));
insert into moving_boxes (dims) values (row(11,11,11));

table moving_boxes;
select (dims).width from moving_boxes;
select (dims).width from moving_boxes where (dims)depth > 10;
