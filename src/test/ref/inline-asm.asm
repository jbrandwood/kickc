.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    // asm
    lda #'a'
    ldx #$ff
  !:
    sta $400,x
    sta $500,x
    sta $600,x
    sta $700,x
    dex
    bne !-
    // }
    rts
}
