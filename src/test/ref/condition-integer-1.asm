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
    ldy #2
    ldx #0
  // loop byte
  b3:
    cpx #0
    bne b4
    lda #'0'
    sta SCREEN,y
    iny
  b4:
    inx
    cpx #3
    bne b3
    lda #' '
    sta SCREEN,y
    iny
    lda #<0
    sta.z i1
    sta.z i1+1
  // loop word
  b7:
    lda.z i1+1
    cmp #>0
    bne b8
    lda.z i1
    cmp #<0
    bne b8
    lda #'0'
    sta SCREEN,y
    iny
  b8:
    inc.z i1
    bne !+
    inc.z i1+1
  !:
    lda.z i1+1
    cmp #>3
    bne b7
    lda.z i1
    cmp #<3
    bne b7
    rts
}
