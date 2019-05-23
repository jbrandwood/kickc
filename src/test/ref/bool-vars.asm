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
    .label o1 = 2
    .label o2 = 3
    ldx #0
  b1:
    cpx #$a
    lda #0
    rol
    eor #1
    sta o1
    txa
    and #1
    eor #0
    beq !+
    lda #1
  !:
    eor #1
    sta o2
    lda o1
    cmp #0
    bne b6
    jmp b5
  b6:
    lda o2
    cmp #0
    bne b2
  b5:
    lda o1
    cmp #0
    bne b4
    lda o2
    cmp #0
    bne b4
  b2:
    lda #'*'
    sta screen,x
  b3:
    inx
    cpx #$15
    bne b1
    rts
  b4:
    lda #' '
    sta screen,x
    jmp b3
}
bool_not: {
    .label screen = $450
    ldx #0
  b1:
    txa
    and #1
    cpx #$a
    bcc b4
    cmp #0
    beq b4
    lda #'*'
    sta screen,x
  b3:
    inx
    cpx #$15
    bne b1
    rts
  b4:
    lda #' '
    sta screen,x
    jmp b3
}
bool_or: {
    .label screen = $428
    ldx #0
  b1:
    txa
    and #1
    cpx #$a
    bcc b2
    cmp #0
    beq b2
    lda #' '
    sta screen,x
  b3:
    inx
    cpx #$15
    bne b1
    rts
  b2:
    lda #'*'
    sta screen,x
    jmp b3
}
bool_and: {
    .label screen = $400
    ldx #0
  b1:
    txa
    and #1
    cpx #$a
    bcc b5
    jmp b4
  b5:
    cmp #0
    beq b2
  b4:
    lda #' '
    sta screen,x
  b3:
    inx
    cpx #$15
    bne b1
    rts
  b2:
    lda #'*'
    sta screen,x
    jmp b3
}
