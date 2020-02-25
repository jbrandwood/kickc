// Two levels of functions to test that register allocation handles live ranges and call-ranges optimally to allocate the fewest possible ZP-variables
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
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
// line(byte register(X) l)
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
// plot(byte register(X) x)
plot: {
    // SCREEN[x] = '*'
    lda #'*'
    sta SCREEN,x
    // }
    rts
}
