// A simple loop results in NullPointerException during loop analysis

byte* SCREEN = (char*)$400;

void main() {
    *SCREEN = '0';
    d();
    b();
}

void b() {
    for( byte i: 0..3) {
        d();
    }
}

void d() {
    (*SCREEN)++;
}