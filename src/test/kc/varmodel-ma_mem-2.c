// Test memory model multiple-assignment/main memory for all non-pointer variables

#pragma var_model(ma_mem)

void main() {
    // A local pointer 
    char* screen = (char*)0x0400;
    // A local counter
    for( char i: 0..5 )
        *(screen++) = 'a';
}