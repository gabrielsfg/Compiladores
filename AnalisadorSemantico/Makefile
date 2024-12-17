# Definições
CC = gcc
CFLAGS = -g -Wall -ansi

LEX = flex
YACC = bison
LEX_SRC = goianinha.l
YACC_SRC = goianinha.y

LEX_OUTPUT = lex.yy.c
YACC_OUTPUT = goianinha.sintatico.c
YACC_HEADER = goianinha.sintatico.h

AST_SRC = ast.c
AST_HEADER = ast.h

OBJS = lex.yy.o sintatico.o ast.o
TARGET = goianinha

# Regra padrão
all: $(TARGET)

# Compilar o executável final
$(TARGET): $(OBJS)
	$(CC) $(CFLAGS) -o $@ $^

# Gerar o arquivo léxico a partir do Flex
lex.yy.c: $(LEX_SRC) $(YACC_OUTPUT)
	$(LEX) $<

lex.yy.o: lex.yy.c
	$(CC) $(CFLAGS) -c $< -o $@

# Gerar os arquivos do Bison
$(YACC_OUTPUT): $(YACC_SRC)
	$(YACC) -d -t -v --output=$@ $<

sintatico.o: $(YACC_OUTPUT)
	$(CC) $(CFLAGS) -c $< -o $@

# Compilar o arquivo da AST
ast.o: $(AST_SRC) $(AST_HEADER)
	$(CC) $(CFLAGS) -c $(AST_SRC) -o $@

# Limpar arquivos gerados
clean:
	rm -f $(OBJS) $(LEX_OUTPUT) $(YACC_OUTPUT) $(YACC_HEADER) $(TARGET) *.output
