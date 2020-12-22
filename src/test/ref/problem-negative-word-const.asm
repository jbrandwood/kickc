// Problem with assigning negative word constant (vwuz1=vbuc1)
  // Commodore 64 PRG executable file
.file [name="problem-negative-word-const.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .label screen = $400
.segment Code
main: {
    .label w = 2
    ldx #0
  __b1:
    // w = i
    txa
    sta.z w
    lda #0
    sta.z w+1
    // i&1
    txa
    and #1
    // if(i&1)
    cmp #0
    beq __b2
    lda #<-1
    sta.z w
    sta.z w+1
  __b2:
    // screen[i] = w
    txa
    asl
    tay
    lda.z w
    sta screen,y
    lda.z w+1
    sta screen+1,y
    // for( byte i:0..7)
    inx
    cpx #8
    bne __b1
    // }
    rts
}
