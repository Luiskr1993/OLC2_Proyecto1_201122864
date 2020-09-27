



/*Segmento de codigo
%{

}%

*/

/* Direcciones lexical de la gramatica */
%lex
%options flex case-insensitive 
%option yylineno 
%locations 
%%

/*
"\""([^\n\"\\]*(\\[.\n])*)*"\""  
*/

\s+                                   /* IGNORE */
"//".*                                /* IGNORE */
[/][*][^*]*[*]+([^/*][^*]*[*]+)*[/]   /* IGNORE */
\'([a-zA-z]|[0-9])\'                return 'Carater';
([0-9])+"."([0-9])*                 return 'Decimal';
[0-9]+("."[0-9]+)?\b                return 'Number';
\"([^\\\"]|\\.)*\"                  return 'Cadena';

"*"                                 return 'tPor';
"/"                                 return 'tDivision';
"-"                                 return 'tMenos';
"+"                                 return 'tMas';
"("                                 return 'tPara';
")"                                 return 'tParc';
"^"                                 return 'tXor';
"||"                                return 'tOr';
"&&"                                return 'tAnd';
"!"                                 return 'tNot';
"++"                                return 'tMasm';
"--"                                return 'tMenosm';
","                                 return 'tComa';
"."                                 return 'tPunto';
";"                                 return 'tPtcoma';
":"                                 return 'tDosPts';
"["                                 return 'tCorizq';
"]"                                 return 'tCorder';
"{"                                 return 'tLlavea';
"}"                                 return 'tLlavec';
"="                                 return 'tIgual';
"=="                                return 'tIguaIg';
"!="                                return 'tNoIgu';
"?"                                 return 'tTern'

">"                                 return 'tMayor';
"<"                                 return 'tMenor';
">="                                return 'tMayoI';
"<="                                return 'tMenoI';



"null"                              return  'tNull';
"import"                            return  'tImport';
"true"                              return  'tTrue';
"switch"                            return  'tSwitch';
"continue"                          return  'tContinue';
"private"                           return  'tPrivate';
"define"                            return  'tDefine';
"try"                               return  'tTry';
"integer"                           return  'tInteger';
"var"                               return  'tVar';
"false"                             return  'tFalse';
"case"                              return  'tCase';
"return"                            return  'tReturn';
"void"                              return  'tVoid';
"as"                                return  'tAs';
"catch"                             return  'tCatch';
"double"                            return  'tDouble';
"const"                             return  'tConst';
"if"                                return  'tIf';
"default"                           return  'tDefault';
"print"                             return  'tPrint';
"for"                               return  'tFor';
"strc"                              return  'tStrc';
"throw"                             return  'tThrow';
"char"                              return  'tChar';
"global"                            return  'tGlobal';
"else"                              return  'tElse';
"break"                             return  'tBreak';
"public"                            return  'tPublic';
"while"                             return  'tWhile';
"do"                                return  'tDo';
"Boolean"                           return  'tBoolean';



[a-zA-Z_][_a-zA-Z0-9ñÑ]*            return 'Identificador';


// EOF means "end of file"
<<EOF>>               return 'EOF'
// any other characters will throw an error
.                     return 'INVALID'

/lex

// Operator associations and precedence.
//
// This is the part that defines rules like
// e.g. multiplication/division apply before
// subtraction/addition, etc. Of course you can
// also be explicit by adding parentheses, as
// we all learned in elementary school.
//
// Notice that there's this weird UMINUS thing.
// This is a special Bison/Jison trick for preferring
// the unary interpretation of the minus sign, e.g.
// -2^2 should be interpreted as (-2)^2 and not -(2^2).
//
// Details here:
// http://web.mit.edu/gnu/doc/html/bison_8.html#SEC76

%left tMas 
%left tMenos
%left tPor 
%left tDivision
%left tAnd 
%left tXor
%left tOr 
%left tNot
%left tMayor 
%left tMenor 
%left tMayoI 
%left tMenoI
%left tIguaIg
%left tNoIgu
%left tTern
%left UMINUS




%start S

%% /* language grammar */

// At the top level, you explicitly return
// the result. $1 refers to the first child node,
// i.e. the "e"

S:                      INICIO EOF
                        ;

INICIO:                 LINSTRUCCIONES
                        ;


LINSTRUCCIONES:         LINSTRUCCIONES INSTRUCCIONES
                        | INSTRUCCIONES
                        ;

INSTRUCCIONES:          IMPORT
                        | FUNCTION 
                        | DEC_VARIABLE
                        | STRUCT_DEF

                        ;

 IMPORT:                tImport LISTID tPtcoma
                        ;

 LISTID:                LISTID  tComa Identificador
                        | Identificador
                        ;


DEC_VARIABLE:           tVar Identificador tDosPts tIgual CONDICION tPtcoma
                        | tConst Identificador tDosPts tIgual CONDICION tPtcoma
                        | tGlobal Identificador tDosPts tIgual CONDICION tPtcoma
                        | DEC_VARIABLE1 tPtcoma
                        | TIPOA LISTID tIgual CONDICION  tPtcoma
                        | Identificador LISTID tIgual CONDICION tPtcoma
                        | TIPOA LISTID  tPtcoma
                        | Identificador LISTID tPtcoma
                        ;

DEC_VARIABLE1:          Identificador LISTACOR Identificador tIgual CONDICION 
                        ;

TIPOA:                  TIPOP LISTACOR
                        | TIPOP
                        ;


TIPOP:                  tInteger
                        | tDouble
                        | tChar
                        | tBoolean
                        ;



TIPOS:                  tInteger
                        | tDouble
                        | tChar
                        | tBoolean
                        | Identificador
                        ;

LISTACOR:               LISTACOR tCorizq tCorder
                        | tCorizq tCorder
                        ;




//FUNCIONES 
FUNCTION:               TIPOA Identificador tPara LCPARAML tParc tLlavea BODYFUN tLlavec      
                        | TIPOA Identificador tPara  tParc tLlavea BODYFUN tLlave   
                        | Identificador Identificador tPara LCPARAML tParc tLlavea BODYFUN tLlavec      
                        | Identificador Identificador tPara  tParc tLlavea BODYFUN tLlave 
                        | tVoid Identificador tPara tParc tLlavea BODYFUN tLlavec         
                        | tVoid Identificador tPara LCPARAML tParc tLlavea BODYFUN tLlavec      
                        | tLlavea error tLlavec  
                        ;       


/* LCPARAM1:               LCPARAML                    
                        | EPSILON                                 
                        ;             
 */

LCPARAML:               LCPARAML tComa TIPOA Identificador
                        | LCPARAML tComa Identificador Identificador
                        | TIPOA Identificador
                        | Identificador Identificador
                        ;


BODYFUN:                BODYFUN INS_FUN
                        | INS_FUN                                   
                        ;


INS_FUN:                CNIF_F                    
                        | WHILE_F                                
                        | SWITCH_F                    
                        | ACCSATRI tPtcoma                                                     
                        | DO_F                                
                        | FOR_F                            
                        | DEC_VARIABLE                                   
                        | CONDICION tPtcoma                            
                        | tReturn CONDICION tPtcoma                    
                        | PRINT tPtcoma   
                        | TRYCATCH
                        | error tPtcoma                                
                        ;


// INICO  SENTENCIA IF
CNIF_F:                 tIf tPara CONDICION tParc tLlavea BODYFUN tLlavec ELSEIF_F tElse tLlavea BODYFUN tLlavec
                        | tIf tPara CONDICION tParc tLlavea BODYFUN tLlavec tElse tLlavea BODYFUN tLlavec                  
                        | tIf tPara CONDICION tParc tLlavea BODYFUN tLlavec ELSEIF_F                  
                        | tIf tPara CONDICION tParc tLlavea BODYFUN tLlavec 
                        | tIf  error tPtcoma                     
                        ;



ELSEIF_F:               ELSEIF_F EI_F
                        | EI_F                  
                        ;


 EI_F:                  tElse tIf tPara CONDICION tParc tLlavea BODYFUN tLlavec  
                       ;    



// INICO  SENTENCIA SWITCH
SWITCH_F:               tSwitch tPara CONDICION tParc tLlavea LCASE_F tDefault tDosPts BODYFUN tBreak tPtcoma tLlavec
                        | tSwitch tPara CONDICION tParc tLlavea LCASE_F tDefault tDosPts BODYFUN  tLlavec
                        | tSwitch tPara CONDICION tParc tLlavea LCASE_F  tLlavec
                        ;
    
                  


LCASE_F:                LCASE_F CASE_F
                        | CASE_F
                        ;


CASE_F:                 tCase VALOP tDosPts BODYFUN tBreak tPtcoma
                        | tCase VALOP tDosPts BODYFUN 
                        ;

VALOP:                  | Cadena
                        | Decimal
                        | Number
                        | Carater
                        ;

//WHILE 

WHILE_F:                tWhile tPara CONDICION tParc tLlavea BODYFUN tLlavec
                        ;

 
//DO DE UNA FUNCION:                                  
DO_F:                   tDo tLlavea BODYFUN tLlavec tWhile tPara CONDICION tParc tPtcoma
                        ;

// FOR DE UNA FUNCION
FOR_F:                  tFor tPara FORCON tParc tLlavea BODYFUN tLlavec
                        ;                        

FORCON:                 FOR1  tPtcoma CONDICION tPtcoma ACCSATRI
                        | tPtcoma CONDICION tPtcoma ACCSATRI
                        | tPtcoma tPtcoma
                        ;

FOR1:                   DEC_VARIABLE1
                        | ACCSATRI
                        ;


           

                     
//FUNCIONES 


PRINT:                  tPrint tPara PARAMETROS2 tParc
                        ;


/***********************************PENDIENTE****************************/


// Asignacion variables
ACCSATRI:               LCALL tIgual CONDICION                                       
                        | LCALL tMasm                   
                        | LCALL tMenosm                                                    
                        ;

/******************************************************/


INSTHROW:               tThrow CONDICION tPtcoma
                        ;


//TRY CATCH
TRYCATCH:               tTry tLlavea LCWHILE_F tLlavec tCatch tPara Identificador Identificador tParc tLlavea LCWHILE_F tLlavec
                        ;



LCWHILE_F:              LCWHILE_F CWHILE_F
                        | CWHILE_F
                        ;

CWHILE_F:               CNIF_F
                        | WHILE_F                   
                        | SWITCH_F                  
                        | DO_F                   
                        | FOR_F                 
                        | DEC_VARIABLE    
                        | CONDICION tPtcoma                
                        | ACCSATRI tPtcoma                                       
                        | tBreak tPtcoma                    
                        | tContinue tPtcoma
                        | tReturn CONDICION tPtcoma   
                        | tReturn tPtcoma   
                        | PRINT tPtcoma  
                        |INSTHROW        
                        ;



// ARREGLOS
DECARRAY:               TIPOP LISTACOR Identificador tIgual ARRAYIN tPtcoma
                        ;


ARRAYIN:                tStrc TIPOS LISTARREGLO
                        | VALORARRAY
                        ;


VALORARRAY:             tLlavea PARAMETROS2 tLlavec
                        ;

LISTARRAY:              LISTARRAY LISTAARR
                        | LISTAARR
                        ;  


LISTAARR:               PARAMETROS2
                        | VALORARRAY
                        ;                        

LISTARREGLO:            LISTARREGLO tCorizq CONDICION tCorder
                        | tCorizq CONDICION tCorder
                        ;


//ETRUCTURAS
STRUCT_DEF:             tDefine Identificador tAs tCorizq LISATRIB tCorder tPtcoma
                        ;


LISATRIB:               LISATRIB tComa ATRIBUTO
                        | ATRIBUTO
                        ;

ATRIBUTO:               TIPOS Identificador
                        | TIPOS Identificador tIgual CONDICION
                        ;

CALSTRUCT:              tStrc Identificador  LISTACOR
                        | tStrc Identificador tPara tParc
                        | tStrc TIPOP LISTARREGLO /*definicion de arreglo*/
                        | tStrc Identificador LISTARREGLO /*definicion de arreglo*/
                        | VALORARRAY /*definicion de arreglo*/
                        ;




CONDICION:              CONDICION tAnd CONDICION
                        | CONDICION tOr CONDICION            
                        | tNot CONDICION 
                        | CONDICION tXor CONDICION       
                        | CONDICION tIguaIg CONDICION     
                        | CONDICION tNoIgu CONDICION   
                        | CONDICION tMayor CONDICION  
                        | CONDICION tMenor CONDICION
                        | CONDICION tMayoI EX
                        | CONDICION tMenoI CONDICION       
                        | CONDICION tTern CONDICION tDosPts  CONDICION    
                        | tTrue
                        | tFalse                
                        | EX
                        ;



EX:                     EX tMas EX                  
                        | EX tMenos EX
                        | EX tPor EX
                        | EX tDivision EX
                        | Cadena
                        | tPara CONDICION tParc
                        | LCALL
                        | Decimal
                        | Number
                        | Carater
                        | tMenos EX %prec UMINUS   
                        | tNull 
                        | CALSTRUCT
                        | Tokpara error Tokparc 

                     
                        ;




PARAMETROS1:            PARAMETROS2 
                        ; 

PARAMETROS2:            PARAMETROS2 tComa CONDICION
                        | CONDICION
                        ; 
       

//LLAMADAS DE TODO TIPO
LCALL:                  LCALL tPunto Identificador
                        | LCALL tPunto Identificador tPara PARAMETROS2 tParc
                        | LCALL tPunto Identificador tPara  tParc
                        | LCALL tPunto Identificador LISTARREGLO
                        | Identificador 
                        | Identificador tPara PARAMETROS2 tParc
                        | Identificador LISTARREGLO
                        | Identificador tPara  tParc
                        ;  


//CALFUNC:                Identificador tPara PARAMETORS2 


EPSILON:                { }
                        ;


