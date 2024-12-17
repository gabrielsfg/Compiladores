#include <stdio.h>
#include <stdlib.h>
#include "goianinha.tab.h"
#include "ast.h"

extern FILE *yyin;
extern int yylineno;
extern ASTNode *root;

void yyerror(const char *s);

int main(int argc, char **argv) {
    if (argc < 2) {
        printf("Uso: %s <arquivo fonte>\n", argv[0]);
        return 1;
    }

    FILE *arquivo = fopen(argv[1], "r");
    if (!arquivo) {
        printf("Erro ao abrir o arquivo %s\n", argv[1]);
        return 1;
    }
    yyin = arquivo;

    if (yyparse() == 0) {
        if (root) {
            printf("Árvore Sintática Abstrata (AST) construída com sucesso!\n");
        } else {
            printf("Erro: Árvore Sintática Abstrata não foi construída.\n");
        }
    } else {
        printf("Erro durante a análise sintática.\n");
    }

    fclose(arquivo);
    freeAST(root); 
    return 0;
}

void yyerror(const char *s) {
    fprintf(stderr, "Erro: %s na linha %d\n", s, yylineno);
}
