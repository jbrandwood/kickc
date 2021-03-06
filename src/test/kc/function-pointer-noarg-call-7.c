// Tests calling into a function pointer with local variables

void do10( void (*fn)(void)) {
    for( byte i: 0..9)
        (*fn)();
}

byte* const SCREEN = (byte*)$0400;
const byte msg[] = "hello ";

volatile byte idx = 0;

void hello() {
    byte i=0;
    do {
        SCREEN[idx++] = msg[i++];
    } while(msg[i]);
}


void main() {
    void (*f)() = &hello;
    do10(f);
}


