SELECT 
  f.codigoempresa as empresa,
  e.nome as razao,
  e.cnpj as cnpj,
  f.codigoempregado as matricula,
  c.nomefuncionario as nome,
  sum(round(f.vrunitario,2)) as fgts,

  to_char(f.datalanc, 'mm-yyyy') as competencia
  --,f.quantidade as quantidade,
  --f.evento as verba,
  --f.descricao as evento  
  --,c.cpfcic  
 

  FROM dpcuca.lancam f

  LEFT JOIN dpcuca.funcion c ON (c.cod_funcionario = f.codigoempregado 
		            AND  c.cod_empresa = f.codigoempresa)

  LEFT JOIN dpcuca.empresas AS e ON (e.id_empresa = f.codigoempresa)		            
           
  WHERE 
     f.evento in (5901) --FGTS MENSAL 5901 + FGTS MULTA 5903
   
  
   /* AND to_char(f.datalanc, 'mm/yyyy') IN ('12/2017', '01/2018', '02/2018', '03/2018', '04/2018',
					   '06/2018', '07/2018', '11/2018', '12/2018', '01/2019')
 
   group by   f.codigoempresa,  e.nome,  e.cnpj, to_char(f.datalanc, 'mm-yyyy'),
	      f.quantidade,   f.evento,   f.descricao	

    
 */   
  --AND f.codigoempregado = 1
  --AND   to_char(f.datalanc, 'mm-yyyy') >= '03-2010
  --AND (to_char(c.datatransferenciafuncionario, 'mm-yyyy') <= '01-2019' or
  --							to_char(c.datatransferenciafuncionario, 'mm-yyyy') is null)'    
  --AND f.quantidade <> 0 --SE = 0 FGTS MES SEGUINTE OU SE <> 0 FGTS FERIAS  + FGTS DO MES
 -- AND c.cpfcic = '' --and c.dataadmissao >= '2013-02-01'
 AND c.piscadastrado = '12358728227' 


   GROUP BY

     f.codigoempresa,  e.nome,  e.cnpj,  f.codigoempregado,
	c.nomefuncionario ,   f.datalanc
	/* f.quantidade,  f.evento,  f.descricao,  
	 c.cpfcic  */

	ORDER BY  f.datalanc

   