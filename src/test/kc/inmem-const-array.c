const byte WHITE = 1;
const byte RED = 2;
const byte GREEN = 5;

void main() {
   byte colseq[] = { WHITE, RED, GREEN };
   byte* screen = (byte*)$400;
   byte* cols = (byte*)$d800;
   byte j = 0;
   for( byte i : 0..39) {
      screen[i] = '*';
      cols[i] = colseq[j];
      if(++j==3) {
         j=0;
      }
   }

}