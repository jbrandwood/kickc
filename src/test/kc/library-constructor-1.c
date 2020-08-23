// Demonstrates Library Constructor Functionality
// #pragma constructor_for() declares named constructors for other symbols

#pragma constructor_for(my_init, print)

volatile char my_value;

void my_init(void) {
    my_value = '*';
}

char * const SCREEN = 0x0400;

void main(void) {
    print();
}

void print() {
    *SCREEN = my_value;
}

