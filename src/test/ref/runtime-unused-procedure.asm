// Tests that a procedure that is never called, but requires static analysis is correctly eliminated
  // Commodore 64 PRG executable file
.file [name="runtime-unused-procedure.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .label screen = $400
.segment Code
main: {
    // screen[0] = 'a'
    lda #'a'
    sta screen
    // }
    rts
}
