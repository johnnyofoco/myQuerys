select
nomefuncionario,
datanascimento,
cast(rpad(cast(age(datanascimento) as varchar),2,'') as integer) as idade

from dpcuca.funcion 

where cod_empresa = 473 and datademissao is null

order by 3 desc