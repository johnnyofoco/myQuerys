select
l.codigoempresa,
replace(replace(replace(e.cnpj, '.', '' ), '/', ''),'-','') as cnpj,
--l.descricao,
--to_char(datalanc, 'mm/yyyy') as competencia,
count(*) as "Qtd_Funcionarios",
SUM(l.vencimentos*-1) as valor
--l.codigoempregado, 
--f.cpfcic,
--f.nomefuncionario,
--l.evento, 
--l.quantidade,
--f.dataadmissao, 
--referencia,


from dpcuca.lancam l 

left join dpcuca.funcion f on (f.cod_empresa = l.codigoempresa and 
                               f.cod_funcionario = l.codigoempregado)
left join dpcuca.empresas e on (e.id_empresa = f.cod_empresa)

where evento in (9034)
  and to_char(datalanc, 'mm/yyyy') = '12/2020'     
  and codigoempresa in (23,25,371,372,373,374,375,376,398,430,431,465,472)
	
group by l.codigoempresa, e.cnpj, l.descricao, to_char(datalanc, 'mm/yyyy')

order by 1

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


--l.codigoempregado, f.nomefuncionario,l.quantidade, l.referencia,f.dataadmissao
--order by l.codigoempresa 
--order by l.codigoempresa, f.nomefuncionario
--and f.dataadmissao not between '2019-07-01' and '2019-07-31'
  --and codigoempresa in (371,372,373,430,431,465) --Botucatu
  --and codigoempresa in (23,25,374,375,376,398,472) --Lençóis Paulista
  /*and f.nomefuncionario in ('MARCIA LUZIA PERACOLLI DE OLIVEIRA','KATIA MOURA', 'FABIOLA FERNANDES DA SILVA COSTA',
				'ALESSANDRA ZAMONER','GABRIELLA PRECIOSO SILVESTRINI')*/
    --group by l.codigoempresa, e.cnpj, l.descricao, to_char(datalanc, 'mm/yyyy') 
--sum(l.vencimentos)




/*

17521657000105
17538498000224
66729963000562
20597000000128
20597000000209
66729963000643
72676877000450
72676877000531

*/











