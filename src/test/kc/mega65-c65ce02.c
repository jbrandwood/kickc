// Tests compiling inline C65CE02 Assembler

void main() {
    kickasm {{
        .cpu _45gs02
        ldz #2
        stz $0800
        adcq ($2)
    }}
}