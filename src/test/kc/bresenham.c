byte STAR = 81;
byte SCREEN[40*25] = (byte*)$0400;

void main() {
  byte x0 = 4;
  byte y0 = 4;
  byte x1 = 39;
  byte y1 = 24;
  byte xd = x1-x0;
  byte yd = y1-y0;
  byte x = x0;
  byte y = y0;
  byte e = yd/2;
  byte *cursor = SCREEN+y*40+x;
  do  {
      *cursor = STAR;
      x = x + 1;
      cursor = cursor + 1;
      e = e+yd;
      if(xd<=e) {
          y = y+1;
          cursor = cursor + 40;
          e = e - xd;
      }
  } while (x<(x1+1));
}