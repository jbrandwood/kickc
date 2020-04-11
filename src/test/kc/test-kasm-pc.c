// Test inline KickAssembler code with PC location specification

byte* TABLE = $2000;

void main() {
    byte* BORDERCOL = $d020;
    byte i=0;
    while(true) {
        *BORDERCOL = TABLE[i++];
    }
}

kickasm(pc TABLE) {{
    .byte 1, 2, 3
}}