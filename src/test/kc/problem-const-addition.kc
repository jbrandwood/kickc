// Illustrates problem with constant addition not handling mixed types properly

char* SCREEN = $400;
char* CHARGEN = 0xd000;
char* PROCPORT = 0x01;

void main() {
    for(char pos: 0..3)
        plot_chargen(pos);
}

// Render 8x8 char (ch) as pixels on char canvas #pos
void plot_chargen(byte pos) {
    byte* sc = SCREEN + pos*10 + 41;
      for(byte x:0..7)
        *sc++ = '*';
}
