// Tests trouble passing a function pointer

#include <stdio.h>
#include <printf.h>
#include <conio.h>

void f1(void(*fn)()) {
	(*fn)();
}

void hello() {
	printf("hello ");
}

void world() {
	printf("world!");
}

void main() {
	f1(&hello);
	f1(&world);
}
