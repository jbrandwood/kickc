// Test __varcall calling convention
// Parameter passing

void main() {
    setbg(0);
    setbg(0x0b);
}

char * const BGCOL = (char *)0xd021;

__varcall void setbg(char col) {
    *BGCOL = col;
}