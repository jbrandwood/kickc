// Test elimination of noop-casts (signed byte to byte)
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .label screen = $400
    .label sw = 2
    lda #<$1234
    sta.z sw
    lda #>$1234
    sta.z sw+1
    ldx #0
  __b1:
    // sw += (signed byte)i
    txa
    pha
    clc
    adc.z sw
    sta.z sw
    pla
    ora #$7f
    bmi !+
    lda #0
  !:
    adc.z sw+1
    sta.z sw+1
    // screen[i] = sw
    txa
    asl
    tay
    lda.z sw
    sta screen,y
    lda.z sw+1
    sta screen+1,y
    // for( byte i: 0..10)
    inx
    cpx #$b
    bne __b1
    // }
    rts
}
