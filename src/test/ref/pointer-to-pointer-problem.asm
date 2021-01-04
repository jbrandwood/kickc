// Demonstrates problem with pointer to pointer
  // Commodore 64 PRG executable file
.file [name="pointer-to-pointer-problem.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .label p1 = 0
  .label p2 = 0
.segment Code
main: {
    // **p1 = **p2
    ldy p2
    sty.z $fe
    ldy p2+1
    sty.z $ff
    ldy #0
    lda ($fe),y
    ldy p1
    sty.z $fe
    ldy p1+1
    sty.z $ff
    ldy #0
    sta ($fe),y
    // }
    rts
}
