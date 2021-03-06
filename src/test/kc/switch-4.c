// Tests simple switch()-statement - switch without default
// Expected output " 1  4 "

void main() {
    char* const SCREEN = (char*)0x0400;
    for(char i:0..5) {
        // Test switching on a simple char
        switch(i) {
            case 1:
            case 4:
                SCREEN[i] = '0'+i;
                break;
        }
    }
}
