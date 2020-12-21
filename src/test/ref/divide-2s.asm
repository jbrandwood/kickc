// Check that division by factors of 2 is converted to shifts
  // Commodore 64 PRG executable file
.file [name="divide-2s.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
.segment Code
main: {
    .label SCREEN = $400
    ldx #0
  __b1:
    // (SCREEN+40*0)[i] = i/1
    txa
    sta SCREEN,x
    // i/2
    txa
    lsr
    // (SCREEN+40*1)[i] = i/2
    sta SCREEN+$28*1,x
    // i/4
    txa
    lsr
    lsr
    // (SCREEN+40*2)[i] = i/4
    sta SCREEN+$28*2,x
    // i/8
    txa
    lsr
    lsr
    lsr
    // (SCREEN+40*3)[i] = i/8
    sta SCREEN+$28*3,x
    // sb = -(signed byte)i
    txa
    eor #$ff
    clc
    adc #1
    // sb/2
    cmp #$80
    ror
    // (SCREEN+40*5)[i] = (byte)(sb/2)
    sta SCREEN+$28*5,x
    // for(byte i: 0..10)
    inx
    cpx #$b
    bne __b1
    // }
    rts
}
