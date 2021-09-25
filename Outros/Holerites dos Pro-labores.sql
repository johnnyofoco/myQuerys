select 
codigoempresa, 
codsocio, 
sum(valor) 

from dpcuca.lancsoc 

where codigoempresa = 1 and codsocio = 1 and datapagto >= '2019-03-01' 

group by codigoempresa,codsocio

(
SELECT codigoempresa, codsocio, datapagto, datapagtoirrf, automatico, 
       evento, descricao, codigodacategoria, codclasse, dependentes, 
       deducoes, valor, fgts, base, conta_dev, conta_cred, datausosaldo, 
       reducao45porct, versao, codsetor, irrf, cpf_dependente, agilizador, 
       data_inicial_local, data_final_local, importado, convenio_medico, 
       levar_informe, ocorrencia, quinto_dia, inss_evt, rais_evt, fgts_evt
  FROM dpcuca.lancsoc where codigoempresa = 1 and codsocio = 2 and datapagto >= '2019-03-01' order by evento
)