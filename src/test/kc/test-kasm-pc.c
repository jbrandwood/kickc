// Test inline KickAssembler code with PC location specification

__address(0x2000) byte TABLE[] = kickasm {{
    .byte 1, 2, 3
}};

void main() {
    byte* BORDER_COLOR = $d020;
    byte i=0;
    while(true) {
        *BORDER_COLOR = TABLE[i++];
    }
}

