// Generate a charset based on a 5x3 pattern stored in 2 bytes
byte* VIC_MEMORY = $d018;
byte* SCREEN = $400;
byte* CHARSET = $3000;

// Stores chars as 15 bits (in 2 bytes) specifying the 3x5
// The 5x3 char is stored as 5x 3-bit rows followed by a zero. %aaabbbcc cdddeee0
word charset_spec_row[] = { %1111011111011010, %1111011111011110, %1111001001001110, %1101011011011110 };

void main() {
    byte* charset = CHARSET+8;
    for(byte c=0;c!=4;c++) {
        gen_char3(charset, charset_spec_row[c]);
        charset = charset+8;
    }
    *VIC_MEMORY = (byte)(((word)SCREEN/$40)|((word)CHARSET/$400));
}

// Generate one 5x3 character from a 16-bit char spec
// The 5x3 char is stored as 5x 3-bit rows followed by a zero. %aaabbbcc cdddeee0
void gen_char3(byte* dst, word spec) {
    for(byte r : 0..4 ) {
        byte b = 0;
        for(byte c: 0..2 ) {
            if((>spec&$80)!=0) {
                b = b|1;
            }
            b = b*2;
            spec = spec*2;
        }
        dst[r] = b;
    }
}