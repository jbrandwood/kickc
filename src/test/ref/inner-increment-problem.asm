// Inner increment is not being done properly (screen++)
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .label screen = 2
    .label i = 4
    lda #<0
    sta i
    sta i+1
    lda #<$400
    sta screen
    lda #>$400
    sta screen+1
  b1:
    ldy #0
    lda (screen),y
    asl
    tax
    inc CHAR_COUNTS,x
    bne !+
    inc CHAR_COUNTS+1,x
  !:
    inc screen
    bne !+
    inc screen+1
  !:
    inc i
    bne !+
    inc i+1
  !:
    lda i+1
    cmp #>$3e8
    bne b1
    lda i
    cmp #<$3e8
    bne b1
    rts
}
  CHAR_COUNTS: .fill 2*$100, 0
