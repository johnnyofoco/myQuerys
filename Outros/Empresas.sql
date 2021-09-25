select
id_empresa as "Empresa",
cnpj as "Cnpj",
nome as "RazaoSocial"

from 
dpcuca.empresas

where id_empresa in (23,25,371,372,373,374,375,376,398,430,431,465,472)

order by 1