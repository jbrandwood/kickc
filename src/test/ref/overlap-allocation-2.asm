// Two levels of functions to test that register allocation handles live ranges and call-ranges optimally to allocate the fewest possible ZP-variables
  // Commodore 64 PRG executable file
.file [name="overlap-allocation-2.prg", type="prg", segments="Program"]
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
  __b1:
    // line(i)
    tya
    tax
    jsr line
    // for(byte i : 0..8)
    iny
    cpy #9
    bne __b1
    ldy #$a
  __b2:
    // line(j)
    tya
    tax
    jsr line
    // for(byte j : 10..18)
    iny
    cpy #$13
    bne __b2
    // }
    rts
}
// void line(__register(X) char l)
line: {
    // plot(l)
    jsr plot
    // plot(l+20)
    txa
    axs #-[$14]
    jsr plot
    // }
    rts
}
// void plot(__register(X) char x)
plot: {
    // SCREEN[x] = '*'
    lda #'*'
    sta SCREEN,x
    // }
    rts
}
