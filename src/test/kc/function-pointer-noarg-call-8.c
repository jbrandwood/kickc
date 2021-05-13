// Tests calling into a function pointer with local variables

void do10(void(*fn)(void)) {
    for( byte i: 0..9)
        (*fn)();
}

byte* const SCREEN = (byte*)$0400;

const byte msg1[] = "hello ";
const byte msg2[] = "world ";
byte* volatile msg;
byte volatile idx = 0;

void hello() {
    byte i=0;
    do {
        SCREEN[idx++] = msg[i++];
    } while(msg[i]);
}

void main() {
    void(*f)(void) = &hello;
    msg = msg1;
    do10(f);
    msg = msg2;
    do10(f);
}



