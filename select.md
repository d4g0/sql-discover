# Select query


## List aliases

```sql
select colum_reference as alias from table_reference
```

## Distint
```sql
-- removes duplicated rows
SELECT DISTINCT ON (expression [, expression ...]) select_list ...
SELECT DISTINCT select_list ...
```
## FROM clause

```sql

FROM table_reference [, table_reference [, ...]]

-- lateral (scoped aliases in nested froms)
SELECT * FROM foo, LATERAL (SELECT * FROM bar WHERE bar.id = foo.bar_id) ss;
```

## Join clause
```sql
SELECT * FROM t1 JOIN t2 ON t1.num = t2.num;
SELECT * FROM t1 JOIN t2 USING (num);

```

## Group By clause

```sql

select 
	count(*) as wareHouses, 
	sum( cast(a.capacidad as integer) ) as capacidad_total, 
	c.nomb_ciu 
from "Almacen" a, "Ciudad" c
where c.id_ciudad = a.id_ciudad
group by c.nomb_ciu

```

## Having Clause

```sql

select 
	count(*) as wareHouses, 
	sum( cast(a.capacidad as integer) ) as capacidad_total, 
	c.nomb_ciu 
from "Almacen" a, "Ciudad" c
where c.id_ciudad = a.id_ciudad
group by c.nomb_ciu
having c.nomb_ciu = 'Habana' or c.nomb_ciu = 'Matanzas'
-- 
-- having sum( cast(a.capacidad as integer)) > 200
```

## Order By
```sql
select 
	count(*) as wareHouses, 
	sum( cast(a.capacidad as integer) ) as capacidad_total, 
	c.nomb_ciu 
from "Almacen" a, "Ciudad" c
where c.id_ciudad = a.id_ciudad
group by c.nomb_ciu
having sum( cast(a.capacidad as integer)) > 200
order by sum( cast(a.capacidad as integer)), c.nomb_ciu asc
-- can use column aliases
-- order by capacidad_total, c.nomb_ciu asc
```


## LIMIT and OFFSET

```sql
-- syntax
SELECT select_list
    FROM table_expression
    [ ORDER BY ... ]
    [ LIMIT { number | ALL } ] [ OFFSET number ]

-- sample
select 
	count(*) as wareHouses, 
	sum( cast(a.capacidad as integer) ) as capacidad_total, 
	c.nomb_ciu 
from "Almacen" a, "Ciudad" c
where c.id_ciudad = a.id_ciudad
group by c.nomb_ciu
having sum( cast(a.capacidad as integer)) > 200
order by capacidad_total, c.nomb_ciu asc
limit 2 offset 1

```

## VALUES Lists

```sql
-- generates a "constan table"
VALUES ( expression [, ...] ) [, ...]
```


## Subquery

```sql


select * FROM (SELECT * FROM table1) AS alias_name

-- names ()
select * 
FROM (VALUES ('anne', 'smith'), ('bob', 'jones'), ('joe', 'blow'))
AS names(first, last)

```

## [Subquery functions](!https://www.postgresql.org/docs/current/functions-subquery.html#FUNCTIONS-SUBQUERY-EXISTS)

Right hand side query must return a single column

### EXISTS (subquery)
```sql
EXISTS (subquery)
```

### IN
```sql
expression IN (subquery)
```

### NOT IN (subquery)
```sql
expression NOT IN (subquery)
```

### ANY/SOME
```sql
expression operator ANY (subquery)
expression operator SOME (subquery)
```

### ALL
```sql
expression operator ALL (subquery)
```