// Illustrates a problem with pointer sizeof()-rewriting for pointers inside structs
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .const SIZEOF_WORD = 2
main: {
    .label SCREEN = $400
    lda RADIX_DECIMAL_VALUES+1*SIZEOF_WORD
    sta SCREEN
    lda RADIX_DECIMAL_VALUES+1*SIZEOF_WORD+1
    sta SCREEN+1
    lda RADIX_DECIMAL_VALUES+1*SIZEOF_WORD
    sta SCREEN+1*SIZEOF_WORD
    lda RADIX_DECIMAL_VALUES+1*SIZEOF_WORD+1
    sta SCREEN+1*SIZEOF_WORD+1
    rts
}
  RADIX_DECIMAL_VALUES: .word $2710, $3e8, $64, $a
