  // Commodore 64 PRG executable file
.file [name="summin.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .label screen = $400
.segment Code
main: {
    .label s1 = 2
    .label s3 = 3
    // sum(1,2)
    lda #2
    ldx #1
    jsr sum
    // sum(1,2)
    // byte s1=sum(1,2)
    sta.z s1
    // sum(3,4)
    lda #4
    ldx #3
    jsr sum
    // sum(3,4)
    // byte s2=sum(3,4)
    tay
    // sum(9,13)
    lda #$d
    ldx #9
    jsr sum
    // sum(9,13)
    // byte s3=sum(9,13)
    sta.z s3
    // s1+s2
    tya
    clc
    adc.z s1
    // byte s4=s1+s2+s3
    clc
    adc.z s3
    // *screen = s4
    sta screen
    // }
    rts
}
// sum(byte register(X) a, byte register(A) b)
sum: {
    // a+b
    stx.z $ff
    clc
    adc.z $ff
    // }
    rts
}
