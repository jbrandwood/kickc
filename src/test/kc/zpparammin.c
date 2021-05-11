byte* SCREEN = (byte*)$400;
byte* SCREEN2 = (byte*)$400+40;

void main() {
    for(byte i : 0..10) {
        SCREEN[i] = sum(i,i+1,i+2);
        SCREEN2[i] = sum2(i,i+1,i+2);
    }
}

byte sum(byte a, byte b, byte c) {
  return a+b+c;
}


byte sum2(byte a, byte b, byte c) {
  return a+b+c;
}