.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .const SCREEN = $400
  jsr main
main: {
    .label k = 2
    ldx #0
  b1:
    lda #0
  b2:
    sta SCREEN,x
    clc
    adc #1
    cmp #$65
    bne b2
    inx
    cpx #$65
    bne b1
    lda #0
    sta k
  b3:
    ldy #0
  b4:
    eor #$55
    tax
    tya
    ldx k
    sta SCREEN,x
    iny
    cpy #$65
    bne b4
    inc k
    lda k
    cmp #$65
    bne b3
    rts
}
