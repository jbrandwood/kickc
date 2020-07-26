// Tests compiling inline C65CE02/45GS02 Assembler

#pragma cpu(MEGA45GS02)

void main() {
    kickasm {{
        ldz #2
        stz $0800
        adcq ($2)
    }}
}