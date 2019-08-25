// Test declaring a variable as register with no information about which register (for compatibility with standard C)
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
main: {
    ldx #0
  b1:
    cpx #$28*4
    bcc b2
    rts
  b2:
    txa
    and #7
    tay
    lda MSG,y
    sta SCREEN,x
    inx
    jmp b1
}
.encoding "screencode_upper"
  MSG: .text "CAMELOT!"
  .byte 0
