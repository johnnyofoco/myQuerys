SELECT
NOME,
CNPJ,
COMPETENCIA,
EMPRESA,
SUM(VALOR) AS "IRRF"

FROM

--DESCONTOS DO IRRF
(

--Folha normal
SELECT 
  e.cnpj as Cnpj,
  f.codigoempresa as Empresa,
  e.nome as Nome,
  f.codigoempregado as Matricula,
  f.evento as Verba,
  f.descricao as Descricao,
  sum(f.vencimentos) as Valor,
  f.datalanc as DataLancamento,
  to_char(f.datalanc, 'mm-yyyy') as Competencia,
  f.datapagtoirrf as DataPagamentoIRRF,
  to_char(f.datapagtoirrf, 'mm-yyyy') as Periodo_IRRF

  FROM dpcuca.lancam as f

  LEFT JOIN dpcuca.empresas as e on (e.id_empresa = f.codigoempresa)

  WHERE 
        f.evento in (0015, 9201, 9202, 9203, 9204)
			--0015 - IRF s/ pro labore
			--9201 - IRF s/ Salários
			--9202 - IRF s/ 13º Salario
			--9203 - IRF s/Férias
			--9204 - IRF s/ Adiantamentos	
  
  GROUP BY e.cnpj, f.codigoempresa,  e.nome, f.codigoempregado, f.evento,  
           f.descricao, f.quantidade, f.datalanc, to_char(f.datalanc, 'mm-yyyy'),
           f.datapagtoirrf, to_char(f.datapagtoirrf, 'mm-yyyy')

  UNION ALL

  --Folha dos sócios
  SELECT

  e.cnpj as Cnpj,
  s.codigoempresa as Empresa,
  e.nome as Nome,
  s.codsocio as Matricula,
  s.evento as Verba,
  s.descricao as Descricao,
  sum(s.valor) as Valor,
  s.datapagto as DataLancamento,
  to_char(s.datapagto, 'mm-yyyy') as Competencia,
  s.datapagtoirrf as DataPagamentoIRRF,
  to_char(s.datapagtoirrf, 'mm-yyyy') as Periodo_IRRF
       
  FROM
   dpcuca.lancsoc s

   LEFT JOIN dpcuca.empresas as e on (e.id_empresa = s.codigoempresa)

   WHERE 
	 s.evento = 0015

   GROUP BY  e.cnpj, s.codigoempresa, e.nome, s.codsocio, s.evento, s.descricao,
             s.datapagto, to_char(s.datapagto, 'mm-yyyy'), s.datapagtoirrf,
             to_char(s.datapagtoirrf, 'mm-yyyy')
          
 ) AS SUB

 WHERE Empresa IN (2,17,71,351,380,385,417,488) 
   AND to_char(DataPagamentoIRRF, 'mm-yyyy') = '07-2020'

 GROUP BY NOME, CNPJ, COMPETENCIA, EMPRESA
 
 ORDER BY CNPJ
