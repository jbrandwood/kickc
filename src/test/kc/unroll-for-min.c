// Minimal unrolled ranged for() loop
void main() {
    char* SCREEN = (char*)0x0400;
    inline for(char i : 0..2) {
        SCREEN[i] = 'a';
    }
}