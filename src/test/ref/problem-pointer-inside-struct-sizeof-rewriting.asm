// Illustrates a problem with pointer sizeof()-rewriting for pointers inside structs
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .label SCREEN = $400
    .label digit_value = 3
    .label radix = 2
    lda #0
    sta radix
  b1:
    ldx #0
  b2:
    lda RADIX_DECIMAL_VALUES,x
    sta digit_value
    lda RADIX_DECIMAL_VALUES+1,x
    sta digit_value+1
    txa
    asl
    tay
    lda digit_value
    sta SCREEN,y
    lda digit_value+1
    sta SCREEN+1,y
    inx
    cpx #5
    bne b2
    inc radix
    lda #2
    cmp radix
    bne b1
    rts
}
  RADIX_DECIMAL_VALUES: .word $2710, $3e8, $64, $a
