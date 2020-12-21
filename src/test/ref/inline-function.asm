// Test inline function
// Splits screen so upper half is lower case and lower half lower case
  // Commodore 64 PRG executable file
.file [name="inline-function.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .label RASTER = $d012
  .label D018 = $d018
  .label BG_COLOR = $d021
  .label screen = $400
  .label charset1 = $1000
  .label charset2 = $1800
.segment Code
main: {
    .const toD0181_return = screen/$40|charset1/$400
    .const toD0182_return = screen/$40|charset2/$400
    // asm
    sei
  __b1:
    // while(*RASTER!=$ff)
    lda #$ff
    cmp RASTER
    bne __b1
    // *D018 = toD018(screen, charset1)
    lda #toD0181_return
    sta D018
    // *BG_COLOR = $6
    lda #6
    sta BG_COLOR
  __b2:
    // while(*RASTER!=$62)
    lda #$62
    cmp RASTER
    bne __b2
    // *D018 = toD018(screen, charset2)
    lda #toD0182_return
    sta D018
    // *BG_COLOR = $b
    lda #$b
    sta BG_COLOR
    jmp __b1
}
