// Test __varcall calling convention
// Larger type parameter & return value

int * const BGCOL = (int *)0xd020;

void main() {
    int a = 0x0102;
    *BGCOL = a;
    a = plus(a, 0x0203);
    *BGCOL = a;
    a = plus(a, a);
    *BGCOL = a;
}

__varcall int plus(int a, int b) {
    return a+b;
}