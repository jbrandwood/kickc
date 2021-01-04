// Type inference into the ternary operator
  // Commodore 64 PRG executable file
.file [name="ternary-inference.prg", type="prg", segments="Program"]
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
  __b1:
    // i<5?0x57:'0'
    cpx #5
    bcc __b2
    lda #'0'
    jmp __b3
  __b2:
    // i<5?0x57:'0'
    lda #$57
  __b3:
    // (i<5?0x57:'0')+i
    stx.z $ff
    clc
    adc.z $ff
    // screen[i] = (i<5?0x57:'0')+i
    sta screen,x
    // for(byte i: 0..10)
    inx
    cpx #$b
    bne __b1
    // }
    rts
}
