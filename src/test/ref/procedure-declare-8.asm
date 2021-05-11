// Pointer to procedure
  // Commodore 64 PRG executable file
.file [name="procedure-declare-8.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .label SCREEN = $400
.segment Code
main: {
    // (*proc_ptr)()
    jsr proc1
    jsr proc2
    // }
    rts
}
proc2: {
    // SCREEN[1] = 'b'
    lda #'b'
    sta SCREEN+1
    // }
    rts
}
proc1: {
    // SCREEN[0] = 'a'
    lda #'a'
    sta SCREEN
    // }
    rts
}
