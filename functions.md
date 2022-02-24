# Functions

## Structure

### Declaration
```sql
Declare
    user_id integer;
    quantity numeric(5);
    url varchar;
    myrow tablename%ROWTYPE;
    myfield tablename.columnname%TYPE;
    arow RECORD;
```

```sql
CREATE FUNCTION somefunc(param param_data_type) RETURNS return_type
AS $$ 

DECLARE
    declarations 
BEGIN
    statements
END;
$$
LANGUAGE plpgsql;
```


## Samples



```sql

CREATE or replace FUNCTION price_with_tax(
    subtotal real, 
    OUT tax real, 
    OUT full_price real
) AS $$
BEGIN
    tax := subtotal * 0.06;
	full_price = subtotal + tax;
END;
$$ LANGUAGE plpgsql;


-- basics
create or replace function getAlmacenById(id int) returns setof "Almacen" AS $$
    select * from "Almacen" a 
    where a.id_alm = id
$$ LANGUAGE SQL;    


create or replace function getAlmacenByName(name varchar) returns setof "Almacen" AS $$
    select * from "Almacen" a 
    where a.nomb_alm = name
$$ LANGUAGE SQL;    


create or replace function updateAlmacenName(
    current_name varchar, 
    new_name varchar
    ) returns setof "Almacen" AS $$

    update "Almacen" a
    set a.nomb_alm = new_name
    where a.nomb_alm = current_name
    returning *
$$ LANGUAGE SQL;    

```

