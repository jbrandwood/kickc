// Tests using integer conditions in if()
// This should produce '+ ++ ++' at the top of the screen
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
main: {
    .label i1 = 2
    lda #'+'
    sta SCREEN
    lda #' '
    sta SCREEN+1
    ldy #2
    ldx #0
  // loop byte
  __b3:
    cpx #0
    beq __b4
    lda #'+'
    sta SCREEN,y
    iny
  __b4:
    inx
    cpx #3
    bne __b3
    lda #' '
    sta SCREEN,y
    iny
    lda #<0
    sta.z i1
    sta.z i1+1
  // loop word
  __b7:
    lda.z i1
    cmp #<0
    bne !+
    lda.z i1+1
    cmp #>0
    beq __b8
  !:
    lda #'+'
    sta SCREEN,y
    iny
  __b8:
    inc.z i1
    bne !+
    inc.z i1+1
  !:
    lda.z i1+1
    cmp #>3
    bne __b7
    lda.z i1
    cmp #<3
    bne __b7
    rts
}
