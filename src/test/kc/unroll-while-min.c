// Minimal unrolled while() loop
void main() {
    char* SCREEN = (char*)$400;
    char i=0;
    inline while(i<2) {
        SCREEN[i++] = 'a';
    }
}