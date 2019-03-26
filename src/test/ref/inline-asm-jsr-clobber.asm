// Tests that inline ASM JSR clobbers all registers
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .label i = 2
    lda #0
    sta i
  b1:
    jsr $e544
    inc i
    lda #$b
    cmp i
    bne b1
    rts
}
