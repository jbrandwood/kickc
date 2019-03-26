.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .const BLACK = 0
    .label screen = $400
    .label cols = $d800
    ldy #0
  b1:
    tya
    tax
    axs #-$c
    lda #'a'
    sta screen,x
    lda #BLACK
    sta cols,x
    iny
    cpy #$b
    bne b1
    rts
}
