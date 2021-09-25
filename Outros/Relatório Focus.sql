select
f.cod_empresa,
e.cnpj,
f.cod_funcionario,
f.nomefuncionario,
f.cpfcic,
f.cedidentid, 
to_char(f.dataadmissao, 'dd/mm/yyyy') as Admissao,
to_char(f.datademissao, 'dd/mm/yyyy') as Demissao,
f.demrais,
f.demcaged,
f.demfgts,
to_char(f.dataopcao, 'dd/mm/yyyy') as DataOpcao

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
   f.nomefuncionario like '%NATAL MARQUES DE OLIVEIRA%'
or f.nomefuncionario like '%ADRIANO RODRIGO DA SILVA%'
or f.nomefuncionario like '%MANOEL CORREIA DA SILVA SANTOS%'   
or f.nomefuncionario like '%LUIS FERNANDO MADEIRA%'
or f.nomefuncionario like '%SEBASTIÃO IZALTINO LEME%'
or f.nomefuncionario like '%MANOEL CORREIA DA SILVA  SANTOS%'
  