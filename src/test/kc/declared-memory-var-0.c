// Test declaring a variable as "__mem __notssa", meaning it will be stored in memory and accessed through an implicit pointer (using load/store)

__mem __ma char idx;

char* const SCREEN = (char*)0x0400;

void main() {
    for( char i: 0..5 ) {
        SCREEN[i] = idx;
        idx +=i;
    }
}