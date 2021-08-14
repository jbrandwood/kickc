// Test compile-time and run-time multiplication
// const*var multiplication - converted to shift/add

char * const SCREEN = (char*)0x0400;

void main() {
    char i=0;
    for(char c1=0;c1<5;c1++) {
        // const*var
        char c3 = 7*c1;
        SCREEN[i++] = c3;
    }
}