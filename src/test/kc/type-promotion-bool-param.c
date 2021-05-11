// Test promoting a bool to a byte

char* const SCREEN = (char*)0x0400;
char i = 0;


void main() {
    print(1==0);
}

void print(char c) {
    SCREEN[i++] = c;
}