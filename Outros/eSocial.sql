SELECT 
--id, 
id_tipos_arquivos_esocial, 
indicativo_tabela, 
id_primario as , 
id_secundario, 
status, 
competencia, 
ambiente, 
apuracao, 
operacao, 
inicio, 
fim, 
recibo, 
xml, 
descricao, 
chave1, 
chave2, 
protocolo, 
excluido, 
totalizador, 
id_xml, 
recibo_alterado, 
justificativa_recibo_alterado

FROM cargasesocial.cargas2019 

LEFT JOIN dpcuca.tipos_arquivos_esocial ON (id = id_tipos_arquivos_esocial ) , codigo, descricao, data_vigencia_inicio, data_vigencia_fim
  FROM dpcuca.tipos_arquivos_esocial order by 1




  where id_primario = 474