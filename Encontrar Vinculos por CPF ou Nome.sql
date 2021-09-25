select
f.cod_empresa,
e.cnpj,
f.cod_funcionario,
f.nomefuncionario,
f.datanascimento,
f.cpfcic,
f.cedidentid, 
to_char(f.dataadmissao, 'dd/mm/yyyy') as Admissao,
to_char(f.datademissao, 'dd/mm/yyyy') as Demissao,
f.demrais,
f.demcaged,
f.demfgts,
to_char(f.dataopcao, 'dd/mm/yyyy') as DataOpcao

--select * from dpcuca.funcion where nomefuncionario like '%JOHNNY%'limit 1 

/*
e.nome,
contratotrabalho,
prazo,
cast(to_char(f.dataavisoprevio, 'dd-mm-yyyy') as date) as DataAviso,
f.mae,
f.cpfcic,
f.cedidentid, 
f.emissor, 
f.ufemissor,
tipoavisoprevio,
piscadastrado,
saldofgts,
valormultarescisoria 
*/

from 
dpcuca.funcion f

left join dpcuca.empresas e on (e.id_empresa = f.cod_empresa) 

where 
-- f.cod_empresa = 32 --and cast(to_char(f.datademissao, 'dd-mm-yyyy') as date) = '24-04-2020'
--cpfcic = '127.325.338-82' --and
 --f.cod_empresa IN (23,25,371,372,373,374,375,376,398,430,431,465,472) and 
f.nomefuncionario like '%JOHNNY%'
  --and demrais <> 11  

  order by datademissao

  
