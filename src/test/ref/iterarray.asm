  // Commodore 64 PRG executable file
.file [name="iterarray.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
.segment Code
main: {
    .label buf = $1100
    ldx #5
  __b1:
    // 2+i+2
    txa
    clc
    adc #2+2
    // buf[i] = 2+i+2
    sta buf,x
    // i = i+1
    inx
    // while(i<10)
    cpx #$a
    bcc __b1
    // }
    rts
}
