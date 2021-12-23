// Tests that variables overflow to main memory when zeropage is exhausted

// Tell the compiler to use zeropage
#pragma var_model(ssa_zp)

// Start by reserving most of zeropage (254 bytes)
#pragma zp_reserve(1..246)

// And then allocate a bunch of variables
void main() {
    int* const SCREEN = (int*)0x0400;

    int a, b, c, d, e, f, g, h;

    for(char i=0;i<10;i++) {
        SCREEN[i] = a++;
        SCREEN[i] = b++;
        SCREEN[i] = c++;
        SCREEN[i] = d++;
        SCREEN[i] = a++;
        SCREEN[i] = e++;
        SCREEN[i] = f++;
        SCREEN[i] = g++;
        SCREEN[i] = h++;
        SCREEN[i] = a++;
    }
}
