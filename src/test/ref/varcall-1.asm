// Test __varcall calling convention
// Parameter passing
  // Commodore 64 PRG executable file
.file [name="varcall-1.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .label BGCOL = $d021
.segment Code
// void setbg(__zp(2) char col)
setbg: {
    .label col = 2
    // *BGCOL = col
    lda.z col
    sta BGCOL
    // }
    rts
}
main: {
    // setbg(0)
    lda #0
    sta.z setbg.col
    jsr setbg
    // setbg(0x0b)
    lda #$b
    sta.z setbg.col
    jsr setbg
    // }
    rts
}
