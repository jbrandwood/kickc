/* Textbox routine with word wrap for KickC by Scan/Desire */
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label screen = $400
main: {
    .label wait = 6
    .label x = 2
    lda #0
    sta x
  b1:
    lda x
    asl
    clc
    adc #1
    sta textbox.x2
    lax x
    axs #-[$a]
    stx textbox.y2
    lda x
    sta textbox.y1
    lda #<text2
    sta textbox.text
    lda #>text2
    sta textbox.text+1
    jsr textbox
    lda #<0
    sta wait
    sta wait+1
  b2:
    inc wait
    bne !+
    inc wait+1
  !:
    lda wait+1
    cmp #>$88b8
    bcc b2
    bne !+
    lda wait
    cmp #<$88b8
    bcc b2
  !:
    lda x
    clc
    adc #2
    sta x
    cmp #$f
    bcc b1
    lda #<text
    sta textbox.text
    lda #>text
    sta textbox.text+1
    lda #$18
    sta textbox.y2
    lda #$14
    sta textbox.x2
    lda #$c
    sta textbox.y1
    lda #0
    sta textbox.x1
    jsr textbox
    lda #<text
    sta textbox.text
    lda #>text
    sta textbox.text+1
    lda #9
    sta textbox.y2
    lda #$25
    sta textbox.x2
    lda #3
    sta textbox.y1
    sta textbox.x1
    jsr textbox
    lda #<text
    sta textbox.text
    lda #>text
    sta textbox.text+1
    lda #$18
    sta textbox.y2
    lda #$27
    sta textbox.x2
    lda #8
    sta textbox.y1
    lda #$1e
    sta textbox.x1
    jsr textbox
  b5:
    jmp b5
}
// textbox(byte zeropage(2) x1, byte zeropage(3) y1, byte zeropage(4) x2, byte zeropage(5) y2, byte* zeropage(6) text)
textbox: {
    .label _8 = $d
    .label _17 = $a
    .label x1 = 2
    .label y1 = 3
    .label x2 = 4
    .label y2 = 5
    .label y = 3
    .label x = 8
    .label z = $b
    .label i = 9
    .label text = 6
    .label _31 = $d
    jsr draw_window
    inc y
    ldy x1
    iny
    sty x
    lda y
    asl
    asl
    clc
    adc y
    sta z
    lda #0
    sta z+1
    asl z
    rol z+1
    asl z
    rol z+1
    asl z
    rol z+1
    tya
    cmp x2
    beq breturn
    lda y
    cmp y2
    beq breturn
    lda #0
    sta i
  b1:
    lda x
    clc
    adc z
    sta _8
    lda #0
    adc z+1
    sta _8+1
    clc
    lda _31
    adc #<screen
    sta _31
    lda _31+1
    adc #>screen
    sta _31+1
    ldy i
    lda (text),y
    ldy #0
    sta (_31),y
    ldy i
    lda (text),y
    cmp #$20
    bne b2
    iny
    ldx #0
  b3:
    lda (text),y
    cmp #$20
    beq b5
    lda (text),y
    cmp #0
    bne b4
  b5:
    txa
    clc
    adc x
    tay
    lda x2
    sec
    sbc x1
    sta _17
    cpy x2
    bcc b2
    cpx _17
    bcc b6
  b2:
    inc i
    inc x
    lda x
    cmp x2
    bne b8
    ldy x1
    iny
    sty x
    inc y
    lda y
    cmp y2
    bne b9
  breturn:
    rts
  b9:
    lda y
    asl
    asl
    clc
    adc y
    sta z
    lda #0
    sta z+1
    asl z
    rol z+1
    asl z
    rol z+1
    asl z
    rol z+1
  b8:
    ldy i
    lda (text),y
    cmp #0
    beq !b1+
    jmp b1
  !b1:
    rts
  b6:
    inc y
    lda y
    cmp y2
    bne b7
    rts
  b7:
    lda y
    asl
    asl
    clc
    adc y
    sta z
    lda #0
    sta z+1
    asl z
    rol z+1
    asl z
    rol z+1
    asl z
    rol z+1
    lda x1
    sta x
    jmp b2
  b4:
    iny
    inx
    jmp b3
}
// draw_window(byte zeropage(2) x1, byte zeropage(3) y1, byte zeropage(4) x2, byte zeropage(5) y2)
draw_window: {
    .label _2 = $13
    .label _3 = $b
    .label _4 = $19
    .label _5 = $d
    .label _13 = $f
    .label _14 = $11
    .label _18 = $17
    .label _19 = $15
    .label _24 = $1d
    .label x1 = 2
    .label y1 = 3
    .label x2 = 4
    .label y2 = 5
    .label z = $b
    .label q = $d
    .label z_1 = $15
    .label y3 = 9
    .label z_2 = $1b
    .label _27 = $f
    .label _28 = $11
    .label _29 = $13
    .label _30 = $b
    .label _31 = $17
    .label _32 = $15
    .label _33 = $19
    .label _34 = $d
    .label _35 = $1d
    lda y1
    asl
    asl
    clc
    adc y1
    sta z
    lda #0
    sta z+1
    asl z
    rol z+1
    asl z
    rol z+1
    asl z
    rol z+1
    lda y2
    asl
    asl
    clc
    adc y2
    sta q
    lda #0
    sta q+1
    asl q
    rol q+1
    asl q
    rol q+1
    asl q
    rol q+1
    ldx x1
    inx
  b1:
  // draw horizontal lines
    txa
    clc
    adc z
    sta _13
    lda #0
    adc z+1
    sta _13+1
    clc
    lda _27
    adc #<screen
    sta _27
    lda _27+1
    adc #>screen
    sta _27+1
    lda #$43
    ldy #0
    sta (_27),y
    txa
    clc
    adc q
    sta _14
    tya
    adc q+1
    sta _14+1
    clc
    lda _28
    adc #<screen
    sta _28
    lda _28+1
    adc #>screen
    sta _28+1
    lda #$43
    sta (_28),y
    inx
    cpx x2
    bcc b1
    lda x1
    clc
    adc z
    sta _2
    tya
    adc z+1
    sta _2+1
    clc
    lda _29
    adc #<screen
    sta _29
    lda _29+1
    adc #>screen
    sta _29+1
    // draw upper corners
    lda #$55
    sta (_29),y
    lda x2
    clc
    adc _3
    sta _3
    bcc !+
    inc _3+1
  !:
    clc
    lda _30
    adc #<screen
    sta _30
    lda _30+1
    adc #>screen
    sta _30+1
    lda #$49
    ldy #0
    sta (_30),y
    ldx y1
    inx
  b2:
  // draw vertical lines
    txa
    asl
    asl
    stx $ff
    clc
    adc $ff
    sta z_1
    lda #0
    sta z_1+1
    asl z_1
    rol z_1+1
    asl z_1
    rol z_1+1
    asl z_1
    rol z_1+1
    lda x1
    clc
    adc z_1
    sta _18
    lda #0
    adc z_1+1
    sta _18+1
    clc
    lda _31
    adc #<screen
    sta _31
    lda _31+1
    adc #>screen
    sta _31+1
    lda #$42
    ldy #0
    sta (_31),y
    lda x2
    clc
    adc _19
    sta _19
    bcc !+
    inc _19+1
  !:
    clc
    lda _32
    adc #<screen
    sta _32
    lda _32+1
    adc #>screen
    sta _32+1
    lda #$42
    ldy #0
    sta (_32),y
    inx
    cpx y2
    bcc b2
    lda x1
    clc
    adc q
    sta _4
    tya
    adc q+1
    sta _4+1
    clc
    lda _33
    adc #<screen
    sta _33
    lda _33+1
    adc #>screen
    sta _33+1
    // draw lower corners
    lda #$4a
    sta (_33),y
    lda x2
    clc
    adc _5
    sta _5
    bcc !+
    inc _5+1
  !:
    clc
    lda _34
    adc #<screen
    sta _34
    lda _34+1
    adc #>screen
    sta _34+1
    lda #$4b
    ldy #0
    sta (_34),y
    lda x2
    sec
    sbc x1
    tax
    lda y2
    sec
    sbc y1
    cpx #1+1
    bcc breturn
    cmp #1+1
    bcs b5
  breturn:
    rts
  b5:
    ldy y1
    iny
    sty y3
  b3:
  // blank inside
    lda y3
    asl
    asl
    clc
    adc y3
    sta z_2
    lda #0
    sta z_2+1
    asl z_2
    rol z_2+1
    asl z_2
    rol z_2+1
    asl z_2
    rol z_2+1
    ldx x1
    inx
  b7:
    txa
    clc
    adc z_2
    sta _24
    lda #0
    adc z_2+1
    sta _24+1
    clc
    lda _35
    adc #<screen
    sta _35
    lda _35+1
    adc #>screen
    sta _35+1
    lda #$20
    ldy #0
    sta (_35),y
    inx
    cpx x2
    bcc b7
    inc y3
    lda y3
    cmp y2
    bcc b3
    rts
}
  text: .text "this is a small test with word wrap, if a word is too long it moves it to the next line. isn't that supercalifragilisticexpialidocious? i think it's cool!@"
  text2: .text "textbox by scan of desire@"
