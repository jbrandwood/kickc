// Test MAKELONG4() with to few parameters

void main() {
    unsigned long* const SCREEN = (unsigned int*)0x0400;
    *SCREEN = MAKELONG4(1, 2, 3);
}