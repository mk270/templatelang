TARGET := templatelang
CCFLAGS := -ggdb

all: $(TARGET)

$(TARGET): lex.yy.o node.o
	$(CC) $(CCFLAGS) -o $@ $^ -lfl

lex.yy.o: lex.yy.c
	$(CC) -std=gnu99 -c -o $@ $< -lfl

lex.yy.c: templatelang.l
	flex -o $@ $<

clean:
	rm -f -- *.o lex.yy.c $(TARGET)
