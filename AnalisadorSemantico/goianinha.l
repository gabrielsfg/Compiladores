%{
#include "goianinha.sintatico.h"
%}

%option yylineno

%%
[ \t\n]+                 { /* Ignorar espaços, tabs e quebras de linha */ }
"int"                    { return INT; }
"car"                    { return CAR; }
"programa"               { return PROGRAMA; }
"retorne"                { return RETORNE; }
"leia"                   { return LEIA; }
"escreva"                { return ESCREVA; }
"novalinha"              { return NOVALINHA; }
"se"                     { return SE; }
"entao"                  { return ENTAO; }
"senao"                  { return SENAO; }
"enquanto"               { return ENQUANTO; }
"execute"                { return EXECUTE; }

"=="                     { return EQ; }
"!="                     { return NE; }
">="                     { return GE; }
"<="                     { return LE; }
">"                      { return GT; }
"<"                      { return LT; }
"+"                      { return PLUS; }
"-"                      { return MINUS; }
"*"                      { return TIMES; }
"/"                      { return DIVIDE; }
"="                      { return ASSIGN; }
"!"                      { return NOT; }
","                      { return ','; }
";"                      { return ';'; }
"{"                      { return '{'; }
"}"                      { return '}'; }
"\"[^\"]*\""             { return STRING; }
\"[^\"]*$                { yyterminate(); }
"("                      { return '('; }
")"                      { return ')'; }



[a-zA-Z_][a-zA-Z0-9_]*   { return ID; }
[0-9]+                   { return INTCONST; }
\'.\'                    { return CARCONST; }
\"[^\"]*\"               { return STRING; }

.                        { fprintf(stderr, "ERRO: syntax error na linha %d\n", yylineno); yyterminate(); }

%%

int yywrap() {
    return 1;
}
