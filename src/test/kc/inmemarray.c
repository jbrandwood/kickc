
byte* SCREEN = (byte*)$400;
byte TXT[] = { 3, 1, 13, 5, 12, 15, 20, 32};

void main() {
   byte j = 0;
   for(byte i : 0..100) {
      SCREEN[i] = TXT[j];
      if(++j==8) {
         j = 0;
      }
   }
}