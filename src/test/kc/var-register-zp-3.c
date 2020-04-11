// Test declaring a variable as register on a specific ZP address

char* screen = $400;

void main() {
    print2(screen, "hello");
    print2(screen+80, "world");
}

void print2(__address(250) char*  at, __address(252) char*  msg) {
    byte j=0;
    for(byte i=0; msg[i]; i++) {
        print_char(at, j, msg[i]);
        j += 2;
    }
}

void print_char(__address(250) char* at, register(X) char  idx, register(A) char  ch) {
    at[idx] = ch;
}
