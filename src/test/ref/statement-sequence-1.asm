// Tests statement sequence  generation
  // Commodore 64 PRG executable file
.file [name="statement-sequence-1.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
.segment Code
main: {
    .label SCREEN = $400
    ldy #0
  __b1:
    // c = i+5
    tya
    tax
    axs #-[5]
    // i&1
    tya
    and #1
    // if((i&1)==0 || i>5)
    cmp #0
    beq __b3
    cpy #5+1
    bcc __b2
  __b3:
    // c++;
    inx
  __b2:
    // SCREEN[i] = c
    txa
    sta SCREEN,y
    // for(byte i: 0..10)
    iny
    cpy #$b
    bne __b1
    // }
    rts
}
