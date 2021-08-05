// Demonstrates a problem where a preprocessor macro with parameters name is used without any call parenthesis.
  // Commodore 64 PRG executable file
.file [name="preprocessor-17.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
.segment Code
main: {
    .label SCREEN = $400
    // SCREEN[0] = CLEAR
    lda #$7f
    sta SCREEN
    // SCREEN[1] = CLEAR
    lda #0
    sta SCREEN+1
    // }
    rts
}
