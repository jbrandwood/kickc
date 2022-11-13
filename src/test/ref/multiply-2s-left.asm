// Check that multiplication by factors of 2 on the left side is converted to shifts
  // Commodore 64 PRG executable file
.file [name="multiply-2s-left.prg", type="prg", segments="Program"]
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
    // (SCREEN+0*40)[i] = 1*i
    txa
    sta SCREEN,x
    // 2*i
    txa
    asl
    // (SCREEN+1*40)[i] = 2*i
    sta SCREEN+1*$28,x
    // 4*i
    txa
    asl
    asl
    // (SCREEN+2*40)[i] = 4*i
    sta SCREEN+2*$28,x
    // 8*i
    txa
    asl
    asl
    asl
    // (SCREEN+3*40)[i] = 8*i
    sta SCREEN+3*$28,x
    // signed byte sb = -(signed byte)i
    // And a single signed byte
    txa
    eor #$ff
    clc
    adc #1
    // 2*sb
    asl
    // (SCREEN+5*40)[i] = (byte)(2*sb)
    sta SCREEN+5*$28,x
    // for(byte i: 0..10)
    inx
    cpx #$b
    bne __b1
    // }
    rts
}
