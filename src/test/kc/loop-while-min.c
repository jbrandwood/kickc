
// Minimal classic while() loop

char* SCREEN = (char*)0x0400;

void main() {
    char i = 0;
    while(i!=100) {
        SCREEN[i] = i;
        i++;
    }
}

