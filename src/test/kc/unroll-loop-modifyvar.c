// An unrolled loop modifying a var used later

void main() {
    byte* SCREEN = (char*)$400;

    byte a=3;
    inline do {
        SCREEN[a]=a;
        a++;
    } while(a<14);
    SCREEN[a]=a;

}