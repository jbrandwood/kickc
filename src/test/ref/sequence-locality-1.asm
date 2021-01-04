// Tests statement sequence locality of if(cond) { stmt1; } else { stmt2; }
  // Commodore 64 PRG executable file
.file [name="sequence-locality-1.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
.segment Code
main: {
    .label screen = $400
    ldx #0
    ldy #0
  __b1:
    // if(i>5)
    cpy #5+1
    bcc __b4
    // j += i
    tya
    asl
  __b2:
    // screen[idx++] = j
    sta screen,x
    // screen[idx++] = j;
    inx
    // for(byte i: 0..10)
    iny
    cpy #$b
    bne __b1
    // }
    rts
  __b4:
    tya
    jmp __b2
}
