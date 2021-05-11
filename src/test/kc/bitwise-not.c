
void main() {
    byte* SCREEN = (char*)$400;
    *SCREEN = ~1ub;

    for(byte c : 1..26) {
        SCREEN[c] = ~c;
    }

}