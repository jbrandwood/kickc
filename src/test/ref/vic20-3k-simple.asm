// Trivial VIC 20 program
/// @file
/// Commodore VIC 20 registers and memory layout
///
/// http://sleepingelephant.com/denial/wiki/index.php?title=Memory_Map
/// http://www.zimmers.net/anonftp/pub/cbm/vic20/manuals/VIC-20_Programmers_Reference_Guide_1st_Edition_6th_Printing.pdf
/// @file
/// MOS 6560/6561 VIDEO INTERFACE CHIP
///
/// Used in VIC 20
/// http://archive.6502.org/datasheets/mos_6560_6561_vic.pdf
  // Commodore VIC 20 +3k expanded executable PRG file
.file [name="vic20-3k-simple.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0401]
.segmentdef Code [start=$40d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .const RED = 2
  /// Default address of screen color matrix
  .label DEFAULT_COLORRAM = $9600
  /// Default address of screen character matrix
  .label DEFAULT_SCREEN = $1e00
.segment Code
main: {
    ldx #0
  __b1:
    // for(char i=0; MESSAGE[i]; i++)
    lda MESSAGE,x
    cmp #0
    bne __b2
    // }
    rts
  __b2:
    // DEFAULT_SCREEN[i] = MESSAGE[i]
    lda MESSAGE,x
    sta DEFAULT_SCREEN,x
    // DEFAULT_COLORRAM[i] = RED
    lda #RED
    sta DEFAULT_COLORRAM,x
    // for(char i=0; MESSAGE[i]; i++)
    inx
    jmp __b1
}
.segment Data
  MESSAGE: .text "hello world!"
  .byte 0
