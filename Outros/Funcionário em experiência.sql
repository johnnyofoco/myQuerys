
select
f.cod_empresa as "Empresa",
--e.nome,
/*case cast(e.codigomunicipioibge as varchar)
when '3526803' then 'Lençóis Paulista'
else 'Botucatu' end as cidade,*/
f.cod_funcionario as "Matricula",
--f.cpfcic,
f.nomefuncionario as "Nome",
to_char(f.dataadmissao, 'dd/mm/yyyy') as "Admissao",
f.datademissao as "Demissao",
f.contratotrabalho as "Tipo de contrato" ,
f.tipotrabalho as "QTD dias 1º período",
f.prazo as "QTD dias 2º período" ,
f.dataprorrogacao as "Data da prorrogação",
to_char(f.datatermexperiencia, 'dd/mm/yyyy') as "Término final do contrato",
f.dataadmissao

from 
dpcuca.funcion f

left join dpcuca.empresas e on (e.id_empresa = f.cod_empresa)
                    
  where f.cod_empresa in (23,25,371,372,373,374,375,376,398,430,431,465,472) 
    and (
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
    and (f.datatransferenciafuncionario is null or f.datatransferenciafuncionario <= '2020-10-30')


    
    and (f.dataadmissao >= '2020-09-13')
        
      
  group by f.cod_empresa, e.nome, e.codigomunicipioibge , f.cod_funcionario, f.cpfcic,
	   f.nomefuncionario, to_char(f.dataadmissao, 'dd/mm/yyyy'), f.datademissao, f.datatransferenciafuncionario,
	   f.contratotrabalho, f.tipotrabalho, f.prazo, f.dataprorrogacao, f.datatermexperiencia, f.dataadmissao

  order by f.dataadmissao --4,6