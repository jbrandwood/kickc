  // Commodore 64 PRG executable file
.file [name="struct-ptr-25.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .label SCREEN = $400
.segment Code
main: {
    // SCREEN[0] = *fileCur
    lda $1010-1
    sta SCREEN
    // }
    rts
}
