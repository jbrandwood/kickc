  // Commodore 64 PRG executable file
.file [name="consolidate-constant-problem.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .label screen = $400
.segment Code
main: {
    // *(screen+40*j+39) = 0
    lda #0
    sta screen+$27
    // screen[40*j+37] = 0
    sta screen+$25
    // *(screen+40*j+39) = 0
    sta screen+$28*1+$27
    // screen[40*j+37] = 0
    sta screen+$28*1+$25
    // }
    rts
}
