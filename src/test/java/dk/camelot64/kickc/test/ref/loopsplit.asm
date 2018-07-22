.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  jsr main
main: {
    lda #$64
  b1:
    sec
    sbc #1
    cmp #0
    bne b2
    rts
  b2:
    cmp #$32
    beq !+
  !:
    jmp b1
}
