// Illustrates a problem where volatiles with initializers are initialized outside the main()-routine
.pc = $801 "Basic"
:BasicUpstart(_start)
.pc = $80d "Program"
  .label x = 2
_start: {
    // x = 12
    lda #$c
    sta.z x
    jsr main
    rts
}
main: {
  __b1:
    // while(++x<50)
    inc.z x
    lda.z x
    cmp #$32
    bcc __b1
    // x = 0
    lda #0
    sta.z x
    // }
    rts
}
