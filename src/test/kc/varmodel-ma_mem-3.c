// Test two different memory models

void main() {
    model_ma_mem();
    model_ssa_zp();
}

#pragma var_model(full, ma_mem)

void model_ma_mem() {
    // A local pointer
    char* screen = (char*)0x0400;
    // A local counter
    for( char i: 0..5 )
        *(screen++) = 'a';
}

#pragma var_model(ssa_zp)

void model_ssa_zp() {
    // A local pointer
    char* screen = (char*)0x0428;
    // A local counter
    for( char i: 0..5 )
        *(screen++) = 'b';
}