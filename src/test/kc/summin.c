byte* screen = (byte*)$400;

void main() {
  byte s1=sum(1,2);
  byte s2=sum(3,4);
  byte s3=sum(9,13);
  byte s4=s1+s2+s3;
  *screen = s4;
}

byte sum(byte a, byte b) {
  return a+b;
}
