// Test the preprocessor
// Macro generating inline ASM
  // Commodore 64 PRG executable file
.file [name="preprocessor-7.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .label SCREEN = $400
.segment Code
main: {
    // SEI
    sei
    // SCREEN[idx++] = 'x'
    lda #'x'
    sta SCREEN
    // CLI
    cli
    // }
    rts
}
