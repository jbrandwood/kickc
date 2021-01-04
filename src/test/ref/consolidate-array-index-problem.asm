  // Commodore 64 PRG executable file
.file [name="consolidate-array-index-problem.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
.segment Code
main: {
    .const BLACK = 0
    .label screen = $400
    .label cols = $d800
    ldy #0
  __b1:
    // y=x+12
    tya
    tax
    axs #-[$c]
    // screen[y] = 'a'
    lda #'a'
    sta screen,x
    // cols[y] = BLACK
    lda #BLACK
    sta cols,x
    // for(byte x:0..10)
    iny
    cpy #$b
    bne __b1
    // }
    rts
}
