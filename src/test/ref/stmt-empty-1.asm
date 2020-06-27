// Test an empty statement ';'
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
main: {
    ldx #0
  __b1:
    // for (; str[b] != 0; ++b)
    lda str,x
    cmp #0
    bne __b2
    // '0'+b
    txa
    axs #-['0']
    // SCREEN[0] = '0'+b
    // Empty body
    stx SCREEN
    // }
    rts
  __b2:
    // for (; str[b] != 0; ++b)
    inx
    jmp __b1
}
  str: .text "Hello!"
  .byte 0
