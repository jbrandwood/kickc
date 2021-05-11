byte cnt = 0;
byte cnt2 = 0;
byte cnt3 = 0;
byte SCREEN[256]=(byte*)$0400;

void main() {
  SCREEN[0]=inccnt();
  cnt++;
  SCREEN[1]=inccnt();
  SCREEN[2]=cnt2;
  SCREEN[3]=cnt3;
}

byte inccnt() {
    ++cnt;
    ++cnt2;
    ++cnt3;
    return cnt;
}



