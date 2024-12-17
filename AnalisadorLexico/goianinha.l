%{
#include <stdio.h>
#include <stdlib.h>


#define PROGRAMA 1
#define INT 2
#define CAR 3
#define RETORNE 4
#define LEIA 5
#define ESCREVA 6
#define NOVALINHA 7
#define SE 8
#define ENTAO 9
#define SENAO 10
#define ENQUANTO 11
#define EXECUTE 12
#define ID 13
#define INTCONST 14
#define CARCONST 15

int yywrap() {
    return 1;
}

extern int yylineno;
%}

%x COMMENT

digit       [0-9]
letter      [a-zA-Z_]
id          {letter}({letter}|{digit})*
intconst    {digit}+
carconst    '([^']|\\')'

%%

"programa"          { return PROGRAMA; }
"int"               { return INT; }
"car"               { return CAR; }
"retorne"           { return RETORNE; }
"leia"              { return LEIA; }
"escreva"           { return ESCREVA; }
"novalinha"         { return NOVALINHA; }
"se"                { return SE; }
"entao"             { return ENTAO; }
"senao"             { return SENAO; }
"enquanto"          { return ENQUANTO; }
"execute"           { return EXECUTE; }

{id}                { printf("IDENTIFIER: %s\n", yytext); return ID; }
{intconst}          { printf("INTEGER CONSTANT: %s\n", yytext); return INTCONST; }
{carconst}          { printf("CHARACTER CONSTANT: %s\n", yytext); return CARCONST; }

\"[^\"]*\"          { printf("STRING: %s\n", yytext); }

"+"                 { return '+'; }
"-"                 { return '-'; }
"*"                 { return '*'; }
"/"                 { return '/'; }
"="                 { return '='; }
";"                 { return ';'; }
","                 { return ','; }
"("                 { return '('; }
")"                 { return ')'; }
"{"                 { return '{'; }
"}"                 { return '}'; }
"<"                 { return '<'; }
">"                 { return '>'; }
"<="                { return 100; }
">="                { return 101; }
"=="                { return 102; }
"!="                { return 103; }

[ \t]+              /* Ignora espaços e tabs */
\n                  { yylineno++; }

"/*"                { BEGIN COMMENT; }
<COMMENT>[^*\n]+    /* Ignora conteúdo dentro do comentário */
<COMMENT>"*/"       { BEGIN INITIAL; }
<COMMENT>\n         { yylineno++; }

.                   { printf("CARACTERE INVÁLIDO: %s\n", yytext); exit(1); }

%%
