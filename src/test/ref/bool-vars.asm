// A test of boolean conditions using && || and !
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    jsr bool_and
    jsr bool_or
    jsr bool_not
    jsr bool_complex
    rts
}
bool_complex: {
    .label screen = $478
    ldy #0
  __b1:
    cpy #$a
    lda #0
    rol
    eor #1
    tax
    tya
    and #1
    eor #0
    beq !+
    lda #1
  !:
    eor #1
    cpx #0
    bne __b6
    jmp __b5
  __b6:
    cmp #0
    bne __b2
  __b5:
    cpx #0
    bne __b4
    cmp #0
    bne __b4
  __b2:
    lda #'*'
    sta screen,y
  __b3:
    iny
    cpy #$15
    bne __b1
    rts
  __b4:
    lda #' '
    sta screen,y
    jmp __b3
}
bool_not: {
    .label screen = $450
    ldx #0
  __b1:
    txa
    and #1
    cpx #$a
    bcc __b4
    cmp #0
    beq __b4
    lda #'*'
    sta screen,x
  __b3:
    inx
    cpx #$15
    bne __b1
    rts
  __b4:
    lda #' '
    sta screen,x
    jmp __b3
}
bool_or: {
    .label screen = $428
    ldx #0
  __b1:
    txa
    and #1
    cpx #$a
    bcc __b2
    cmp #0
    beq __b2
    lda #' '
    sta screen,x
  __b3:
    inx
    cpx #$15
    bne __b1
    rts
  __b2:
    lda #'*'
    sta screen,x
    jmp __b3
}
bool_and: {
    .label screen = $400
    ldx #0
  __b1:
    txa
    and #1
    cpx #$a
    bcs __b4
    cmp #0
    beq __b2
  __b4:
    lda #' '
    sta screen,x
  __b3:
    inx
    cpx #$15
    bne __b1
    rts
  __b2:
    lda #'*'
    sta screen,x
    jmp __b3
}
