// Test inline KickAssembler code

void main() {
    while(true) {
        kickasm {{
            inc $d020
        }}
    }
}

kickasm {{
    .byte 1, 2, 3
}}