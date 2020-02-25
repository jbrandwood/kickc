// Tests that immediate zero values are reused - even when assigning to words
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .label w = 2
    ldx #0
    txa
    sta.z w
    sta.z w+1
  __b1:
    // w = w + j
    txa
    clc
    adc.z w
    sta.z w
    bcc !+
    inc.z w+1
  !:
    // for ( byte j : 0..10)
    inx
    cpx #$b
    bne __b1
    // }
    rts
}
