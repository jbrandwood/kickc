// Test inline KickAssembler code with PC location specification

byte* TABLE = $2000;

void main() {
    byte* BORDER_COLOR = $d020;
    byte i=0;
    while(true) {
        *BORDER_COLOR = TABLE[i++];
    }
}

kickasm(pc TABLE) {{
    .byte 1, 2, 3
}}