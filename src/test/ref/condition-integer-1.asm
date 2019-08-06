// Tests using integer conditions in if()
// This should produce '0 0 0' at the top of the screen
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
main: {
    .label i1 = 2
    lda #'0'
    sta SCREEN
    lda #' '
    sta SCREEN+1
    ldx #2
    ldy #0
  b5:
    lda #'0'
    sta SCREEN,x
    inx
  b4:
    iny
    cpy #3
    bne b3
    lda #' '
    sta SCREEN,x
    inx
    lda #<0
    sta i1
    sta i1+1
  b9:
    lda #'0'
    sta SCREEN,x
    inx
  b8:
    inc i1
    bne !+
    inc i1+1
  !:
    lda i1+1
    cmp #>3
    bne b7
    lda i1
    cmp #<3
    bne b7
    rts
  // loop word
  b7:
    lda i1+1
    cmp #>0
    bne b8
    lda i1
    cmp #<0
    bne b8
    jmp b9
  // loop byte
  b3:
    cpy #0
    bne b4
    jmp b5
}
