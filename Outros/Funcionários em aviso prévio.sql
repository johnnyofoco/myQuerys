select
f.cod_empresa,
e.cnpj,
f.cod_funcionario,
f.nomefuncionario,
to_char(f.dataadmissao, 'dd/mm/yyyy') as Admissao,
to_char(f.datademissao, 'dd/mm/yyyy') as Demissao,
to_char(f.dataavisoprevio, 'dd/mm/yyyy') as DataAviso,
dataavisoprevio
/*f.demrais,
f.demcaged,
f.demfgts,
to_char(f.dataopcao, 'dd/mm/yyyy') as DataOpcao*/

from 
dpcuca.funcion f

left join dpcuca.empresas e on (e.id_empresa = f.cod_empresa) 

where 

 f.dataavisoprevio between '2020-08-27' and '2020-10-31'

 order by f.dataavisoprevio

