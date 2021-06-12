// Tests rolling sprite MSB by variable amount
  // Commodore 64 PRG executable file
.file [name="roll-sprite-msb.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .label SPRITES_XPOS = $d000
  .label SPRITES_YPOS = $d001
  .label SPRITES_XMSB = $d010
.segment Code
main: {
    .label xpos = 2
    lda #<$c8
    sta.z xpos
    lda #>$c8
    sta.z xpos+1
    ldx #0
  __b1:
    // position_sprite(s, xpos, 50)
    stx.z position_sprite.spriteno
    jsr position_sprite
    // xpos += 10
    lda #$a
    clc
    adc.z xpos
    sta.z xpos
    bcc !+
    inc.z xpos+1
  !:
    // for(byte s: 0..7)
    inx
    cpx #8
    bne __b1
    // }
    rts
}
// position_sprite(byte zp(4) spriteno, word zp(2) x)
position_sprite: {
    .const y = $32
    .label spriteno = 4
    .label x = 2
    // spriteno * 2
    lda.z spriteno
    asl
    tay
    // SPRITES_YPOS[spriteno * 2] = y
    lda #y
    sta SPRITES_YPOS,y
    // BYTE0(x)
    lda.z x
    // SPRITES_XPOS[spriteno * 2] = BYTE0(x)
    sta SPRITES_XPOS,y
    // if (x > 255)
    lda.z x+1
    bne __b1
    lda #$ff
    cmp.z x
    bcc __b1
    // 1 << spriteno
    lda #1
    ldy.z spriteno
    cpy #0
    beq !e+
  !:
    asl
    dey
    bne !-
  !e:
    // (1 << spriteno) ^ $ff
    eor #$ff
    // *SPRITES_XMSB &= (1 << spriteno) ^ $ff
    and SPRITES_XMSB
    sta SPRITES_XMSB
    // }
    rts
  __b1:
    // 1 << spriteno
    lda #1
    ldy.z spriteno
    cpy #0
    beq !e+
  !:
    asl
    dey
    bne !-
  !e:
    // *SPRITES_XMSB |= 1 << spriteno
    ora SPRITES_XMSB
    sta SPRITES_XMSB
    rts
}
