// Tests comma-separated declarations inside for()
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .label SCREEN = $400
    lda #'g'
    ldx #0
  __b1:
    // for(byte i, j='g'; i<10; i++, j++)
    cpx #$a
    bcc __b2
    // }
    rts
  __b2:
    // SCREEN[i] = j
    sta SCREEN,x
    // for(byte i, j='g'; i<10; i++, j++)
    inx
    clc
    adc #1
    jmp __b1
}
