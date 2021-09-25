select
l.codigoempresa,
--e.cnpj,
l.codigoempregado, 
--f.cpfcic,
f.nomefuncionario,
--l.evento, 
l.descricao,
--datalanc,
to_char(datalanc, 'mm/yyyy') as competencia,
datalanc as datalancamento,
l.quantidade,
-- count(*) as 'Qtd_Funcionarios',
--f.dataadmissao, 
--referencia,
l.vencimentos as valor
--,m.dataafastamento as inicioafastamento

from dpcuca.lancam l 

left join dpcuca.funcion f on (f.cod_empresa = l.codigoempresa and 
                               f.cod_funcionario = l.codigoempregado)

left join dpcuca.empresas e on (e.id_empresa = f.cod_empresa)
--inner join dpcuca.afasttrb m on (m.codigoempresa = f.cod_empresa and m.codigoempregado = f.cod_funcionario)

where  l.codigoempresa in (23,25,371,372,373,374,375,376,398,430,431,465,472) 
   and evento in (8316)
   and to_char(datalanc, 'mm/yyyy') = '12/2020'
   --and to_char(datalanc, 'dd/mm/yyyy') = '31/11/2020'

  --funcionárias que são operadoras de caixa
  /* and (
	f.nomefuncionario = 'ALINE HENRIQUE DE OLIVEIRA' or
	f.nomefuncionario = 'ANA RITA RICCI GOMES' or
	f.nomefuncionario = 'CAMILA CASTRO CILLI' or
	f.nomefuncionario = 'DANIELE REGINA DIOGO OLIVEIRA' or
	f.nomefuncionario = 'DEBORA KETLIN GARCIA' or
	f.nomefuncionario = 'ELISETE DE LOURDES RICCI LIMA' or
	f.nomefuncionario = 'ELOIZE JULIANA BESERRA' or
	f.nomefuncionario = 'ISABELE CRISTINA PACHECO JACYNTHO' or
	f.nomefuncionario = 'JESSICA APARECIDA DE SOUZA HEIRAS' or 
	f.nomefuncionario = 'JULIANA GOMES FERREIRA' or 
	f.nomefuncionario = 'KARINA CRISTINA MIRANDA LOPES' or
	f.nomefuncionario = 'KAUANE DO PRADO FARINHA' or
	f.nomefuncionario = 'LETICIA GUEDES TANGERINO' or
	f.nomefuncionario = 'MIRLLEY EVENNYN ANDRADE DA SILVA'or
	f.nomefuncionario = 'TALITA PEREIRA MATHIAS'   
    )*/


   /*and (f.nomefuncionario like ('%ANA PAULA DIAS DOS SANTOS')
		       or f.nomefuncionario like ('CLARICE MARIANO DE LIMA')
		       or f.nomefuncionario like ('LUANA TAMARA NASCIMENTO ALVES')
		       or f.nomefuncionario like ('GABRIELI INARA CARVALHO')
		       or f.nomefuncionario like ('JESSICA ROCHA RODRIGUES'))*/

order by  f.nomefuncionario

/*###################VERBAS PARA CONFERÊNCIA###################
   
	8316 - Despesas de Loja
	2325 - Comissões
	2313,2214,2317 - Gratificações
	1401 - Adicional Quebra de Caixa
	0601 - Adicional de Função (Gerentes)
	0502 - DSR
	8101,3501 - Desconto de Vale Transporte
	0001 - Salário Base / 0101 - Salário Maternidade
	9034 - Contribuição Assistencial
	7719,7720 - Mensalidade Unimed / Despesas Unimed


###################OUTRAS OPÇÕES DE FILTRO#######################
   and codigoempresa = 
   and f.dataadmissao not between '2019-07-01' and '2019-07-31'
   and codigoempresa in (371,372,373,430,431,465) --Botucatu
   and codigoempresa in (23,25,374,375,376,398,472) --Lençóis Paulista
   and l.referencia <> '12/12 avos'
   and f.nomefuncionario in ('MARCIA LUZIA PERACOLLI DE OLIVEIRA','KATIA MOURA', 'FABIOLA FERNANDES DA SILVA COSTA',
				'ALESSANDRA ZAMONER','GABRIELLA PRECIOSO SILVESTRINI') 
   and codigoempresa in (23,25,371,372,373,374,375,376,398,430,431,465,472) -- Todas 				
   and m.codigoempresa <> 38 and
    (m.razao = '6-Licença Maternidade' and 
      m.dataafastamento between '2016-08-01' and '2020-12-31') 
*/