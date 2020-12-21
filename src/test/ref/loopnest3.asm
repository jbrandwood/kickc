  // Commodore 64 PRG executable file
.file [name="loopnest3.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .label SCREEN = $400
.segment Code
main: {
    lda #0
  __b1:
    // b(i)
    jsr b
    // for(byte i:0..100)
    clc
    adc #1
    cmp #$65
    bne __b1
    // }
    rts
}
// b(byte register(A) i)
b: {
    // c(i)
    jsr c
    // }
    rts
}
// c(byte register(A) i)
c: {
    ldx #0
  __b1:
    // SCREEN[j] = i
    sta SCREEN,x
    // for( byte j: 0..100)
    inx
    cpx #$65
    bne __b1
    // }
    rts
}
