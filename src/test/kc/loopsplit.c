void main() {
  byte i=100;
  byte s=0;
  while(--i>0) {
      if(i>50) {
         s++;
      } else {
         s--;
      }
  }
  byte* const SCREEN = (char*)$400;
  *SCREEN = s;
}
