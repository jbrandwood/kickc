// Test auto-casting of call-parameters

void main() {
    word w = 0x1234;
    print(0x1234);
    print(w);
    print( MAKEWORD(0x12,0x34) );
}

word* const SCREEN = (word*)0x0400;
byte idx = 0;

void print(word w) {
    SCREEN[idx++] = w;
}