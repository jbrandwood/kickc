// Tests the ternary operator - when the condition is constant
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .label SCREEN = $400
    ldy #0
  __b1:
    // cond(i)
    jsr cond
    // cond(i)?m1(i):m2(i)
    cmp #0
    bne __b2
    // m2(i)
    jsr m2
    // cond(i)?m1(i):m2(i)
  __b4:
    // SCREEN[i] = cond(i)?m1(i):m2(i)
    sta SCREEN,y
    // for( byte i: 0..9)
    iny
    cpy #$a
    bne __b1
    // }
    rts
  __b2:
    // m1(i)
    jsr m1
    // cond(i)?m1(i):m2(i)
    jmp __b4
}
// m1(byte register(Y) i)
m1: {
    // 5+i
    tya
    clc
    adc #5
    // }
    rts
}
// m2(byte register(Y) i)
m2: {
    // 10+i
    tya
    clc
    adc #$a
    // }
    rts
}
// cond(byte register(Y) b)
cond: {
    // b<5
    cpy #5
    lda #0
    rol
    eor #1
    // }
    rts
}
