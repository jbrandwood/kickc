// Test declaring a variable as "memory", meaning it will be stored in memory and accessed through an implicit pointer (using load/store)
// Test a memory variable containing a pointer

char* const SCREEN = 0x0400;

__mem __ma char* cursor = SCREEN;

void main() {
    for( char i: 0..24 ) {
        *cursor = '*';
        cursor += 41;
    }
}