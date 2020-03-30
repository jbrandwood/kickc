.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
  .label CHARGEN = $d000
  .label PROCPORT = 1
  .label D018 = $d018
  .label CHARSET4 = $2800
main: {
    .label __1 = 8
    .label __11 = 9
    .label __21 = $a
    .label __30 = $b
    .label chargen1 = 6
    .label charset4 = 4
    .label chargen = 2
    // asm
    sei
    // *PROCPORT = $32
    lda #$32
    sta PROCPORT
    lda #<CHARSET4
    sta.z charset4
    lda #>CHARSET4
    sta.z charset4+1
    lda #<CHARGEN
    sta.z chargen
    lda #>CHARGEN
    sta.z chargen+1
  __b1:
    // chargen1 = chargen+1
    lda.z chargen
    clc
    adc #1
    sta.z chargen1
    lda.z chargen+1
    adc #0
    sta.z chargen1+1
    // *chargen & %01100000
    lda #$60
    ldy #0
    and (chargen),y
    sta.z __1
    // *chargen1 & %01100000
    lda #$60
    and (chargen1),y
    // (*chargen1 & %01100000)/4
    lsr
    lsr
    // (*chargen & %01100000) | (*chargen1 & %01100000)/4
    ora.z __1
    // ((*chargen & %01100000) | (*chargen1 & %01100000)/4)/2
    lsr
    // ((*chargen & %01100000) | (*chargen1 & %01100000)/4)/2/4
    lsr
    lsr
    // bits = bits_count[((*chargen & %01100000) | (*chargen1 & %01100000)/4)/2/4]
    tay
    lda bits_count,y
    // if(bits>=2)
    cmp #2
    bcc __b6
    lda #1
    jmp __b2
  __b6:
    lda #0
  __b2:
    // bits_gen = bits_gen*2
    asl
    tax
    // *chargen & %00011000
    lda #$18
    ldy #0
    and (chargen),y
    sta.z __11
    // *chargen1 & %00011000
    lda #$18
    and (chargen1),y
    // (*chargen1 & %00011000)/4
    lsr
    lsr
    // (*chargen & %00011000) | (*chargen1 & %00011000)/4
    ora.z __11
    // ((*chargen & %00011000) | (*chargen1 & %00011000)/4)/2
    lsr
    // bits = bits_count[((*chargen & %00011000) | (*chargen1 & %00011000)/4)/2]
    tay
    lda bits_count,y
    // if(bits>=2)
    cmp #2
    bcc __b3
    // bits_gen = bits_gen + 1
    inx
  __b3:
    // bits_gen = bits_gen*2
    txa
    asl
    tax
    // *chargen & %00000110
    lda #6
    ldy #0
    and (chargen),y
    // (*chargen & %00000110)*2
    asl
    sta.z __21
    // *chargen1 & %00000110
    lda #6
    and (chargen1),y
    // (*chargen1 & %00000110)/2
    lsr
    // (*chargen & %00000110)*2 | (*chargen1 & %00000110)/2
    ora.z __21
    // bits = bits_count[((*chargen & %00000110)*2 | (*chargen1 & %00000110)/2)]
    tay
    lda bits_count,y
    // if(bits>=2)
    cmp #2
    bcc __b4
    // bits_gen = bits_gen + 1
    inx
  __b4:
    // bits_gen = bits_gen*2
    txa
    asl
    tax
    // *chargen & %00000001
    lda #1
    ldy #0
    and (chargen),y
    // (*chargen & %00000001)*4
    asl
    asl
    sta.z __30
    // *chargen1 & %00000001
    lda #1
    and (chargen1),y
    // (*chargen & %00000001)*4 | (*chargen1 & %00000001)
    ora.z __30
    // bits = bits_count[((*chargen & %00000001)*4 | (*chargen1 & %00000001))]
    tay
    lda bits_count,y
    // if(bits>=2)
    cmp #2
    bcc __b5
    // bits_gen = bits_gen + 1
    inx
  __b5:
    // bits_gen = bits_gen*2
    txa
    asl
    // *charset4 = bits_gen
    ldy #0
    sta (charset4),y
    // charset4++;
    inc.z charset4
    bne !+
    inc.z charset4+1
  !:
    // chargen = chargen+2
    lda #2
    clc
    adc.z chargen
    sta.z chargen
    bcc !+
    inc.z chargen+1
  !:
    // while (chargen<CHARGEN+$800)
    lda.z chargen+1
    cmp #>CHARGEN+$800
    bcs !__b1+
    jmp __b1
  !__b1:
    bne !+
    lda.z chargen
    cmp #<CHARGEN+$800
    bcs !__b1+
    jmp __b1
  !__b1:
  !:
    // *PROCPORT = $37
    lda #$37
    sta PROCPORT
    // asm
    cli
    ldx #0
  __b11:
    // SCREEN[i] = i
    txa
    sta SCREEN,x
    // for(byte i : 0..255)
    inx
    cpx #0
    bne __b11
    // *D018 = $19
    lda #$19
    sta D018
    // }
    rts
}
  bits_count: .byte 0, 1, 1, 2, 1, 2, 2, 3, 1, 2, 2, 3, 2, 3, 3, 4
