// Test effective live range and register allocation
// main::b and main::c should be allocated to hardware registers

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
    SCREEN[b] = ca;
}