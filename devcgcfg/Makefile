build: main

bpf.o: bpf.c bpf.h
	gcc -c bpf.c -o bpf.o

main.o: bpf.c bpf.h
	gcc -c main.c -o main.o

main: main.o bpf.o
	gcc bpf.o main.o -o main

clean:
	rm -f *.o

.PHONY: clean
