// Tests using integer conditions in && and || operator
// This should produce '01010101', '00110011', '00010001', '01110111' at the top of the screen
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
main: {
    .label _8 = 2
    .label _9 = 3
    .label _14 = 4
    .label _15 = 5
    ldx #0
    ldy #0
  b1:
    tya
    and #1
    cmp #0
    beq b2
    lda #'+'
    sta SCREEN,x
  b2:
    tya
    and #2
    cmp #0
    beq b3
    lda #'+'
    sta SCREEN+$28*1,x
  b3:
    tya
    and #1
    sta _8
    tya
    and #2
    sta _9
    lda #0
    cmp _8
    beq b4
    cmp _9
    beq b4
    lda #'+'
    sta SCREEN+$28*2,x
  b4:
    tya
    and #1
    sta _14
    tya
    and #2
    sta _15
    lda #0
    cmp _14
    bne b9
    cmp _15
    beq b5
  b9:
    lda #'+'
    sta SCREEN+$28*3,x
  b5:
    inx
    iny
    cpy #8
    bne b1
    rts
}
