// Tests that inline ASM JSR clobbers all registers
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .label i = 2
    lda #0
    sta.z i
  __b1:
    // asm
    jsr $e544
    // for( byte i:0..10)
    inc.z i
    lda #$b
    cmp.z i
    bne __b1
    // }
    rts
}
