// VIC 20 Raster bars
// Commodore VIC 20 registers and memory layout
// http://sleepingelephant.com/denial/wiki/index.php?title=Memory_Map
// http://www.zimmers.net/anonftp/pub/cbm/vic20/manuals/VIC-20_Programmers_Reference_Guide_1st_Edition_6th_Printing.pdf
// MOS 6560/6561 VIDEO INTERFACE CHIP
// Used in VIC 20
// http://archive.6502.org/datasheets/mos_6560_6561_vic.pdf
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
