# Views


```sql

create or replace view almacenByCity as 
select 
	count(*) as wareHouses, 
	sum( cast(a.capacidad as integer) ) as capacidad_total, 
	c.nomb_ciu 
from "Almacen" a, "Ciudad" c
where c.id_ciudad = a.id_ciudad
group by c.nomb_ciu

```