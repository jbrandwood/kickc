/// @file
/// @brief Commodore 64 Registers and Constants
/// @file
/// @brief The MOS 6526 Complex Interface Adapter (CIA)
///
/// http://archive.6502.org/datasheets/mos_6526_cia_recreated.pdf
  // Commodore 64 PRG executable file
.file [name="raster-bars.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .const OFFSET_STRUCT_MOS6569_VICII_RASTER = $12
  .const OFFSET_STRUCT_MOS6569_VICII_BG_COLOR = $21
  .const OFFSET_STRUCT_MOS6569_VICII_BORDER_COLOR = $20
  /// The VIC-II MOS 6567/6569
  .label VICII = $d000
.segment Code
main: {
    // asm
    sei
  __b1:
    // while (VICII->RASTER!=$a)
    lda #$a
    cmp VICII+OFFSET_STRUCT_MOS6569_VICII_RASTER
    bne __b1
  __b2:
    // while (VICII->RASTER!=$b)
    lda #$b
    cmp VICII+OFFSET_STRUCT_MOS6569_VICII_RASTER
    bne __b2
    // raster()
    jsr raster
    jmp __b1
}
raster: {
    // asm
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    // char col = rastercols[i]
    lda rastercols
    ldx #0
  __b1:
    // VICII->BG_COLOR = col
    sta VICII+OFFSET_STRUCT_MOS6569_VICII_BG_COLOR
    // VICII->BORDER_COLOR = col
    sta VICII+OFFSET_STRUCT_MOS6569_VICII_BORDER_COLOR
    // col  = rastercols[++i];
    inx
    // col  = rastercols[++i]
    lda rastercols,x
    // asm
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    // while (col!=$ff)
    cmp #$ff
    bne __b1
    // }
    rts
}
.segment Data
  rastercols: .byte $b, 0, $b, $b, $c, $b, $c, $c, $f, $c, $f, $f, 1, $f, 1, 1, $f, 1, $f, $f, $c, $f, $c, $c, $b, $c, $b, $b, 0, $b, 0, $ff
