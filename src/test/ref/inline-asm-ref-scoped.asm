// Tests that references to labels in other scopes is possible from inline ASM
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    // asm
    lda #'c'
    sta sub.ll+1
    // sub()
    jsr sub
    // }
    rts
}
sub: {
    // asm
  ll:
    lda #0
    sta $400
    // }
    rts
}
