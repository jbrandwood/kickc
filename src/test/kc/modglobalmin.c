byte cnt = 0;
byte SCREEN[256]=$0400;

void main() {
  inccnt();
  SCREEN[0]=cnt++;
  inccnt();
  SCREEN[1]=++cnt;
}

void inccnt() {
    ++cnt;
}



