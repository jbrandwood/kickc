// Test a trivial loop head constant
// For trivially constant loop heads for(;;) loops can be written to run body before comparison
// The simplest possible for-loop with a constant loop head.

char * const SCREEN = 0x0400;

void main() {
    for(char i=0;i<40;i++)
        SCREEN[i] = '*';
}