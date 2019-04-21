# Postgresing

## Not Null

You usually don't want holes in your data. Generously applying `not null`
constraints can help.

*Create a table* with the `not null` modifier used for one of the columns:

```sql
create table cocktails (
  id serial primary key,
  name varchar not null,
  description varchar
);
```

*Add a new column* with the `not null` modifier:

```sql
alter table cocktails
  add column created_at timestamptz not null;
```

This statement works cleanly on an empty table, but will fail if there is
even one row in the table. To add this column would immediately put each row
in the table in violation of the `not null` constraint. There are techniques
for getting around this.

*Alter an existing column* to have a `not null` modifier:

```sql
alter table cocktails
  alter column description set not null;
```

This has the same issue as above if there is already data in the table.

*Remove a `not null` modifier* from an existing column:

```sql
alter table cocktails
  alter column description drop not null;
```
