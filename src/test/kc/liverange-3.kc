// Test effective live range and register allocation
// Here main::b should be allocated to the same register as print::b and main::ca to the same register as print::ca

void main() {
    for(char a: 0..100 ) {
        for( char b: 0..100 ) {
            for( char c: 0..100 ) {
                char ca = c+a;
                print(b, ca);
            }
        }
    }
}

char* const SCREEN  = 0x0400;

void print(char b, char ca) {
    (*(SCREEN+999))++;
    SCREEN[b] = ca;
}