// Tests break statement in a simple loop
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
main: {
    ldx #0
  b1:
    lda SCREEN,x
    cmp #'a'
    bne b2
    rts
  b2:
    lda #'a'
    sta SCREEN,x
    inx
    cpx #$28*6+1
    bne b1
    rts
}
