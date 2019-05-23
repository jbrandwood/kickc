// Tests break statement in a simple loop
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
main: {
    ldx #0
  b1:
    inx
    cpx #$28*6
    bcc b2
    rts
  b2:
    lda SCREEN,x
    cmp #' '
    beq b1
    inc SCREEN,x
    jmp b1
}
