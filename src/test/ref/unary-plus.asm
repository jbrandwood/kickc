// Test unary plus
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .const SIZEOF_SIGNED_WORD = 2
main: {
    .label SCREEN = $400
    .label SCREEN2 = $428
    .const i = 3
    .const j = 3
    lda #i
    sta SCREEN
    lda #3
    sta SCREEN+1
    lda #<j
    sta SCREEN2
    lda #>j
    sta SCREEN2+1
    lda #<3
    sta SCREEN2+1*SIZEOF_SIGNED_WORD
    lda #>3
    sta SCREEN2+1*SIZEOF_SIGNED_WORD+1
    rts
}
