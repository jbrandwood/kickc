// Illustrates the problem with variable forward references not working
  // Commodore 64 PRG executable file
.file [name="var-forward-problem.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .const b = 'a'
  .label screen = $400
.segment Code
main: {
    // *screen = b
    lda #b
    sta screen
    // }
    rts
}
