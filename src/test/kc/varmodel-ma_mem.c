// Test memory model multiple-assignment/main memory for all variables (here  local variables)

#pragma var_model(full, ma_mem)

void main() {
    // A local pointer 
    char* screen = 0x0400;
    // A local counter
    for( char i: 0..5 )
        *(screen++) = 'a';
}