// Tests calling into different function pointers which call a common sub-method

void do10(void(*fn)()) {
    for( byte i: 0..9)
        (*fn)();
}

void hello() {
    print("hello ");
}

void world() {
    print("world ");
}

void main() {
    do10(&hello);
    do10(&world);
}

byte* const SCREEN = (byte*)$0400;
volatile byte idx = 0;

void print(byte* msg) {
    byte i=0;
    do {
        SCREEN[idx++] = msg[i++];
    } while(msg[i]);
}

