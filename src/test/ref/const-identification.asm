.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label plots = $1000
  .label SCREEN = $400
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
line: {
    .const x0 = 0
    .const x1 = $a
    ldy #x0
  __b1:
    // for(byte x = x0; x<=x1; x++)
    cpy #x1+1
    bcc __b2
    // }
    rts
  __b2:
    // plot(x)
    jsr plot
    // for(byte x = x0; x<=x1; x++)
    iny
    jmp __b1
}
// plot(byte register(Y) x)
plot: {
    // idx = plots[x]
    ldx plots,y
    // SCREEN[idx]+1
    lda SCREEN,x
    clc
    adc #1
    // SCREEN[idx] = SCREEN[idx]+1
    sta SCREEN,x
    // }
    rts
}
