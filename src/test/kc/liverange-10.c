// Test effective live range and register allocation
// Here outsw::sw and outw::w should have the same allocation

char* const SCREEN  = (char*)0x0400;
char idx = 0;

void main() {
    for(signed int sw: -20..19 )
        outsw(sw);
    for(unsigned int w: 0..39 )
        outw(w);
}

void outsw(signed int sw) {
    if(sw<0) {
        out('-');
        sw = -sw;
    }
    outw((unsigned int)sw);
}

char HEXTAB[] = "0123456789abcdef";

void outw(unsigned int w) {
    out(HEXTAB[BYTE1(w)<<4]);
    out(HEXTAB[BYTE1(w)&0x0f]);
    out(HEXTAB[BYTE0(w)<<4]);
    out(HEXTAB[BYTE0(w)&0x0f]);
}

void out(char c) {
    idx++;
    SCREEN[idx] = c;
}