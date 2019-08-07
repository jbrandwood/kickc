.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
  .encoding "petscii_mixed"
    lda #$45
    sta strTemp+2
    lda #0
    sta strTemp+3
    tay
  loop:
    lda strTemp,y
    beq done
    jsr $ffd2
    iny
    jmp loop
  done:
    rts
}
  strTemp: .text "v=X"
  .byte 0
