// Tests calling into a function pointer with local variables
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .label cols = 2
    lda #<$d800
    sta.z cols
    lda #>$d800
    sta.z cols+1
  __b1:
    // for(byte* cols = $d800; cols<$d800+1000;cols++)
    lda.z cols+1
    cmp #>$d800+$3e8
    bcc __b2
    bne !+
    lda.z cols
    cmp #<$d800+$3e8
    bcc __b2
  !:
    // }
    rts
  __b2:
    // (*cls)()
    jsr fn1
    // (*cols)++;
    ldy #0
    lda (cols),y
    clc
    adc #1
    sta (cols),y
    // for(byte* cols = $d800; cols<$d800+1000;cols++)
    inc.z cols
    bne !+
    inc.z cols+1
  !:
    jmp __b1
}
fn1: {
    .label screen = 4
    lda #<$400
    sta.z screen
    lda #>$400
    sta.z screen+1
  __b1:
    // for(byte* screen=$400;screen<$400+1000;screen++)
    lda.z screen+1
    cmp #>$400+$3e8
    bcc __b2
    bne !+
    lda.z screen
    cmp #<$400+$3e8
    bcc __b2
  !:
    // }
    rts
  __b2:
    // (*screen)++;
    ldy #0
    lda (screen),y
    clc
    adc #1
    sta (screen),y
    // for(byte* screen=$400;screen<$400+1000;screen++)
    inc.z screen
    bne !+
    inc.z screen+1
  !:
    jmp __b1
}
