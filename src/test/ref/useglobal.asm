// Tests procedures using global variables (should not fail)
  // Commodore 64 PRG executable file
.file [name="useglobal.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .label SCREEN = $400
.segment Code
main: {
    // *SCREEN = 1
    lda #1
    sta SCREEN
    // }
    rts
}
