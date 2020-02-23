.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .const BLACK = 0
    .label screen = $400
    .label cols = $d800
    ldy #0
  __b1:
    // y=x+12
    tya
    tax
    axs #-[$c]
    // screen[y] = 'a'
    lda #'a'
    sta screen,x
    // cols[y] = BLACK
    lda #BLACK
    sta cols,x
    // for(byte x:0..10)
    iny
    cpy #$b
    bne __b1
    // }
    rts
}
