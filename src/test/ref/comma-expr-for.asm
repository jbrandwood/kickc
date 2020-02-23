// Tests comma-expressions in for()-statement
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .label SCREEN = $400
    lda #'g'
    ldx #0
  __b1:
    // for( byte i=0; j<10, i<10; i++, j++)
    cpx #$a
    bcc __b2
    // }
    rts
  __b2:
    // SCREEN[i] = j
    sta SCREEN,x
    // for( byte i=0; j<10, i<10; i++, j++)
    inx
    clc
    adc #1
    jmp __b1
}
