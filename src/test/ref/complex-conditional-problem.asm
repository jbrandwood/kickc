// Test to provoke Exception when using complex || condition
  // Commodore 64 PRG executable file
.file [name="complex-conditional-problem.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .label RASTER = $d012
  .label SCREEN = $400
.segment Code
main: {
  __b1:
    // key = *RASTER
    lda RASTER
    // if (key > $20 || key < $40)
    cmp #$20+1
    bcs __b3
    cmp #$40
    bcs __b2
  __b3:
    lda #0
  __b2:
    // *SCREEN = key
    sta SCREEN
    jmp __b1
}
