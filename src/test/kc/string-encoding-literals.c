// Test string encoding via literals

char no_null[] = "abcABC1"z;
char petscii_mixed[] = "abcABC1"pm;
char petscii_upper[] = "abcABC2"pu;
char petscii_standard[] = "abcABC3"p;
char screencode_mixed[] = "abcABC4"sm;
char screencode_upper[] = "abcABC5"su;
char screencode_standard[] = "abcABC6"s;
char ascii[] = "abcABC7"as;
char atascii[] = "abcABC8"at;
char screencode_atari[] = "abcABC9"sa;
char standard[] = "abcABC0";


void main() {
    char* const SCREEN = 0x0400;
    char * const D018 = 0xd018;
    *D018 = 0x16;
    for( char i: 0..7 ) {
        (SCREEN+40*0)[i] = petscii_mixed[i];
        (SCREEN+40*1)[i] = petscii_upper[i];
        (SCREEN+40*2)[i] = petscii_standard[i];
        (SCREEN+40*3)[i] = screencode_mixed[i];
        (SCREEN+40*4)[i] = screencode_upper[i];
        (SCREEN+40*5)[i] = screencode_standard[i];
        (SCREEN+40*6)[i] = ascii[i];
        (SCREEN+40*7)[i] = atascii[i];
        (SCREEN+40*8)[i] = screencode_atari[i];
        (SCREEN+40*9)[i] = standard[i];
        (SCREEN+40*10)[i] = no_null[i];
    }

}