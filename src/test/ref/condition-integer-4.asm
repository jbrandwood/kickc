// Tests using integer conditions in && and || operator
// This should produce '01010101', '00110011', '00010001', '01110111' at the top of the screen
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
main: {
    .label __4 = 2
    .label __5 = 3
    .label __8 = 4
    .label __9 = 5
    ldx #0
    ldy #0
  __b1:
    tya
    and #1
    cmp #0
    beq __b2
    lda #'+'
    sta SCREEN,x
  __b2:
    tya
    and #2
    cmp #0
    beq __b3
    lda #'+'
    sta SCREEN+$28*1,x
  __b3:
    tya
    and #1
    sta.z __4
    tya
    and #2
    sta.z __5
    lda #0
    cmp.z __4
    beq __b4
    cmp.z __5
    beq __b4
    lda #'+'
    sta SCREEN+$28*2,x
  __b4:
    tya
    and #1
    sta.z __8
    tya
    and #2
    sta.z __9
    lda #0
    cmp.z __8
    bne __b9
    cmp.z __9
    beq __b5
  __b9:
    lda #'+'
    sta SCREEN+$28*3,x
  __b5:
    inx
    iny
    cpy #8
    bne __b1
    rts
}
