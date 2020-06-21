// Test inline KickAssembler code

void main() {
    while(true) {
        // KickAsm inline code
        kickasm {{
            inc $d020
        }}
    }
}

// KickAsm data initializer
export char A[] = kickasm {{
    .byte 1, 2, 3
}}