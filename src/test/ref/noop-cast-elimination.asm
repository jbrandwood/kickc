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
    txa
    sta.z $fe
    ora #$7f
    bmi !+
    lda #0
  !:
    sta.z $ff
    clc
    lda.z sw
    adc.z $fe
    sta.z sw
    lda.z sw+1
    adc.z $ff
    sta.z sw+1
    txa
    asl
    tay
    lda.z sw
    sta screen,y
    lda.z sw+1
    sta screen+1,y
    inx
    cpx #$b
    bne __b1
    rts
}
