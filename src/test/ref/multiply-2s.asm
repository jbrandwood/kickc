// Check that multiplication by factors of 2 is converted to shifts
  // Commodore 64 PRG executable file
.file [name="multiply-2s.prg", type="prg", segments="Program"]
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
    // (SCREEN+0*40)[i] = i*1
    txa
    sta SCREEN,x
    // i*2
    txa
    asl
    // (SCREEN+1*40)[i] = i*2
    sta SCREEN+1*$28,x
    // i*4
    txa
    asl
    asl
    // (SCREEN+2*40)[i] = i*4
    sta SCREEN+2*$28,x
    // i*8
    txa
    asl
    asl
    asl
    // (SCREEN+3*40)[i] = i*8
    sta SCREEN+3*$28,x
    // sb = -(signed byte)i
    txa
    eor #$ff
    clc
    adc #1
    // sb*2
    asl
    // (SCREEN+5*40)[i] = (byte)(sb*2)
    sta SCREEN+5*$28,x
    // for(byte i: 0..10)
    inx
    cpx #$b
    bne __b1
    // }
    rts
}
