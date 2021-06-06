// Test that memory model "mem" affects intermediates

#pragma var_model(mem)

void main() {
    // A local pointer 
    char* const SCREEN  = (char*)0x0400;
    // A local counter
    for( char i: 0..5 ) {
        // Generates an intermediate
        *(SCREEN+i) = sum(i,i)+sum(i,i);
    }
}

char sum(char a, char b) {
    return a+b;
}