// Fill screen using an efficient char-based index
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
main: {
    ldx #0
  __b1:
    // for(char i=0;i<250;i++)
    cpx #$fa
    bcc __b2
    // }
    rts
  __b2:
    // SCREEN[i] = ' '
    lda #' '
    sta SCREEN,x
    // (SCREEN+250)[i] = ' '
    sta SCREEN+$fa,x
    // (SCREEN+500)[i] = ' '
    sta SCREEN+$1f4,x
    // (SCREEN+750)[i] = ' '
    sta SCREEN+$2ee,x
    // for(char i=0;i<250;i++)
    inx
    jmp __b1
}
