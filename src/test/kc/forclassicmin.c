
// Minimal classic for() loop

byte* SCREEN = (byte*)$0400;

void main() {
    for(byte i=0; i!=100; i++) {
        SCREEN[i] = i;
    }
}

