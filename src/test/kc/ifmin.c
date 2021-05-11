// Minimal if() test
byte* SCREEN = (byte*)$400;

void main() {
  byte i=0;
  do {
    if(i<50) {
      *SCREEN = i;
    }
  } while(++i<100);
}