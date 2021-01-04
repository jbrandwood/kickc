// A file using a library
  // Commodore 64 PRG executable file
.file [name="includes-3.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .label SCREEN = $400
.segment Code
main: {
    // SCREEN[i++] = value
    lda #'a'
    sta SCREEN
    lda #'x'
    sta SCREEN+1
    // }
    rts
}
