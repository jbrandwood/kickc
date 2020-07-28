// Tests the different ASM addressing modes
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    // asm
    lda.z $12,x
    jmp ($1234)
    // }
}
