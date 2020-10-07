




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

%{
 const {NodoArbol} = require('../AST/NodoArbol');
 var id = 0;
 
 function incrementa() {
     id++;
 }
}%

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

S:                      INICIO EOF { 
                            return $1;
                        }
                        ;

INICIO:                 LINSTRUCCIONES {
                            id = incrementa();
                            var temp = nodoArbol(id, "INICIO");

                            id = incrementa();
                            temp.insertaHijo(id, $1.toString());
                        }
                        ;


LINSTRUCCIONES:         LINSTRUCCIONES INSTRUCCIONES {
                            //$1.push($2);
                            //$$ = $2;
                            id = incrementa();
                            var temp = nodoArbol(id, "LINSTRUCCIONES");

                            id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $2.toString());

                            $$ = temp;
                        }
                        | INSTRUCCIONES {
                            id = incrementa();
                            var temp = nodoArbol(id, "LINSTRUCCIONES");

                            id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            $$ = temp;
                        }
                        ;

INSTRUCCIONES:          IMPORT {
                            id = incrementa();
                            var temp = nodoArbol(id, "INSTRUCCIONES");

                            id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            $$ = temp;
                        }
                        | FUNCTION {
                            id = incrementa();
                            var temp = nodoArbol(id, "INSTRUCCIONES");

                            id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            $$ = temp;
                        }
                        | DEC_VARIABLE {
                            id = incrementa();
                            var temp = nodoArbol(id, "INSTRUCCIONES");

                            id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            $$ = temp;
                        }
                        | STRUCT_DEF {
                            id = incrementa();
                            var temp = nodoArbol(id, "INSTRUCCIONES");

                            id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            $$ = temp;
                        }

                        ;

 IMPORT:                tImport LISTID tPtcoma {
                            //se crea un nodo para el tImport
                            id = incrementa();
                            var raiz = new NodoArbol(id, "IMPORT");
                            id = incrementa();
                            raiz.insertaHijo(id, $1.toString());
                            id = incrementa();
                            raiz.insertaHijo(id, $2.toString());
                            id = incrementa();
                            raiz.insertaHijo(id, $3.toString());
                            $$ = raiz;   
                        }
                        ;

 LISTID:                LISTID  tComa Identificador {
                            id = incrementa();
                            var temp = nodoArbol(id, "DEC_VARIABLE");

                            id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $2.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $3.toString());

                            $$ = temp;
                        }
                        | Identificador {
                            id = incrementa();
                            var temp = nodoArbol(id, "DEC_VARIABLE");

                            id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            $$ = temp;
                        }
                        ;


DEC_VARIABLE:           tVar Identificador tDosPts tIgual CONDICION tPtcoma {
                            id = incrementa();
                            var temp = nodoArbol(id, "DEC_VARIABLE");

                            id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $2.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $3.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $4.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $5.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $6.toString());

                            $$ = temp;
                        }
                        | tConst Identificador tDosPts tIgual CONDICION tPtcoma {
                            id = incrementa();
                            var temp = nodoArbol(id, "DEC_VARIABLE");

                            id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $2.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $3.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $4.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $5.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $6.toString());

                            $$ = temp;
                        }
                        | tGlobal Identificador tDosPts tIgual CONDICION tPtcoma {
                            id = incrementa();
                            var temp = nodoArbol(id, "DEC_VARIABLE");

                            id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $2.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $3.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $4.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $5.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $6.toString());

                            $$ = temp;
                        }
                        | DEC_VARIABLE1 tPtcoma {
                            id = incrementa();
                            var temp = nodoArbol(id, "DEC_VARIABLE");

                            id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $2.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $3.toString());

                            $$ = temp;
                        }
                        | TIPOA LISTID tIgual CONDICION  tPtcoma {
                            id = incrementa();
                            var temp = nodoArbol(id, "DEC_VARIABLE");

                            id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $2.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $3.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $4.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $5.toString());

                            $$ = temp;
                        }
                        | Identificador LISTID tIgual CONDICION tPtcoma {
                            id = incrementa();
                            var temp = nodoArbol(id, "DEC_VARIABLE");

                            id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $2.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $3.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $4.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $5.toString());

                            $$ = temp;
                        }
                        | TIPOA LISTID  tPtcoma {
                            id = incrementa();
                            var temp = nodoArbol(id, "DEC_VARIABLE");

                            id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $2.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $3.toString());

                            $$ = temp;
                        }
                        | Identificador LISTID tPtcoma {
                            id = incrementa();
                            var temp = nodoArbol(id, "DEC_VARIABLE");

                            id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $2.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $3.toString());

                            $$ = temp;
                        }
                        ;

DEC_VARIABLE1:          Identificador LISTACOR Identificador tIgual CONDICION {
                            id = incrementa();
                            var temp = nodoArbol(id, "DEC_VARIABLE1");

                            id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $2.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $3.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $4.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $5.toString());

                            $$ = temp;
                        }
                        ;

TIPOA:                  TIPOP LISTACOR {
                            id = incrementa();
                            var temp = nodoArbol(id, "TIPOA");

                            id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $2.toString());

                            $$ = temp;
                        }
                        | TIPOP {
                            id = incrementa();
                            var temp = nodoArbol(id, "TIPOA");

                            id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            $$ = temp;
                        }
                        ;


TIPOP:                  tInteger {
                            id = incrementa();
                            var temp = nodoArbol(id, "TIPOP");

                            id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            $$ = temp;
                        }
                        | tDouble {
                            id = incrementa();
                            var temp = nodoArbol(id, "TIPOP");

                            id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            $$ = temp;
                        }
                        | tChar {
                            id = incrementa();
                            var temp = nodoArbol(id, "TIPOP");

                            id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            $$ = temp;
                        }
                        | tBoolean {
                            id = incrementa();
                            var temp = nodoArbol(id, "TIPOP");

                            id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            $$ = temp;
                        }
                        ;



TIPOS:                  tInteger {
                            id = incrementa();
                            var temp = nodoArbol(id, "TIPOS");

                            id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            $$ = temp;
                        }
                        | tDouble {
                            id = incrementa();
                            var temp = nodoArbol(id, "TIPOS");

                            id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            $$ = temp;
                        }
                        | tChar {
                            id = incrementa();
                            var temp = nodoArbol(id, "TIPOS");

                            id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            $$ = temp;
                        }
                        | tBoolean {
                            id = incrementa();
                            var temp = nodoArbol(id, "TIPOS");

                            id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            $$ = temp;
                        }
                        | Identificador {
                            id = incrementa();
                            var temp = nodoArbol(id, "TIPOS");

                            id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            $$ = temp;
                        }
                        ;

LISTACOR:               LISTACOR tCorizq tCorder {
                            id = incrementa();
                            var temp = nodoArbol(id, "LISTACOR");

                            id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $2.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $3.toString());

                            $$ = temp;
                        }
                        | tCorizq tCorder {
                            id = incrementa();
                            var temp = nodoArbol(id, "LISTACOR");

                            id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $2.toString());

                            $$ = temp;
                        }
                        ;




//FUNCIONES 
FUNCTION:               TIPOA Identificador tPara LCPARAML tParc tLlavea BODYFUN tLlavec {
                            id = incrementa();
                            var temp = nodoArbol(id, "FUNCTION");

                            id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $2.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $3.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $4.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $5.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $6.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $7.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $8.toString());

                            $$ = temp;
                        }    
                        | TIPOA Identificador tPara  tParc tLlavea BODYFUN tLlave {
                            id = incrementa();
                            var temp = nodoArbol(id, "FUNCTION");

                            id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $2.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $3.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $4.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $5.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $6.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $7.toString());

                            $$ = temp;
                        }  
                        | Identificador Identificador tPara LCPARAML tParc tLlavea BODYFUN tLlavec {
                            id = incrementa();
                            var temp = nodoArbol(id, "FUNCTION");

                            id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $2.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $3.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $4.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $5.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $6.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $7.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $8.toString());

                            $$ = temp;
                        }     
                        | Identificador Identificador tPara  tParc tLlavea BODYFUN tLlave {
                            id = incrementa();
                            var temp = nodoArbol(id, "FUNCTION");

                            id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $2.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $3.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $4.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $5.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $6.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $7.toString());

                            $$ = temp;
                        } 
                        | tVoid Identificador tPara tParc tLlavea BODYFUN tLlavec {
                            id = incrementa();
                            var temp = nodoArbol(id, "FUNCTION");

                            id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $2.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $3.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $4.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $5.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $6.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $7.toString());

                            $$ = temp;
                        }        
                        | tVoid Identificador tPara LCPARAML tParc tLlavea BODYFUN tLlavec {
                            id = incrementa();
                            var temp = nodoArbol(id, "FUNCTION");

                            id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $2.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $3.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $4.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $5.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $6.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $7.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $8.toString());

                            $$ = temp;
                        }     
                        | tLlavea error tLlavec  {
                            id = incrementa();
                            var temp = nodoArbol(id, "FUNCTION");

                            id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $2.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $3.toString());

                            $$ = temp;
                        }
                        ;       


/* LCPARAM1:               LCPARAML                    
                        | EPSILON                                 
                        ;             
 */

LCPARAML:               LCPARAML tComa TIPOA Identificador {
                            id = incrementa();
                            var temp = nodoArbol(id, "LCPARAML");

                            id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $2.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $3.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $4.toString());

                            $$ = temp;
                        }
                        | LCPARAML tComa Identificador Identificador {
                            id = incrementa();
                            var temp = nodoArbol(id, "LCPARAML");

                            id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $2.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $3.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $4.toString());

                            $$ = temp;
                        }
                        | TIPOA Identificador {
                            id = incrementa();
                            var temp = nodoArbol(id, "LCPARAML");

                            id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $2.toString());

                            $$ = temp;
                        }
                        | Identificador Identificador {
                            id = incrementa();
                            var temp = nodoArbol(id, "LCPARAML");

                            id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $2.toString());

                            $$ = temp;
                        }
                        ;


BODYFUN:                BODYFUN INS_FUN {
                            id = incrementa();
                            var temp = nodoArbol(id, "BODYFUN");

                            id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $2.toString());

                            $$ = temp;
                        }
                        | INS_FUN  {
                            id = incrementa();
                            var temp = nodoArbol(id, "BODYFUN");

                            id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            $$ = temp;
                        }                                 
                        ;


INS_FUN:                CNIF_F  {
                            id = incrementa();
                            var temp = nodoArbol(id, "INS_FUN");

                            id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            $$ = temp;
                        }                  
                        | WHILE_F  {
                            id = incrementa();
                            var temp = nodoArbol(id, "INS_FUN");

                            id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            $$ = temp;
                        }                              
                        | SWITCH_F {
                            id = incrementa();
                            var temp = nodoArbol(id, "INS_FUN");

                            id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            $$ = temp;
                        }                   
                        | ACCSATRI tPtcoma {
                            id = incrementa();
                            var temp = nodoArbol(id, "INS_FUN");

                            id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $2.toString());

                            $$ = temp;
                        }                                                    
                        | DO_F {
                            id = incrementa();
                            var temp = nodoArbol(id, "INS_FUN");

                            id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            $$ = temp;
                        }                              
                        | FOR_F  {
                            id = incrementa();
                            var temp = nodoArbol(id, "INS_FUN");

                            id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            $$ = temp;
                        }                          
                        | DEC_VARIABLE {
                            id = incrementa();
                            var temp = nodoArbol(id, "INS_FUN");

                            id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            $$ = temp;
                        }                                  
                        | CONDICION tPtcoma {
                            id = incrementa();
                            var temp = nodoArbol(id, "INS_FUN");

                            id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $2.toString());

                            $$ = temp;
                        }                          
                        | tReturn CONDICION tPtcoma {
                            id = incrementa();
                            var temp = nodoArbol(id, "INS_FUN");

                            id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $2.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $3.toString());

                            $$ = temp;
                        }                   
                        | PRINT tPtcoma {
                            id = incrementa();
                            var temp = nodoArbol(id, "INS_FUN");

                            id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $2.toString());

                            $$ = temp;
                        } 
                        | TRYCATCH {
                            id = incrementa();
                            var temp = nodoArbol(id, "INS_FUN");

                            id = incrementa();
                            temp.insertaHijo(id, $1.toString());
                        }
                        | error tPtcoma {
                            id = incrementa();
                            var temp = nodoArbol(id, "INS_FUN");

                            id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $2.toString());

                            $$ = temp;
                        }                               
                        ;


// INICO  SENTENCIA IF
CNIF_F:                 tIf tPara CONDICION tParc tLlavea BODYFUN tLlavec ELSEIF_F tElse tLlavea BODYFUN tLlavec {
                            id = incrementa();
                            var temp = nodoArbol(id, "CNIF_F");

                            id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $2.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $3.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $4.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $5.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $6.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $7.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $8.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $9.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $10.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $11.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $12.toString());

                            $$ = temp;
                        }
                        | tIf tPara CONDICION tParc tLlavea BODYFUN tLlavec tElse tLlavea BODYFUN tLlavec {
                            id = incrementa();
                            var temp = nodoArbol(id, "CNIF_F");

                            id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $2.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $3.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $4.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $5.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $6.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $7.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $8.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $9.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $10.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $11.toString());

                            $$ = temp;
                        }                  
                        | tIf tPara CONDICION tParc tLlavea BODYFUN tLlavec ELSEIF_F {
                            id = incrementa();
                            var temp = nodoArbol(id, "CNIF_F");

                            id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $2.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $3.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $4.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $5.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $6.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $7.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $8.toString());

                            $$ = temp;
                        }                
                        | tIf tPara CONDICION tParc tLlavea BODYFUN tLlavec {
                            id = incrementa();
                            var temp = nodoArbol(id, "CNIF_F");

                            id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $2.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $3.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $4.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $5.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $6.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $7.toString());

                            $$ = temp;
                        }
                        | tIf  error tPtcoma {
                            id = incrementa();
                            var temp = nodoArbol(id, "CNIF_F");

                            id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $2.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $3.toString());

                            $$ = temp;
                        }                   
                        ;



ELSEIF_F:               ELSEIF_F EI_F {
                            id = incrementa();
                            var temp = nodoArbol(id, "ELSEIF_F");

                            id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $2.toString());

                            $$ = temp;
                        }
                        | EI_F {
                            id = incrementa();
                            var temp = nodoArbol(id, "ELSEIF_F");

                            id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            $$ = temp;
                        }                 
                        ;


 EI_F:                  tElse tIf tPara CONDICION tParc tLlavea BODYFUN tLlavec {
                            id = incrementa();
                            var temp = nodoArbol(id, "EI_F");

                            id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $2.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $3.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $4.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $5.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $6.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $7.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $8.toString());

                            $$ = temp;
                        }  
                       ;    



// INICO  SENTENCIA SWITCH
SWITCH_F:               tSwitch tPara CONDICION tParc tLlavea LCASE_F tDefault tDosPts BODYFUN tBreak tPtcoma tLlavec {
                            id = incrementa();
                            var temp = nodoArbol(id, "SWITCH_F");

                            id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $2.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $3.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $4.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $5.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $6.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $7.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $8.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $9.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $10.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $11.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $12.toString());

                            $$ = temp;
                        }
                        | tSwitch tPara CONDICION tParc tLlavea LCASE_F tDefault tDosPts BODYFUN  tLlavec {
                            id = incrementa();
                            var temp = nodoArbol(id, "SWITCH_F");

                            id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $2.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $3.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $4.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $5.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $6.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $7.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $8.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $9.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $10.toString());

                            $$ = temp;
                        }
                        | tSwitch tPara CONDICION tParc tLlavea LCASE_F  tLlavec {
                            id = incrementa();
                            var temp = nodoArbol(id, "SWITCH_F");

                            id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $2.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $3.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $4.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $5.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $6.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $7.toString());

                            $$ = temp;
                        }
                        ;
    
                  


LCASE_F:                LCASE_F CASE_F {
                            id = incrementa();
                            var temp = nodoArbol(id, "LCASE_F");

                            id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $2.toString());

                            $$ = temp;
                        }
                        | CASE_F {
                            id = incrementa();
                            var temp = nodoArbol(id, "LCASE_F");

                            id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            $$ = temp;
                        }
                        ;


CASE_F:                 tCase VALOP tDosPts BODYFUN tBreak tPtcoma {
                            id = incrementa();
                            var temp = new NodoArbol(id, "CASE_F");

                            id = incrementa();
                            temp.insertaHijo(id, $1.toString());
                            id = incrementa();
                            temp.insertaHijo(id, $2.toString());
                            id = incrementa();
                            temp.insertaHijo(id, $3.toString());
                            id = incrementa();
                            temp.insertaHijo(id, $4.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $5.toString());
                            id = incrementa();
                            temp.insertaHijo(id, $6.toString());

                            $$ = temp;
                        }
                        | tCase VALOP tDosPts BODYFUN {
                            id = incrementa();
                            var temp = new NodoArbol(id, "CASE_F");

                            id = incrementa();
                            temp.insertaHijo(id, $1.toString());
                            id = incrementa();
                            temp.insertaHijo(id, $2.toString());
                            id = incrementa();
                            temp.insertaHijo(id, $3.toString());
                            id = incrementa();
                            temp.insertaHijo(id, $4.toString());

                            $$ = temp;
                        }
                        ;

VALOP:                  | Cadena{
                                    id = incrementa();
                                    var temp = new NodoArbol(id, "VALOP");

                                    id = incrementa();
                                    temp.insertaHijo(id, $1.toString());

                                    $$ = temp;
                                }
                        | Decimal{
                                    id = incrementa();
                                    var temp = new NodoArbol(id, "VALOP");

                                    id = incrementa();
                                    temp.insertaHijo(id, $1.toString());

                                    $$ = temp;
                                 }
                        | Number{ 
                                    id = incrementa();
                                    var temp = new NodoArbol(id, "VALOP");

                                    id = incrementa();
                                    temp.insertaHijo(id, $1.toString());

                                    $$ = temp;
                                }
                        | Carater{
                                    id = incrementa();
                                    var temp = new NodoArbol(id, "VALOP");

                                    id = incrementa();
                                    temp.insertaHijo(id, $1.toString());

                                    $$ = temp;
                                 }
                        ;

//WHILE 

WHILE_F:                tWhile tPara CONDICION tParc tLlavea BODYFUN tLlavec {
                            id = incrementa();
                            var temp = new nodoArbol(id, "WHILE_F");

                            id = incrementa();
                            temp.insertaHijo(id, $1.toString());
                            
                            id = incrementa();
                            temp.insertaHijo(id, $2.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $3.toString());
                            
                            id = incrementa();
                            temp.insertaHijo(id, $4.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $5.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $6.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $7.toString());
                            
                            $$ = temp;
                        }
                        ;

 
//DO DE UNA FUNCION:                                  
DO_F:                   tDo tLlavea BODYFUN tLlavec tWhile tPara CONDICION tParc tPtcoma {
                            id = incrementa();
                            var temp = new nodoArbol(id, "DO_F");

                            id = incrementa();
                            temp.insertaHijo(id, $1.toString());
                            
                            id = incrementa();
                            temp.insertaHijo(id, $2.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $3.toString());
                            
                            id = incrementa();
                            temp.insertaHijo(id, $4.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $5.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $6.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $7.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $8.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $9.toString());
                            
                            $$ = temp;
                        }
                        ;

// FOR DE UNA FUNCION
FOR_F:                  tFor tPara FORCON tParc tLlavea BODYFUN tLlavec {
                            id = incrementa();
                            var temp = new nodoArbol(id, "FOR_F");

                            id = incrementa();
                            temp.insertaHijo(id, $1.toString());
                            
                            id = incrementa();
                            temp.insertaHijo(id, $2.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $3.toString());
                            
                            id = incrementa();
                            temp.insertaHijo(id, $4.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $5.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $6.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $7.toString());
                            
                            $$ = temp;
                        }
                        ;                        

FORCON:                 FOR1  tPtcoma CONDICION tPtcoma ACCSATRI {
                            id = incrementa();
                            var temp = new nodoArbol(id, "FORCON");

                            id = incrementa();
                            temp.insertaHijo(id, $1.toString());
                            
                            id = incrementa();
                            temp.insertaHijo(id, $2.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $3.toString());
                            
                            id = incrementa();
                            temp.insertaHijo(id, $4.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $5.toString());
                            
                            $$ = temp;
                        }
                        | tPtcoma CONDICION tPtcoma ACCSATRI {
                            id = incrementa();
                            var temp = new nodoArbol(id, "FORCON");

                            id = incrementa();
                            temp.insertaHijo(id, $1.toString());
                            
                            id = incrementa();
                            temp.insertaHijo(id, $2.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $3.toString());
                            
                            id = incrementa();
                            temp.insertaHijo(id, $4.toString());
                            
                            $$ = temp;
                        }
                        | tPtcoma tPtcoma {
                            id = incrementa();
                            var temp = new nodoArbol(id, "FORCON");

                            id = incrementa();
                            temp.insertaHijo(id, $1.toString());
                            
                            id = incrementa();
                            temp.insertaHijo(id, $2.toString());
                            
                            $$ = temp;
                        }
                        ;

FOR1:                   DEC_VARIABLE1 {
                            id = incrementa();
                            var temp = new nodoArbol(id, "PRINT");

                            id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            $$ = temp;
                        }
                        | ACCSATRI {
                            id = incrementa();
                            var temp = new nodoArbol(id, "FOR1");

                            id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            $$ = temp;
                        }
                        ;


           

                     
//FUNCIONES 


PRINT:                  tPrint tPara PARAMETROS2 tParc {
                            id = incrementa();
                            var temp = new nodoArbol(id, "PRINT");

                            id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            $$ = temp;
                        }
                        ;


/***********************************PENDIENTE****************************/


// Asignacion variables
ACCSATRI:               LCALL tIgual CONDICION                                       
                        | LCALL tMasm                   
                        | LCALL tMenosm                                                    
                        ;

/******************************************************/


INSTHROW:               tThrow CONDICION tPtcoma {
                            id = incrementa();
                            var temp = new nodoArbol(id, "INSTHROW");

                            id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $2.toString());

                            $$ = temp;
                        }
                        ;


//TRY CATCH
TRYCATCH:               tTry tLlavea LCWHILE_F tLlavec tCatch tPara Identificador Identificador tParc tLlavea LCWHILE_F tLlavec {
                            id = incrementa();
                            var temp = nodoArbol(id, "TRYCATCH");

                            id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $2.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $3.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $4.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $5.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $6.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $7.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $8.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $9.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $10.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $11.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $12.toString());

                            $$ = temp;
                        }
                        ;



LCWHILE_F:              LCWHILE_F CWHILE_F {
                            id = incrementa();
                            var temp = nodoArbol(id, "LCWHILE_F");

                            id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $2.toString());

                            $$ = temp;
                        }
                        | CWHILE_F {
                            id = incrementa();
                            var temp = nodoArbol(id, "LCWHILE_F");

                            id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            $$ = temp;
                        }
                        ;

CWHILE_F:               CNIF_F {
                            id = incrementa();
                            var temp = nodoArbol(id, "CWHILE_F");

                            id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            $$ = temp;
                        }
                        | WHILE_F {
                            id = incrementa();
                            var temp = nodoArbol(id, "CWHILE_F");

                            id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            $$ = temp;
                        }                  
                        | SWITCH_F {
                            id = incrementa();
                            var temp = nodoArbol(id, "CWHILE_F");

                            id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            $$ = temp;
                        }                 
                        | DO_F  {
                            id = incrementa();
                            var temp = nodoArbol(id, "CWHILE_F");

                            id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            $$ = temp;
                        }                 
                        | FOR_F {
                            id = incrementa();
                            var temp = nodoArbol(id, "CWHILE_F");

                            id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            $$ = temp;
                        }                 
                        | DEC_VARIABLE  {
                            id = incrementa();
                            var temp = nodoArbol(id, "CWHILE_F");

                            id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            $$ = temp;
                        }  
                        | CONDICION tPtcoma {
                            id = incrementa();
                            var temp = nodoArbol(id, "CWHILE_F");

                            id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $2.toString());

                            $$ = temp;
                        }              
                        | ACCSATRI tPtcoma {
                            id = incrementa();
                            var temp = nodoArbol(id, "CWHILE_F");

                            id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $2.toString());

                            $$ = temp;
                        }                                      
                        | tBreak tPtcoma {
                            id = incrementa();
                            var temp = nodoArbol(id, "CWHILE_F");

                            id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $2.toString());

                            $$ = temp;
                        }                    
                        | tContinue tPtcoma {
                            id = incrementa();
                            var temp = nodoArbol(id, "CWHILE_F");

                            id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $2.toString());

                            $$ = temp;
                        }
                        | tReturn CONDICION tPtcoma  {
                            id = incrementa();
                            var temp = nodoArbol(id, "CWHILE_F");

                            id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $2.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $3.toString());

                            $$ = temp;
                        } 
                        | tReturn tPtcoma {
                            id = incrementa();
                            var temp = nodoArbol(id, "CWHILE_F");

                            id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $2.toString());

                            $$ = temp;
                        }  
                        | PRINT tPtcoma  {
                            id = incrementa();
                            var temp = nodoArbol(id, "CWHILE_F");

                            id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $2.toString());

                            $$ = temp;
                        }
                        |INSTHROW {
                            id = incrementa();
                            var temp = nodoArbol(id, "CWHILE_F");

                            id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            $$ = temp;
                        }       
                        ;



// ARREGLOS
DECARRAY:               TIPOP LISTACOR Identificador tIgual ARRAYIN tPtcoma {
                            id = incrementa();
                            var temp = nodoArbol(id, "DECARRAY");

                            id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $2.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $3.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $4.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $5.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $6.toString());

                            $$ = temp;
                        }
                        ;


ARRAYIN:                tStrc TIPOS LISTARREGLO {
                            id = incrementa();
                            var temp = nodoArbol(id, "VALORARRAY");

                            id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $2.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $3.toString());

                            $$ = temp;
                        }
                        | VALORARRAY {
                            id = incrementa();
                            var temp = nodoArbol(id, "ARRAYIN");

                            id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            $$ = temp;
                        }
                        ;


VALORARRAY:             tLlavea PARAMETROS2 tLlavec {
                            id = incrementa();
                            var temp = nodoArbol(id, "VALORARRAY");

                            id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            id = incremeta();
                            temp.insertaHijo(id, $2.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $3.toString());

                            $$ = temp;
                        }
                        ;

LISTARRAY:              LISTARRAY LISTAARR {
                            id = incrementa();
                            var temp = new nodoArbol(id, "LISTAARRAY");
                            
                            id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $1.toString());
                            
                            $$ = temp;
                        }
                        | LISTAARR {
                            id = incrementa();
                            var temp = new nodoArbol(id, "LISTAARRAY");

                            id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            $$ = temp;
                        }
                        ;  


LISTAARR:               PARAMETROS2 {
                            id = incrementa();
                            var temp = new nodoArbol(id, "LISTAARR");

                            id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            $$ = temp;
                        }
                        | VALORARRAY {
                            id = incrementa();
                            var temp = new nodoArbol(id, "LISTAARR");

                            id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            $$ = temp;
                        }
                        ;                        

LISTARREGLO:            LISTARREGLO tCorizq CONDICION tCorder {
                            id = incrementa();
                            var temp = new nodoArbol(id, "STRUCT_DEF");

                            id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $2.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $3.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $4.toString());

                            $$ = temp;
                        }
                        | tCorizq CONDICION tCorder {
                            id = incrementa();
                            var temp = new nodoArbol(id, "STRUCT_DEF");

                            id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $2.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $3.toString());

                            $$ = temp;
                        }
                        ;


//ESTRUCTURAS
STRUCT_DEF:             tDefine Identificador tAs tCorizq LISATRIB tCorder tPtcoma {
                            id = incrementa();
                            var temp = new nodoArbol(id, "STRUCT_DEF");

                            id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $2.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $3.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $4.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $5.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $6.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $7.toString());
                        }
                        ;


LISATRIB:               LISATRIB tComa ATRIBUTO {
                            id = incrementa();
                            var temp = new nodoArbol(id, "LISATRIB");

                            id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $2.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $3.toString());
                        }
                        | ATRIBUTO {
                            id = incrementa();
                            var temp = new nodoArbol(id, "LISATRIB");

                            id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                        }
                        ;

ATRIBUTO:               TIPOS Identificador {
                            id = incrementa();
                            var temp = new nodoArbol(id, "ATRIBUTO");

                            id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $2.toString());
                        }
                        | TIPOS Identificador tIgual CONDICION {
                            id = incrementa();
                            var temp = new nodoArbol(id, "ATRIBUTO");

                            id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $2.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $3.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $4.toString());

                            $$ = temp;
                        }
                        ;

CALSTRUCT:              tStrc Identificador  LISTACOR {
                            id = incrementa();
                            var temp = new nodoArbol(id, "CALSTRUCT");

                            id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $2.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $3.toString());

                            $$ = temp;
                        }
                        | tStrc Identificador tPara tParc {
                            id = incrementa();
                            var temp = new nodoArbol(id, "CALSTRUCT");

                            id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $2.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $3.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $4.toString());

                            $$ = temp;
                        }
                        | tStrc TIPOP LISTARREGLO { /*definicion de arreglo*/
                            id = incrementa();
                            var temp = new nodoArbol(id, "CALSTRUCT");

                            id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $2.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $3.toString());

                            $$ = temp;
                        }
                        | tStrc Identificador LISTARREGLO { /*definicion de arreglo*/
                            id = incrementa();
                            var temp = new nodoArbol(id, "CALSTRUCT");

                            id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $2.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $3.toString());

                            $$ = temp;
                        }
                        | VALORARRAY { /*definicion de arreglo*/
                            id = incrementa();
                            var temp = new nodoArbol(id, "CALSTRUCT");

                            id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            $$ = temp;
                        }
                        ;




CONDICION:              CONDICION tAnd CONDICION {
                            id = incrementa();
                            var temp = new nodoArbol(id, "CONDICION");

                            id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $2.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $3.toString());

                            $$ = temp;
                        }
                        | CONDICION tOr CONDICION {
                            id = incrementa();
                            var temp = new nodoArbol(id, "CONDICION");

                            id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $2.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $3.toString());

                            $$ = temp;
                        }           
                        | tNot CONDICION {
                            id = incrementa();
                            var temp = new nodoArbol(id, "CONDICION");

                            id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $2.toString());

                            $$ = temp;
                        }
                        | CONDICION tXor CONDICION {
                            id = incrementa();
                            var temp = new nodoArbol(id, "CONDICION");

                            id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $2.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $3.toString());

                            $$ = temp;
                        }     
                        | CONDICION tIguaIg CONDICION {
                            id = incrementa();
                            var temp = new nodoArbol(id, "CONDICION");

                            id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $2.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $3.toString());

                            $$ = temp;
                        }    
                        | CONDICION tNoIgu CONDICION {
                            id = incrementa();
                            var temp = new nodoArbol(id, "CONDICION");

                            id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $2.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $3.toString());

                            $$ = temp;
                        }  
                        | CONDICION tMayor CONDICION {
                            id = incrementa();
                            var temp = new nodoArbol(id, "CONDICION");

                            id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $2.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $3.toString());

                            $$ = temp;
                        }
                        | CONDICION tMenor CONDICION {
                            id = incrementa();
                            var temp = new nodoArbol(id, "CONDICION");

                            id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $2.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $3.toString());

                            $$ = temp;
                        }
                        | CONDICION tMayoI EX {
                            id = incrementa();
                            var temp = new nodoArbol(id, "CONDICION");

                            id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $2.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $3.toString());

                            $$ = temp;
                        }
                        | CONDICION tMenoI CONDICION {
                            id = incrementa();
                            var temp = new nodoArbol(id, "CONDICION");

                            id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $2.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $3.toString());

                            $$ = temp;
                        }     
                        | CONDICION tTern CONDICION tDosPts  CONDICION {
                            id = incrementa();
                            var temp = new nodoArbol(id, "CONDICION");

                            id = incrementa();
                            temp.insertaHijo(id, $1.toString());
                            
                            id = incrementa();
                            temp.insertaHijo(id, $2.toString());
                            
                            id = incrementa();
                            temp.insertaHijo(id, $3.toString());
                            
                            id = incrementa();
                            temp.insertaHijo(id, $4.toString());
                            
                            id = incrementa();
                            temp.insertaHijo(id, $5.toString());
                            $$ = temp;
                        }  
                        | tTrue {
                            id = incrementa();
                            var temp = new nodoArbol(id, "CONDICION");

                            id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            $$ = temp;
                        }
                        | tFalse {
                            id = incrementa();
                            var temp = new nodoArbol(id, "CONDICION");

                            id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            $$ = temp;
                        }              
                        | EX {
                            id = incrementa();
                            var temp = new nodoArbol(id, "CONDICION");

                            id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            $$ = temp;
                        }
                        ;



EX:                     EX tMas EX {
                            id = incrementa();
                            var temp = new nodoArbol(id, "EX");

                            id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $2.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $3.toString());
                            $$ = temp;
                        }                 
                        | EX tMenos EX {
                            id = incrementa();
                            var temp = new nodoArbol(id, "EX");

                            id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $2.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $3.toString());

                            $$ = temp;
                        }
                        | EX tPor EX {
                            id = incrementa();
                            var temp = new nodoArbol(id, "EX");

                            id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $2.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $3.toString());

                            $$ = temp;
                        }
                        | EX tDivision EX {
                            id = incrementa();
                            var temp = new nodoArbol(id, "EX");

                            id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $2.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $3.toString());

                            $$ = temp;
                        }
                        | Cadena {
                            id = incrementa();
                            var temp = new nodoArbol(id, "EX");

                            id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            $$ = temp;
                        }
                        | tPara CONDICION tParc {
                            id = incrementa();
                            var temp = new nodoArbol(id, "EX");

                            id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $2.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $3.toString());

                            var temp;
                        }
                        | LCALL {
                            id = incrementa();
                            var temp = new nodoArbol(id, "EX");

                            id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            $$ = temp;
                        }
                        | Decimal {
                            id = incrementa();
                            var temp = new nodoArbol(id, "EX");

                            id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            $$ = temp;
                        }
                        | Number {
                            id = incrementa();
                            var temp = new nodoArbol(id, "EX");

                            id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            $$ = temp;
                        }
                        | Carater {
                            id = incrementa();
                            var temp = new nodoArbol(id, "EX");

                            id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            $$ = temp;
                        }
                        | tMenos EX %prec UMINUS {
                            id = incrementa();
                            var temp = new nodoArbol(id, "EX");

                            id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $2.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $3.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $4.toString());

                            $$ = temp;
                        } 
                        | tNull {
                            id = incrementa();
                            var temp = new nodoArbol(id, "EX");

                            id = incrementa();
                            temp.insertaHijo(id, $1.toString());
                            $$ = temp;
                        }
                        | CALSTRUCT {
                            id = incrementa();
                            var temp = new nodoArbol(id, "EX");

                            id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            $$ = temp;
                        }
                        | Tokpara error Tokparc {
                            id = incrementa();
                            var temp = new nodoArbol(id, "EX");

                            id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $2.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $3.toString());
                        }
                        ;




PARAMETROS1:            PARAMETROS2 {
                            id = incrementa();
                            var temp = new nodoArbol(id, "PARAMETROS1");

                            id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            $$ = temp;
                        }
                        ; 

PARAMETROS2:            PARAMETROS2 tComa CONDICION {
                            id = incrementa();
                            var temp = new nodoArbol(id, "PARAMETROS2");

                            id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $2.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $3.toString());

                            $$ = temp;
                        }

                        | CONDICION {
                            id = incrementa();
                            var temp = new nodoArbol(id, "PARAMETROS2");

                            id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            $$ = temp;
                        }
                        ; 
       

//LLAMADAS DE TODO TIPO
LCALL:                  LCALL tPunto Identificador {
                            id = incrementa();
                            var temp = new nodoArbol(id, "LCALL");

                            id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $2.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $3.toString());

                            $$ = temp;

                        }
                        | LCALL tPunto Identificador tPara PARAMETROS2 tParc {
                            id = incrementa();
                            var temp = new NodoArbol(id, "LCALL");

                            id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $2.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $3.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $4.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $5.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $6.toString());

                            $$ = temp;
                        }
                        | LCALL tPunto Identificador tPara  tParc {
                            id = incrementa();
                            var temp = new NodoArbol(id, "LCALL");

                            id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $2.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $3.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $4.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $5.toString());

                            $$ = temp;
                        }
                        | LCALL tPunto Identificador LISTARREGLO {
                            id = incrementa();
                            var temp = new NodoArbol(id, "LCALL");

                            id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $2.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $3.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $4.toString());
                            
                            $$ = temp;
                        }
                        | Identificador {
                            id = incrementa();
                            var temp = new nodoArbol(id, "LCALL");

                            id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            $$ = temp;
                        }
                        | Identificador tPara PARAMETROS2 tParc {
                            id = incrementa();
                            var temp = new NodoArbol(id, "LCALL");

                            id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $2.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $3.toString());

                            id = incrementa();
                            temp.insertaHijo(id, $4.toString());

                            $$ = temp;
                        }
                        | Identificador LISTARREGLO {
                            id = incrementa();
                            var temp = new NodoArbol(id, "LCALL");
                            id = incrementa();
                            temp.insertaHijo(id, $1.toString());
                            id = incrementa();
                            temp.insertaHijo(id, $2.toString());

                            $$ = temp;
                        }
                        | Identificador tPara  tParc{
                            id = incrementa();
                            var temp = new NodoArbol(id, "LCALL");
                            id = incrementa();
                            temp.insertaHijo(id, $1.toString());
                            id = incrementa();
                            temp.insertaHijo(id, $2.toString());
                            id = incrementa();
                            temp.insertaHijo(id, $3.toString());

                            $$ = temp;
                        }
                        ;  


//CALFUNC:                Identificador tPara PARAMETORS2 


EPSILON:                { }
                        ;


