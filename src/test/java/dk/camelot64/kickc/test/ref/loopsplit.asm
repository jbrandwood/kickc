.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  jsr main
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
    bcs b4
  !:
    dex
    jmp b1
  b4:
    inx
    jmp b1
}
