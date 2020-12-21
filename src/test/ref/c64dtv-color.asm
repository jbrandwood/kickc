// Test C64DTV v2 256-colors and the 16-color redefinable palette
  // Commodore 64 PRG executable file
.file [name="c64dtv-color.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .const DTV_FEATURE_ENABLE = 1
  .const DTV_BORDER_OFF = 2
  .const DTV_HIGHCOLOR = 4
  .const DTV_BADLINE_OFF = $20
  .label RASTER = $d012
  .label BG_COLOR = $d021
  // Feature enables or disables the extra C64 DTV features
  .label DTV_FEATURE = $d03f
  // Controls the graphics modes of the C64 DTV
  .label DTV_CONTROL = $d03c
  // Defines colors for the 16 first colors ($00-$0f)
  .label DTV_PALETTE = $d200
.segment Code
main: {
    // asm
    sei
    // *DTV_FEATURE = DTV_FEATURE_ENABLE
    lda #DTV_FEATURE_ENABLE
    sta DTV_FEATURE
    // *DTV_CONTROL = DTV_HIGHCOLOR | DTV_BORDER_OFF | DTV_BADLINE_OFF
    lda #DTV_HIGHCOLOR|DTV_BORDER_OFF|DTV_BADLINE_OFF
    sta DTV_CONTROL
  __b1:
    // while(*RASTER!=$40)
    lda #$40
    cmp RASTER
    bne __b1
    // *BG_COLOR = 0
    // Create rasterbars
    lda #0
    sta BG_COLOR
    ldx #$31
  __b3:
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
    nop
    nop
    nop
    // (*BG_COLOR)++;
    inc BG_COLOR
    // for (byte r : $31..$ff)
    inx
    cpx #0
    bne __b3
    ldx #0
  // Rotate palette
  __b4:
    // DTV_PALETTE[c] = palette[c]
    lda palette,x
    sta DTV_PALETTE,x
    // palette[c]++;
    inc palette,x
    // for(byte c : 0..$f)
    inx
    cpx #$10
    bne __b4
    jmp __b1
  .segment Data
    palette: .byte 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, $a, $b, $c, $d, $e, $f
}
