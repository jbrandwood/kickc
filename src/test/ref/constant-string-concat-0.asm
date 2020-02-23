// Concatenates string constants in different ways
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .label SCREEN = $400
    ldx #0
  __b1:
    // for( byte i=0;msg[i]!=0;i++)
    lda msg,x
    cmp #0
    bne __b2
    // }
    rts
  __b2:
    // SCREEN[i] = msg[i]
    lda msg,x
    sta SCREEN,x
    // for( byte i=0;msg[i]!=0;i++)
    inx
    jmp __b1
    msg: .text "camelot"
    .byte 0
}
