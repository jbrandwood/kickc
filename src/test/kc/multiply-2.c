// Test compile-time and run-time multiplication
// var*const multiplication - converted to shift/add

char * const SCREEN = (char*)0x0400;

void main() {
    char i=0;
    for(char c1=0;c1<5;c1++) {
        // const*const
        char c2 = 3*2+1;
        // var*const
        char c3 = c1*c2;
        SCREEN[i++] = c3;
    }
}