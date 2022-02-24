# Data Manipulation

## Insert

```sql
insert into "Almacen" ( 
	id_alm, 
	nomb_alm, 
	capacidad, 
	clase, 
	id_ciudad 
) values(
	10,
	'Almacen 12',
	300,
	'clase A',
	1
)
```


## Update

```sql

--      table           column   value   row filter (optional)
UPDATE "Almacen"  SET   id_alm   = 7     WHERE id_alm = 10;


-- scalar expression
UPDATE products SET price = price * 1.10;

-- variuos updates in a single query
UPDATE mytable SET a = 5, b = 3, c = 1 WHERE a > 0;

```


## Delete

```sql

DELETE FROM products WHERE price = 10;

```


## Returning Data from Modified Rows

```sql

INSERT INTO users (firstname, lastname) VALUES ('Joe', 'Cool') RETURNING id;

-- sample
insert into "Almacen" ( 
	id_alm, 
	nomb_alm, 
	capacidad, 
	clase, 
	id_ciudad 
) values(
	8,
	'Lolos',
	300,
	'clase B',
	1
) returning *


```