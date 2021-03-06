// Test effective live range and register allocation
// out::c should be a hardware register, main::i should be a hardware register, global idx should be a hardware register


byte msg[] = "hello world!";
char* const SCREEN  = (char*)0x0400;
char idx  = 0;

void main() {
    for( byte i: 0..11) out(msg[i]);
}

void out(char c) {
    SCREEN[idx++] = c;
}