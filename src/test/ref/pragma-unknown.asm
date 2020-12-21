// Test an unknown pragma
  // Commodore 64 PRG executable file
.file [name="pragma-unknown.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .label SCREEN = $400
.segment Code
main: {
    // *SCREEN = 'a'
    lda #'a'
    sta SCREEN
    // }
    rts
}
