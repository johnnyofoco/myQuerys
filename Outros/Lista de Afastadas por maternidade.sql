
/*########################################## LISTA DE AFASTAMENTOS OCORRIDOS POR LICENÇA MATERNIDADE - ÚLTIMOS 5 ANOS ###################################*/

select 
*
from

(
select
m.codigoempresa as empresa,
 e.cnpj as cnpj,
  e.nome as razaosocial,
   m.codigoempregado as matricula,
    f.nomefuncionario as nome,
   f.piscadastrado as pis, 
  f.cpfcic as cpf,
 to_char(m.dataafastamento, 'mm-yyyy') as inicioafastamento,
to_char(m.dataalta, 'mm-yyyy') as fimafastamento

/*
m.dataafastamento as inicioafastamento,
m.dataalta as fimafastamento,
m.razao as tipo,
*/

from dpcuca.afasttrb m

  inner join dpcuca.empresas e on (m.codigoempresa = e.id_empresa)
  inner join dpcuca.funcion f on (m.codigoempresa = f.cod_empresa and m.codigoempregado = f.cod_funcionario)

    where m.codigoempresa <> 38 and
	   m.razao = '6-Licença Maternidade' and ,
	   (m.dataafastamento >= '2016-08-01' and '2020-12-31')     

      order by m.dataafastamento

      
) as listaafastadas 