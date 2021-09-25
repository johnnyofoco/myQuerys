select

f.cod_empresa as "EMP",
 e.nome as "RAZAO_SOCIAL",
  e.cnpj as "CNPJ",
   e.endereco as "ENDERECO",
    e.bairro as "BAIRRO_EMPRESA",
    case cast(e.codigomunicipioibge as varchar)
     when '3526803' then 'LENÇÓIS PAULISTA'
      else 'BOTUCATU' end as "CIDADE_EMPRESA",
       e.cep as "CEP_EMPRESA",
        f.nomefuncionario as "NOMEFUNCIONARIO",
         f.cpfcic as "CPF",
           UPPER(f.endereco) AS "LOGRADOURO",
            UPPER(f.bairrodistrito) AS "BAIRRO_FUNC",
            f.cep AS "CEP_FUNC",
           case cast(f.codigomunicipioibge as varchar)
          when '3526803' then 'LENÇÓIS PAULISTA'
         else 'BOTUCATU' end as "CIDADE_FUNC",
        'SP' as "UF",
       substring(to_char(f.dataadmissao, 'dd-mm-yyyy'),1,2 ) as "DIA",
      substring(to_char(f.dataadmissao, 'dd-mm-yyyy'),4,2 ) as "MES",
     substring(to_char(f.dataadmissao, 'dd-mm-yyyy'),7,4 ) as "ANO",
   d.descricao as "CARGO",
  x.salario as "SALARIO",
 CASE e.id_empresa
   WHEN 23 THEN 'C B L PRENHACA VESTUARIO EPP'
   WHEN 25 THEN 'A. I. PRENHACA CALÇADOS EPP'
   WHEN 371 THEN 'PRENHACA E PRENHACA ARTIGOS DE VESTUARIO'  
   WHEN 372 THEN 'PRENHACA E PRENHACA ARTIGOS DE VESTUARIO'
   WHEN 373 THEN 'PRENHACA & PRENHACA CALC.E CONF.LTDA EPP'
   WHEN 374 THEN 'PRENHACA & PRENHACA CALC.E CONF.LTDA EPP'
   WHEN 375 THEN 'C B L PRENHACA VESTUARIO EPP'
   WHEN 376 THEN 'A. I. PRENHACA CALÇADOS EPP'
   WHEN 398 THEN 'PRENHACA & LUZ CALÇ. E CONFEC.LTDA EPP'
   WHEN 430 THEN 'PRENHACA & LUZ CALÇ. E CONFEC.LTDA EPP'
   WHEN 431 THEN 'C B L PRENHACA VESTUARIO EPP'
   WHEN 465 THEN 'A. I. PRENHACA CALÇADOS EPP'
   WHEN 472 THEN 'A. I. PRENHACA CALÇADOS EPP'
   ELSE '0'
   END as "MATRIZ_RAZAO",
 CASE e.id_empresa
   WHEN 23 THEN '66.729.963/0001-39'
   WHEN 25 THEN '72.676.877/0001-08'
   WHEN 371 THEN '17.521.657/0001-05'
   WHEN 372 THEN '17.521.657/0001-05'
   WHEN 373 THEN '17.538.498/0001-43'
   WHEN 374 THEN '17.538.498/0001-43'
   WHEN 375 THEN '66.729.963/0001-39'
   WHEN 376 THEN '72.676.877/0001-08'
   WHEN 398 THEN '20.597.000/0001-28'
   WHEN 430 THEN '20.597.000/0001-28'
   WHEN 431 THEN '66.729.963/0001-39'
   WHEN 465 THEN '72.676.877/0001-08'
   WHEN 472 THEN '72.676.877/0001-08'
   ELSE '0'
   END as "MATRIZ_CNPJ"

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
                    
  where f.cod_empresa in (23,25,371,372,373,374,375,376,398,430,431,465,472) AND
     (
	/*#######CONDIÇÕES PARA SER CONSIDERADO ATIVO NO MÊS(PERÍODO) - CUCA FRESCA#######*/
	--Admitido dentro ou anteriormente ao período, e não demitido até agora.  
	 (f.dataadmissao <= '2020-11-30' and f.datademissao is null) or 
	 --Admitido dentro ou anteriormente ao período, e demitido no périodo.
	 (f.dataadmissao <= '2020-11-30' and 
	  f.datademissao between '2020-11-01' and '2020-11-30' or 
	  --Admitido dentro ou anteriormente ao período, e demitido posteriormente.  
	 (f.dataadmissao <= '2020-11-30' and f.datademissao > '2020-11-30') )
	) 
	--Sem transferência ou com transferência anterior ou até o último dia do período
    and (f.datatransferenciafuncionario is null or f.datatransferenciafuncionario <= '2020-11-30')

       
  group by  e.nome, e.cnpj, e.endereco, e.bairro, e.codigomunicipioibge,
	    e.cep, f.nomefuncionario, f.cpfcic, x.salario, f.endereco,
            f.bairrodistrito, f.cep, f.codigomunicipioibge, f.dataadmissao,
            d.descricao, x.salario, e.id_empresa, f.cod_empresa
  
  order by d.descricao