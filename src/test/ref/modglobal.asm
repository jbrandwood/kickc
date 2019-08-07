.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
  .label cnt = 2
main: {
    ldx #0
    ldy #0
    txa
    jsr inccnt
    sta SCREEN
    lda.z cnt
    clc
    adc #1
    jsr inccnt
    sta SCREEN+1
    sty SCREEN+2
    stx SCREEN+3
    rts
}
inccnt: {
    clc
    adc #1
    sta.z cnt
    iny
    inx
    rts
}
