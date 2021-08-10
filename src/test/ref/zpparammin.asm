  // Commodore 64 PRG executable file
.file [name="zpparammin.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .label SCREEN = $400
  .label SCREEN2 = $400+$28
.segment Code
main: {
    .label i = 2
    lda #0
    sta.z i
  __b1:
    // sum(i,i+1,i+2)
    lda.z i
    clc
    adc #1
    ldx.z i
    inx
    inx
    ldy.z i
    jsr sum
    // SCREEN[i] = sum(i,i+1,i+2)
    ldy.z i
    sta SCREEN,y
    // sum2(i,i+1,i+2)
    tya
    clc
    adc #1
    ldx.z i
    inx
    inx
    jsr sum2
    // SCREEN2[i] = sum2(i,i+1,i+2)
    ldy.z i
    sta SCREEN2,y
    // for(byte i : 0..10)
    inc.z i
    lda #$b
    cmp.z i
    bne __b1
    // }
    rts
}
// __register(A) char sum(__register(Y) char a, __register(A) char b, __register(X) char c)
sum: {
    // a+b
    sty.z $ff
    clc
    adc.z $ff
    // a+b+c
    stx.z $ff
    clc
    adc.z $ff
    // }
    rts
}
// __register(A) char sum2(__register(Y) char a, __register(A) char b, __register(X) char c)
sum2: {
    // a+b
    sty.z $ff
    clc
    adc.z $ff
    // a+b+c
    stx.z $ff
    clc
    adc.z $ff
    // }
    rts
}
