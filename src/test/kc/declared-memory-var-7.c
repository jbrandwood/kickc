// Test declaring a variable as "memory", meaning it will be stored in memory and accessed through an implicit pointer (using load/store)
// Test a zeropage notregister variable

__ma  char idx;

char* const SCREEN = (char*)0x0400;

void main() {
    for( char i: 0..5 ) {
        SCREEN[i] = idx;
        idx +=i;
    }
}