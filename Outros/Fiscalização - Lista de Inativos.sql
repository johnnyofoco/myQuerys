select
f.nomefuncionario as "NOME",
 f.piscadastrado as "PIS",
  to_char(f.dataadmissao, 'dd-mm-yyyy') as "DATA DE ADMISSÃO",
   to_char(f.datademissao, 'dd-mm-yyyy') as "DATA DA RESCISÃO",
   CASE f.demfgts
   WHEN'H' THEN 'Rescisão, com justa causa, por iniciativa do empregador'
   WHEN'I1' THEN 'Rescisão sem justa causa, por iniciativa do empregador, inclusive rescisão antecipada do contrato a termo'
   WHEN'I2' THEN 'Rescisão por culpa recíproca ou força maior'
   WHEN'I3' THEN 'Rescisão por término do contrato a termo'
   WHEN'I4' THEN 'Rescisão sem justa causa do contrato de trabalho do empregado doméstico, por iniciativa do empregador'
   WHEN'J' THEN 'Rescisão do contrato de trabalho por iniciativa do empregado'
   WHEN'K' THEN 'Rescisão a pedido do empregado ou por iniciativa do empregador, com justa causa, no caso de empregado não optante, com menos de um ano de serviço'
   WHEN'L' THEN 'Outros motivos de rescisão do contrato de trabalho'
   WHEN'M' THEN 'Mudança de regime estatutário'
   WHEN'N1' THEN 'Transferência de empregado para outro estabelecimento da mesma empresa'
   WHEN'N2' THEN 'Transferência de empregado para outra empresa que tenha assumido os encargos trabalhistas, sem que tenha havido rescisão de contrato de trabalho'
   WHEN'O1' THEN 'Afastamento temporário por motivo de acidente do trabalho, por período superior a 15 dias'
   WHEN'O2' THEN 'Novo afastamento temporário em decorrência do mesmo acidente do trabalho'
   WHEN'O3' THEN 'Afastamento temporário por motivo de acidente do trabalho, por período igual ou inferior a 15 dias'
   WHEN'P1' THEN 'Afastamento temporário por motivo de doença, por período superior a 15 dias'
   WHEN'P2' THEN 'Novo afastamento temporário em decorrência da mesma doença, dentro de 60 dias contados da cessação do afastamento anterior'
   WHEN'P3' THEN 'Afastamento temporário por motivo de doença, por período igual ou inferior a 15 dias'
   WHEN'Q1' THEN 'Afastamento temporário por motivo de licença-maternidade (120 dias)'
   WHEN'Q2' THEN 'Prorrogação do afastamento temporário por motivo de licença-maternidade'
   WHEN'Q3' THEN 'Afastamento temporário por motivo de aborto não criminoso'
   WHEN'Q4' THEN 'Afastamento temporário por motivo de licença-maternidade decorrente de adoção ou guarda judicial de criança até 1 (um) ano de idade (120 dias)'
   WHEN'Q5' THEN 'Afastamento temporário por motivo de licença-maternidade decorrente de adoção ou guarda judicial de criança a partir de 1 (um) ano até 4 (quatro) anos de idade (60 dias)'
   WHEN'Q6' THEN 'Afastamento temporário por motivo de licença-maternidade decorrente de adoção ou guarda judicial de criança a partir de 4 (quatro) anos até 8 (oito) anos de idade (30 dias)'
   WHEN'R' THEN 'Afastamento temporário para prestar serviço militar'
   WHEN'S2' THEN 'Falecimento'
   WHEN'S3' THEN 'Falecimento motivado por acidente de trabalho'
   WHEN'U1' THEN 'Aposentadoria por tempo de contribuição ou idade sem continuidade de vínculo empregatício'
   WHEN'U2' THEN 'Aposentadoria por tempo de contribuição ou idade com continuidade de vínculo empregatício'
   WHEN'U3' THEN 'Aposentadoria por invalidez'
   WHEN'W' THEN 'Afastamento temporário para exercício de mandato sindical'
   WHEN'X' THEN 'Licença sem vencimentos'
   WHEN'Y' THEN 'Outros motivos de afastamento temporário'
   WHEN'Z1' THEN 'Retorno de afastamento temporário por motivo de licença-maternidade'
   WHEN'Z2' THEN 'Retorno de afastamento temporário por motivo de acidente do trabalho'
   WHEN'Z3' THEN 'Retorno de novo afastamento temporário em decorrência do mesmo acidente do trabalho'
   WHEN'Z4' THEN 'Retorno de afastamento temporário por motivo de prestação de serviço militar'
   WHEN'Z5' THEN 'Outros retornos de afastamento temporário e/ou licença'
   WHEN'Z6' THEN 'Retorno de afastamento temporário por motivo de acidente do trabalho, por período igual ou inferior a 15 dias.'
   ELSE ''
   END as "MOTIVO DA RESCISÃO",

'De: '|| to_char(t.dataafastamento, 'dd/mm/yyyy') ||' A: '|| to_char(t.dataalta, 'dd/mm/yyyy') as "PERÍODO DE AFASTAMENTO",
t.razao as "MOTIVO DA AFASTAMENTO"
 
from 
dpcuca.funcion f
 --Dados da empresa
 left join dpcuca.empresas e on (e.id_empresa = f.cod_empresa)
 
 --Último salário
 left join (select max(a.salariocontratual) as salario, 
		      a.codigoempresa as emp, 
		      a.codigoempregado as func 
		from dpcuca.altsal a
	     inner join dpcuca.funcion b on (a.codigoempresa = b.cod_empresa and a.codigoempregado = b.cod_funcionario)
	   group by 2,3) 
	as x on (x.emp = f.cod_empresa and x.func = f.cod_funcionario )

 --Última alteração do cargo
inner join (select max(c.id_tbtpcarg) as id,
	           c.codigoempresa as emp,
	           c.codigoempregado as mat
	      from dpcuca.altcarg c 
	    inner join dpcuca.funcion b on (b.cod_empresa = c.codigoempresa  and b.cod_funcionario = c.codigoempregado)
	   group by 2,3) 
	  as y on (f.cod_empresa = y.emp  and f.cod_funcionario = y.mat )   

--Descrição da última alteração de cargo
left join dpcuca.tbtpcarg d on (d.id_tbtpcarg = y.id)

--Funcionários afastados (Não são considerados ativos para o MTE)
Left join dpcuca.afasttrb t on (t.codigoempresa = f.cod_empresa and t.codigoempregado = f.cod_funcionario) 
                    
  where f.cod_empresa in (393) and f.datademissao is not null

  
  order by 1,3