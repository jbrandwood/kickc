// Demonstrates Library Constructor Functionality
// Multiple #pragma constructor_for() constructors

#pragma constructor_for(init_1, print)
#pragma constructor_for(init_2, print)

volatile char sym;
char * volatile SCREEN;

void init_1(void) {
    sym = '*';
}

void init_2(void) {
    SCREEN = (char*)0x0400;
}

void main(void) {
    print();
}

void print() {
    *SCREEN = sym;
}

