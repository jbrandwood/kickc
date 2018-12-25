.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .const WHITE = 1
  .const RED = 2
  .const GREEN = 5
main: {
    .label screen = $400
    .label cols = $d800
    ldy #0
    ldx #0
  b1:
    lda #'*'
    sta screen,x
    lda colseq,y
    sta cols,x
    iny
    cpy #3
    bne b2
    ldy #0
  b2:
    inx
    cpx #$28
    bne b1
    rts
    colseq: .byte WHITE, RED, GREEN
}
