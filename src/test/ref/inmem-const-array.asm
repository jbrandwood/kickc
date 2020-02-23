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
  __b1:
    // screen[i] = '*'
    lda #'*'
    sta screen,x
    // cols[i] = colseq[j]
    lda colseq,y
    sta cols,x
    // if(++j==3)
    iny
    cpy #3
    bne __b2
    ldy #0
  __b2:
    // for( byte i : 0..39)
    inx
    cpx #$28
    bne __b1
    // }
    rts
    colseq: .byte WHITE, RED, GREEN
}
