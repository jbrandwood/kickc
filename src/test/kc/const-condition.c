// Ensure that if()'s with constant comparisons are identified and eliminated

void main() {
    byte* const SCREEN = (byte*)$0400;
    if(7<4) {
        SCREEN[0] = '*';
    } else {
        SCREEN[0] = '!';
    }
}

