// Tests break statement in a simple loop
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
main: {
    ldx #0
  __b1:
    inx
    cpx #$28*6
    bcc __b2
    rts
  __b2:
    lda SCREEN,x
    cmp #' '
    beq __b1
    inc SCREEN,x
    jmp __b1
}
