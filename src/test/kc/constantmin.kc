byte* const SCREEN = $0400;
const byte STAR = 81;

byte* VIC = $d000;
byte* BGCOL = VIC+$10*2+1;
byte RED = 2;

void main() {
  *SCREEN = STAR;
  *BGCOL = RED;
  for(byte i: 40..79) {
    SCREEN[i] = (STAR+1);
  }
}