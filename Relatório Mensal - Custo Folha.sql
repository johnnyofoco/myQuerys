SELECT
empresa as "Código",
razao as "Razão Social",
--tipo as "Tipo",
cnpj as "CNPJ",
ROUND(SUM( prolabore + autonomo + folha + fgts + 
          INSS_Descontado_Funcionarios + INSS_Descontado_Socios + INSS_Descontado_Autonomos +
	  INSS_Empresa_Funcionarios + INSS_Empresa_Socios + INSS_Empresa_Autonomos +
	  INSS_Terceiros_Funcionarios +  
	  INSS_RATxFAP_Funcionarios --+ retencao
          ),2) as "TOTAL",
--ROUND(SUM(qtdprolabore)/2,0) as "Quantidade Pro-Labore",
SUM(prolabore) as "Pro-Labore",
SUM(autonomo) as "Autonômo",
SUM(folha) as "Folha dos Funcionários",
ROUND(SUM(fgts),2) as "FGTS",

ROUND(SUM(INSS_Descontado_Funcionarios),2) as "INSS_Descontado_Funcionarios",
ROUND(SUM(INSS_Descontado_Socios),2) as "INSS_Descontado_Socios",
ROUND(SUM(INSS_Descontado_Autonomos),2) as "INSS_Descontado_Autonomos",

ROUND(SUM(INSS_Empresa_Funcionarios),2) as "INSS_Empresa_Funcionarios",
ROUND(SUM(INSS_Empresa_Socios),2) as "INSS_Empresa_Socios",
ROUND(SUM(INSS_Empresa_Autonomos),2) as "INSS_Empresa_Autonomos",

ROUND(SUM(INSS_Terceiros_Funcionarios),2) as "INSS_Terceiros_Funcionarios"

--,ROUND(SUM(INSS_RATxFAP_Funcionarios),2) as "Retenção"


FROM
 
(
--################################################ VALOR DA FOLHA DE PGTO (FUNC, SÓCIOS E AUTONOMOS) #########################################################

--Valor Folha dos Funcionários
SELECT 
  f.codigoempresa as empresa,
  e.nome as razao,
  t.tipo as tipo,
  e.cnpj as cnpj,
  sum(f.vencimentos) as folha,
  0 as prolabore,
  0 as qtdprolabore,
  0 as autonomo,
  0 as fgts,

  0 as INSS_Descontado_Funcionarios,
  0 as INSS_Descontado_Socios,
  0 as INSS_Descontado_Autonomos,

  0 as INSS_Empresa_Funcionarios,
  0 as INSS_Empresa_Socios, 
  0 as INSS_Empresa_Autonomos,

  0 as INSS_Terceiros_Funcionarios,

  0 as INSS_RATxFAP_Funcionarios

 --,0 as retencao


  FROM dpcuca.lancam f

  LEFT JOIN dpcuca.funcion c ON (c.cod_funcionario = f.codigoempregado 
		            AND  c.cod_empresa = f.codigoempresa)
  LEFT JOIN dpcuca.empresas AS e ON (e.id_empresa = f.codigoempresa)
  LEFT JOIN dpcuca.tipoempr t on (t.codigoempresa = e.id_empresa 
                             and (to_char(t.datainicio, 'mm-yyyy') <= '12-2020' and t.datainicio =
						 (select max(v.datainicio)
							from dpcuca.tipoempr v
							where  v.codigoempresa = t.codigoempresa)
							))	            
           
  
  WHERE to_char(f.datalanc, 'mm-yyyy') = '12-2020'
    AND f.vencimentos > 0

   GROUP BY f.codigoempresa, e.nome, e.cnpj, t.tipo

 UNION ALL

--Valor Folha Sócios (Pro-Labore)
SELECT 
  s.codigoempresa,
  e.nome,
  t.tipo, 
  e.cnpj, 
  0 as folha,
  sum(s.valor) as prolabore,
  count(*) as qtdprolabore,
  0 as autonomo,
  0 as fgts,

  0 as INSS_Descontado_Funcionarios,
  0 as INSS_Descontado_Socios,
  0 as INSS_Descontado_Autonomos,

  0 as INSS_Empresa_Funcionarios,
  0 as INSS_Empresa_Socios, 
  0 as INSS_Empresa_Autonomos,

  0 as INSS_Terceiros_Funcionarios,

  0 as INSS_RATxFAP_Funcionarios

  FROM dpcuca.lancsoc s

  LEFT JOIN dpcuca.empresas e on (e.id_empresa = s.codigoempresa)
  LEFT JOIN dpcuca.tipoempr t on (t.codigoempresa = e.id_empresa 
                             and (to_char(t.datainicio, 'mm-yyyy') <= '12-2020' and t.datainicio =
						 (select max(v.datainicio)
							from dpcuca.tipoempr v
							where  v.codigoempresa = t.codigoempresa)
							))		            
           
  WHERE to_char(s.datapagto, 'mm-yyyy') = '12-2020'
    AND s.valor > 0
    
   GROUP BY s.codigoempresa, e.nome, e.cnpj, t.tipo

 UNION ALL

--Valor da folha dos Autonomos

SELECT 
  a.codigoempresa,
  e.nome,
  t.tipo,
  e.cnpj,
  0 as folha,
  0 as prolabore,
  0 as qtdprolabore,
  sum(valor) as autonomo,
  0 as fgts,

  0 as INSS_Descontado_Funcionarios,
  0 as INSS_Descontado_Socios,
  0 as INSS_Descontado_Autonomos,

  0 as INSS_Empresa_Funcionarios,
  0 as INSS_Empresa_Socios, 
  0 as INSS_Empresa_Autonomos,

  0 as INSS_Terceiros_Funcionarios,

  0 as INSS_RATxFAP_Funcionarios

  FROM dpcuca.lancaut as aa 

  LEFT JOIN dpcuca.autonomo a ON (a.id_autonomo = aa.id_autonomo)
  LEFT JOIN dpcuca.empresas e ON (e.id_empresa = a.codigoempresa)
  LEFT JOIN dpcuca.tipoempr t on (t.codigoempresa = e.id_empresa 
                             and (to_char(t.datainicio, 'mm-yyyy') <= '12-2020' and t.datainicio =
						 (select max(v.datainicio)
							from dpcuca.tipoempr v
							where  v.codigoempresa = t.codigoempresa)
							))  	
  
  WHERE  aa.evento = 1 and to_char(aa.datapagtoirrf, 'mm-yyyy') = '12-2020'

  GROUP BY  a.codigoempresa,  e.nome, e.cnpj, t.tipo
 
 UNION ALL

--################################################ VALOR DO FGTS FUNCIONÁRIOS ###############################################################################
 
--Valor FGTS
SELECT 
  f.codigoempresa as empresa,
  e.nome as razao,
  t.tipo,
  e.cnpj as cnpj,
  0 as folha,
  0 as prolabore,
  0 as qtdprolabore,
  0 as autonomo,
  sum(f.vrunitario) as fgts,

  0 as INSS_Descontado_Funcionarios,
  0 as INSS_Descontado_Socios,
  0 as INSS_Descontado_Autonomos,

  0 as INSS_Empresa_Funcionarios,
  0 as INSS_Empresa_Socios, 
  0 as INSS_Empresa_Autonomos,

  0 as INSS_Terceiros_Funcionarios,

  0 as INSS_RATxFAP_Funcionarios
  							
  FROM dpcuca.lancam f

  LEFT JOIN dpcuca.funcion c ON (c.cod_funcionario = f.codigoempregado 
		            AND  c.cod_empresa = f.codigoempresa)
  LEFT JOIN dpcuca.empresas AS e ON (e.id_empresa = f.codigoempresa)
  LEFT JOIN dpcuca.tipoempr t on (t.codigoempresa = e.id_empresa 
                             and (to_char(t.datainicio, 'mm-yyyy') <= '12-2020' and t.datainicio =
						 (select max(v.datainicio)
							from dpcuca.tipoempr v
							where  v.codigoempresa = t.codigoempresa)
							))		            
  
  WHERE to_char(f.datalanc, 'mm-yyyy') = '12-2020'
    AND f.evento = 5901
    
   GROUP BY f.codigoempresa, e.nome, e.cnpj, t.tipo

 UNION ALL

--################################################ INSS DESCONTADO (FUNC, SOCIOS, AUTONOMOS) #################################################################
    
--INSS Descontado Funcionarios
(
SELECT 

  f.codigoempresa,
  e.nome,
  t.tipo,
  e.cnpj,
  0 as folha,
  0 as prolabore,
  0 as qtdprolabore,
  0 as autonomo,
  0 as fgts,

  sum(f.vencimentos - (f.vencimentos * 2)) as INSS_Descontado_Funcionarios,
  0 as INSS_Descontado_Socios,
  0 as INSS_Descontado_Autonomos,

  0 as INSS_Empresa_Funcionarios,
  0 as INSS_Empresa_Socios, 
  0 as INSS_Empresa_Autonomos,

  0 as INSS_Terceiros_Funcionarios,

  0 as INSS_RATxFAP_Funcionarios
  							
  FROM dpcuca.lancam f

  LEFT JOIN dpcuca.funcion c ON (c.cod_funcionario = f.codigoempregado 
		            AND  c.cod_empresa = f.codigoempresa)
  LEFT JOIN dpcuca.empresas AS e ON (e.id_empresa = f.codigoempresa)
  LEFT JOIN dpcuca.tipoempr t on (t.codigoempresa = e.id_empresa 
                             and (to_char(t.datainicio, 'mm-yyyy') <= '12-2020' and t.datainicio =
						 (select max(v.datainicio)
							from dpcuca.tipoempr v
							where  v.codigoempresa = t.codigoempresa)
							))
           
 
  WHERE to_char(f.datalanc, 'mm-yyyy') = '12-2020'
   AND f.evento in (9101,9102,9104)--VR INSS( A BASE É RETIRADA DO CAMPO VR UNITARIO)   

   GROUP BY f.codigoempresa, e.nome, e.cnpj, t.tipo

   UNION ALL

--Valor INSS Sócios

SELECT 
  s.codigoempresa,
  e.nome,
  t.tipo, 
  e.cnpj, 
  0 as folha,
  0 as prolabore,
  count(*) as qtdprolabore,
  0 as autonomo,
  0 as fgts,
  
  0 as INSS_Descontado_Funcionarios,
  sum(valor -(valor*2)) as INSS_Descontado_Socios,
  0 as INSS_Descontado_Autonomos,

  0 as INSS_Empresa_Funcionarios,
  0 as INSS_Empresa_Socios, 
  0 as INSS_Empresa_Autonomos,

  0 as INSS_Terceiros_Funcionarios,

  0 as INSS_RATxFAP_Funcionarios
 
  FROM dpcuca.lancsoc s

  LEFT JOIN dpcuca.empresas e ON (e.id_empresa = s.codigoempresa)
  LEFT JOIN dpcuca.tipoempr t on (t.codigoempresa = e.id_empresa 
                             and (to_char(t.datainicio, 'mm-yyyy') <= '12-2020' and t.datainicio =
						 (select max(v.datainicio)
							from dpcuca.tipoempr v
							where  v.codigoempresa = t.codigoempresa)
							))		            
           
  WHERE to_char(s.datapagto, 'mm-yyyy') = '12-2020'
    AND s.evento = (18) -- 18 INSS SEGURADO CONTRIB.INDIVIDUAL
                         
   GROUP BY s.codigoempresa, e.nome, e.cnpj, t.tipo
)


UNION ALL

--Valor INSS Autonomos

SELECT 
 a.codigoempresa,
 e.nome,
 t.tipo,
 e.cnpj,
 0 as folha,
 0 as prolabore,
 0 as qtdprolabore,
 0 as autonomo,
 0 as fgts,

  0 as INSS_Descontado_Funcionarios,
  0 as INSS_Descontado_Socios,
  sum(valor -(valor*2)) as INSS_Descontado_Autonomos,

  0 as INSS_Empresa_Funcionarios,
  0 as INSS_Empresa_Socios, 
  0 as INSS_Empresa_Autonomos,

  0 as INSS_Terceiros_Funcionarios,

  0 as INSS_RATxFAP_Funcionarios


  FROM dpcuca.lancaut as aa 

  LEFT JOIN dpcuca.autonomo a ON (a.id_autonomo = aa.id_autonomo)
  LEFT JOIN dpcuca.empresas e ON (e.id_empresa = a.codigoempresa)
  LEFT JOIN dpcuca.tipoempr t on (t.codigoempresa = e.id_empresa 
                             and (to_char(t.datainicio, 'mm-yyyy') <= '12-2020' and t.datainicio =
						 (select max(v.datainicio)
							from dpcuca.tipoempr v
							where  v.codigoempresa = t.codigoempresa)
							))
  
  WHERE  aa.evento = 11 and to_char(aa.datapagtoirrf, 'mm-yyyy') = '12-2020'

  GROUP BY  a.codigoempresa,  e.nome, e.cnpj, t.tipo

  UNION ALL

--################################################ CALCULO INSS EMPRESA (FUNC, SOCIOS, AUTONOMOS) ############################################################

--INSS_Empresa_Funcionarios

  SELECT 

  f.codigoempresa as empresa,
  e.nome as razao,
  t.tipo,
  e.cnpj as cnpj,
  0 as folha,
  0 as prolabore,
  0 as qtdprolabore,
  0 as autonomo,
  0 as fgts,

  0 as INSS_Descontado_Funcionarios,
  0 as INSS_Descontado_Socios,
  0 as INSS_Descontado_Autonomos,

  CASE t.tipo WHEN '00-Não optante Simples' THEN sum((round(f.vrunitario,2) * 0.20)) ELSE 0 END as INSS_Empresa_Funcionarios,
  0 as INSS_Empresa_Socios, 
  0 as INSS_Empresa_Autonomos,

  0 as INSS_Terceiros_Funcionarios,

  0 as INSS_RATxFAP_Funcionarios

  							
  FROM dpcuca.lancam f

  LEFT JOIN dpcuca.funcion c ON (c.cod_funcionario = f.codigoempregado 
		            AND  c.cod_empresa = f.codigoempresa)

  LEFT JOIN dpcuca.empresas AS e ON (e.id_empresa = f.codigoempresa)
  LEFT JOIN dpcuca.tipoempr t on (t.codigoempresa = e.id_empresa 
                             and (to_char(t.datainicio, 'mm-yyyy') <= '12-2020' and t.datainicio =
						 (select max(v.datainicio)
							from dpcuca.tipoempr v
							where  v.codigoempresa = t.codigoempresa)
							))		            
           
 
  WHERE to_char(f.datalanc, 'mm-yyyy') = '12-2020'
   AND f.evento in (9101,9102,9104)--VR INSS( A BASE É RETIRADA DO CAMPO VR UNITARIO)   

   GROUP BY f.codigoempresa, e.nome, e.cnpj, t.tipo

   UNION ALL

--INSS_Empresa_Socios

SELECT 
  s.codigoempresa,
  e.nome,
  t.tipo, 
  e.cnpj, 
  0 as folha,
  0 as prolabore,
  count(*) as qtdprolabore,
  0 as autonomo,
  0 as fgts,
  
  0 as INSS_Descontado_Funcionarios,
  0 as INSS_Descontado_Socios,
  0 as INSS_Descontado_Autonomos,

  0 as INSS_Empresa_Funcionarios,
  CASE t.tipo WHEN '00-Não optante Simples' THEN round(sum(base)*0.20,2) ELSE 0 END as INSS_Empresa_Socios, 
  0 as INSS_Empresa_Autonomos,

  0 as INSS_Terceiros_Funcionarios,

  0 as INSS_RATxFAP_Funcionarios


  FROM dpcuca.lancsoc s

  LEFT JOIN dpcuca.empresas e ON (e.id_empresa = s.codigoempresa)		            
  LEFT JOIN dpcuca.tipoempr t on (t.codigoempresa = e.id_empresa 
                             and (to_char(t.datainicio, 'mm-yyyy') <= '12-2020' and t.datainicio =
						 (select max(v.datainicio)
							from dpcuca.tipoempr v
							where  v.codigoempresa = t.codigoempresa)
							))         
  WHERE to_char(s.datapagto, 'mm-yyyy') = '12-2020'
    AND s.evento = (18) -- 18 INSS SEGURADO CONTRIB.INDIVIDUAL
                         
   GROUP BY s.codigoempresa, e.nome, e.cnpj, t.tipo



UNION ALL

--Valor INSS_Empresa_Autonomos

SELECT 
 a.codigoempresa,
 e.nome,
 t.tipo,
 e.cnpj,
 0 as folha,
 0 as prolabore,
 0 as qtdprolabore,
 0 as autonomo,
 0 as fgts,

 0 as INSS_Descontado_Funcionarios,
 0 as INSS_Descontado_Socios,
 0 as INSS_Descontado_Autonomos,

 0 as INSS_Empresa_Funcionarios,
 0 as INSS_Empresa_Socios, 
 CASE t.tipo WHEN '00-Não optante Simples' THEN round(sum(valor)*0.20 ,2) ELSE 0 END as INSS_Empresa_Autonomos,

 0 as INSS_Terceiros_Funcionarios,
 0 as INSS_RATxFAP_Funcionarios

  FROM dpcuca.lancaut as aa 

  LEFT JOIN dpcuca.autonomo a ON (a.id_autonomo = aa.id_autonomo)
  LEFT JOIN dpcuca.empresas e ON (e.id_empresa = a.codigoempresa)
  LEFT JOIN dpcuca.tipoempr t on (t.codigoempresa = e.id_empresa 
                             and (to_char(t.datainicio, 'mm-yyyy') <= '12-2020' and t.datainicio =
						 (select max(v.datainicio)
							from dpcuca.tipoempr v
							where  v.codigoempresa = t.codigoempresa)
							))
  
  WHERE  aa.evento = 1 and to_char(aa.datapagtoirrf, 'mm-yyyy') = '12-2020'

  GROUP BY  a.codigoempresa,  e.nome, e.cnpj, t.tipo  

--################################################ CALCULO INSS TERCEIROS(FUNCIONÁRIOS) ###########################################################

UNION ALL

--INSS_Terceiros_Funcionarios

  SELECT 

  f.codigoempresa as empresa,
  e.nome as razao,
  t.tipo,
  e.cnpj as cnpj,
  0 as folha,
  0 as prolabore,
  0 as qtdprolabore,
  0 as autonomo,
  0 as fgts,

  0 as INSS_Descontado_Funcionarios,
  0 as INSS_Descontado_Socios,
  0 as INSS_Descontado_Autonomos,

  0 as INSS_Empresa_Funcionarios,
  0 as INSS_Empresa_Socios, 
  0 as INSS_Empresa_Autonomos,

  CASE t.tipo WHEN '00-Não optante Simples' THEN sum((round(f.vrunitario,2) * 0.058)) ELSE 0 END as INSS_Terceiros_Funcionarios,

  0 as INSS_RATxFAP_Funcionarios

  							
  FROM dpcuca.lancam f

  LEFT JOIN dpcuca.funcion c ON (c.cod_funcionario = f.codigoempregado 
		            AND  c.cod_empresa = f.codigoempresa)

  LEFT JOIN dpcuca.empresas AS e ON (e.id_empresa = f.codigoempresa)
  LEFT JOIN dpcuca.tipoempr t on (t.codigoempresa = e.id_empresa 
                             and (to_char(t.datainicio, 'mm-yyyy') <= '12-2020' and t.datainicio =
						 (select max(v.datainicio)
							from dpcuca.tipoempr v
							where  v.codigoempresa = t.codigoempresa)
							))		            
           
 
  WHERE to_char(f.datalanc, 'mm-yyyy') = '12-2020'
   AND f.evento in (9101,9102,9104)--VR INSS( A BASE É RETIRADA DO CAMPO VR UNITARIO)   

   GROUP BY f.codigoempresa, e.nome, e.cnpj, t.tipo

  --################################################ CALCULO INSS FAP X RAT (FUNCIONÁRIOS) #######################################################  

UNION ALL

--INSS_RATxFAP_Funcionarios

  SELECT 

  f.codigoempresa as empresa,
  e.nome as razao,
  t.tipo,
  e.cnpj as cnpj,
  0 as folha,
  0 as prolabore,
  0 as qtdprolabore,
  0 as autonomo,
  0 as fgts,

  0 as INSS_Descontado_Funcionarios,
  0 as INSS_Descontado_Socios,
  0 as INSS_Descontado_Autonomos,

  0 as INSS_Empresa_Funcionarios,
  0 as INSS_Empresa_Socios, 
  0 as INSS_Empresa_Autonomos,

  0 as INSS_Terceiros_Funcionarios,

  CASE t.tipo WHEN '00-Não optante Simples' THEN sum((round(f.vrunitario,2) * 0.03)) ELSE 0 END as INSS_RATxFAP_Funcionarios

  							
  FROM dpcuca.lancam f

  LEFT JOIN dpcuca.funcion c ON (c.cod_funcionario = f.codigoempregado 
		            AND  c.cod_empresa = f.codigoempresa)

  LEFT JOIN dpcuca.empresas AS e ON (e.id_empresa = f.codigoempresa)
  LEFT JOIN dpcuca.tipoempr t on (t.codigoempresa = e.id_empresa 
                             and (to_char(t.datainicio, 'mm-yyyy') <= '12-2020' and t.datainicio =
						 (select max(v.datainicio)
							from dpcuca.tipoempr v
							where  v.codigoempresa = t.codigoempresa)
							))		            
           
 
  WHERE to_char(f.datalanc, 'mm-yyyy') = '12-2020'
   AND f.evento in (9101,9102,9104)--VR INSS( A BASE É RETIRADA DO CAMPO VR UNITARIO)   

   GROUP BY f.codigoempresa, e.nome, e.cnpj, t.tipo


UNION ALL

  --################################################ RETENÇÃO DE INSS SOBRE NOTA FISCAL ####################################################### 

SELECT 
  f.codigoempresa as empresa,
  e.nome as razao,
  t.tipo as tipo,
  e.cnpj as cnpj,
  0 as folha,
  0 as prolabore,
  0 as qtdprolabore,
  0 as autonomo,
  0 as fgts,

  0 as INSS_Descontado_Funcionarios,
  0 as INSS_Descontado_Socios,
  0 as INSS_Descontado_Autonomos,

  0 as INSS_Empresa_Funcionarios,
  0 as INSS_Empresa_Socios, 
  0 as INSS_Empresa_Autonomos,

  0 as INSS_Terceiros_Funcionarios,

  0 as INSS_RATxFAP_Funcionarios

  --,sum(r.valor) as retencao,  to_char(r.competencia, 'mm-yyyy')
  

  FROM dpcuca.lancam f

  LEFT JOIN dpcuca.empresas AS e ON (e.id_empresa = f.codigoempresa)
  LEFT JOIN dpcuca.retencao AS r ON (r.codigo_empresa = e.id_empresa)
  LEFT JOIN dpcuca.tipoempr t on (t.codigoempresa = e.id_empresa 
                             and (to_char(t.datainicio, 'mm-yyyy') <= '12-2020' and t.datainicio =
						 (select max(v.datainicio)
							from dpcuca.tipoempr v
							where  v.codigoempresa = t.codigoempresa)
							))	 
	
WHERE to_char(r.competencia, 'mm-yyyy') = '12-2020' 

GROUP BY f.codigoempresa, e.nome, e.cnpj, t.tipo, r.competencia


) AS SUB

--WHERE EMPRESA = 445

  GROUP BY empresa, razao, cnpj, tipo

	ORDER BY EMPRESA

