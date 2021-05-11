// Test declaring a variable as "memory", meaning it will be stored in main memory
// Test a fixed main memory address __notssa variable

__ma __address(0x1000) char idx;

char* const SCREEN = (char*)0x0400;

void main() {
    for( char i: 0..5 ) {
        SCREEN[i] = idx;
        idx +=i;
    }
}