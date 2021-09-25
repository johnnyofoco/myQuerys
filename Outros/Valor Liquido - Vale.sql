SELECT
"Empresa",
"Loja",
"Nome do funcionário",
SUM(VALOR-IRRF)*-1 as "Valor Liquido"

FROM 

(
SELECT 

  f.codigoempresa as "Empresa",
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
  end as "Loja",
  e.cnpj as "Cnpj",
  f.codigoempregado as "Matricula",
  c.nomefuncionario as "Nome do funcionário",
  sum(f.vencimentos )  as "valor",
  0 as "irrf"
 
  FROM dpcuca.lancam f

  inner join dpcuca.funcion c on (c.cod_funcionario = f.codigoempregado and
                                  c.cod_empresa = f.codigoempresa)

  inner join dpcuca.empresas e on (f.codigoempresa = e.id_empresa)
           
  
  where to_char(f.datalanc, 'mm/yyyy') = '12/2020' 
   and f.codigoempresa in (23,25,371,372,373,374,375,376,398,430,431,465,472)
   and f.evento in (7504)

  group by   f.codigoempresa, e.cnpj, f.codigoempregado, c.nomefuncionario, c.cpfcic, f.vencimentos

  UNION ALL

SELECT 

  f.codigoempresa as "Empresa",
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
  end as "Loja",
  e.cnpj as "Cnpj",
  f.codigoempregado as "Matricula",
  c.nomefuncionario as "Nome do funcionário",
  0 as "valor",
  sum(f.vencimentos )  as "irrf"
 
  FROM dpcuca.lancam f

  inner join dpcuca.funcion c on (c.cod_funcionario = f.codigoempregado and
                                  c.cod_empresa = f.codigoempresa)

  inner join dpcuca.empresas e on (f.codigoempresa = e.id_empresa)
           
  
  where to_char(f.datalanc, 'mm-yyyy') = '12-2020' 
   and f.codigoempresa in (23,25,371,372,373,374,375,376,398,430,431,465,472)
   and f.evento in (9204)

  group by   f.codigoempresa, e.cnpj, f.codigoempregado, c.nomefuncionario, c.cpfcic, f.vencimentos

  
) AS SUB

  GROUP BY "Empresa", "Loja","Nome do funcionário"
  
  order by 1,3