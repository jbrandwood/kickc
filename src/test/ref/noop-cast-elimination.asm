// Test elimination of noop-casts (signed byte to byte)
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .label screen = $400
    .label sw = 2
    lda #<$1234
    sta sw
    lda #>$1234
    sta sw+1
    ldx #0
  b1:
    txa
    sta $fe
    ora #$7f
    bmi !+
    lda #0
  !:
    sta $ff
    clc
    lda sw
    adc $fe
    sta sw
    lda sw+1
    adc $ff
    sta sw+1
    txa
    asl
    tay
    lda sw
    sta screen,y
    lda sw+1
    sta screen+1,y
    inx
    cpx #$b
    bne b1
    rts
}
