# Functions Practice


```sql
create or replace function get_almacen_by_id(id integer) 
	returns setof "Almacen"
	as $$
    declare
    almacen "Almacen"%rowtype;
    
    begin
        select * 
        into almacen 
        from "Almacen" a 
        where a.id_alm = id;

        if not found then
            raise  exception 'Almacen: % no encontrado', id;
        end if;
		
		return next almacen;

    end;
  $$
 language plpgsql;
 
 select * from get_almacen_by_id(22)

```