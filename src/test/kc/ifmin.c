// Minimal if() test
byte* SCREEN = $0400;

void main() {
  byte i=0;
  do {
    if(i<50) {
      *SCREEN = i;
    }
  } while(++i<100);
}