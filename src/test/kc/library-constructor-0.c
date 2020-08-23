// Demonstrates Library Constructor Functionality
// #pragma constructor() declares a constructor for the file.

#pragma constructor(my_init)

char my_value;

void my_init(void) {
    my_value = '*';
}

char * const SCREEN = 0x0400;

void main(void) {
    *SCREEN = my_value;
}

