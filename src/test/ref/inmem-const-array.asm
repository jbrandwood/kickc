  // Commodore 64 PRG executable file
.file [name="inmem-const-array.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .const WHITE = 1
  .const RED = 2
  .const GREEN = 5
.segment Code
main: {
    .label screen = $400
    .label cols = $d800
    ldy #0
    ldx #0
  __b1:
    // screen[i] = '*'
    lda #'*'
    sta screen,x
    // cols[i] = colseq[j]
    lda colseq,y
    sta cols,x
    // if(++j==3)
    iny
    cpy #3
    bne __b2
    ldy #0
  __b2:
    // for( byte i : 0..39)
    inx
    cpx #$28
    bne __b1
    // }
    rts
  .segment Data
    colseq: .byte WHITE, RED, GREEN
}
