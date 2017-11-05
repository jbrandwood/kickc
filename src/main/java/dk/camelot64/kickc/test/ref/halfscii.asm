.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .const SCREEN = $400
  .const CHARSET = $2000
  .const CHARGEN = $d000
  .const PROCPORT = 1
  .const D018 = $d018
  .const CHARSET4 = $2800
  bits_count: .byte 0, 1, 1, 2, 1, 2, 2, 3, 1, 2, 2, 3, 2, 3, 3, 4
  jsr main
main: {
    .label _2 = 6
    .label _15 = 9
    .label _28 = 9
    .label _40 = 9
    .label chargen1 = 7
    .label bits_gen = 6
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
    sta _2
    lda (chargen1),y
    and #$60
    lsr
    lsr
    ora _2
    lsr
    lsr
    lsr
    tax
    lda bits_count,x
    cmp #2
    bcc b2_from_b1
    lda #0+1
    jmp b2
  b2_from_b1:
    lda #0
  b2:
    asl
    sta bits_gen
    ldy #0
    lda (chargen),y
    and #$18
    sta _15
    lda (chargen1),y
    and #$18
    lsr
    lsr
    ora _15
    lsr
    tax
    lda bits_count,x
    cmp #2
    bcc b3
    inc bits_gen
  b3:
    asl bits_gen
    ldy #0
    lda (chargen),y
    and #6
    asl
    sta _28
    lda (chargen1),y
    and #6
    lsr
    ora _28
    tax
    lda bits_count,x
    cmp #2
    bcc b4
    inc bits_gen
  b4:
    asl bits_gen
    ldy #0
    lda (chargen),y
    and #1
    asl
    asl
    sta _40
    lda (chargen1),y
    and #1
    ora _40
    tax
    lda bits_count,x
    cmp #2
    bcc b5
    inc bits_gen
  b5:
    lda bits_gen
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
