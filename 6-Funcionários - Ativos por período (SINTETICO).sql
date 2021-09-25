select

emp as "COD_EMPRESA",
razao as "RAZAO_SOCIAL",
cnpj as "CNPJ",
sum(qtd_inicio) as "QTD_FUNCIONARIOS_ATIVOS_JANEIRO_2019",
sum(qtd_fim)as "QTD_FUNCIONARIOS_ATIVOS_DEZEMBRO_2019"

from


/* INICIO DO PERÍODO DESEJADO */
(
select
f.cod_empresa as emp,
e.nome as razao,
e.cnpj as cnpj,
count(*) as qtd_inicio,
0 as qtd_fim

from 
dpcuca.funcion f
left join dpcuca.empresas e on (e.id_empresa = f.cod_empresa)
                    
  where 
     (
	/*#######CONDIÇÕES PARA SER CONSIDERADO ATIVO NO MÊS(PERÍODO) - CUCA FRESCA#######*/
	--Admitido dentro ou anteriormente ao período, e não demitido até agora.  
	 (f.dataadmissao <= '2019-01-31' and f.datademissao is null) or 
	 --Admitido dentro ou anteriormente ao período, e demitido no périodo.
	 (f.dataadmissao <= '2019-01-31' and 
	  f.datademissao between '2019-01-01' and '2019-01-31' or 
	  --Admitido dentro ou anteriormente ao período, e demitido posteriormente.  
	 (f.dataadmissao <= '2019-01-31' and f.datademissao > '2019-01-31') )
	) 
	--Sem transferência ou com transferência anterior ou até o último dia do período
    and (f.datatransferenciafuncionario is null or f.datatransferenciafuncionario <= '2019-01-31')

    group by f.cod_empresa, e.nome, e.cnpj, qtd_fim

   
union all

/* FIM DO PERÍODO DESEJADO */

select
f.cod_empresa as emp,
e.nome as razao,
e.cnpj as cnpj,
0 as qtd_inicio,
count(*) as qtd_fim

from 
dpcuca.funcion f
left join dpcuca.empresas e on (e.id_empresa = f.cod_empresa)
                    
  where 
       (
	 (f.dataadmissao <= '2019-12-31' and f.datademissao is null) or 
	 (f.dataadmissao <= '2019-12-31' and 
	  f.datademissao between '2019-12-01' and '2019-12-31' or 
	 (f.dataadmissao <= '2019-12-31' and f.datademissao > '2019-12-31') )
	) 
    and (f.datatransferenciafuncionario is null or f.datatransferenciafuncionario <= '2019-12-31')

   group by f.cod_empresa, e.nome, e.cnpj, qtd_inicio

    
) as sub

GROUP BY emp, razao, cnpj

ORDER BY emp

      

