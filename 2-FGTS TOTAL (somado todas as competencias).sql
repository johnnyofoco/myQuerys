SELECT 
  f.codigoempresa as empresa,
  e.nome as razao,
  e.cnpj as cnpj,
  f.codigoempregado as matricula,
  c.nomefuncionario as nome,
  cast(sum(f.vrunitario) as real) as fgts,
  --to_char(f.datalanc, 'mm/yyyy'),
  c.cpfcic  
 

  FROM dpcuca.lancam f

  LEFT JOIN dpcuca.funcion c ON (c.cod_funcionario = f.codigoempregado 
		            AND  c.cod_empresa = f.codigoempresa)

  LEFT JOIN dpcuca.empresas AS e ON (e.id_empresa = f.codigoempresa)		            
										
  WHERE f.evento in (5901) and c.piscadastrado = '16428340888'


  --AND f.codigoempresa = 465 --FGTS MENSAL 5901 + FGTS MULTA 5903 
     --AND f.quantidade <> 0 --SE = 0 FGTS MES SEGUINTE OU SE <> 0 FGTS FERIAS  + FGTS DO MES
    -- AND c.cpfcic = '248.969.228-32'
   -- AND f.codigoempresa in (184,22,374)
    --AND f.nome like '%ANA PAULA OSTANICO%'
   /* AND to_char(f.datalanc, 'mm/yyyy') in ('03/2014', '11/2015', '12/2015', '01/2016', '02/2016', '03/2016', '04/2016', '05/2016', '06/2016','07/2016',
					  '08/2016', '09/2016', '10/2016','11/2016', '12/2016', '01/2017', '02/2017','03/2017', '04/2017', '11/2017',
					  '04/2019')*/

    GROUP BY

      f.codigoempresa,
	e.nome,
	 e.cnpj,
	  f.codigoempregado,
	   c.nomefuncionario,
	    to_char(f.datalanc, 'mm/yyyy'),
	      c.cpfcic
	       

	ORDER BY 1