// Test __varcall calling convention
// Return value
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label BGCOL = $d021
// plus(byte zp(3) a, byte zp(4) b)
plus: {
    .label return = 2
    .label a = 3
    .label b = 4
    // a+b
    lda.z a
    clc
    adc.z b
    // return a+b;
    sta.z return
    // }
    rts
}
main: {
    // *BGCOL = a
    lda #1
    sta BGCOL
    // plus(a, 1)
    sta.z plus.a
    sta.z plus.b
    jsr plus
    // a = plus(a, 1)
    lda.z plus.return
    // *BGCOL = a
    sta BGCOL
    // plus(a, 1)
    sta.z plus.a
    lda #1
    sta.z plus.b
    jsr plus
    // a = plus(a, 1)
    lda.z plus.return
    // *BGCOL = a
    sta BGCOL
    // }
    rts
}
