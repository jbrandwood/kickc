// Test a for() loop that runs forever

char * const SCREEN = (char*)0x0400;

void main() {
    for (;;) {
        (*SCREEN)++;
    }
}