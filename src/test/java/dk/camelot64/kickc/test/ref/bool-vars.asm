.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label screen = $400
  jsr main
main: {
    .label o1 = 2
    ldx #0
  b1:
    cpx #$a
    lda #0
    rol
    eor #1
    sta o1
    txa
    and #1
    sec
    sbc #0
    beq !+
    lda #$ff
  !:
    eor #$ff
    cmp #0
    beq !+
    lda #$ff
  !:
    and o1
    cmp #0
    bne b2
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
