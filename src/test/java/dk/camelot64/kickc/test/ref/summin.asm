.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .const screen = $400
  jsr main
main: {
    .label s1 = 2
    .label s3 = 3
    lda #2
    ldx #1
    jsr sum
    sta s1
    lda #4
    ldx #3
    jsr sum
    tay
    lda #$d
    ldx #9
    jsr sum
    sta s3
    tya
    clc
    adc s1
    clc
    adc s3
    sta screen
    rts
}
sum: {
    stx $ff
    clc
    adc $ff
    rts
}
