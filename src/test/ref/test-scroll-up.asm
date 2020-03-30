// Tests different ways of scrolling up the screen
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label screen = $400
main: {
    // scrollup1()
    jsr scrollup1
    // scrollup2()
    jsr scrollup2
    // scrollup3()
    jsr scrollup3
    // }
    rts
}
scrollup3: {
    .label l2 = 3
    .label line = 9
    .label __3 = 5
    .label __4 = 7
    lda #<0
    sta.z line
    sta.z line+1
  __b1:
    // for (word line = 0; line < 40*24; line += 40)
    lda.z line+1
    cmp #>$28*$18
    bcc __b2
    bne !+
    lda.z line
    cmp #<$28*$18
    bcc __b2
  !:
    // }
    rts
  __b2:
    lda.z line
    sta.z l2
    lda.z line+1
    sta.z l2+1
    ldx #0
  __b3:
    // for (byte c=0; c<40; ++c)
    cpx #$28
    bcc __b4
    // line += 40
    lda #$28
    clc
    adc.z line
    sta.z line
    bcc !+
    inc.z line+1
  !:
    jmp __b1
  __b4:
    // screen[l2++] = screen[l2+40]
    lda.z l2
    clc
    adc #<screen+$28
    sta.z __3
    lda.z l2+1
    adc #>screen+$28
    sta.z __3+1
    lda.z l2
    clc
    adc #<screen
    sta.z __4
    lda.z l2+1
    adc #>screen
    sta.z __4+1
    ldy #0
    lda (__3),y
    sta (__4),y
    // screen[l2++] = screen[l2+40];
    inc.z l2
    bne !+
    inc.z l2+1
  !:
    // for (byte c=0; c<40; ++c)
    inx
    jmp __b3
}
scrollup2: {
    .label line1 = 3
    .label line2 = 9
    .label l = 2
    lda #0
    sta.z l
    lda #<screen
    sta.z line1
    lda #>screen
    sta.z line1+1
    lda #<screen+$28
    sta.z line2
    lda #>screen+$28
    sta.z line2+1
  __b1:
    ldx #0
  __b2:
    // *line1++ = *line2++
    ldy #0
    lda (line2),y
    sta (line1),y
    // *line1++ = *line2++;
    inc.z line1
    bne !+
    inc.z line1+1
  !:
    inc.z line2
    bne !+
    inc.z line2+1
  !:
    // for (byte c: 0..39)
    inx
    cpx #$28
    bne __b2
    // for( byte l: 0..23 )
    inc.z l
    lda #$18
    cmp.z l
    bne __b1
    // }
    rts
}
scrollup1: {
    .label __2 = 7
    .label __4 = 9
    .label line = 5
    .label __5 = 9
    .label __6 = 7
    lda #<0
    sta.z line
    sta.z line+1
  __b1:
    // for (word line = 0; line < 40*24; line += 40)
    lda.z line+1
    cmp #>$28*$18
    bcc __b4
    bne !+
    lda.z line
    cmp #<$28*$18
    bcc __b4
  !:
    // }
    rts
  __b4:
    ldx #0
  __b2:
    // for (byte c=0; c<40; ++c)
    cpx #$28
    bcc __b3
    // line += 40
    lda #$28
    clc
    adc.z line
    sta.z line
    bcc !+
    inc.z line+1
  !:
    jmp __b1
  __b3:
    // line+c
    txa
    clc
    adc.z line
    sta.z __2
    lda #0
    adc.z line+1
    sta.z __2+1
    // line+c+40
    txa
    clc
    adc.z line
    sta.z __4
    lda #0
    adc.z line+1
    sta.z __4+1
    // screen[line+c] = screen[line+c+40]
    clc
    lda.z __5
    adc #<screen+$28
    sta.z __5
    lda.z __5+1
    adc #>screen+$28
    sta.z __5+1
    clc
    lda.z __6
    adc #<screen
    sta.z __6
    lda.z __6+1
    adc #>screen
    sta.z __6+1
    ldy #0
    lda (__5),y
    sta (__6),y
    // for (byte c=0; c<40; ++c)
    inx
    jmp __b2
}
