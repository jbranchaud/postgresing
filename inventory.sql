-- Game Inventory

begin;

create schema if not exists aphex_inventory;
set search_path to aphex_inventory,public;

create table characters (
  id serial primary key,
  name varchar not null,
  level integer not null default 1
);

create table items (
  id serial primary key,
  name varchar not null,
  worth integer not null default 1
);

create table characters_items (
  character_id integer not null references characters (id),
  item_id integer not null references items (id),
  quantity integer not null,
  primary key (character_id, item_id)
);

-- add some characters
insert into characters (name) values ('Frodo');
insert into characters (name) values ('Leroy Jenkins');

-- add some items
insert into items (name) values ('Wooden Sword');
insert into items (name) values ('Arrow');
insert into items (name, worth) values ('Magic Ring', 254);

-- add some items to an inventory
-- Frodo picks up an Arrow
insert into characters_items as ci (character_id, item_id, quantity)
  values (
    1,
    2,
    1
  )
on conflict (character_id, item_id)
do update set quantity = ci.quantity + 1
  where ci.character_id = 1 and ci.item_id = 2;

-- Frodo picks up another Arrow
insert into characters_items as ci (character_id, item_id, quantity)
  values (
    1,
    2,
    1
  )
on conflict (character_id, item_id)
do update set quantity = ci.quantity + 1
  where ci.character_id = 1 and ci.item_id = 2;
