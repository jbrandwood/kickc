// Tests break statement in a simple loop
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
main: {
    ldx #0
  __b1:
    lda SCREEN,x
    cmp #'a'
    beq __breturn
    lda #'a'
    sta SCREEN,x
    inx
    cpx #$28*6+1
    bne __b1
  __breturn:
    rts
}
