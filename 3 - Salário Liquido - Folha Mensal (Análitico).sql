SELECT 


  f.codigoempresa as "Empresa",
  e.cnpj as "CNPJ",
  e.nome as "Razão Social",
 /* case f.codigoempresa 
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
  */
  /*e.cnpj as "Cnpj",
  f.codigoempregado as "Matricula",
  c.cpfcic as "cpf",*/
  c.nomefuncionario as "Nome do funcionário",
  /*f.evento as "verba",
  f.descricao as "descricao",
  f.quantidade as "quantidade",
  f.datalanc as "Data lanc",*/
  to_char(f.datalanc, 'mm-yyyy') as "Competência",
  --datalanc as "data pagamento",
  sum(f.vencimentos) as "Valor"
 
  FROM dpcuca.lancam f

  inner join dpcuca.funcion c on (c.cod_funcionario = f.codigoempregado and
                                  c.cod_empresa = f.codigoempresa)

  inner join dpcuca.empresas e on (f.codigoempresa = e.id_empresa)
           
  --to_char(f.datalanc, 'mm-yyyy')
  where f.datalanc = '2020-11-30' and c.datademissao is null
   and f.codigoempresa in (23,25,371,372,373,374,375,376,398,430,431,465,472)
      and f.evento not in (9204, 4204, 4205, 9104, 9203, 0013, 3906, 3907, 3908, 4212, 4213, 4218, 4219, 5801, 4201, 4202,3901,3902)


  group by   f.codigoempresa, e.cnpj, c.nomefuncionario, e.nome, to_char(f.datalanc, 'mm-yyyy')
  --c.nomefuncionario, c.cpfcic, f.codigoempregado
		--,c.nomefuncionario,  f.evento,  f.descricao,  f.quantidade,  f.datalanc

  order by 1,4