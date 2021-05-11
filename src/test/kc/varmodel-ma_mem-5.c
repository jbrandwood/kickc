// Test memory model
// Demonstrates problem where post-increase on __ma memory variables is performed to early

#pragma var_model(ma_mem, pointer_ssa_zp)

char* const SCREEN = (char*)0x0400;

void main() {
    char i=0;
    do {
        SCREEN[i] = '*';
    } while(i++<4);
}
