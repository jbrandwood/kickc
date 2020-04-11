byte i=0;

void main() {
   byte a=4;
   a=a+inci();
   a=a+inci();
   byte* SCREEN = $400;
   *SCREEN = i;
   *(SCREEN+1) = a;
}

byte inci() {
  i = i+7;
  return i;
}