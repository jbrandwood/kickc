  // Commodore 64 PRG executable file
.file [name="preprocessor-1.prg", type="prg", segments="Program"]
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
    // END_MAIN
    rts
}
