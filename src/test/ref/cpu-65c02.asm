// Test the 65C02 CPU
// A program that uses 65C02 instructions
.cpu _65c02
  // Commodore 64 PRG executable file
.file [name="cpu-65c02.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .label SCREEN = $400
.segment Code
main: {
    // char a = SCREEN[0]
    lda SCREEN
    // a+1
    inc
    // SCREEN[1] = a+1
    sta SCREEN+1
    // }
    rts
}
