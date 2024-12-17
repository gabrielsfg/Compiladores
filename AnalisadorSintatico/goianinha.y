%{
#include <stdio.h>
#include <stdlib.h>
extern int yylex();
extern int yyparse();
extern FILE *yyin;
extern int yylineno; /* Declaração para rastrear a linha */
void yyerror(const char *s);
%}

/* Definições de tokens */
%token ID INTCONST CARCONST STRING
%token PLUS MINUS TIMES DIVIDE NOT ASSIGN LT GT GE LE EQ NE
%token OU E RETORNE LEIA ESCREVA NOVALINHA SE ENTAO SENAO ENQUANTO EXECUTE PROGRAMA
%token INT CAR

/* Definições de precedência */
%left PLUS MINUS
%left TIMES DIVIDE
%right NOT
%right UMINUS /* Precedência para operador unário negativo */

%%
Programa:
    DeclFuncVar DeclProg {
        printf("Codigo analisado sem erros.\n");
    }
;

DeclFuncVar:
    Tipo ID DeclVar ';' DeclFuncVar
    | Tipo ID DeclFunc DeclFuncVar
    | /* vazio */
;

DeclProg:
    PROGRAMA Bloco
;

DeclVar:
    ',' ID DeclVar
    | /* vazio */
;

DeclFunc:
    '(' ListaParametros ')' Bloco
;

ListaParametros:
    /* vazio */
    | ListaParametrosCont
;

ListaParametrosCont:
    Tipo ID
    | Tipo ID ',' ListaParametrosCont
;

Bloco:
    '{' ListaDeclVar ListaComando '}'
    | '{' ListaDeclVar '}'
;

ListaDeclVar:
    /* vazio */
    | Tipo ID DeclVar ';' ListaDeclVar
;

Tipo:
    INT
    | CAR
;

ListaComando:
    Comando
    | Comando ListaComando
;

Comando:
    ';'
    | Expr ';'
    | RETORNE Expr ';'
    | LEIA LVALUEExpr ';'
    | ESCREVA Expr ';'
    | ESCREVA STRING ';'
    | NOVALINHA ';'
    | SE '(' Expr ')' ENTAO Comando
    | SE '(' Expr ')' ENTAO Comando SENAO Comando
    | ENQUANTO '(' Expr ')' EXECUTE Comando
    | Bloco
;

Expr:
    OrExpr
    | LVALUEExpr ASSIGN AssignExpr
;

OrExpr:
    OrExpr OU AndExpr
    | AndExpr
;

AndExpr:
    AndExpr E EqExpr
    | EqExpr
;

EqExpr:
    EqExpr EQ DesigExpr
    | EqExpr NE DesigExpr
    | DesigExpr
;

DesigExpr:
    DesigExpr LT AddExpr
    | DesigExpr GT AddExpr
    | DesigExpr GE AddExpr
    | DesigExpr LE AddExpr
    | AddExpr
;

AddExpr:
    AddExpr PLUS MulExpr
    | AddExpr MINUS MulExpr
    | MulExpr
;

MulExpr:
    MulExpr TIMES UnExpr
    | MulExpr DIVIDE UnExpr
    | UnExpr
;

UnExpr:
    MINUS PrimExpr %prec UMINUS
    | NOT PrimExpr
    | PrimExpr
;

LVALUEExpr:
    ID
;

PrimExpr:
    ID '(' ListaExpr ')' { /* Ação semântica para chamada de função */ }
    | ID '(' ')'         { /* Ação semântica para chamada sem argumentos */ }
    | ID
    | INTCONST
    | CARCONST
    | '(' Expr ')'
;

AssignExpr:
    Expr
;

ListaExpr:
    Expr
    | ListaExpr ',' Expr
    | /* vazio */
;

%%

void yyerror(const char *s) {
    fprintf(stderr, "ERRO: %s na linha %d\n", s, yylineno);
}

int main(int argc, char **argv) {
    if (argc < 2) {
        fprintf(stderr, "Uso: %s <arquivo>\n", argv[0]);
        return 1;
    }
    yyin = fopen(argv[1], "r");
    if (!yyin) {
        perror(argv[1]);
        return 1;
    }
    return yyparse();
}
