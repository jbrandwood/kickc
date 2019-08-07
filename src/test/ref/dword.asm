.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .const a = $ee6b2800
    .label SCREEN = $400
    .label b = 2
    ldx #0
  b1:
    txa
    clc
    adc #<a
    sta.z b
    lda #>a
    adc #0
    sta.z b+1
    lda #<a>>$10
    adc #0
    sta.z b+2
    lda #>a>>$10
    adc #0
    sta.z b+3
    lda.z b
    sta SCREEN,x
    inx
    cpx #$65
    bne b1
    rts
}
