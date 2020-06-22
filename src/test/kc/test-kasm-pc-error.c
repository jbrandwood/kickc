// Test inline KickAssembler code with PC location specification

char* const TABLE = 0x2000;

kickasm(pc TABLE) {{
    .byte 1, 2, 3
}};

void main() {
    byte* BORDER_COLOR = $d020;
    byte i=0;
    while(true) {
        *BORDER_COLOR = TABLE[i++];
    }
}

