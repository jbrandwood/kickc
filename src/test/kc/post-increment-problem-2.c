byte *screen=(byte *)$0400;
void main() {
  word offset=40*10;
  for (char x=0;x<254;x++)
    incscreen(offset);
}


void incscreen(word ptr) {
  --(*(screen+ptr));
  (*(screen+ptr+1))--;
  ++(*(screen+ptr));
  (*(screen+ptr+1))++;
}
