// Test memory model
// Constant memory variables

#pragma var_model(ma_mem, pointer_ssa_zp)

char* screen = (char*)0x0400;

char a = 'a';

void main() {
    char b = 'b';
    for( char i: 0..5 ) {
        *(screen++) = a;
        *(screen++) = b;
        *(screen++) = i;
    }
}
