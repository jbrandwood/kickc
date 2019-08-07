.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
  .label CHARGEN = $d000
  .label PROCPORT = 1
  .label D018 = $d018
  .label CHARSET4 = $2800
main: {
    .label _1 = 8
    .label _11 = 9
    .label _21 = $a
    .label _30 = $b
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
  b1:
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
    sta.z _1
    lda #$60
    and (chargen1),y
    lsr
    lsr
    ora.z _1
    lsr
    lsr
    lsr
    tay
    lda bits_count,y
    cmp #2
    bcc b6
    lda #1
    jmp b2
  b6:
    lda #0
  b2:
    asl
    tax
    lda #$18
    ldy #0
    and (chargen),y
    sta.z _11
    lda #$18
    and (chargen1),y
    lsr
    lsr
    ora.z _11
    lsr
    tay
    lda bits_count,y
    cmp #2
    bcc b3
    inx
  b3:
    txa
    asl
    tax
    lda #6
    ldy #0
    and (chargen),y
    asl
    sta.z _21
    lda #6
    and (chargen1),y
    lsr
    ora.z _21
    tay
    lda bits_count,y
    cmp #2
    bcc b4
    inx
  b4:
    txa
    asl
    tax
    lda #1
    ldy #0
    and (chargen),y
    asl
    asl
    sta.z _30
    lda #1
    and (chargen1),y
    ora.z _30
    tay
    lda bits_count,y
    cmp #2
    bcc b5
    inx
  b5:
    txa
    asl
    ldy #0
    sta (charset4),y
    inc.z charset4
    bne !+
    inc.z charset4+1
  !:
    lda.z chargen
    clc
    adc #2
    sta.z chargen
    bcc !+
    inc.z chargen+1
  !:
    lda.z chargen+1
    cmp #>CHARGEN+$800
    bcs !b1+
    jmp b1
  !b1:
    bne !+
    lda.z chargen
    cmp #<CHARGEN+$800
    bcs !b1+
    jmp b1
  !b1:
  !:
    lda #$37
    sta PROCPORT
    cli
    ldx #0
  b11:
    txa
    sta SCREEN,x
    inx
    cpx #0
    bne b11
    lda #$19
    sta D018
    rts
}
  bits_count: .byte 0, 1, 1, 2, 1, 2, 2, 3, 1, 2, 2, 3, 2, 3, 3, 4
