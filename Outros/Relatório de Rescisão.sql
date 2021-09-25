select 
empresa as "Empresa",
matricula as "Matricula",
nome as "Nome do Funcionário",
cpf as "CPF",
to_char(admissao, 'dd-mm-yyyy') as "Admissão",
to_char(databaixa, 'dd-mm-yyyy') as "Data da Baixa",
((databaixa - admissao) / 30) as "Tempo médio(meses)",
demrais as "Notivo Rais",
demcaged as "Notivo Caged",
demfgts as "Notivo FGTS",
sum(liquidorescisao) as "Liquido Rescisão",
trunc(sum(guiarescisoria),2) as "FGTS Mês + Multa"

from
(
select

codigoempresa as empresa,
codigoempregado as matricula,
nomefuncionario as nome,
cpfcic as cpf,
datademissao as databaixa,
cast(to_char(dataadmissao, 'dd-mm-yyyy') as date) as admissao,
demrais,
demcaged,
demfgts,
sum(vencimentos) as liquidorescisao, 
0 as guiarescisoria
		
from 
dpcuca.lancam 
  left join dpcuca.funcion on (cod_funcionario = codigoempregado and cod_empresa = codigoempresa)
   where tipolcto = 'RCS'
    group by codigoempresa, codigoempregado, nomefuncionario, datademissao, 
		cpf, dataadmissao, demrais, demcaged, demfgts

union all

select

codigoempresa as empresa,
codigoempregado as matricula,
nomefuncionario as nome,
cpfcic as cpf,
datademissao as databaixa,
cast(to_char(dataadmissao, 'dd-mm-yyyy') as date) as admissao,
demrais,
demcaged,
demfgts,
0 as liquidorescisao,
sum(vrunitario) as guiarescisoria
		
from 
dpcuca.lancam 
  left join dpcuca.funcion on (cod_funcionario = codigoempregado and cod_empresa = codigoempresa)
   where evento in (5901,5903) and tipolcto = 'RCS'
     group by codigoempresa, codigoempregado, nomefuncionario, datademissao, 
		cpf, dataadmissao, demrais, demcaged, demfgts

) as sub
 
    where empresa in (23,25,371,372,373,374,375,376,398,430,431,465,472)
     and databaixa between '2019-01-01' and '2019-08-30' and demfgts = 'J'
    
    group by empresa, matricula, nome, databaixa, cpf, 
		admissao, demrais, demcaged, demfgts

    order by databaixa