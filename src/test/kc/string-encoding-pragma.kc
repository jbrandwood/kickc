// Test string encoding via literals

// Default encoding (screencode_mixed)
char screencode_mixed1[] = "abcABC1";
// Change default encoding
#pragma encoding(petscii_mixed)
char petscii_mixed1[] = "abcABC2";
char petscii_mixed2[] = "abcABC3";
// Change default encoding
#pragma encoding(screencode_mixed)
char screencode_mixed2[] = "abcABC4";
// Override default encoding using suffix
char screencode_upper[] = "abcABC5"su;
char screencode_mixed3[] = "abcABC6";

void main() {
    char* SCREEN = 0x0400;
    for( char i: 0..5 ) {
        (SCREEN+40*2)[i] = screencode_mixed1[i];
        (SCREEN+40*0)[i] = petscii_mixed1[i];
        (SCREEN+40*1)[i] = petscii_mixed2[i];
        (SCREEN+40*2)[i] = screencode_mixed2[i];
        (SCREEN+40*4)[i] = screencode_upper[i];
        (SCREEN+40*3)[i] = screencode_mixed3[i];
    }

}