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
    ldy #0
    ldx #2
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
    lda i1
    cmp #<0
    bne !+
    lda i1+1
    cmp #>0
    beq b8
  !:
    lda #'+'
    sta SCREEN,x
    inx
    jmp b8
  // loop byte
  b3:
    cpy #0
    beq b4
    lda #'+'
    sta SCREEN,x
    inx
    jmp b4
}
