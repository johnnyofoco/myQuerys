
select
f.cod_empresa,
e.nome,
case cast(e.codigomunicipioibge as varchar)
when '3526803' then 'Lençóis Paulista'
else 'Botucatu' end as cidade,
f.cod_funcionario,
f.cpfcic,
f.nomefuncionario,
to_char(f.dataadmissao, 'dd-mm-yyyy') as Admissao,
f.datademissao as Demissao,
f.datatransferenciafuncionario as Transferencia

from 
dpcuca.funcion f

left join dpcuca.empresas e on (e.id_empresa = f.cod_empresa)
                    
  where f.cod_empresa in (371) 
    and (
	/*#######CONDIÇÕES PARA SER CONSIDERADO ATIVO NO MÊS(PERÍODO) - CUCA FRESCA#######*/
	--Admitido dentro ou anteriormente ao período, e não demitido até agora.  
	 (f.dataadmissao <= '2020-10-31' and f.datademissao is null) or 
	 --Admitido dentro ou anteriormente ao período, e demitido no périodo.
	 (f.dataadmissao <= '2020-10-31' and 
	  f.datademissao between '2020-10-01' and '2020-10-31' or 
	  --Admitido dentro ou anteriormente ao período, e demitido posteriormente.  
	 (f.dataadmissao <= '2020-10-31' and f.datademissao > '2020-10-31') )
	) 
	--Sem transferência ou com transferência anterior ou até o último dia do período
    and (f.datatransferenciafuncionario is null or f.datatransferenciafuncionario <= '2020-10-31')
    
      
  group by f.cod_empresa, e.nome, e.codigomunicipioibge , f.cod_funcionario, f.cpfcic,
	   f.nomefuncionario, to_char(f.dataadmissao, 'dd-mm-yyyy'), f.datademissao, f.datatransferenciafuncionario

  order by f.cod_empresa, f.nomefuncionario
