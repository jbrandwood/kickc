  // Commodore 64 PRG executable file
.file [name="loopnest.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .label SCREEN = $400
.segment Code
main: {
    ldy #$64
  __b1:
    // nest()
    jsr nest
    // while (--i>0)
    dey
    cpy #0
    bne __b1
    // }
    rts
}
nest: {
    ldx #$64
  __b1:
    // *SCREEN = j
    stx SCREEN
    // while (--j>0)
    dex
    cpx #0
    bne __b1
    // }
    rts
}
