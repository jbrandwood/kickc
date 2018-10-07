byte* SCREEN = $0400;

void main() {
  byte i=100;
  do {
    nest();
  } while (--i>0);
}

void nest() {
  byte j=100;
  do {
    *SCREEN = j;
  } while (--j>0);
}
