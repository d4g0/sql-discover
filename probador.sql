CREATE or replace function e3(
	nomb varchar, rol1 varchar, prov varchar 
)
returns setof proyectos as $$
declare
	salida proyectos; idp integer; ide integer;
BEGIN 
	if exists (
		select * from estudiantes
		where nombre_est = nomb
	)
	then 
		raise exception  'ya existe';

	end if;

	Insert into estudiantes values(
	(select max(idest)+1 from estudiantes), nomb, rol1, prov
	);

	if(rol1 = 'Probador') then
		select idproyecto into idp from proyectos
		where nombre_proy = 'Sistema de Mensajería Beeper';

		select max(idest) from estudiantes into ide;

		insert into estudiantes_proyectos values(
			ide, idp, current_date, 150
		);

	end if;

	for salida in select from proyectos where presupuesto > 6000
	loop 
		return next salida;
	end loop;

END; 
$$
LANGUAGE plpgsql;


