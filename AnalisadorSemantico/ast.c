#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "ast.h"

ASTNode* createASTNode(char *token, int line, ASTNode *left, ASTNode *right) {
    ASTNode *node = (ASTNode*)malloc(sizeof(ASTNode));
    if (!node) {
        fprintf(stderr, "Erro ao alocar memória para o nó da AST.\n");
        exit(1);
    }
    node->token = strdup(token);
    node->line = line;
    node->left = left;
    node->right = right;
    return node;
}

void printAST(ASTNode *root, int level) {
    if (root == NULL) return;

    int i;
    for (i = 0; i < level; i++) printf("  ");
    printf("Token: %s (Linha: %d)\n", root->token, root->line);

    printAST(root->left, level + 1);
    printAST(root->right, level + 1);
}

void freeAST(ASTNode *root) {
    if (root == NULL) return;
    free(root->token);
    freeAST(root->left);
    freeAST(root->right);
    free(root);
}
