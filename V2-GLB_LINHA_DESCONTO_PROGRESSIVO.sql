
SELECT
NVL(APLICAR_DESCONTO_DE,0) AS APLICAR_DESCONTO_DE 
FROM
(
    /*
      COMPARA QTD_RECEBIDA COM A QTD ENCONTRADA EM CADA LINHA DE DESCONTO PARA O CLIENTE E ITEM ESPECIFICADO
      E RETORNA O MAIOR DESCONTO ENCONTRADO QUE A QTD RECEBIDA SEJA IGUAL, OU A PRIMEIRA IMEDIATAMENTE ANTERIOR
    */
    SELECT
    --RETORNA APENAS O REGISTRO COM A MAIOR QTD E QUE ATENDA AS CL�USULAS CONTIDAS NO WHERE
    MAX( CASE GLP_NU_QUANTIDADE 
               --SE A QTD_RECEBIDA FOR IGUAL ALGUMA EXISTENTE, RETORNA O % DE DESCONTO DA CORRESPOND�NCIA EXATA
                WHEN TO_NUMBER(:QTD_RECEBIDA) THEN GLP_PC_DESCONTO 
                /*
                  SEN�O, CASO A QTD_RECEBIDA N�O EXISTA EXATAMENTE NA TABELA, ENT�O RETORNO O REGISTRO 
                  COM A QTD MENOR IMEDIATAMENTE ANTERIOR A QTD_RECEBIDA
                */
                ELSE DECODE(GLP_NU_QUANTIDADE, :QTD_RECEBIDA, GLP_PC_DESCONTO, 
                                (SELECT PROG2.GLP_PC_DESCONTO AS APLICAR_DESCONTO
                                    FROM GLB_GRUPO_DESCONTO GRUPO2
                                        INNER JOIN GLB_LINHA_DESCONTO LINHA2 ON GRUPO2.GGD_CO_NUMERO = LINHA2.GGD_CO_NUMERO
                                        LEFT JOIN GLB_LINHA_DESCONTO_PROGRESSIVO PROG2 ON LINHA2.GLD_GRUPO_DESCONTO = PROG2.GLD_GRUPO_DESCONTO AND PROG2.GLP_IN_STATUS IS NULL
                                    WHERE PROG2.GLP_NU_QUANTIDADE < TO_NUMBER(:QTD_RECEBIDA) AND ROWNUM = 1
                                    AND GRUPO2.GGD_TIPO_GRUPO = 'OIT_GSK'
                                    AND LINHA2.PRO_CO_NUMERO = 7153
                                    AND LINHA2.CLI_CO_NUMERO = 377171)
                            )
         END) AS APLICAR_DESCONTO_DE
    
    FROM GLB_GRUPO_DESCONTO GRUPO
    
    INNER JOIN GLB_LINHA_DESCONTO LINHA ON GRUPO.GGD_CO_NUMERO = LINHA.GGD_CO_NUMERO
    LEFT JOIN GLB_LINHA_DESCONTO_PROGRESSIVO PROG ON LINHA.GLD_GRUPO_DESCONTO = PROG.GLD_GRUPO_DESCONTO 
          AND PROG.GLP_IN_STATUS IS NULL
    
    WHERE GRUPO.GGD_TIPO_GRUPO = 'OIT_GSK'
    AND LINHA.PRO_CO_NUMERO = 7153
    AND LINHA.CLI_CO_NUMERO = 377171
        
) SUBSELECT




/*
SELECT 
LINHA.GGD_CO_NUMERO, 
LINHA.GLD_GRUPO_DESCONTO, 
LINHA.PRO_CO_NUMERO, 
LINHA.CLI_CO_NUMERO, 
PROG.GLP_CO_PLANO, 
PROG.GLP_NU_QUANTIDADE, 
PROG.GLP_PC_DESCONTO, 
PROG.GLP_IN_STATUS,
CASE GLP_NU_QUANTIDADE
WHEN TO_NUMBER(:QTD_RECEBIDA) THEN GLP_PC_DESCONTO
ELSE (SELECT GLP_PC_DESCONTO 
            FROM GLB_LINHA_DESCONTO_PROGRESSIVO PROG2 
            WHERE (GLP_NU_QUANTIDADE < TO_NUMBER(:QTD_RECEBIDA) AND ROWNUM = 1))
END AS APLICAR_DESCONTO
FROM GLB_GRUPO_DESCONTO GRUPO

INNER JOIN GLB_LINHA_DESCONTO LINHA
ON GRUPO.GGD_CO_NUMERO = LINHA.GGD_CO_NUMERO
LEFT JOIN GLB_LINHA_DESCONTO_PROGRESSIVO PROG
ON LINHA.GLD_GRUPO_DESCONTO = PROG.GLD_GRUPO_DESCONTO
AND PROG.GLP_IN_STATUS IS NULL

WHERE GRUPO.GGD_TIPO_GRUPO = 'OIT_GSK'
AND LINHA.PRO_CO_NUMERO = 7153
AND LINHA.CLI_CO_NUMERO = 377171;
--AND GLP_NU_QUANTIDADE >= 5;
*/
