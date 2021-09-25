SELECT 
codigoempresa as "Empresa", 
 codigoempregado as "Matricula",  
  to_char(inicioaquisitivo, 'dd-mm-yyyy') as "InicioAquisitivo", 
   to_char(terminoaquisitivo, 'dd-mm-yyyy') as "TerminoAquisitivo" ,
    feriasdias as "DireitoFerias", 
     case(cast(feriasdias - (feriasdias1 + gozodias) as text))
      when '0.00' then 'OK'
     else cast(feriasdias - (feriasdias1  + gozodias) as text)
      end as "SaldoDiasFerias",

	to_char(cast(	
        LPAD(CAST((DATE_PART('day', terminoaquisitivo))AS TEXT),2, '0') || '-' ||
	LPAD(CAST(
       	case ((DATE_PART('month', terminoaquisitivo)) + 11)
	when 23 then 11
	when 22 then 10
	when 21 then 09
	when 20 then 08
	when 19 then 07
	when 18 then 06
	when 17 then 05
	when 16 then 04
	when 15 then 03
	when 14 then 02
	when 13 then 01
	else (DATE_PART('month', terminoaquisitivo)) + 11
	end AS TEXT),2,'0') || '-' ||
       (CAST((DATE_PART('year', terminoaquisitivo)) + 1  AS TEXT))
	 as date), 'dd-mm-yyyy') as "PrazoFatal"
  
       
  FROM dpcuca.ferias 

  WHERE codigoempresa = 25 AND codigoempregado = 30 

  ORDER BY 4 DESC

  LIMIT 5





  /*#######################################OUTROS CÓDIGOS /  CAMPOS ######################################################*/

/*
  	(DATE_PART('day', terminoaquisitivo)) as "Dia",
	case ((DATE_PART('month', terminoaquisitivo)) + 11)
	when 23 then 11
	when 22 then 10
	when 21 then 09
	when 20 then 08
	when 19 then 07
	when 18 then 06
	when 17 then 05
	when 16 then 04
	when 15 then 03
	when 14 then 02
	when 13 then 01
	else (DATE_PART('month', terminoaquisitivo)) + 11
	end as "Mes",
       (DATE_PART('year', terminoaquisitivo)) + 1  as "Ano",


       
	
	iniciogozo, 
	terminogozo,
	iniciogozo1, 
        terminogozo1, 
        quantosavos,
        salariobase, 
        adicionais, 
        medias, 
        salariobase1, 
        adicionais1, 
        medias1

*/
