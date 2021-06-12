// Inline functions in two levels

void main() {
    for(byte* sc = (byte*)$400;sc<$400+1000;sc++) *sc = ' ';
    line(2, $40, 10, '*');
    line(4, $80, 15, '.');
}

byte* cur_line = (byte*)$400;

inline void line(byte xpos, byte xadd, byte ysize, byte ch) {
    cur_line = (byte*)$400;
    word pos = {xpos, 0};
    for( byte i=0;i<ysize; i++) {
        plot(BYTE1(pos), ch);
        pos += xadd;
        cur_line += 40;
    }
}

inline void plot(byte xpos, byte ch) {
    *(cur_line+xpos) = ch;
}



