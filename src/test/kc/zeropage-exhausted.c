// Tests warning when running out of zeropage-addresses for variables

// Start by reserving most of zeropage (254 bytes)
#pragma zp_reserve(1..254)

// And then allocate a 2-byte-variable
void main() {
    int* const SCREEN = (int*)0x0400;
    for(__zp int i=0;i<10;i++)
        SCREEN[(char)i] = i;
}
