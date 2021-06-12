byte* const SCREEN = (char*)$400;

void main() {
   byte his[] = { BYTE1(SCREEN), BYTE1(SCREEN+$100), BYTE1(SCREEN+$200) }; // constant array
   for( byte h: 0..2) {
      for (byte l: 4..7) {
         word w = { his[h], l }; // inline word
         byte* sc = (byte*)w;
         *sc = '*';
      }
   }
}