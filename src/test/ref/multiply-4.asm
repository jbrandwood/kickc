// Test compile-time and run-time multiplication
// const*var multiplication - converted to shift/add
  // Commodore 64 PRG executable file
.file [name="multiply-4.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .label SCREEN = $400
.segment Code
main: {
    ldy #0
    ldx #0
  __b1:
    // for(char c1=0;c1<5;c1++)
    cpx #5
    bcc __b2
    // }
    rts
  __b2:
    // char c3 = 7*c1
    txa
    asl
    stx.z $ff
    clc
    adc.z $ff
    asl
    stx.z $ff
    clc
    adc.z $ff
    // SCREEN[i++] = c3
    sta SCREEN,y
    // SCREEN[i++] = c3;
    iny
    // for(char c1=0;c1<5;c1++)
    inx
    jmp __b1
}
