// Tests that inline ASM clobbering is taken into account when assigning registers
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
main: {
    .label l = 2
    ldx #0
  // First loop with no clobber
  __b1:
    lda #0
  __b2:
    sta SCREEN,x
    clc
    adc #1
    cmp #$65
    bne __b2
    inx
    cpx #$65
    bne __b1
    ldy #0
  // Then loop with clobbering A&X
  __b4:
    lda #0
    sta.z l
  __b5:
    eor #$55
    tax
    lda.z l
    sta SCREEN,y
    inc.z l
    lda #$65
    cmp.z l
    bne __b5
    iny
    cpy #$65
    bne __b4
    rts
}
