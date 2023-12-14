/* EXAMPLE OF TRIGGER PROGRESS DATABASE ERP DATASUL

RAFAEL PREVIDI 01/12/2023 

ao alterar alguns campos do ítem ou adicionar um ítem
grava informações a respeito na tabela log_item 
*/

/* DECLARAR BUFFER PARA OS ESTADOS DAS TABELAS AO ENTRAR NO REGISTRO E AO SAIR DO REGISTRO*/
DEF PARAM BUFFER p-table FOR ITEM.
DEF PARAM BUFFER p-table-old FOR ITEM.

/* v_cod_usuar_corren é uma variavel global do datasul que armazena o  usuário conectado naquela sessão*/
def shared var v_cod_usuar_corren as character format "x(12)":U label "Usuario Corrente" column-label "Usuario Corrente" NO-uNDO.
DEF NEW GLOBAL SHARED VAR c-motivo          AS CHAR NO-UNDO.


/* efetuar grava»’o da data na tabela ao incluir um novo código*/

IF p-table-old.it-codigo = "" AND 
   p-table.it-codigo <> "" THEN DO:

   
    CREATE LOG_item.
    ASSIGN LOG_item.data-hora    = datetime(string(TODAY,"99/99/9999") + " " + string(TIME + 1,"HH:MM:SS"))
           LOG_item.it-codigo    = p-table.it-codigo
           LOG_item.motivo       = c-motivo           
           LOG_item.usuario      = v_cod_usuar_corren.
END.

/*efetuar gravação na tabela ao alterar alguns dos campos abaixo*/
IF (p-table.cod-obsoleto <> p-table-old.cod-obsoleto OR   
   p-table.ge-codigo    <> p-table-old.ge-codigo    OR
   p-table.fm-codigo    <> p-table-old.fm-codigo    OR
   p-table.fm-cod-com   <> p-table-old.fm-cod-com   OR
   p-table.cod-comprado <> p-table-old.cod-comprado ) AND
    p-table-old.it-codigo <> ""   THEN DO: 

    CREATE LOG_item.
    ASSIGN LOG_item.data-hora    = datetime(string(TODAY,"99/99/9999") + " " + string(TIME + 2,"HH:MM:SS"))
           LOG_item.it-codigo    = p-table.it-codigo
           LOG_item.motivo       = c-motivo           
           LOG_item.usuario      = v_cod_usuar_corren.
    
END.

c-motivo = "".

RETURN "OK":U.
