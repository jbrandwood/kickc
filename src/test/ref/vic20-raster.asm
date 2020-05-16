// VIC 20 Raster bars
.pc = $1001 "Basic"
:BasicUpstart(main)
.pc = $100d "Program"
  .const OFFSET_STRUCT_MOS6561_VIC_RASTER = 4
  .const OFFSET_STRUCT_MOS6561_VIC_BORDER_BACKGROUND_COLOR = $f
  // The MOS 6560/6561 VIC Video Interface Chip
  .label VIC = $9000
main: {
    // asm
    sei
  __b1:
    // VIC->BORDER_BACKGROUND_COLOR = VIC->RASTER
    lda VIC+OFFSET_STRUCT_MOS6561_VIC_RASTER
    sta VIC+OFFSET_STRUCT_MOS6561_VIC_BORDER_BACKGROUND_COLOR
    jmp __b1
}
