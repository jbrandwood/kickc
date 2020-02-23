.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
main: {
    .label __0 = 6
    // ifunc(8)
    jsr ifunc
    // ifunc(8)
    // SCREEN[0] = ifunc(8)
    lda.z __0
    sta SCREEN
    lda.z __0+1
    sta SCREEN+1
    lda.z __0+2
    sta SCREEN+2
    lda.z __0+3
    sta SCREEN+3
    // }
    rts
}
ifunc: {
    .const a = 8
    .label x = 6
    .label xsqr = 2
    .label delta = $a
    .label return = 6
    lda #<3
    sta.z delta
    lda #>3
    sta.z delta+1
    lda #<3>>$10
    sta.z delta+2
    lda #>3>>$10
    sta.z delta+3
    lda #<1
    sta.z x
    lda #>1
    sta.z x+1
    lda #<1>>$10
    sta.z x+2
    lda #>1>>$10
    sta.z x+3
    lda #<1
    sta.z xsqr
    lda #>1
    sta.z xsqr+1
    lda #<1>>$10
    sta.z xsqr+2
    lda #>1>>$10
    sta.z xsqr+3
  __b1:
    // while(xsqr <=a)
    lda.z xsqr+3
    cmp #>a+1>>$10
    bcc __b2
    bne !+
    lda.z xsqr+2
    cmp #<a+1>>$10
    bcc __b2
    bne !+
    lda.z xsqr+1
    cmp #>a+1
    bcc __b2
    bne !+
    lda.z xsqr
    cmp #<a+1
    bcc __b2
  !:
    // return --x;
    lda.z return
    sec
    sbc #1
    sta.z return
    lda.z return+1
    sbc #0
    sta.z return+1
    lda.z return+2
    sbc #0
    sta.z return+2
    lda.z return+3
    sbc #0
    sta.z return+3
    // }
    rts
  __b2:
    // ++x;
    inc.z x
    bne !+
    inc.z x+1
    bne !+
    inc.z x+2
    bne !+
    inc.z x+3
  !:
    // xsqr += delta
    lda.z xsqr
    clc
    adc.z delta
    sta.z xsqr
    lda.z xsqr+1
    adc.z delta+1
    sta.z xsqr+1
    lda.z xsqr+2
    adc.z delta+2
    sta.z xsqr+2
    lda.z xsqr+3
    adc.z delta+3
    sta.z xsqr+3
    // delta += 2
    lda.z delta
    clc
    adc #2
    sta.z delta
    bcc !+
    inc.z delta+1
    bne !+
    inc.z delta+2
    bne !+
    inc.z delta+3
  !:
    jmp __b1
}
