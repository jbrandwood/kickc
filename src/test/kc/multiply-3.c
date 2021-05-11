// Test compile-time and run-time multiplication
// var*var multiplication - converted to call

char * const SCREEN = (char*)0x0400;

void main() {
    char i = 0;
    for(char c1=0;c1<5;c1++) {
        for(char c2=0;c2<5;c2++) {
            // var*var
            char c3 = (char)mul8u(c1,7);
            char c4 = (char)mul8u(c2,5);
            SCREEN[i++] = (char)mul8u(c3, c4);
        }
    }
}

// Perform binary multiplication of two unsigned 8-bit chars into a 16-bit unsigned int
unsigned int mul8u(__ma char a, __ma char b) {
    unsigned int res = 0;
    unsigned int mb = b;
    while(a!=0) {
        if( (a&1) != 0) {
            res = res + mb;
        }
        a = a>>1;
        mb = mb<<1;
    }
    return res;
}

