// Tests rolling sprite MSB by variable amount
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SPRITES_XPOS = $d000
  .label SPRITES_YPOS = $d001
  .label SPRITES_XMSB = $d010
main: {
    .label xpos = 2
    lda #$c8
    sta xpos
    lda #0
    sta xpos+1
    tax
  b1:
    stx position_sprite.spriteno
    jsr position_sprite
    lda #$a
    clc
    adc xpos
    sta xpos
    bcc !+
    inc xpos+1
  !:
    inx
    cpx #8
    bne b1
    rts
}
// position_sprite(byte zeropage(4) spriteno, word zeropage(2) x)
position_sprite: {
    .const y = $32
    .label spriteno = 4
    .label x = 2
    lda spriteno
    asl
    tay
    lda #y
    sta SPRITES_YPOS,y
    lda spriteno
    asl
    tay
    lda x
    sta SPRITES_XPOS,y
    lda x+1
    bne b1
    lda x
    cmp #$ff
    beq !+
    bcs b1
  !:
    lda #1
    ldy spriteno
    cpy #0
    beq !e+
  !:
    asl
    dey
    bne !-
  !e:
    eor #$ff
    and SPRITES_XMSB
    sta SPRITES_XMSB
  breturn:
    rts
  b1:
    lda #1
    ldy spriteno
    cpy #0
    beq !e+
  !:
    asl
    dey
    bne !-
  !e:
    ora SPRITES_XMSB
    sta SPRITES_XMSB
    jmp breturn
}
