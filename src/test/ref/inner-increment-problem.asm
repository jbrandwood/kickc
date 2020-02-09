// Inner increment is not being done properly (screen++)
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    // Count the number of the different chars on the screen
    .label screen = 2
    .label i = 4
    lda #<0
    sta.z i
    sta.z i+1
    lda #<$400
    sta.z screen
    lda #>$400
    sta.z screen+1
  __b1:
    ldy #0
    lda (screen),y
    asl
    tax
    lda (screen),y
    asl
    tay
    clc
    lda CHAR_COUNTS,x
    adc #1
    sta CHAR_COUNTS,y
    bne !+
    lda CHAR_COUNTS+1,x
    adc #0
    sta CHAR_COUNTS+1,y
  !:
    inc.z screen
    bne !+
    inc.z screen+1
  !:
    inc.z i
    bne !+
    inc.z i+1
  !:
    lda.z i+1
    cmp #>$3e8
    bne __b1
    lda.z i
    cmp #<$3e8
    bne __b1
    rts
}
  CHAR_COUNTS: .fill 2*$100, 0
