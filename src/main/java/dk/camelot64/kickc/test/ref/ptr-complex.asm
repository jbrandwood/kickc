.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  jsr main
main: {
    .const screen = $400
    .const BGCOL = $d020
    .const sc2 = screen+$51
    .label _2 = 2
    .label _9 = 2
    .label _11 = 4
    ldx #0
  b1:
    txa
    clc
    adc #<screen+$28
    sta _2
    lda #0
    adc #>screen+$28
    sta _2+1
    ldy #0
    lda (_2),y
    sta screen,x
    inx
    cpx #$b
    bne b1
    lda screen+$79
    sta sc2
    lda screen+$7a
    sta screen+$52
    ldx #0
  b2:
    txa
    clc
    adc #<screen+$a0
    sta _9
    lda #0
    adc #>screen+$a0
    sta _9+1
    txa
    clc
    adc #<screen+$c8
    sta _11
    lda #0
    adc #>screen+$c8
    sta _11+1
    ldy #0
    lda (_11),y
    sta (_9),y
    inx
    cpx #$b
    bne b2
    inc $d020
    dec $d000+$21
    inc BGCOL
    rts
}
