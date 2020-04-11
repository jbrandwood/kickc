// Test declaring a variable as "memory", meaning it will be stored in memory and accessed through an implicit pointer (using load/store)
// Test a pointer to a memory variable

__mem __ma char idx;
char* idx_p = &idx;

char* const SCREEN = 0x0400;

void main() {
    for( char i: 0..5 ) {
        SCREEN[i] = *idx_p;
        *idx_p +=i;
    }
}