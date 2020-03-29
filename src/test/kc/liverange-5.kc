// Test effective live range and register allocation
// Here out::b, print::b and main::b can have the same allocation

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
    out(b, ca);
}

void out(char b, char ca) {
    (*(SCREEN+999))++;
    SCREEN[b] = ca;
}