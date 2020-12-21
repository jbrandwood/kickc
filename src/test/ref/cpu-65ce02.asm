// Test the 65CE02 CPU
// A program that uses 65CE02 instructions
.cpu _65ce02
  // Commodore 64 PRG executable file
.file [name="cpu-65ce02.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .label SCREEN = $400
.segment Code
main: {
    // a = SCREEN[0]
    lda SCREEN
    // a = -a
    neg
    // SCREEN[1] = a
    sta SCREEN+1
    // a/4
    asr
    asr
    // SCREEN[2] = a/4
    // Becomes a NEG
    sta SCREEN+2
    // }
    rts
}
