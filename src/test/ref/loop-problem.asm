.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
  jsr main
main: {
    lda #'0'
    sta SCREEN
    jsr d
    jsr b
    rts
}
b: {
    ldx #0
  b1:
    jsr d
    inx
    cpx #4
    bne b1
    rts
}
d: {
    inc SCREEN
    rts
}
