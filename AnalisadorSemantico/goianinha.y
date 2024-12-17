%{
#include <stdio.h>
#include <stdlib.h>
#include "ast.h"

extern int yylex();
extern int yyparse();
extern FILE *yyin;
extern int yylineno;

void yyerror(const char *s);

ASTNode *root;
%}

%union {
    char *str;
    int num;   
    struct ASTNode *ast;
}

/* Definições de tokens */
%token <str> ID INTCONST CARCONST STRING
%token PLUS MINUS TIMES DIVIDE NOT ASSIGN LT GT GE LE EQ NE
%token OU E RETORNE LEIA ESCREVA NOVALINHA SE ENTAO SENAO ENQUANTO EXECUTE PROGRAMA
%token INT CAR

/* Definições de precedência */
%left PLUS MINUS
%left TIMES DIVIDE
%right NOT
%right UMINUS

/* Declaração de tipos */
%type <ast> Programa DeclFuncVar DeclProg Bloco ListaDeclVar ListaComando Comando
%type <ast> Expr OrExpr AndExpr EqExpr DesigExpr AddExpr MulExpr UnExpr LVALUEExpr PrimExpr AssignExpr
%type <ast> ListaExpr ListaParametros ListaParametrosCont DeclVar Tipo


%%

Programa:
    DeclFuncVar DeclProg {
        root = createASTNode("Programa", yylineno, $1, $2);
        printf("AST construida com sucesso!\n");
        printf("Codigo analisado sem erros.\n");
    }
;

DeclFuncVar:
    Tipo ID DeclVar ';' DeclFuncVar {
        $$ = createASTNode("DeclFuncVar", yylineno, NULL, $5);
    }
    | /* vazio */ { $$ = NULL; }
;

DeclProg:
    PROGRAMA Bloco {
        $$ = createASTNode("DeclProg", yylineno, $2, NULL);
    }
;

DeclVar:
    ',' ID DeclVar {
        $$ = createASTNode($2, yylineno, NULL, $3);
    }
    | /* vazio */ { $$ = NULL; }
;

Bloco:
    '{' ListaDeclVar ListaComando '}' {
        $$ = createASTNode("Bloco", yylineno, $2, $3);
    }
    | '{' ListaDeclVar '}' {
        $$ = createASTNode("Bloco", yylineno, $2, NULL);
    }
;

ListaDeclVar:
    Tipo ID DeclVar ';' ListaDeclVar {
        $$ = createASTNode("ListaDeclVar", yylineno, NULL, $5);
    }
    | /* vazio */ { $$ = NULL; }
;

Tipo:
    INT { $$ = createASTNode("int", yylineno, NULL, NULL); }
    | CAR { $$ = createASTNode("car", yylineno, NULL, NULL); }
;

ListaComando:
    Comando { $$ = $1; }
    | Comando ListaComando {
        $$ = createASTNode("ListaComando", yylineno, $1, $2);
    }
;

Comando:
    ';' { $$ = createASTNode("ComandoVazio", yylineno, NULL, NULL); }
    | Expr ';' { $$ = $1; }
    | RETORNE Expr ';' {
        $$ = createASTNode("Retorne", yylineno, $2, NULL);
    }
    | LEIA LVALUEExpr ';' {
        $$ = createASTNode("Leia", yylineno, $2, NULL);
    }
    | ESCREVA Expr ';' {
        $$ = createASTNode("Escreva", yylineno, $2, NULL);
    }
    | Bloco { $$ = $1; }
;

Expr:
    OrExpr { $$ = $1; }
    | LVALUEExpr ASSIGN AssignExpr {
        $$ = createASTNode("Atribuicao", yylineno, $1, $3);
    }
;

LVALUEExpr:
    ID { $$ = createASTNode($1, yylineno, NULL, NULL); }
;

OrExpr:
    OrExpr OU AndExpr { $$ = createASTNode("OU", yylineno, $1, $3); }
    | AndExpr { $$ = $1; }
;

AndExpr:
    AndExpr E EqExpr { $$ = createASTNode("E", yylineno, $1, $3); }
    | EqExpr { $$ = $1; }
;

EqExpr:
    EqExpr EQ DesigExpr { $$ = createASTNode("EQ", yylineno, $1, $3); }
    | EqExpr NE DesigExpr { $$ = createASTNode("NE", yylineno, $1, $3); }
    | DesigExpr { $$ = $1; }
;

DesigExpr:
    DesigExpr LT AddExpr { $$ = createASTNode("LT", yylineno, $1, $3); }
    | DesigExpr GT AddExpr { $$ = createASTNode("GT", yylineno, $1, $3); }
    | DesigExpr GE AddExpr { $$ = createASTNode("GE", yylineno, $1, $3); }
    | DesigExpr LE AddExpr { $$ = createASTNode("LE", yylineno, $1, $3); }
    | AddExpr { $$ = $1; }
;

AddExpr:
    AddExpr PLUS MulExpr { $$ = createASTNode("PLUS", yylineno, $1, $3); }
    | AddExpr MINUS MulExpr { $$ = createASTNode("MINUS", yylineno, $1, $3); }
    | MulExpr { $$ = $1; }
;

MulExpr:
    MulExpr TIMES UnExpr { $$ = createASTNode("TIMES", yylineno, $1, $3); }
    | MulExpr DIVIDE UnExpr { $$ = createASTNode("DIVIDE", yylineno, $1, $3); }
    | UnExpr { $$ = $1; }
;

UnExpr:
    MINUS PrimExpr %prec UMINUS { $$ = createASTNode("UMINUS", yylineno, $2, NULL); }
    | NOT PrimExpr { $$ = createASTNode("NOT", yylineno, $2, NULL); }
    | PrimExpr { $$ = $1; }
;

PrimExpr:
    ID { $$ = createASTNode($1, yylineno, NULL, NULL); }
    | INTCONST { $$ = createASTNode("INTCONST", yylineno, NULL, NULL); }
    | CARCONST { $$ = createASTNode("CARCONST", yylineno, NULL, NULL); }
    | '(' Expr ')' { $$ = $2; }
;

ListaParametros:
    /* vazio */ { $$ = NULL; }
    | ListaParametrosCont { $$ = $1; }
;

ListaParametrosCont:
    Tipo ID { $$ = createASTNode("Parametro", yylineno, NULL, NULL); }
    | Tipo ID ',' ListaParametrosCont { 
        $$ = createASTNode("Parametros", yylineno, NULL, $4); 
    }
;

AssignExpr:
    Expr { $$ = $1; }
;

ListaExpr:
    Expr { $$ = $1; }
    | ListaExpr ',' Expr { $$ = createASTNode("ListaExpr", yylineno, $1, $3); }
    | /* vazio */ { $$ = NULL; }
;

%%

void yyerror(const char *s) {
    fprintf(stderr, "ERRO: %s na linha %d\n", s, yylineno);
    printf("Erro de sintaxe encontrado no codigo.\n");
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

    if (yyparse() == 0) {
        printf("Codigo analisado com sucesso!\n");
    } else {
        printf("Erro: O codigo possui erros de sintaxe.\n");
    }

    fclose(yyin);
    return 0;
}
