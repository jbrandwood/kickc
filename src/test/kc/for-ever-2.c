// Test a for() loop that runs forever

char * const SCREEN = 0x0400;

void main() {
    for (char i=0;;i++) {
        SCREEN[i]++;
    }
}