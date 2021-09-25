select
        f.nomefuncionario as "NOME",
         f.piscadastrado as "PIS",
         to_char(f.dataadmissao, 'dd-mm-yyyy') as "DATA DE ADMISSÃO",
	x.salario as "ÚLTIMO SALÁRIO",
	d.descricao as "CARGO",
	d.descricao as "FUNÇÃO"
 
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
Left join dpcuca.afasttrb a on (a.codigoempresa = f.cod_empresa and a.codigoempregado = f.cod_funcionario) 

--select * from dpcuca.afasttrb limit 1
                    
  where f.cod_empresa in (393) AND
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

       
  group by  f.nomefuncionario, f.piscadastrado, x.salario, f.endereco,
            f.bairrodistrito, f.cep, f.codigomunicipioibge, f.dataadmissao,
            d.descricao, x.salario, e.id_empresa, f.cod_empresa
  
  order by 1,3