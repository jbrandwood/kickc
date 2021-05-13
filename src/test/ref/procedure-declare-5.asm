// Procedure Declaration - a void procedure declared with empty parenthesis
  // Commodore 64 PRG executable file
.file [name="procedure-declare-5.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
.segment Code
main: {
    .label SCREEN = $400
    // f()
    jsr f
    // SCREEN[0] = f()
    lda #f.return
    sta SCREEN
    // }
    rts
}
f: {
    .label return = 7
    rts
}
