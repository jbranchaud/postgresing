-- rename a table

begin;

create table ingredient_types (
  name varchar primary key
);

create table ingredients (
  id serial primary key,
  name varchar not null,
  ingredient_type varchar not null references ingredient_types (name)
);


-- > \d ingredient_types
--     Table "public.ingredient_types"
--  Column |       Type        | Modifiers
-- --------+-------------------+-----------
--  name   | character varying | not null
-- Indexes:
--     "ingredient_types_pkey" PRIMARY KEY, btree (name)
-- Referenced by:
--     TABLE "ingredients" CONSTRAINT "ingredients_ingredient_type_fkey" FOREIGN KEY (ingredient_type) REFERENCES ingredient_types(name)
-- 
-- > \d ingredients
--                                    Table "public.ingredients"
--      Column      |       Type        |                        Modifiers
-- -----------------+-------------------+----------------------------------------------------------
--  id              | integer           | not null default nextval('ingredients_id_seq'::regclass)
--  name            | character varying | not null
--  ingredient_type | character varying | not null
-- Indexes:
--     "ingredients_pkey" PRIMARY KEY, btree (id)
-- Foreign-key constraints:
--     "ingredients_ingredient_type_fkey" FOREIGN KEY (ingredient_type) REFERENCES ingredient_types(name)


alter table ingredient_types rename to item_types;


-- > \d item_types
--        Table "public.item_types"
--  Column |       Type        | Modifiers
-- --------+-------------------+-----------
--  name   | character varying | not null
-- Indexes:
--     "ingredient_types_pkey" PRIMARY KEY, btree (name)
-- Referenced by:
--     TABLE "ingredients" CONSTRAINT "ingredients_ingredient_type_fkey" FOREIGN KEY (ingredient_type) REFERENCES item_types(name)
-- 
-- > \d ingredients
--                                    Table "public.ingredients"
--      Column      |       Type        |                        Modifiers
-- -----------------+-------------------+----------------------------------------------------------
--  id              | integer           | not null default nextval('ingredients_id_seq'::regclass)
--  name            | character varying | not null
--  ingredient_type | character varying | not null
-- Indexes:
--     "ingredients_pkey" PRIMARY KEY, btree (id)
-- Foreign-key constraints:
--     "ingredients_ingredient_type_fkey" FOREIGN KEY (ingredient_type) REFERENCES item_types(name)
