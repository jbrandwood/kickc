// Tests break statement in a simple loop
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
main: {
    ldx #0
  b1:
    lda SCREEN,x
    cmp #' '
    bne b2
  b3:
    inx
    cpx #$28*6+1
    bne b1
    rts
  b2:
    inc SCREEN,x
    jmp b3
}
