// Test unary plus
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .const SIZEOF_SIGNED_WORD = 2
main: {
    .const i = 3
    .const j = 3
    .label SCREEN = $400
    .label SCREEN2 = $428
    // SCREEN[0] = i
    lda #i
    sta SCREEN
    // SCREEN[1] = +3
    lda #3
    sta SCREEN+1
    // SCREEN2[0] = j
    lda #<j
    sta SCREEN2
    lda #>j
    sta SCREEN2+1
    // SCREEN2[1] = +3
    lda #<3
    sta SCREEN2+1*SIZEOF_SIGNED_WORD
    lda #>3
    sta SCREEN2+1*SIZEOF_SIGNED_WORD+1
    // }
    rts
}
