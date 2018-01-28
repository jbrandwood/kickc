.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  jsr main
main: {
    .const a = $ee6b2800
    .const SCREEN = $400
    .label b = 2
    ldx #0
  b1:
    txa
    clc
    adc #<a
    sta b
    lda #>a
    adc #0
    sta b+1
    lda #<a>>$10
    adc #0
    sta b+2
    lda #>a>>$10
    adc #0
    sta b+3
    lda b
    sta SCREEN,x
    inx
    cpx #$65
    bne b1
    rts
}
