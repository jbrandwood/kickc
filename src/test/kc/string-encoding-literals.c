// Test string encoding via literals

byte petscii_mixed[] = "abcABC1"pm;
byte petscii_upper[] = "abcABC2"pu;
byte petscii_standard[] = "abcABC3"p;
byte screencode_mixed[] = "abcABC4"sm;
byte screencode_upper[] = "abcABC5"su;
byte screencode_standard[] = "abcABC6"s;
byte standard[] = "abcABC7";

void main() {
    byte* SCREEN = 0x0400;
    for( byte i: 0..5 ) {
        (SCREEN+40*0)[i] = petscii_mixed[i];
        (SCREEN+40*1)[i] = petscii_upper[i];
        (SCREEN+40*2)[i] = petscii_standard[i];
        (SCREEN+40*3)[i] = screencode_mixed[i];
        (SCREEN+40*4)[i] = screencode_upper[i];
        (SCREEN+40*5)[i] = screencode_standard[i];
        (SCREEN+40*6)[i] = standard[i];
    }

}