// Creates a font where each char contains the number of the char (00-ff)

// Make charset from proto chars
void init_font_hex(byte* charset) {
    byte* proto_hi = FONT_HEX_PROTO;
    for( byte c: 0..15 ) {
        byte* proto_lo = FONT_HEX_PROTO;
        for( byte c: 0..15 ) {
            byte idx = 0;
            charset[idx++] = 0;
            for( byte i: 0..4) {
                charset[idx++] = proto_hi[i]<<4 | proto_lo[i]<<1;
            }
            charset[idx++] = 0;
            charset[idx++] = 0;
            proto_lo += 5;
            charset += 8;
        }
        proto_hi += 5;
    }
}

// Bit patterns for symbols 0-f (3x5 pixels) used in font hex
byte FONT_HEX_PROTO[] = {
    // 0
    0b010,
    0b101,
    0b101,
    0b101,
    0b010,
    // 1
    0b110,
    0b010,
    0b010,
    0b010,
    0b111,
    // 2
    0b110,
    0b001,
    0b010,
    0b100,
    0b111,
    // 3
    0b110,
    0b001,
    0b010,
    0b001,
    0b110,
    // 4
    0b101,
    0b101,
    0b111,
    0b001,
    0b001,
    // 5
    0b111,
    0b100,
    0b110,
    0b001,
    0b110,
    // 6
    0b011,
    0b100,
    0b110,
    0b101,
    0b010,
    // 7
    0b111,
    0b001,
    0b001,
    0b001,
    0b001,
    // 8
    0b010,
    0b101,
    0b010,
    0b101,
    0b010,
    // 9
    0b010,
    0b101,
    0b011,
    0b001,
    0b001,
    // a
    0b010,
    0b101,
    0b111,
    0b101,
    0b101,
    // b
    0b110,
    0b101,
    0b110,
    0b101,
    0b110,
    // c
    0b010,
    0b101,
    0b100,
    0b101,
    0b010,
    // d
    0b110,
    0b101,
    0b101,
    0b101,
    0b110,
    // e
    0b111,
    0b100,
    0b110,
    0b100,
    0b111,
    // f
    0b111,
    0b100,
    0b110,
    0b100,
    0b100
};
