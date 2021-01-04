// Tests that inline assembler is optimized
  // Commodore 64 PRG executable file
.file [name="inline-asm-optimized.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .label SCREEN = $400
.segment Code
main: {
    // *SCREEN = 0
    lda #0
    sta SCREEN
    // asm
    sta SCREEN+1
    sta SCREEN+2
    // SCREEN[3] = 0
    sta SCREEN+3
    // asm
    sta SCREEN+4
    // }
    rts
}
