// Minimal unrolled ranged for() loop
  // Commodore 64 PRG executable file
.file [name="unroll-for-min.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
.segment Code
main: {
    .label SCREEN = $400
    // SCREEN[i] = 'a'
    lda #'a'
    sta SCREEN
    sta SCREEN+1
    sta SCREEN+2
    // }
    rts
}
