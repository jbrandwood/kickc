byte* SCREEN = (byte*)$400;
byte* CHARSET = (byte*)$2000;
byte* CHARGEN = (byte*)$D000;
byte* PROCPORT = (byte*)$01;
byte* D018 = (byte*)$d018;
byte* CHARSET4 = (byte*)$2800;

byte bits_count[] = { 0, 1, 1, 2, 1, 2, 2, 3, 1, 2, 2, 3, 2, 3, 3, 4 };

void main() {
    asm { sei }
    *PROCPORT = $32;
    byte* chargen = CHARGEN;
    byte* charset4 = CHARSET4;
    do {
        byte bits_gen = 0;
        byte* chargen1 = chargen+1;
        byte bits = bits_count[((*chargen & %01100000) | (*chargen1 & %01100000)/4)/2/4];
        if(bits>=2) { bits_gen = bits_gen + 1; }
        bits_gen = bits_gen*2;
        bits = bits_count[((*chargen & %00011000) | (*chargen1 & %00011000)/4)/2];
        if(bits>=2) { bits_gen = bits_gen + 1; }
        bits_gen = bits_gen*2;
        bits = bits_count[((*chargen & %00000110)*2 | (*chargen1 & %00000110)/2)];
        if(bits>=2) { bits_gen = bits_gen + 1; }
        bits_gen = bits_gen*2;
        bits = bits_count[((*chargen & %00000001)*4 | (*chargen1 & %00000001))];
        if(bits>=2) { bits_gen = bits_gen + 1; }
        bits_gen = bits_gen*2;
        *charset4 = bits_gen;
        charset4++;
        chargen = chargen+2;
    } while (chargen<CHARGEN+$800);
    *PROCPORT = $37;
    asm { cli }
    for(byte i : 0..255) {
        SCREEN[i] = i;
    }
    *D018 = $19;
}


