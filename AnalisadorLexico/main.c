#include <stdio.h>

extern FILE *yyin;
extern int yylex();
extern char *yytext;
extern int yylineno;

int main(int argc, char *argv[]) {
    if (argc < 2) {
        printf("Usage: %s <source file>\n", argv[0]);
        return 1;
    }

    yyin = fopen(argv[1], "r");
    if (!yyin) {
        printf("Cannot open %s\n", argv[1]);
        return 1;
    }

    int token;
    while ((token = yylex()) != 0) {
        printf("Encontrado o lexema %s pertencente ao token de código %d na linha %d\n", yytext, token, yylineno);
    }

    fclose(yyin);
    return 0;
}
