




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
     id = id + 1;

     return id;
 }
%}

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
                            var id = incrementa();
                            var temp = new NodoArbol(id, "INICIO");

                            var id = incrementa();
                            temp.insertaHijo(id, $1.toString());
                            $$ = temp;
                        }
                        ;


LINSTRUCCIONES:         LINSTRUCCIONES INSTRUCCIONES {
                            //$1.push($2);
                            //$$ = $2;
                            var id = incrementa();
                            var temp = new NodoArbol(id, "LINSTRUCCIONES");

                            var id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $2.toString());

                            $$ = temp;
                        }
                        | INSTRUCCIONES {
                            var id = incrementa();
                            var temp = new NodoArbol(id, "LINSTRUCCIONES");

                            var id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            $$ = temp;
                        }
                        ;

INSTRUCCIONES:          IMPORT {
                            var id = incrementa();
                            var temp = new NodoArbol(id, "INSTRUCCIONES");

                            var id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            $$ = temp;
                        }
                        | FUNCTION {
                            var id = incrementa();
                            var temp = new NodoArbol(id, "INSTRUCCIONES");

                            var id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            $$ = temp;
                        }
                        | DEC_VARIABLE {
                            var id = incrementa();
                            var temp = new NodoArbol(id, "INSTRUCCIONES");

                            var id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            $$ = temp;
                        }
                        | STRUCT_DEF {
                            var id = incrementa();
                            var temp = new NodoArbol(id, "INSTRUCCIONES");

                            var id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            $$ = temp;
                        }

                        ;

 IMPORT:                tImport LISTID tPtcoma {
                            //se crea un nodo para el tImport
                            var id = incrementa();
                            var raiz = new NodoArbol(id, "IMPORT");
                            var id = incrementa();
                            raiz.insertaHijo(id, $1.toString());
                            var id = incrementa();
                            raiz.insertaHijo(id, $2.toString());
                            var id = incrementa();
                            raiz.insertaHijo(id, $3.toString());
                            $$ = raiz;   
                        }
                        ;

 LISTID:                LISTID  tComa Identificador {
                            var id = incrementa();
                            var temp = new NodoArbol(id, "DEC_VARIABLE");

                            var id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $2.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $3.toString());

                            $$ = temp;
                        }
                        | Identificador {
                            var id = incrementa();
                            var temp = new NodoArbol(id, "DEC_VARIABLE");

                            var id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            $$ = temp;
                        }
                        ;


DEC_VARIABLE:           tVar Identificador tDosPts tIgual CONDICION tPtcoma {
                            var id = incrementa();
                            var temp = new NodoArbol(id, "DEC_VARIABLE");

                            var id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $2.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $3.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $4.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $5.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $6.toString());

                            $$ = temp;
                        }
                        | tConst Identificador tDosPts tIgual CONDICION tPtcoma {
                            var id = incrementa();
                            var temp = new NodoArbol(id, "DEC_VARIABLE");

                            var id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $2.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $3.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $4.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $5.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $6.toString());

                            $$ = temp;
                        }
                        | tGlobal Identificador tDosPts tIgual CONDICION tPtcoma {
                            var id = incrementa();
                            var temp =  new NodoArbol(id, "DEC_VARIABLE");

                            var id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $2.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $3.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $4.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $5.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $6.toString());

                            $$ = temp;
                        }
                        | DEC_VARIABLE1 tPtcoma {
                            var id = incrementa();
                            var temp =  new NodoArbol(id, "DEC_VARIABLE");

                            var id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $2.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $3.toString());

                            $$ = temp;
                        }
                        | TIPOA LISTID tIgual CONDICION  tPtcoma {
                            var id = incrementa();
                            var temp = new NodoArbol(id, "DEC_VARIABLE");

                            var id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $2.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $3.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $4.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $5.toString());

                            $$ = temp;
                        }
                        | Identificador LISTID tIgual CONDICION tPtcoma {
                            var id = incrementa();
                            var temp = new NodoArbol(id, "DEC_VARIABLE");

                            var id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $2.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $3.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $4.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $5.toString());

                            $$ = temp;
                        }
                        | TIPOA LISTID  tPtcoma {
                            var id = incrementa();
                            var temp = new NodoArbol(id, "DEC_VARIABLE");

                            var id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $2.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $3.toString());

                            $$ = temp;
                        }
                        | Identificador LISTID tPtcoma {
                            var id = incrementa();
                            var temp = new NodoArbol(id, "DEC_VARIABLE");

                            var id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $2.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $3.toString());

                            $$ = temp;
                        }
                        | Identificador tDosPts TIPOS tIgual CONDICION tPtcoma {
                            var id = incrementa();
                            var temp = new NodoArbol(id, "DEC_VARIABLE");

                            var id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $2.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $3.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $4.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $5.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $6.toString());

                            $$ = temp;
                        }
                        | Identificador tDosPts TIPOS tPtcoma {
                            var id = incrementa();
                            var temp = new NodoArbol(id, "DEC_VARIABLE");

                            var id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $2.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $3.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $4.toString());

                        }
                        ;

DEC_VARIABLE1:          Identificador LISTACOR Identificador tIgual CONDICION {
                            var id = incrementa();
                            var temp = new NodoArbol(id, "DEC_VARIABLE1");

                            var id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $2.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $3.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $4.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $5.toString());

                            $$ = temp;
                        }
                        ;

TIPOA:                  TIPOP LISTACOR {
                            var id = incrementa();
                            var temp = new NodoArbol(id, "TIPOA");

                            var id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $2.toString());

                            $$ = temp;
                        }
                        | TIPOP {
                            var id = incrementa();
                            var temp = new NodoArbol(id, "TIPOA");

                            var id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            $$ = temp;
                        }
                        ;


TIPOP:                  tInteger {
                            var id = incrementa();
                            var temp = new NodoArbol(id, "TIPOP");

                            var id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            $$ = temp;
                        }
                        | tDouble {
                            var id = incrementa();
                            var temp = new NodoArbol(id, "TIPOP");

                            var id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            $$ = temp;
                        }
                        | tChar {
                            var id = incrementa();
                            var temp = new NodoArbol(id, "TIPOP");

                            var id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            $$ = temp;
                        }
                        | tBoolean {
                            var id = incrementa();
                            var temp = new NodoArbol(id, "TIPOP");

                            var id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            $$ = temp;
                        }
                        ;



TIPOS:                  tInteger {
                            var id = incrementa();
                            var temp = new NodoArbol(id, "TIPOS");

                            var id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            $$ = temp;
                        }
                        | tDouble {
                            var id = incrementa();
                            var temp = new NodoArbol(id, "TIPOS");

                            var id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            $$ = temp;
                        }
                        | tChar {
                            var id = incrementa();
                            var temp = new NodoArbol(id, "TIPOS");

                            var id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            $$ = temp;
                        }
                        | tBoolean {
                            var id = incrementa();
                            var temp = new NodoArbol(id, "TIPOS");

                            var id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            $$ = temp;
                        }
                        | Identificador {
                            var id = incrementa();
                            var temp = new NodoArbol(id, "TIPOS");

                            var id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            $$ = temp;
                        }
                        ;

LISTACOR:               LISTACOR tCorizq tCorder {
                            var id = incrementa();
                            var temp = new NodoArbol(id, "LISTACOR");

                            var id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $2.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $3.toString());

                            $$ = temp;
                        }
                        | tCorizq tCorder {
                            var id = incrementa();
                            var temp = new NodoArbol(id, "LISTACOR");

                            var id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $2.toString());

                            $$ = temp;
                        }
                        ;




//FUNCIONES 
FUNCTION:               TIPOA Identificador tPara LCPARAML tParc tLlavea BODYFUN tLlavec {
                            var id = incrementa();
                            var temp = new NodoArbol(id, "FUNCTION");

                            var id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $2.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $3.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $4.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $5.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $6.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $7.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $8.toString());

                            $$ = temp;
                        }    
                        | TIPOA Identificador tPara  tParc tLlavea BODYFUN tLlave {
                            var id = incrementa();
                            var temp = new NodoArbol(id, "FUNCTION");

                            var id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $2.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $3.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $4.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $5.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $6.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $7.toString());

                            $$ = temp;
                        }  
                        | Identificador Identificador tPara LCPARAML tParc tLlavea BODYFUN tLlavec {
                            var id = incrementa();
                            var temp = new NodoArbol(id, "FUNCTION");

                            var id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $2.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $3.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $4.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $5.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $6.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $7.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $8.toString());

                            $$ = temp;
                        }     
                        | Identificador Identificador tPara  tParc tLlavea BODYFUN tLlave {
                            var id = incrementa();
                            var temp = new NodoArbol(id, "FUNCTION");

                            var id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $2.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $3.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $4.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $5.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $6.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $7.toString());

                            $$ = temp;
                        } 
                        | tVoid Identificador tPara tParc tLlavea BODYFUN tLlavec {
                            var id = incrementa();
                            var temp = new NodoArbol(id, "FUNCTION");

                            var id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $2.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $3.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $4.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $5.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $6.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $7.toString());

                            $$ = temp;
                        }        
                        | tVoid Identificador tPara LCPARAML tParc tLlavea BODYFUN tLlavec {
                            var id = incrementa();
                            var temp = new NodoArbol(id, "FUNCTION");

                            var id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $2.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $3.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $4.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $5.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $6.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $7.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $8.toString());

                            $$ = temp;
                        }     
                        | tLlavea error tLlavec  {
                            var id = incrementa();
                            var temp = new NodoArbol(id, "FUNCTION");

                            var id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $2.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $3.toString());

                            $$ = temp;
                        }
                        ;       


/* LCPARAM1:               LCPARAML                    
                        | EPSILON                                 
                        ;             
 */

LCPARAML:               LCPARAML tComa TIPOA Identificador {
                            var id = incrementa();
                            var temp = new NodoArbol(id, "LCPARAML");

                            var id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $2.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $3.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $4.toString());

                            $$ = temp;
                        }
                        | LCPARAML tComa Identificador Identificador {
                            var id = incrementa();
                            var temp = new NodoArbol(id, "LCPARAML");

                            var id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $2.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $3.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $4.toString());

                            $$ = temp;
                        }
                        | TIPOA Identificador {
                            var id = incrementa();
                            var temp = new NodoArbol(id, "LCPARAML");

                            var id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $2.toString());

                            $$ = temp;
                        }
                        | Identificador Identificador {
                            var id = incrementa();
                            var temp = new NodoArbol(id, "LCPARAML");

                            var id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $2.toString());

                            $$ = temp;
                        }
                        ;


BODYFUN:                BODYFUN INS_FUN {
                            var id = incrementa();
                            var temp = new NodoArbol(id, "BODYFUN");

                            var id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $2.toString());

                            $$ = temp;
                        }
                        | INS_FUN  {
                            var id = incrementa();
                            var temp = new NodoArbol(id, "BODYFUN");

                            var id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            $$ = temp;
                        }                                 
                        ;


INS_FUN:                CNIF_F  {
                            var id = incrementa();
                            var temp = new NodoArbol(id, "INS_FUN");

                            var id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            $$ = temp;
                        }                  
                        | WHILE_F  {
                            var id = incrementa();
                            var temp = new NodoArbol(id, "INS_FUN");

                            var id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            $$ = temp;
                        }                              
                        | SWITCH_F {
                            var id = incrementa();
                            var temp = new NodoArbol(id, "INS_FUN");

                            var id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            $$ = temp;
                        }                   
                        | ACCSATRI tPtcoma {
                            var id = incrementa();
                            var temp = new NodoArbol(id, "INS_FUN");

                            var id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $2.toString());

                            $$ = temp;
                        }                                                    
                        | DO_F {
                            var id = incrementa();
                            var temp = new NodoArbol(id, "INS_FUN");

                            var id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            $$ = temp;
                        }                              
                        | FOR_F  {
                            var id = incrementa();
                            var temp = new NodoArbol(id, "INS_FUN");

                            var id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            $$ = temp;
                        }                          
                        | DEC_VARIABLE {
                            var id = incrementa();
                            var temp = new NodoArbol(id, "INS_FUN");

                            var id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            $$ = temp;
                        }                                  
                        | CONDICION tPtcoma {
                            var id = incrementa();
                            var temp = new NodoArbol(id, "INS_FUN");

                            var id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $2.toString());

                            $$ = temp;
                        }                          
                        | tReturn CONDICION tPtcoma {
                            var id = incrementa();
                            var temp = new NodoArbol(id, "INS_FUN");

                            var id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $2.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $3.toString());

                            $$ = temp;
                        }                   
                        | PRINT tPtcoma {
                            var id = incrementa();
                            var temp = new NodoArbol(id, "INS_FUN");

                            var id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $2.toString());

                            $$ = temp;
                        } 
                        | TRYCATCH {
                            var id = incrementa();
                            var temp = new NodoArbol(id, "INS_FUN");

                            var id = incrementa();
                            temp.insertaHijo(id, $1.toString());
                        }
                        | error tPtcoma {
                            var id = incrementa();
                            var temp = new NodoArbol(id, "INS_FUN");

                            var id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $2.toString());

                            $$ = temp;
                        }                               
                        ;


// INICO  SENTENCIA IF
CNIF_F:                 tIf tPara CONDICION tParc tLlavea BODYFUN tLlavec ELSEIF_F tElse tLlavea BODYFUN tLlavec {
                            var id = incrementa();
                            var temp = new NodoArbol(id, "CNIF_F");

                            var id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $2.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $3.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $4.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $5.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $6.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $7.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $8.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $9.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $10.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $11.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $12.toString());

                            $$ = temp;
                        }
                        | tIf tPara CONDICION tParc tLlavea BODYFUN tLlavec tElse tLlavea BODYFUN tLlavec {
                            var id = incrementa();
                            var temp = new NodoArbol(id, "CNIF_F");

                            var id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $2.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $3.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $4.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $5.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $6.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $7.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $8.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $9.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $10.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $11.toString());

                            $$ = temp;
                        }                  
                        | tIf tPara CONDICION tParc tLlavea BODYFUN tLlavec ELSEIF_F {
                            var id = incrementa();
                            var temp = new NodoArbol(id, "CNIF_F");

                            var id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $2.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $3.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $4.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $5.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $6.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $7.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $8.toString());

                            $$ = temp;
                        }                
                        | tIf tPara CONDICION tParc tLlavea BODYFUN tLlavec {
                            var id = incrementa();
                            var temp = new NodoArbol(id, "CNIF_F");

                            var id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $2.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $3.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $4.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $5.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $6.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $7.toString());

                            $$ = temp;
                        }
                        | tIf  error tPtcoma {
                            var id = incrementa();
                            var temp = new NodoArbol(id, "CNIF_F");

                            var id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $2.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $3.toString());

                            $$ = temp;
                        }                   
                        ;



ELSEIF_F:               ELSEIF_F EI_F {
                            var id = incrementa();
                            var temp = new NodoArbol(id, "ELSEIF_F");

                            var id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $2.toString());

                            $$ = temp;
                        }
                        | EI_F {
                            var id = incrementa();
                            var temp = new NodoArbol(id, "ELSEIF_F");

                            var id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            $$ = temp;
                        }                 
                        ;


 EI_F:                  tElse tIf tPara CONDICION tParc tLlavea BODYFUN tLlavec {
                            var id = incrementa();
                            var temp = new NodoArbol(id, "EI_F");

                            var id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $2.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $3.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $4.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $5.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $6.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $7.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $8.toString());

                            $$ = temp;
                        }  
                       ;    



// INICO  SENTENCIA SWITCH
SWITCH_F:               tSwitch tPara CONDICION tParc tLlavea LCASE_F tDefault tDosPts BODYFUN tBreak tPtcoma tLlavec {
                            var id = incrementa();
                            var temp = new NodoArbol(id, "SWITCH_F");

                            var id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $2.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $3.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $4.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $5.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $6.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $7.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $8.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $9.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $10.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $11.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $12.toString());

                            $$ = temp;
                        }
                        | tSwitch tPara CONDICION tParc tLlavea LCASE_F tDefault tDosPts BODYFUN  tLlavec {
                            var id = incrementa();
                            var temp = new NodoArbol(id, "SWITCH_F");

                            var id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $2.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $3.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $4.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $5.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $6.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $7.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $8.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $9.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $10.toString());

                            $$ = temp;
                        }
                        | tSwitch tPara CONDICION tParc tLlavea LCASE_F  tLlavec {
                            var id = incrementa();
                            var temp = new NodoArbol(id, "SWITCH_F");

                            var id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $2.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $3.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $4.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $5.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $6.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $7.toString());

                            $$ = temp;
                        }
                        ;
    
                  


LCASE_F:                LCASE_F CASE_F {
                            var id = incrementa();
                            var temp = new NodoArbol(id, "LCASE_F");

                            var id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $2.toString());

                            $$ = temp;
                        }
                        | CASE_F {
                            var id = incrementa();
                            var temp = new NodoArbol(id, "LCASE_F");

                            var id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            $$ = temp;
                        }
                        ;


CASE_F:                 tCase VALOP tDosPts BODYFUN tBreak tPtcoma {
                            var id = incrementa();
                            var temp = new NodoArbol(id, "CASE_F");

                            var id = incrementa();
                            temp.insertaHijo(id, $1.toString());
                            var id = incrementa();
                            temp.insertaHijo(id, $2.toString());
                            var id = incrementa();
                            temp.insertaHijo(id, $3.toString());
                            var id = incrementa();
                            temp.insertaHijo(id, $4.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $5.toString());
                            var id = incrementa();
                            temp.insertaHijo(id, $6.toString());

                            $$ = temp;
                        }
                        | tCase VALOP tDosPts BODYFUN {
                            var id = incrementa();
                            var temp = new NodoArbol(id, "CASE_F");

                            var id = incrementa();
                            temp.insertaHijo(id, $1.toString());
                            var id = incrementa();
                            temp.insertaHijo(id, $2.toString());
                            var id = incrementa();
                            temp.insertaHijo(id, $3.toString());
                            var id = incrementa();
                            temp.insertaHijo(id, $4.toString());

                            $$ = temp;
                        }
                        ;

VALOP:                  | Cadena{
                                    var id = incrementa();
                                    var temp = new NodoArbol(id, "VALOP");

                                    var id = incrementa();
                                    temp.insertaHijo(id, $1.toString());

                                    $$ = temp;
                                }
                        | Decimal{
                                    var id = incrementa();
                                    var temp = new NodoArbol(id, "VALOP");

                                    var id = incrementa();
                                    temp.insertaHijo(id, $1.toString());

                                    $$ = temp;
                                 }
                        | Number{ 
                                    var id = incrementa();
                                    var temp = new NodoArbol(id, "VALOP");

                                    var id = incrementa();
                                    temp.insertaHijo(id, $1.toString());

                                    $$ = temp;
                                }
                        | Carater{
                                    var id = incrementa();
                                    var temp = new NodoArbol(id, "VALOP");

                                    var id = incrementa();
                                    temp.insertaHijo(id, $1.toString());

                                    $$ = temp;
                                 }
                        ;

//WHILE 

WHILE_F:                tWhile tPara CONDICION tParc tLlavea BODYFUN tLlavec {
                            var id = incrementa();
                            var temp = new NodoArbol(id, "WHILE_F");

                            var id = incrementa();
                            temp.insertaHijo(id, $1.toString());
                            
                            var id = incrementa();
                            temp.insertaHijo(id, $2.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $3.toString());
                            
                            var id = incrementa();
                            temp.insertaHijo(id, $4.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $5.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $6.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $7.toString());
                            
                            $$ = temp;
                        }
                        ;

 
//DO DE UNA FUNCION:                                  
DO_F:                   tDo tLlavea BODYFUN tLlavec tWhile tPara CONDICION tParc tPtcoma {
                            var id = incrementa();
                            var temp = new NodoArbol(id, "DO_F");

                            var id = incrementa();
                            temp.insertaHijo(id, $1.toString());
                            
                            var id = incrementa();
                            temp.insertaHijo(id, $2.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $3.toString());
                            
                            var id = incrementa();
                            temp.insertaHijo(id, $4.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $5.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $6.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $7.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $8.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $9.toString());
                            
                            $$ = temp;
                        }
                        ;

// FOR DE UNA FUNCION
FOR_F:                  tFor tPara FORCON tParc tLlavea BODYFUN tLlavec {
                            var id = incrementa();
                            var temp = new NodoArbol(id, "FOR_F");

                            var id = incrementa();
                            temp.insertaHijo(id, $1.toString());
                            
                            var id = incrementa();
                            temp.insertaHijo(id, $2.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $3.toString());
                            
                            var id = incrementa();
                            temp.insertaHijo(id, $4.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $5.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $6.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $7.toString());
                            
                            $$ = temp;
                        }
                        ;                        

FORCON:                 FOR1  tPtcoma CONDICION tPtcoma ACCSATRI {
                            var id = incrementa();
                            var temp = new NodoArbol(id, "FORCON");

                            var id = incrementa();
                            temp.insertaHijo(id, $1.toString());
                            
                            var id = incrementa();
                            temp.insertaHijo(id, $2.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $3.toString());
                            
                            var id = incrementa();
                            temp.insertaHijo(id, $4.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $5.toString());
                            
                            $$ = temp;
                        }
                        | tPtcoma CONDICION tPtcoma ACCSATRI {
                            var id = incrementa();
                            var temp = new NodoArbol(id, "FORCON");

                            var id = incrementa();
                            temp.insertaHijo(id, $1.toString());
                            
                            var id = incrementa();
                            temp.insertaHijo(id, $2.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $3.toString());
                            
                            var id = incrementa();
                            temp.insertaHijo(id, $4.toString());
                            
                            $$ = temp;
                        }
                        | tPtcoma tPtcoma {
                            var id = incrementa();
                            var temp = new NodoArbol(id, "FORCON");

                            var id = incrementa();
                            temp.insertaHijo(id, $1.toString());
                            
                            var id = incrementa();
                            temp.insertaHijo(id, $2.toString());
                            
                            $$ = temp;
                        }
                        ;

FOR1:                   DEC_VARIABLE1 {
                            var id = incrementa();
                            var temp = new NodoArbol(id, "PRINT");

                            var id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            $$ = temp;
                        }
                        | ACCSATRI {
                            var id = incrementa();
                            var temp = new NodoArbol(id, "FOR1");

                            var id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            $$ = temp;
                        }
                        ;


           

                     
//FUNCIONES 


PRINT:                  tPrint tPara PARAMETROS2 tParc {
                            var id = incrementa();
                            var temp = new NodoArbol(id, "PRINT");

                            var id = incrementa();
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
                            var id = incrementa();
                            var temp = new NodoArbol(id, "INSTHROW");

                            var id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $2.toString());

                            $$ = temp;
                        }
                        ;


//TRY CATCH
TRYCATCH:               tTry tLlavea LCWHILE_F tLlavec tCatch tPara Identificador Identificador tParc tLlavea LCWHILE_F tLlavec {
                            var id = incrementa();
                            var temp = new NodoArbol(id, "TRYCATCH");

                            var id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $2.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $3.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $4.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $5.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $6.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $7.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $8.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $9.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $10.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $11.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $12.toString());

                            $$ = temp;
                        }
                        ;



LCWHILE_F:              LCWHILE_F CWHILE_F {
                            var id = incrementa();
                            var temp = new NodoArbol(id, "LCWHILE_F");

                            var id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $2.toString());

                            $$ = temp;
                        }
                        | CWHILE_F {
                            var id = incrementa();
                            var temp = new NodoArbol(id, "LCWHILE_F");

                            var id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            $$ = temp;
                        }
                        ;

CWHILE_F:               CNIF_F {
                            var id = incrementa();
                            var temp = new NodoArbol(id, "CWHILE_F");

                            var id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            $$ = temp;
                        }
                        | WHILE_F {
                            var id = incrementa();
                            var temp = new NodoArbol(id, "CWHILE_F");

                            var id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            $$ = temp;
                        }                  
                        | SWITCH_F {
                            var id = incrementa();
                            var temp = new NodoArbol(id, "CWHILE_F");

                            var id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            $$ = temp;
                        }                 
                        | DO_F  {
                            var id = incrementa();
                            var temp = new NodoArbol(id, "CWHILE_F");

                            var id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            $$ = temp;
                        }                 
                        | FOR_F {
                            var id = incrementa();
                            var temp = new NodoArbol(id, "CWHILE_F");

                            var id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            $$ = temp;
                        }                 
                        | DEC_VARIABLE  {
                            var id = incrementa();
                            var temp = new NodoArbol(id, "CWHILE_F");

                            var id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            $$ = temp;
                        }  
                        | CONDICION tPtcoma {
                            var id = incrementa();
                            var temp = new NodoArbol(id, "CWHILE_F");

                            var id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $2.toString());

                            $$ = temp;
                        }              
                        | ACCSATRI tPtcoma {
                            var id = incrementa();
                            var temp = new NodoArbol(id, "CWHILE_F");

                            var id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $2.toString());

                            $$ = temp;
                        }                                      
                        | tBreak tPtcoma {
                            var id = incrementa();
                            var temp = new NodoArbol(id, "CWHILE_F");

                            var id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $2.toString());

                            $$ = temp;
                        }                    
                        | tContinue tPtcoma {
                            var id = incrementa();
                            var temp = new NodoArbol(id, "CWHILE_F");

                            var id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $2.toString());

                            $$ = temp;
                        }
                        | tReturn CONDICION tPtcoma  {
                            var id = incrementa();
                            var temp = new NodoArbol(id, "CWHILE_F");

                            var id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $2.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $3.toString());

                            $$ = temp;
                        } 
                        | tReturn tPtcoma {
                            var id = incrementa();
                            var temp = new NodoArbol(id, "CWHILE_F");

                            var id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $2.toString());

                            $$ = temp;
                        }  
                        | PRINT tPtcoma  {
                            var id = incrementa();
                            var temp = new NodoArbol(id, "CWHILE_F");

                            var id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $2.toString());

                            $$ = temp;
                        }
                        |INSTHROW {
                            var id = incrementa();
                            var temp = new NodoArbol(id, "CWHILE_F");

                            var id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            $$ = temp;
                        }       
                        ;



// ARREGLOS
DECARRAY:               TIPOP LISTACOR Identificador tIgual ARRAYIN tPtcoma {
                            var id = incrementa();
                            var temp = new NodoArbol(id, "DECARRAY");

                            var id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $2.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $3.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $4.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $5.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $6.toString());

                            $$ = temp;
                        }
                        ;


ARRAYIN:                tStrc TIPOS LISTARREGLO {
                            var id = incrementa();
                            var temp = new NodoArbol(id, "VALORARRAY");

                            var id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $2.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $3.toString());

                            $$ = temp;
                        }
                        | VALORARRAY {
                            var id = incrementa();
                            var temp = new NodoArbol(id, "ARRAYIN");

                            var id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            $$ = temp;
                        }
                        ;


VALORARRAY:             tLlavea PARAMETROS2 tLlavec {
                            var id = incrementa();
                            var temp = new NodoArbol(id, "VALORARRAY");

                            var id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            id = incremeta();
                            temp.insertaHijo(id, $2.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $3.toString());

                            $$ = temp;
                        }
                        ;

LISTARRAY:              LISTARRAY LISTAARR {
                            var id = incrementa();
                            var temp = new NodoArbol(id, "LISTAARRAY");
                            
                            var id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $1.toString());
                            
                            $$ = temp;
                        }
                        | LISTAARR {
                            var id = incrementa();
                            var temp = new NodoArbol(id, "LISTAARRAY");

                            var id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            $$ = temp;
                        }
                        ;  


LISTAARR:               PARAMETROS2 {
                            var id = incrementa();
                            var temp = new NodoArbol(id, "LISTAARR");

                            var id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            $$ = temp;
                        }
                        | VALORARRAY {
                            var id = incrementa();
                            var temp = new NodoArbol(id, "LISTAARR");

                            var id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            $$ = temp;
                        }
                        ;                        

LISTARREGLO:            LISTARREGLO tCorizq CONDICION tCorder {
                            var id = incrementa();
                            var temp = new NodoArbol(id, "STRUCT_DEF");

                            var id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $2.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $3.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $4.toString());

                            $$ = temp;
                        }
                        | tCorizq CONDICION tCorder {
                            var id = incrementa();
                            var temp = new NodoArbol(id, "STRUCT_DEF");

                            var id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $2.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $3.toString());

                            $$ = temp;
                        }
                        ;


//ESTRUCTURAS
STRUCT_DEF:             tDefine Identificador tAs tCorizq LISATRIB tCorder tPtcoma {
                            var id = incrementa();
                            var temp = new NodoArbol(id, "STRUCT_DEF");

                            var id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $2.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $3.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $4.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $5.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $6.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $7.toString());
                            $$ = temp;
                        }
                        ;


LISATRIB:               LISATRIB tComa ATRIBUTO {
                            var id = incrementa();
                            var temp = new NodoArbol(id, "LISATRIB");

                            var id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $2.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $3.toString());
                            $$ = temp;
                        }
                        | ATRIBUTO {
                            var id = incrementa();
                            var temp = new NodoArbol(id, "LISATRIB");

                            var id = incrementa();
                            temp.insertaHijo(id, $1.toString());
                            $$ = temp;

                        }
                        ;

ATRIBUTO:               TIPOS Identificador {
                            var id = incrementa();
                            var temp = new NodoArbol(id, "ATRIBUTO");

                            var id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $2.toString());
                            $$ = temp;
                        }
                        | TIPOS Identificador tIgual CONDICION {
                            var id = incrementa();
                            var temp = new NodoArbol(id, "ATRIBUTO");

                            var id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $2.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $3.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $4.toString());

                            $$ = temp;
                        }
                        ;

CALSTRUCT:              tStrc Identificador  LISTACOR {
                            var id = incrementa();
                            var temp = new NodoArbol(id, "CALSTRUCT");

                            var id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $2.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $3.toString());

                            $$ = temp;
                        }
                        | tStrc Identificador tPara tParc {
                            var id = incrementa();
                            var temp = new NodoArbol(id, "CALSTRUCT");

                            var id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $2.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $3.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $4.toString());

                            $$ = temp;
                        }
                        | tStrc TIPOP LISTARREGLO { /*definicion de arreglo*/
                            var id = incrementa();
                            var temp = new NodoArbol(id, "CALSTRUCT");

                            var id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $2.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $3.toString());

                            $$ = temp;
                        }
                        | tStrc Identificador LISTARREGLO { /*definicion de arreglo*/
                            var id = incrementa();
                            var temp = new NodoArbol(id, "CALSTRUCT");

                            var id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $2.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $3.toString());

                            $$ = temp;
                        }
                        | VALORARRAY { /*definicion de arreglo*/
                            var id = incrementa();
                            var temp = new NodoArbol(id, "CALSTRUCT");

                            var id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            $$ = temp;
                        }
                        ;




CONDICION:              CONDICION tAnd CONDICION {
                            var id = incrementa();
                            var temp = new NodoArbol(id, "CONDICION");

                            var id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $2.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $3.toString());

                            $$ = temp;
                        }
                        | CONDICION tOr CONDICION {
                            var id = incrementa();
                            var temp = new NodoArbol(id, "CONDICION");

                            var id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $2.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $3.toString());

                            $$ = temp;
                        }           
                        | tNot CONDICION {
                            var id = incrementa();
                            var temp = new NodoArbol(id, "CONDICION");

                            var id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $2.toString());

                            $$ = temp;
                        }
                        | CONDICION tXor CONDICION {
                            var id = incrementa();
                            var temp = new NodoArbol(id, "CONDICION");

                            var id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $2.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $3.toString());

                            $$ = temp;
                        }     
                        | CONDICION tIguaIg CONDICION {
                            var id = incrementa();
                            var temp = new NodoArbol(id, "CONDICION");

                            var id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $2.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $3.toString());

                            $$ = temp;
                        }    
                        | CONDICION tNoIgu CONDICION {
                            var id = incrementa();
                            var temp = new NodoArbol(id, "CONDICION");

                            var id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $2.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $3.toString());

                            $$ = temp;
                        }  
                        | CONDICION tMayor CONDICION {
                            var id = incrementa();
                            var temp = new NodoArbol(id, "CONDICION");

                            var id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $2.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $3.toString());

                            $$ = temp;
                        }
                        | CONDICION tMenor CONDICION {
                            var id = incrementa();
                            var temp = new NodoArbol(id, "CONDICION");

                            var id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $2.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $3.toString());

                            $$ = temp;
                        }
                        | CONDICION tMayoI EX {
                            var id = incrementa();
                            var temp = new NodoArbol(id, "CONDICION");

                            var id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $2.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $3.toString());

                            $$ = temp;
                        }
                        | CONDICION tMenoI CONDICION {
                            var id = incrementa();
                            var temp = new NodoArbol(id, "CONDICION");

                            var id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $2.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $3.toString());

                            $$ = temp;
                        }     
                        | CONDICION tTern CONDICION tDosPts  CONDICION {
                            var id = incrementa();
                            var temp = new NodoArbol(id, "CONDICION");

                            var id = incrementa();
                            temp.insertaHijo(id, $1.toString());
                            
                            var id = incrementa();
                            temp.insertaHijo(id, $2.toString());
                            
                            var id = incrementa();
                            temp.insertaHijo(id, $3.toString());
                            
                            var id = incrementa();
                            temp.insertaHijo(id, $4.toString());
                            
                            var id = incrementa();
                            temp.insertaHijo(id, $5.toString());
                            $$ = temp;
                        }  
                        | tTrue {
                            var id = incrementa();
                            var temp = new NodoArbol(id, "CONDICION");

                            var id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            $$ = temp;
                        }
                        | tFalse {
                            var id = incrementa();
                            var temp = new NodoArbol(id, "CONDICION");

                            var id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            $$ = temp;
                        }              
                        | EX {
                            var id = incrementa();
                            var temp = new NodoArbol(id, "CONDICION");

                            var id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            $$ = temp;
                        }
                        ;



EX:                     EX tMas EX {
                            var id = incrementa();
                            var temp = new NodoArbol(id, "EX");

                            var id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $2.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $3.toString());
                            $$ = temp;
                        }                 
                        | EX tMenos EX {
                            var id = incrementa();
                            var temp = new NodoArbol(id, "EX");

                            var id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $2.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $3.toString());

                            $$ = temp;
                        }
                        | EX tPor EX {
                            var id = incrementa();
                            var temp = new NodoArbol(id, "EX");

                            var id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $2.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $3.toString());

                            $$ = temp;
                        }
                        | EX tDivision EX {
                            var id = incrementa();
                            var temp = new NodoArbol(id, "EX");

                            var id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $2.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $3.toString());

                            $$ = temp;
                        }
                        | Cadena {
                            var id = incrementa();
                            var temp = new NodoArbol(id, "EX");

                            var id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            $$ = temp;
                        }
                        | tPara CONDICION tParc {
                            var id = incrementa();
                            var temp = new NodoArbol(id, "EX");

                            var id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $2.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $3.toString());

                            var temp;
                        }
                        | LCALL {
                            var id = incrementa();
                            var temp = new NodoArbol(id, "EX");

                            var id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            $$ = temp;
                        }
                        | Decimal {
                            var id = incrementa();
                            var temp = new NodoArbol(id, "EX");

                            var id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            $$ = temp;
                        }
                        | Number {
                            var id = incrementa();
                            var temp = new NodoArbol(id, "EX");

                            var id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            $$ = temp;
                        }
                        | Carater {
                            var id = incrementa();
                            var temp = new NodoArbol(id, "EX");

                            var id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            $$ = temp;
                        }
                        | tMenos EX %prec UMINUS {
                            var id = incrementa();
                            var temp = new NodoArbol(id, "EX");

                            var id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $2.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $3.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $4.toString());

                            $$ = temp;
                        } 
                        | tNull {
                            var id = incrementa();
                            var temp = new NodoArbol(id, "EX");

                            var id = incrementa();
                            temp.insertaHijo(id, $1.toString());
                            $$ = temp;
                        }
                        | CALSTRUCT {
                            var id = incrementa();
                            var temp = new NodoArbol(id, "EX");

                            var id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            $$ = temp;
                        }
                        | Tokpara error Tokparc {
                            var id = incrementa();
                            var temp = new NodoArbol(id, "EX");

                            var id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $2.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $3.toString());
                            $$ = temp;
                        }
                        ;




PARAMETROS1:            PARAMETROS2 {
                            var id = incrementa();
                            var temp = new NodoArbol(id, "PARAMETROS1");

                            var id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            $$ = temp;
                        }
                        ; 

PARAMETROS2:            PARAMETROS2 tComa CONDICION {
                            var id = incrementa();
                            var temp = new NodoArbol(id, "PARAMETROS2");

                            var id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $2.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $3.toString());

                            $$ = temp;
                        }

                        | CONDICION {
                            var id = incrementa();
                            var temp = new NodoArbol(id, "PARAMETROS2");

                            var id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            $$ = temp;
                        }
                        ; 
       

//LLAMADAS DE TODO TIPO
LCALL:                  LCALL tPunto Identificador {
                            var id = incrementa();
                            var temp = new NodoArbol(id, "LCALL");

                            var id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $2.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $3.toString());

                            $$ = temp;

                        }
                        | LCALL tPunto Identificador tPara PARAMETROS2 tParc {
                            var id = incrementa();
                            var temp = new NodoArbol(id, "LCALL");

                            var id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $2.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $3.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $4.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $5.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $6.toString());

                            $$ = temp;
                        }
                        | LCALL tPunto Identificador tPara  tParc {
                            var id = incrementa();
                            var temp = new NodoArbol(id, "LCALL");

                            var id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $2.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $3.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $4.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $5.toString());

                            $$ = temp;
                        }
                        | LCALL tPunto Identificador LISTARREGLO {
                            var id = incrementa();
                            var temp = new NodoArbol(id, "LCALL");

                            var id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $2.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $3.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $4.toString());
                            
                            $$ = temp;
                        }
                        | Identificador {
                            var id = incrementa();
                            var temp = new NodoArbol(id, "LCALL");

                            var id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            $$ = temp;
                        }
                        | Identificador tPara PARAMETROS2 tParc {
                            var id = incrementa();
                            var temp = new NodoArbol(id, "LCALL");

                            var id = incrementa();
                            temp.insertaHijo(id, $1.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $2.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $3.toString());

                            var id = incrementa();
                            temp.insertaHijo(id, $4.toString());

                            $$ = temp;
                        }
                        | Identificador LISTARREGLO {
                            var id = incrementa();
                            var temp = new NodoArbol(id, "LCALL");
                            var id = incrementa();
                            temp.insertaHijo(id, $1.toString());
                            var id = incrementa();
                            temp.insertaHijo(id, $2.toString());

                            $$ = temp;
                        }
                        | Identificador tPara  tParc{
                            var id = incrementa();
                            var temp = new NodoArbol(id, "LCALL");
                            var id = incrementa();
                            temp.insertaHijo(id, $1.toString());
                            var id = incrementa();
                            temp.insertaHijo(id, $2.toString());
                            var id = incrementa();
                            temp.insertaHijo(id, $3.toString());

                            $$ = temp;
                        }
                        ;  


//CALFUNC:                Identificador tPara PARAMETORS2 


EPSILON:                { }
                        ;


