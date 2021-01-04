  // Commodore 64 PRG executable file
.file [name="loopmin.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
.segment Code
main: {
    lda #0
    ldx #$a
  __b1:
    // if(i>5)
    cpx #5+1
    bcc __b2
    // s=s+i
    stx.z $ff
    clc
    adc.z $ff
  __b2:
    // i--;
    dex
    // while (i>0)
    cpx #0
    bne __b1
    // }
    rts
}
