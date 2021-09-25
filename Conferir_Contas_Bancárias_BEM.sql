select 
f.cod_empresa,
f.cod_funcionario,
f.nomefuncionario,
f.dataadmissao,
f.mae,
b.cod_compensacao as banco,
b.codagencia,
f.contapagamento,
case cast(f.tipoconta as varchar)
when '1' then 'Corrente'
when '2' then 'Poupanca'
else '0'
end as tipoconta

from dpcuca.funcion f --select * from dpcuca.funcion limit 1

left join dpcuca.tbbanco b on (b.id_tbbanco = f.codigobanco) 


where f.datademissao is null and
(
nomefuncionario like '%ALESSANDRA REGIANE TIBURCIO%' or
nomefuncionario like '%ANA PAULA DE SOUZA RODRIGUES%' or
nomefuncionario like '%ARIELI DE OLIVEIRA CARNEIRO%' or
nomefuncionario like '%BEATRIZ GABRIELLE ANTUNES%' or
nomefuncionario like '%DEBORA KETLIN GARCIA%' or
nomefuncionario like '%ELOIZE JULIANA BESERRA%' or
nomefuncionario like '%EMMANUELA CAROLINI SINFRONIO AUGUSTO%' or
nomefuncionario like '%ISABELA SARZI PEREIRA%' or
nomefuncionario like '%JENIFER CARLA LIMA REIS%' or
nomefuncionario like '%JESSICA ALINE DA CRUZ FLORENCIO%' or
nomefuncionario like '%KAUANE DO PRADO FARINHA%' or
nomefuncionario like '%LUANA BENEDITA MADALENA BOLONHA%' or
nomefuncionario like '%MARIA EDUARDA SILVA DE CARVALHO%' or
nomefuncionario like '%MARIA EDUARDA PATEZ DE OLIVEIRA%' or
nomefuncionario like '%MICHELLE CRISTINA DE MORAES%' or
nomefuncionario like '%MIRLLEY EVENNYN ANDRADE DA SILVA%' or
nomefuncionario like '%PATRICIA NICOLE GODOI FEDELE%' or
nomefuncionario like '%SILVIA HELENA BARBOSA%' or
nomefuncionario like '%TATIANE APARECIDA BENEDITO RODRIGUES%' or
nomefuncionario like '%TATIANE APARECIDA DA SILVA%' or
nomefuncionario like '%RODRIGO PRENHACA ANDRADE%' or
nomefuncionario like '%SUSANA BARBOSA LUZ%' or
nomefuncionario like '%ANTONIO CARLOS FIDENCIO%' 
)

order by 5,1


