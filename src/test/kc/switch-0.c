// Tests simple switch()-statement
// Expected output 'd1444d'

void main() {
    char* const SCREEN = (char*)0x0400;

    for(char i:0..5) {
        // Test switching on a simple char
        switch(i) {
            case 1:
                // A simple case with a break
                SCREEN[i] = '1';
                break;
            case 2:
                // A case with no body
            case 3:
                // A case with fall-through
                SCREEN[i] = '3';
            case 4:
                SCREEN[i] = '4';
                break;
            default:
                // No case for 0 & 5
                SCREEN[i] = 'd';
        }
    }
}
