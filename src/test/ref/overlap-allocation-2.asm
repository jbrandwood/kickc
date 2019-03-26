// Two levels of functions to test that register allocation handles live ranges and call-ranges optimally to allocate the fewest possible ZP-variables
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
main: {
    ldy #0
  b1:
    tya
    tax
    jsr line
    iny
    cpy #9
    bne b1
    ldy #$a
  b2:
    tya
    tax
    jsr line
    iny
    cpy #$13
    bne b2
    rts
}
// line(byte register(X) l)
line: {
    jsr plot
    txa
    axs #-$14
    jsr plot
    rts
}
// plot(byte register(X) x)
plot: {
    lda #'*'
    sta SCREEN,x
    rts
}
