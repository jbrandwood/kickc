.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    ldx #0
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
    bcs b3
  !:
    dex
    jmp b1
  b3:
    inx
    jmp b1
}
