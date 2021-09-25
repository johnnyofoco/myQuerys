select
l.codigoempresa,
e.cnpj,
--l.codigoempregado, 
--f.cpfcic,
--f.nomefuncionario,
--l.evento, 
l.descricao,
to_char(datalanc, 'mm/yyyy') as competencia,
--l.quantidade,
 count(*) as "Qtd_Funcionarios",
--f.dataadmissao, 
--referencia,
SUM(l.vencimentos) as valor

from dpcuca.lancam l 

left join dpcuca.funcion f on (f.cod_empresa = l.codigoempresa and 
                               f.cod_funcionario = l.codigoempregado)

left join dpcuca.empresas e on (e.id_empresa = f.cod_empresa)

where  evento in (9034) --and quantidade <> 1
       and to_char(datalanc, 'mm/yyyy') = '04/2020' 
       --and f.dataadmissao not between '2019-07-01' and '2019-07-31'
  and codigoempresa in (23,25,371,372,373,374,375,376,398,430,431,465,472) -- Todas
  --and codigoempresa in (371,372,373,430,431,465) --Botucatu
  --and codigoempresa in (23,25,374,375,376,398,472) --Lençóis Paulista
  --and l.referencia <> '12/12 avos'
  /*and f.nomefuncionario in ('MARCIA LUZIA PERACOLLI DE OLIVEIRA','KATIA MOURA', 'FABIOLA FERNANDES DA SILVA COSTA',
				'ALESSANDRA ZAMONER','GABRIELLA PRECIOSO SILVESTRINI')*/
  --group by l.codigoempresa, e.cnpj, l.descricao, to_char(datalanc, 'mm/yyyy') 
  group by l.codigoempresa, e.cnpj, l.descricao, l.datalanc --, l.codigoempregado, 
		--f.nomefuncionario,l.quantidade, l.referencia,f.dataadmissao
--order by l.codigoempresa 
--order by l.codigoempresa, f.nomefuncionario
order by 1
 --sum(l.vencimentos)
 
/*### VERBAS PARA CONFERÊNCIA ###

	8316 - Despesas de Loja
	2325 - Comissões
	2313,2214 - Gratificações
	1401 - Adicional Quebra de Caixa
	0601 - Adicional de Função (Gerentes)
	0502 - DSR
	8101,3501 - Desconto de Vale Transporte
	0001 - Salário Base / 0101 - Salário Maternidade
	9034 - Contribuição Assistencial
	7719,7720 - Mensalidade Unimed / Despesas Unimed

*/


