// Demonstrates Library Constructor Functionality
// Constructors are removed if not needed

#pragma constructor_for(my_init, print)

volatile char my_value;

// Unused constructor
void my_init(void) {
    SCREEN[0] = '*';
}

char * const SCREEN = (char*)0x0400;

void main(void) {
    SCREEN[2] = '*';
}

// Unused procedure
void print() {
    SCREEN[1] = '*';
}

