// Tests compiling inline C65CE02 Assembler
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    // kickasm
    .cpu _45gs02
        ldz #2
        stz $0800
        adcq ($2)
    
    // }
    rts
}
