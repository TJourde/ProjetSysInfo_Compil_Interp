all : clean compiler interpreter

compiler : compiler.y compiler.l ts.h ts.c
	/home/gzhang/bison/bin/bison -d -v compiler.y
	./flex compiler.l
	gcc -g -o compiler lex.yy.c compiler.tab.c ts.c libfl.a /home/gzhang/bison/lib/liby.a memoire.c


interpreter.tab.c: interpreter.y 
	/home/gzhang/bison/bin/bison -d -v interpreter.y

interpreter: interpreter.y interpreter.l memoire.c memoire.h
	/home/gzhang/bison/bin/bison -d -v interpreter.y
	./flex interpreter.l
	gcc -g -o interpreter lex.yy.c interpreter.tab.c memoire.c libfl.a /home/gzhang/bison/lib/liby.a


test: compiler
	./compiler < test.c

clean:
	rm -f -v compiler.s
	rm -f -v instruct.hex
