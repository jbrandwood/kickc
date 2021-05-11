unsigned long ifunc(unsigned long a){
    unsigned long x = 1;
    unsigned long xsqr = 1;
    unsigned long delta = 3;
    while(xsqr <=a){
        ++x;
        xsqr += delta;
        delta += 2;
    }
    return --x;
}

unsigned long* SCREEN = (char*)0x0400;

void main() {
    SCREEN[0] = ifunc(8);
}