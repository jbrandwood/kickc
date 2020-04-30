// Test minimization of constants
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .const OFFSET_STRUCT_MOS6526_CIA_PORT_A_DDR = 2
  // The CIA#2: Serial bus, RS-232, VIC memory bank
  .label CIA2 = $dd00
main: {
    .const vicSelectGfxBank1_toDd001_return = 3
    // CIA2->PORT_A_DDR = %00000011
    lda #3
    sta CIA2+OFFSET_STRUCT_MOS6526_CIA_PORT_A_DDR
    // CIA2->PORT_A = toDd00(gfx)
    lda #vicSelectGfxBank1_toDd001_return
    sta CIA2
    // }
    rts
}
