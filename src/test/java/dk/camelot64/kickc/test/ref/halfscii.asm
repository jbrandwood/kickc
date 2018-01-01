.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .const SCREEN = $400
  .const CHARGEN = $d000
  .const PROCPORT = 1
  .const D018 = $d018
  .const CHARSET4 = $2800
  jsr main
main: {
    .label _1 = 8
    .label _11 = 8
    .label _21 = 8
    .label _30 = 8
    .label chargen1 = 6
    .label charset4 = 4
    .label chargen = 2
    sei
    lda #$32
    sta PROCPORT
    lda #<CHARSET4
    sta charset4
    lda #>CHARSET4
    sta charset4+1
    lda #<CHARGEN
    sta chargen
    lda #>CHARGEN
    sta chargen+1
  b1:
    lda chargen
    clc
    adc #1
    sta chargen1
    lda chargen+1
    adc #0
    sta chargen1+1
    ldy #0
    lda (chargen),y
    and #$60
    sta _1
    lda (chargen1),y
    and #$60
    lsr
    lsr
    ora _1
    lsr
    lsr
    lsr
    tax
    lda bits_count,x
    cmp #2
    bcc b7
    lda #0+1
    jmp b2
  b7:
    lda #0
  b2:
    asl
    tax
    ldy #0
    lda (chargen),y
    and #$18
    sta _11
    lda (chargen1),y
    and #$18
    lsr
    lsr
    ora _11
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
    ldy #0
    lda (chargen),y
    and #6
    asl
    sta _21
    lda (chargen1),y
    and #6
    lsr
    ora _21
    tay
    lda bits_count,y
    cmp #2
    bcc b4
    inx
  b4:
    txa
    asl
    tax
    ldy #0
    lda (chargen),y
    and #1
    asl
    asl
    sta _30
    lda (chargen1),y
    and #1
    ora _30
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
    inc charset4
    bne !+
    inc charset4+1
  !:
    lda chargen
    clc
    adc #2
    sta chargen
    bcc !+
    inc chargen+1
  !:
    lda chargen+1
    cmp #>CHARGEN+$800
    bcc b1
    bne !+
    lda chargen
    cmp #<CHARGEN+$800
    bcc b1
  !:
    lda #$37
    sta PROCPORT
    cli
    ldx #0
  b6:
    txa
    sta SCREEN,x
    inx
    cpx #0
    bne b6
    lda #$19
    sta D018
    rts
}
  bits_count: .byte 0, 1, 1, 2, 1, 2, 2, 3, 1, 2, 2, 3, 2, 3, 3, 4
