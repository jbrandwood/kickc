  // Commodore 64 PRG executable file
.file [name="const-identification.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .label plots = $1000
  .label SCREEN = $400
.segment Code
main: {
    ldx #0
  __b1:
    // plots[i] = i
    txa
    sta plots,x
    // SCREEN[i] = 0
    lda #0
    sta SCREEN,x
    // for(byte i : 0..39)
    inx
    cpx #$28
    bne __b1
  __b2:
    // line(0, 10)
    jsr line
    jmp __b2
}
// void line(char x0, char x1)
line: {
    .const x0 = 0
    .const x1 = $a
    ldx #x0
  __b1:
    // for(byte x = x0; x<=x1; x++)
    cpx #x1+1
    bcc __b2
    // }
    rts
  __b2:
    // plot(x)
    jsr plot
    // for(byte x = x0; x<=x1; x++)
    inx
    jmp __b1
}
// void plot(__register(X) char x)
plot: {
    // byte idx = plots[x]
    ldy plots,x
    // SCREEN[idx]+1
    lda SCREEN,y
    clc
    adc #1
    // SCREEN[idx] = SCREEN[idx]+1
    sta SCREEN,y
    // }
    rts
}
