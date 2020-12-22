// Tests statement sequence locality of if(cond) { stmt1; } else { stmt2; }
  // Commodore 64 PRG executable file
.file [name="sequence-locality-0.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
.segment Code
main: {
    .label screen = $400
    ldy #0
    ldx #0
  __b1:
    // if(i>5)
    cpx #5+1
    bcs __b2
    // i-5
    txa
    sec
    sbc #5
    // screen[idx++] = i-5
    sta screen,y
    // screen[idx++] = i-5;
    iny
  __b3:
    // for(byte i: 0..10)
    inx
    cpx #$b
    bne __b1
    // }
    rts
  __b2:
    // screen[idx++] = i
    txa
    sta screen,y
    // screen[idx++] = i;
    iny
    jmp __b3
}
