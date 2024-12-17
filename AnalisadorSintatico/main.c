#include <stdio.h>

extern FILE *yyin;
extern int yylineno;
extern char *yytext;
extern int yylex();

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

    int token;
    while ((token = yylex()) != 0) {
        printf("Encontrado o lexema %s pertencente ao token de codigo %d linha %d\n", yytext, token, yylineno);
    }

    fclose(arquivo);
    return 0;
}
