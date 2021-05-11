// Demonstrates missing fragment
// https://gitlab.com/camelot/kickc/-/issues/293

byte bar[10]={9,1,2,3,4,5,6,7,8,9};
byte *SCREEN = (byte*)$400;

void main() {
word a=0;
 a=(foo(1) & 3);
 *SCREEN = (byte)a;
}

byte foo(byte x) {
     return bar[x];
}

