//  Tests that inline ASM clobbering is taken into account when assigning registers
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
main: {
    .label l = 2
    ldx #0
  //  First loop with no clobber
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
    ldy #0
  //  Then loop with clobbering A&X
  b3:
    lda #0
    sta l
  b4:
    eor #$55
    tax
    lda l
    sta SCREEN,y
    inc l
    lda l
    cmp #$65
    bne b4
    iny
    cpy #$65
    bne b3
    rts
}
