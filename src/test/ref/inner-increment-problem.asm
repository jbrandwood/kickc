// Inner increment is not being done properly (screen++)
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    // Count the number of the different chars on the screen
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
    // CHAR_COUNTS[*screen++]++;
    ldy #0
    lda (screen),y
    asl
    tax
    inc CHAR_COUNTS,x
    bne !+
    inc CHAR_COUNTS+1,x
  !:
    inc.z screen
    bne !+
    inc.z screen+1
  !:
    // for( word i:0..999)
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
    // }
    rts
}
  CHAR_COUNTS: .fill 2*$100, 0
