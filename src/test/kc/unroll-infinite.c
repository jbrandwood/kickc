// Unrolling an infinite loop

void main() {
    byte* SCREEN = (char*)$400;

    byte b=0;
    inline do {
        *SCREEN = b;
        b = *SCREEN;
    } while(b<10);

}