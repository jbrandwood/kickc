// Tests break statement in a simple loop
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
main: {
    ldx #0
  __b1:
    lda SCREEN,x
    cmp #' '
    beq __b3
    inc SCREEN,x
  __b3:
    inx
    cpx #$28*6+1
    bne __b1
    rts
}
