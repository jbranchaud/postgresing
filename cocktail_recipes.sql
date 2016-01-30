-- cocktail recipes

begin;

create table ingredients (
  id serial primary key,
  name varchar not null,
  description text not null default 'No Description',
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table recipes (
  id serial primary key,
  name varchar not null,
  description text not null,
  instructions text not null,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table ingredient_amounts (
  ingredient_id integer references ingredients,
  recipe_id integer references recipes,
  metric varchar not null,
  quantity numeric(6,2) not null,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  primary key (ingredient_id, recipe_id)
);
