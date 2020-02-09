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
    sei
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
    lda.z chargen
    clc
    adc #1
    sta.z chargen1
    lda.z chargen+1
    adc #0
    sta.z chargen1+1
    lda #$60
    ldy #0
    and (chargen),y
    sta.z __1
    lda #$60
    and (chargen1),y
    lsr
    lsr
    ora.z __1
    lsr
    lsr
    lsr
    tay
    lda bits_count,y
    cmp #2
    bcc b1
    lda #1
    jmp __b2
  b1:
    lda #0
  __b2:
    asl
    tax
    lda #$18
    ldy #0
    and (chargen),y
    sta.z __11
    lda #$18
    and (chargen1),y
    lsr
    lsr
    ora.z __11
    lsr
    tay
    lda bits_count,y
    cmp #2
    bcc __b3
    inx
  __b3:
    txa
    asl
    tax
    lda #6
    ldy #0
    and (chargen),y
    asl
    sta.z __21
    lda #6
    and (chargen1),y
    lsr
    ora.z __21
    tay
    lda bits_count,y
    cmp #2
    bcc __b4
    inx
  __b4:
    txa
    asl
    tax
    lda #1
    ldy #0
    and (chargen),y
    asl
    asl
    sta.z __30
    lda #1
    and (chargen1),y
    ora.z __30
    tay
    lda bits_count,y
    cmp #2
    bcc __b5
    inx
  __b5:
    txa
    asl
    ldy #0
    sta (charset4),y
    inc.z charset4
    bne !+
    inc.z charset4+1
  !:
    lda #2
    clc
    adc.z chargen
    sta.z chargen
    bcc !+
    inc.z chargen+1
  !:
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
    lda #$37
    sta PROCPORT
    cli
    ldx #0
  __b11:
    txa
    sta SCREEN,x
    inx
    cpx #0
    bne __b11
    lda #$19
    sta D018
    rts
}
  bits_count: .byte 0, 1, 1, 2, 1, 2, 2, 3, 1, 2, 2, 3, 2, 3, 3, 4
