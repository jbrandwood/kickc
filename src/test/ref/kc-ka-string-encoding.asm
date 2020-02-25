.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    // strTemp[2] = 'e'
  .encoding "petscii_mixed"
    lda #'e'
    sta strTemp+2
    // strTemp[3] = 0
    lda #0
    sta strTemp+3
    // asm
    tay
  loop:
    lda strTemp,y
    beq done
    jsr $ffd2
    iny
    jmp loop
  done:
    // }
    rts
}
  strTemp: .text "v=X"
  .byte 0
