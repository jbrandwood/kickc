// Test access to __ma variable from inline ASM
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
main: {
    .label value = 2
    // value = 0
    lda #0
    sta.z value
    tax
  __b1:
    // for(char i=0;i<10;i++)
    cpx #$a
    bcc __b2
    // }
    rts
  __b2:
    // value += i
    txa
    clc
    adc.z value
    sta.z value
    // asm
    lda #$55
    eor value
    sta SCREEN
    // for(char i=0;i<10;i++)
    inx
    jmp __b1
}
