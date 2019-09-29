// Illustrates introducing local scopes inside loops etc
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
main: {
    ldx #0
  __b1:
    lda #'a'
    sta SCREEN,x
    inx
    cpx #6
    bne __b1
    ldx #0
  __b2:
    lda #'b'
    sta SCREEN+$28,x
    inx
    cpx #6
    bne __b2
    rts
}
