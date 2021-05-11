void main() {
  byte buf[16] = (byte*)$1100;
  byte i = 5;
  do {
      buf[i] = 2+i+2;
      i = i+1;
  } while(i<10);
}