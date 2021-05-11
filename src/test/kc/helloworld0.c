// Tests minimal hello world

byte msg[] = "hello world!";
byte* SCREEN = (char*)0x0400;

void main() {
    for( byte i: 0..11) SCREEN[i] = msg[i];
}