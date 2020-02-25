// Test minimization of constants
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  // CIA#2 Port A: Serial bus, RS-232, VIC memory bank
  .label CIA2_PORT_A = $dd00
  // CIA #2 Port A data direction register.
  .label CIA2_PORT_A_DDR = $dd02
main: {
    .const vicSelectGfxBank1_toDd001_return = 3
    // *CIA2_PORT_A_DDR = %00000011
    lda #3
    sta CIA2_PORT_A_DDR
    // *CIA2_PORT_A = toDd00(gfx)
    lda #vicSelectGfxBank1_toDd001_return
    sta CIA2_PORT_A
    // }
    rts
}
