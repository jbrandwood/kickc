// Test that memory model "mem" affects intermediates
  // Commodore 64 PRG executable file
.file [name="varmodel-mem-1.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
.segment Code
main: {
    // A local pointer 
    .label SCREEN = $400
    ldx #0
  // A local counter
  __b1:
    // sum(i,i)
    txa
    jsr sum
    // sum(i,i)
    sta __1
    txa
    jsr sum
    // sum(i,i)
    // sum(i,i)+sum(i,i)
    clc
    adc __1
    // *(SCREEN+i) = sum(i,i)+sum(i,i)
    // Generates an intermediate
    sta SCREEN,x
    // for( char i: 0..5 )
    inx
    cpx #6
    bne __b1
    // }
    rts
  .segment Data
    __1: .byte 0
}
.segment Code
// __register(A) char sum(__register(A) char a, __register(X) char b)
sum: {
    // a+b
    stx.z $ff
    clc
    adc.z $ff
    // }
    rts
}
