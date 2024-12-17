#ifndef AST_H
#define AST_H

typedef struct ASTNode {
    char *token;             
    int line;                
    struct ASTNode *left;    
    struct ASTNode *right;   
} ASTNode;

ASTNode* createASTNode(char *token, int line, ASTNode *left, ASTNode *right);
void printAST(ASTNode *root, int level);
void freeAST(ASTNode *root);

#endif
