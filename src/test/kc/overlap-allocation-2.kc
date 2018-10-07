// Two levels of functions to test that register allocation handles live ranges and call-ranges optimally to allocate the fewest possible ZP-variables
byte* SCREEN = $0400;

void main() {
    for(byte i : 0..8) {
       line(i);
    }
   for(byte j : 10..18) {
       line(j);
    }
}

void line(byte l) {
    plot(l);
    plot(l+20);
}

void plot(byte x) {
    SCREEN[x] = '*';
}
