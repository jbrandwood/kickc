
void main() {
  byte STAR = 81;
  byte screen[40*25] = $0400;
  byte x0 = 0;
  byte y0 = 0;
  byte x1 = 39;
  byte y1 = 24;
  byte xd = x1-x0;
  byte yd = y1-y0;
  byte x = x0;
  byte y = y0;
  byte e = yd/2;
  word idx = x+y*40;
  do  {
      screen[idx] = STAR;
      x = x + 1;
      idx = idx + 1;
      e = e+yd;
      if(xd<e) {
          y = y+1;
          idx  = idx + 40;
          e = e - xd;
      }
  } while (x<(x1+1));
}