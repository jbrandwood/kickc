// Procedure Declaration - A single procedure without parameters or return declared and then defined
  // Commodore 64 PRG executable file
.file [name="procedure-declare-1.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
.segment Code
main: {
    .label SCREEN = $400
    // SCREEN[0] = 'a'
    lda #'a'
    sta SCREEN
    // }
    rts
}
