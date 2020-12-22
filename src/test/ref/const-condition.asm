// Ensure that if()'s with constant comparisons are identified and eliminated
  // Commodore 64 PRG executable file
.file [name="const-condition.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
.segment Code
main: {
    .label SCREEN = $400
    // SCREEN[0] = '!'
    lda #'!'
    sta SCREEN
    // }
    rts
}
