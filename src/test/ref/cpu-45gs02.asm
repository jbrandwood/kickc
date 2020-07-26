// Tests compiling inline C65CE02/45GS02 Assembler
.cpu _45gs02
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    // kickasm
    ldz #2
        stz $0800
        adcq ($2)
    
    // }
    rts
}
