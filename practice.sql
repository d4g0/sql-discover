create or replace function getAlmacenClassBById(id integer) returns setof "Almacen"
as &&
    declare
    almacen "Almacen";
    
    begin
        select * 
        into almacen 
        from "Almacen" a 
        where a.id_alm = id;

        if not found then
            rise exception 'Almacen no encontrado';
        end if;

    end;

&& language plpgsql;



-- Guia de ejercicios

-- canciones conciertos (e1)

-- e_1_2
/* 
muestre el nombre de las canciones, nombre del
concierto donde fue interpretada y lugar del mismo, para aquellas canciones
de género Salsa que hayan sido interpretadas por Paulo en más de 2 conciertos
diferentes.
*/

select
	nombre_cancion,
	con.nombre_concierto
from (select 
	can.nombre_cancion, 
	count(con.nombre_concierto) as cantidad_de_conciertos
from canciones can
join canciones_conciertos can_con USING (idcancion)
join conciertos con USING (idconcierto)
where can.genero = 'Salsa'
group by  can.nombre_cancion
having count(con.nombre_concierto) > 2
) as caciones_en_mas_de_dos_conciertos
join canciones can  USING (nombre_cancion)
join canciones_conciertos can_con USING (idcancion)
join conciertos con using (idconcierto)
order by can.nombre_cancion, con.nombre_concierto
;


/* 
Mediante una vista muestre los nombres de los conciertos, la cantidad de público y
las fechas en que fueron realizados, solamente para aquellos en los que Paulo FG
no interpretó canciones de género Bolero y que cumplen además que la
cantidad de público fue menor que la mínima que haya asistido a sus
conciertos en el Teatro Nacional.
*/

select can.genero, con.nombre_concierto, con.cantidad_publico, con.fecha, con.lugar_presentacion
from canciones can
join canciones_conciertos can_con
USING (idcancion)
join  conciertos con using (idconcierto)
where can.genero != 'Bolero' and con.cantidad_publico < (select 
	minimal_in_teatro_nacional 
		from(
			select 
				min(con.cantidad_publico) as minimal_in_teatro_nacional,
				con.lugar_presentacion
			from conciertos con
			where con.lugar_presentacion = 'Teatro Nacional'
			group by con.lugar_presentacion
		) as minimal_in_nacional
);


/* 
Mediante una Vista muestre el pago total recibido por todos aquellos conciertos en
los cuales se haya interpretado la canción Cleopatra y que se hayan realizado
con anterioridad al concierto al que menos público asistió de todos los realizados.
*/

create or replace view minimal_attendance as
	select 
		min(con.cantidad_publico) as minimal_attendance
	from conciertos con
;

create or replace view date_of_concert_with_minimal_attendance as
	select con.fecha
	from conciertos con
	where con.cantidad_publico = (
		select minimal_attendance from minimal_attendance
	)
;

-- select * from minimal_attendance;

-- select fecha  from date_of_concert_with_minimal_attendance;

 create or replace view get_total_payment_of_concerts_where_cleopatra_play as
	select sum(con.pago)
 	from conciertos con
 	JOIN canciones_conciertos using (idconcierto)
 	join canciones can USING (idcancion)
 	where can.nombre_cancion = 'Cleopatra'
 	and con.fecha < ( 
		select fecha from date_of_concert_with_minimal_attendance
	) ;

select * from get_total_payment_of_concerts_where_cleopatra_play;



/*
Implemente una función que actualice el género con un valor dado a una canción
de la cual se conoce su nombre. Además, esta función debe devolver en una
variable de salida el autor de la canción recién actualizada.

-- TODO ASK
*/

create function update_genre(
        song_name varchar, 
        new_genre varchar, 
        out  author varchar
    ) returns varchar 
    as $$ 
    begin
    update canciones set genero = new_genre
    where canciones.nombre_cancion = song_name;

    return canciones.autor;
    end
    $$ 
language plpgsql;

Implemente una función que dado el id de una canción devuelva la siguiente
información relacionada con los conciertos donde ha sido tocada: nombre
del concierto, lugar de presentación, fecha y cantidad de personas que
estuvieron presentes. Esta función de manera adicional debe comprobar que
esta canción no haya sido doblada en ningún concierto, en cuyo caso debe
eliminarla. Nota: Asumir que la eliminación se hace en cascada.

create or replace function get_concert_data_by_song_id ( id integer) 
    returns table (
        nombre_concierto character varying(35) ,
        lugar_presentacion character varying(35) ,
        fecha timestamp without time zone ,
        cantidad_publico integer ,
    ) as $$
    declare
    cancion canciones;
    con record;
    begin

    for con in (
        select * from conciertos con
        join canciones_conciertos using (idconcierto)
        join canciones can using (idcancion)
        where can.idcancion = id;
    )
    loop 
        
    end loop;
        nombre_concierto        :=  con.nombre_concierto;
        lugar_presentacion      := con.lugar_presentacion;
        fecha                   := con.fecha;
        cantidad_publico        := con.cantidad_publico;
        return next;
    end;
$$
language plpgsql;


-- returns a table
CREATE OR REPLACE FUNCTION get_film (p_pattern VARCHAR, p_year INT) 
    RETURNS TABLE (
        film_title VARCHAR,
        film_release_year INT
) AS $$
DECLARE 
    var_r record;
BEGIN
    FOR var_r IN(SELECT 
                title, 
                release_year 
                FROM film 
                WHERE title ILIKE p_pattern AND 
                release_year = p_year)  
    LOOP
        film_title := upper(var_r.title) ; 
        film_release_year := var_r.release_year;
        RETURN NEXT;
    END LOOP;
END; $$ 
LANGUAGE 'plpgsql';






-- 
create or replace function get_concert_data_by_song_id ( id integer) 
    returns table (
        nombre_concierto character varying(35) ,
        lugar_presentacion character varying(35) ,
        fecha timestamp without time zone ,
        cantidad_publico integer
    ) as $$
    declare
    cancion canciones;
    con record;
    begin
	select * into cancion from canciones can 
	where can.idcancion = id;
	
	if not found then
		raise exception 'Cancion % not found', id;
	end if;
	
	
	
    for con in (
        select * from conciertos con
        join canciones_conciertos can_con using (idconcierto)
        join canciones can using (idcancion)
        where can.idcancion = id
    )
    loop 
        nombre_concierto        := con.nombre_concierto;
        lugar_presentacion      := con.lugar_presentacion;
        fecha                   := con.fecha;
        cantidad_publico        := con.cantidad_publico;
-- 		handle if doblada
		if con.doblada = 'S' then
			delete from canciones where canciones.idcancion = id;
		end if;
		
        return next;
    end loop;
        
    end;
$$
language plpgsql;

select * from get_concert_data_by_song_id(4);


select 
	can.idcancion,
	can.nombre_cancion, 
	can_con.doblada,
	con.nombre_concierto, 
	con.lugar_presentacion 
from conciertos con
join canciones_conciertos can_con using (idconcierto)
join canciones can using (idcancion)
where can.idcancion = 4
order by con.nombre_concierto, can.nombre_cancion;   

update canciones_conciertos cc set doblada = 'N' where cc.idcancion = 4;





-- 

/*
Implemente una función que permita asociar una canción a un concierto
determinado. Debe tener en cuenta que no es posible realizar esta acción
si la duración de la canción es menor de 3 minutos y es doblada. De manera
adicional esta función debe devolver toda la información de los conciertos que
hayan tocado canciones dobladas.
*/

create or replace view conciertos_con_dobladas as
	select con.*
	from conciertos con
	join canciones_conciertos can_con using (idconcierto)
	join canciones can USING (idcancion)
	where can_con.doblada = 'S'
;

create or replace function connect_cancion( 
	id_cancion canciones.idcancion%type,
	id_concierto conciertos.idconcierto%type
) returns setof conciertos as $$
	declare
	conciertos_set conciertos;
	cancion_to_insert  canciones;
	begin

	 
-- 	 save sont to insert
	 select * into cancion_to_insert
	 from canciones where canciones.idcancion = id_cancion;
	 
	 -- 	 check song exisits	
	 if not found then
	 	raise exception 'Cancion con id: % no existe', id_cancion;
	 end if;
	 
	 if (
		( 
			select can_con.doblada
			from canciones_conciertos can_con join canciones using (idcancion)
			where canciones.idcancion = id_cancion
		) = 'S'
		or
		(
			(select can_con.duracion from canciones_conciertos can_con 
			join canciones using (idcancion)
			where canciones.idcancion = id_cancion) < 3
		)
	 ) then
	 	raise exception 'La cancion con id: % no puede ser vinculada con conciertos', id_cancion;
	 end if;
-- 	 link cancion to concierto
	 insert into canciones_conciertos (
	 	idcancion,
		idconcierto,
		duracion,
		doblada 
	 ) values (
	 	id_cancion,
		id_concierto,
		3,
		'N'
	 );
	 
-- 	 return not dobladas conciertos data
	 for conciertos_set in (select * from conciertos_con_dobladas)
	 loop
	 	return next conciertos_set;
	 end loop;
	end;
$$
language plpgsql;

select * from connect_cancion(1,16);



create or replace function update_project_type(
	project_to_replace_name 	proyectos.nombre_proy%type,
	proyect_type_source_name	proyectos.nombre_proy%type
) returns setof proyectos	as $$
	
	declare
	temp_type proyectos.tipo_proyecto%type;
    temp_project proyectos;
	begin
-- 	check existence
		if (
			not exists (
				select * from proyectos where proyectos.nombre_proy = project_to_replace_name
			) 
			or 
			not exists (
				select * from proyectos where proyectos.nombre_proy = proyect_type_source_name
			)
		) then
			raise exception 'Alguno o ambos proyectos no se encuentran en la db';
		
		end if;
		
-- 		save project type
		select p.tipo_proyecto into temp_type from proyectos p where p.nombre_proy = proyect_type_source_name;
		
-- 		update
		update proyectos 
		set tipo_proyecto = temp_type 
		where proyectos.nombre_proy = project_to_replace_name;
		
		select * into temp_project from proyectos 
		where proyectos.nombre_proy = project_to_replace_name;
		
		return next temp_project;
		
		
	end;

$$ language plpgsql;