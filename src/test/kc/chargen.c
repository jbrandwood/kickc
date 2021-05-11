byte* PROCPORT = (byte*)$01;
byte* CHARGEN = (byte*)$d000;
byte* SCREEN = (byte*)$0400;

void main() {
    asm { sei }
    byte* CHAR_A = CHARGEN+8;
    *PROCPORT = $32;
    byte* sc = SCREEN;
    for(byte y:0..7) {
      byte bits = CHAR_A[y];
      for(byte x:0..7) {
        byte c = '.';
        if((bits & $80) != 0) {
           c = '*';
        }
        *sc = c;
        sc++;
        bits = bits*2;
      }
      sc = sc+32;
    }
    *PROCPORT = $37;
    asm { cli }
}
