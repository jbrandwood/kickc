// https://gitlab.com/camelot/kickc/issues/336
// ASM Static Register Value analysis erronously believes >-1 == 0
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .label screen = $400
    .label lasti = 4
    .label i = 2
    .label __2 = 6
    lda #<-1
    sta.z lasti
    sta.z lasti+1
    lda #<0
    sta.z i
    sta.z i+1
  __b1:
    // for(int i=0;i<10;i++)
    lda.z i+1
    bmi __b2
    cmp #>$a
    bcc __b2
    bne !+
    lda.z i
    cmp #<$a
    bcc __b2
  !:
    // }
    rts
  __b2:
    // <lasti
    ldx.z lasti
    // screen[i] = <lasti
    lda #<screen
    clc
    adc.z i
    sta.z __2
    lda #>screen
    adc.z i+1
    sta.z __2+1
    txa
    ldy #0
    sta (__2),y
    // lasti = i
    lda.z i
    sta.z lasti
    lda.z i+1
    sta.z lasti+1
    // for(int i=0;i<10;i++)
    inc.z i
    bne !+
    inc.z i+1
  !:
    jmp __b1
}
