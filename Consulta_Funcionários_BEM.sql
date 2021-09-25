SELECT 
 b.cod_empresa AS "Empresa", 
 e.cnpj AS "CNPJ",
 b.cod_funcionario AS "Matricula",
 f.nomefuncionario AS "Nome",
 CASE CAST(b.tipoadesao as VARCHAR)
 WHEN '0' THEN 'Suspensão'
 WHEN '1' THEN 'Redução Jornada'
 WHEN '9' THEN 'Cancelado'
 ELSE 'Erro'
 END AS "Tipo Adesão", 
 
 (b.data_termino_deducao - b.data_inicio_deducao)+1 AS "Qtd Dias",
 b.dataacordo AS "Data Acordo", 
 b.data_inicio_deducao AS "Inicio", 
 b.data_termino_deducao AS "Fim", 
 b.percentutalreducaocargahoraria AS "Percentual da Redução"
 
 FROM dpcuca.funcion_bem b

 LEFT JOIN dpcuca.funcion as f ON (f.cod_empresa = b.cod_empresa and f.cod_funcionario = b.cod_funcionario)
 LEFT JOIN dpcuca.empresas as e ON (e.id_empresa = b.cod_empresa)

  WHERE b.tipoadesao NOT IN ('9') AND 
        b.cod_empresa IN (23,25,371,372,373,374,375,376,398,430,431,465,472)

   ORDER BY 1,2
  
