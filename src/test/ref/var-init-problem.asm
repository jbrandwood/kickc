// Variables without initialization causes problems when compiling
  // Commodore 64 PRG executable file
.file [name="var-init-problem.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .label screen = $400
.segment Code
main: {
    // *screen = 'a'
    lda #'a'
    sta screen
    // }
    rts
}
