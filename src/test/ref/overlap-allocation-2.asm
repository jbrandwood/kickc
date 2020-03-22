// Two levels of functions to test that register allocation handles live ranges and call-ranges optimally to allocate the fewest possible ZP-variables
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
main: {
    .label i = 2
    .label j = 3
    lda #0
    sta.z i
  __b1:
    // line(i)
    ldy.z i
    jsr line
    // for(byte i : 0..8)
    inc.z i
    lda #9
    cmp.z i
    bne __b1
    lda #$a
    sta.z j
  __b2:
    // line(j)
    ldy.z j
    jsr line
    // for(byte j : 10..18)
    inc.z j
    lda #$13
    cmp.z j
    bne __b2
    // }
    rts
}
// line(byte register(Y) l)
line: {
    // plot(l)
    tya
    tax
    jsr plot
    // plot(l+20)
    tya
    tax
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
