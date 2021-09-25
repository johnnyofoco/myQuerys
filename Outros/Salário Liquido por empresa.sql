
SELECT 

COD as "codigo",
LOJA AS "loja",
CNPJ AS "cnpj",
RAZAO AS "razao",
COMPETENCIA AS "competencia",
COUNT(*) AS "qtd_funcionarios",
SUM(VALOR) AS "valor"

FROM 
(
SELECT 

  f.codigoempresa AS "cod",
  case f.codigoempresa 
  when 23 then 'Hot Wear'
  when 25 then 'Yes Boot´s - LP'
  when 371 then 'Yes Homem - BTU'
  when 372 then 'Yes Boot´s - BTU'
  when 373 then 'Yes Deluxe - BTU'
  when 374 then 'Yes Homem - LP'
  when 375 then 'Yes Deluxe/Escritório - LP'
  when 376 then 'Sport Shoes'
  when 398 then 'Hering'
  when 430 then 'Ana Capri'
  when 431 then 'Yes Club'
  when 465 then 'Yes Sport'
  when 472 then 'Arezzo'
  else 'Não identificada'
  end as "loja",
  e.cnpj as "cnpj",
  e.nome as "razao",
  c.nomefuncionario as "nome", 
  to_char(f.datalanc, 'mm-yyyy') as "competencia",
  sum(f.vencimentos) as "valor"
 
  FROM dpcuca.lancam f

  inner join dpcuca.funcion c on (c.cod_funcionario = f.codigoempregado and
                                  c.cod_empresa = f.codigoempresa)
  inner join dpcuca.empresas e on (f.codigoempresa = e.id_empresa)
           
  
  where to_char(f.datalanc, 'mm-yyyy') in ('08-2020') and c.datademissao is null
   and f.codigoempresa in (23,25,371,372,373,374,375,376,398,430,431,465,472)
      and f.evento not in (9204, 4204, 4205, 9104, 9203, 0013, 3906, 3907, 3908, 4212, 4213, 4218, 4219, 5801, 4201, 4202)


  group by   f.codigoempresa, e.cnpj, e.nome, c.nomefuncionario, to_char(f.datalanc, 'mm-yyyy')

  order by 1
 

  ) AS SUB

  GROUP BY COD,LOJA,CNPJ,RAZAO,COMPETENCIA

 ORDER BY COD
  