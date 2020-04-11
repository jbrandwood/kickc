// Tests that constants are identified early

byte* SCREEN = $400;
// Not an early constant (address-of is used)
byte A = 'a';

void main(){
    SCREEN[0] = A;
    byte B = 'b';
    SCREEN[1] = B;
    byte* addrA = &A;
    SCREEN[2] = *addrA;
    sub();

}

void sub() {
    byte C = 'c';
    SCREEN[3] = C;
    // Not an early constant (expression)
    byte D = A+1;
    SCREEN[4] = D;
}