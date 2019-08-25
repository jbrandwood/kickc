/* Textbox routine with word wrap for KickC by Scan/Desire */
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label screen = $400
main: {
    .label wait = 6
    .label x = 2
    lda #0
    sta.z x
  b1:
    lda.z x
    cmp #$f
    bcc b2
    lda #<text
    sta.z textbox.text
    lda #>text
    sta.z textbox.text+1
    lda #$18
    sta.z textbox.y2
    lda #$14
    sta.z textbox.x2
    lda #$c
    sta.z textbox.y1
    lda #0
    sta.z textbox.x1
    jsr textbox
    lda #<text
    sta.z textbox.text
    lda #>text
    sta.z textbox.text+1
    lda #9
    sta.z textbox.y2
    lda #$25
    sta.z textbox.x2
    lda #3
    sta.z textbox.y1
    sta.z textbox.x1
    jsr textbox
    lda #<text
    sta.z textbox.text
    lda #>text
    sta.z textbox.text+1
    lda #$18
    sta.z textbox.y2
    lda #$27
    sta.z textbox.x2
    lda #8
    sta.z textbox.y1
    lda #$1e
    sta.z textbox.x1
    jsr textbox
  b7:
    jmp b7
  b2:
    lda.z x
    asl
    clc
    adc #1
    sta.z textbox.x2
    lax.z x
    axs #-[$a]
    stx.z textbox.y2
    lda.z x
    sta.z textbox.y1
    lda #<text2
    sta.z textbox.text
    lda #>text2
    sta.z textbox.text+1
    jsr textbox
    lda #<0
    sta.z wait
    sta.z wait+1
  b4:
    lda.z wait+1
    cmp #>$88b8
    bcc b5
    bne !+
    lda.z wait
    cmp #<$88b8
    bcc b5
  !:
    lda.z x
    clc
    adc #2
    sta.z x
    jmp b1
  b5:
    inc.z wait
    bne !+
    inc.z wait+1
  !:
    jmp b4
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
    inc.z y
    ldy.z x1
    iny
    sty.z x
    lda.z y
    asl
    asl
    clc
    adc.z y
    sta.z z
    lda #0
    sta.z z+1
    asl.z z
    rol.z z+1
    asl.z z
    rol.z z+1
    asl.z z
    rol.z z+1
    tya
    cmp.z x2
    beq breturn
    lda.z y
    cmp.z y2
    beq breturn
    lda #0
    sta.z i
  b1:
    lda.z x
    clc
    adc.z z
    sta.z _8
    lda #0
    adc.z z+1
    sta.z _8+1
    clc
    lda.z _31
    adc #<screen
    sta.z _31
    lda.z _31+1
    adc #>screen
    sta.z _31+1
    ldy.z i
    lda (text),y
    ldy #0
    sta (_31),y
    ldy.z i
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
    adc.z x
    tay
    lda.z x2
    sec
    sbc.z x1
    sta.z _17
    cpy.z x2
    bcc b2
    cpx.z _17
    bcc b6
  b2:
    inc.z i
    inc.z x
    lda.z x
    cmp.z x2
    bne b8
    ldy.z x1
    iny
    sty.z x
    inc.z y
    lda.z y
    cmp.z y2
    bne b9
  breturn:
    rts
  b9:
    lda.z y
    asl
    asl
    clc
    adc.z y
    sta.z z
    lda #0
    sta.z z+1
    asl.z z
    rol.z z+1
    asl.z z
    rol.z z+1
    asl.z z
    rol.z z+1
  b8:
    ldy.z i
    lda (text),y
    cmp #0
    beq !b1+
    jmp b1
  !b1:
    rts
  b6:
    inc.z y
    lda.z y
    cmp.z y2
    bne b7
    rts
  b7:
    lda.z y
    asl
    asl
    clc
    adc.z y
    sta.z z
    lda #0
    sta.z z+1
    asl.z z
    rol.z z+1
    asl.z z
    rol.z z+1
    asl.z z
    rol.z z+1
    lda.z x1
    sta.z x
    jmp b2
  b4:
    iny
    inx
    jmp b3
}
// draw_window(byte zeropage(2) x1, byte zeropage(3) y1, byte zeropage(4) x2, byte zeropage(5) y2)
draw_window: {
    .label _2 = $f
    .label _3 = $b
    .label _4 = $11
    .label _5 = $d
    .label _14 = $1b
    .label _15 = $1d
    .label _19 = $19
    .label _20 = $17
    .label _26 = $15
    .label x1 = 2
    .label y1 = 3
    .label x2 = 4
    .label y2 = 5
    .label z = $b
    .label q = $d
    .label z_1 = $17
    .label y3 = 9
    .label z_2 = $13
    .label _27 = $1b
    .label _28 = $1d
    .label _29 = $f
    .label _30 = $b
    .label _31 = $19
    .label _32 = $17
    .label _33 = $11
    .label _34 = $d
    .label _35 = $15
    lda.z y1
    asl
    asl
    clc
    adc.z y1
    sta.z z
    lda #0
    sta.z z+1
    asl.z z
    rol.z z+1
    asl.z z
    rol.z z+1
    asl.z z
    rol.z z+1
    lda.z y2
    asl
    asl
    clc
    adc.z y2
    sta.z q
    lda #0
    sta.z q+1
    asl.z q
    rol.z q+1
    asl.z q
    rol.z q+1
    asl.z q
    rol.z q+1
    ldx.z x1
    inx
  b1:
  // draw horizontal lines
    cpx.z x2
    bcs !b2+
    jmp b2
  !b2:
    lda.z x1
    clc
    adc.z z
    sta.z _2
    lda #0
    adc.z z+1
    sta.z _2+1
    clc
    lda.z _29
    adc #<screen
    sta.z _29
    lda.z _29+1
    adc #>screen
    sta.z _29+1
    // draw upper corners
    lda #$55
    ldy #0
    sta (_29),y
    lda.z x2
    clc
    adc.z _3
    sta.z _3
    bcc !+
    inc.z _3+1
  !:
    clc
    lda.z _30
    adc #<screen
    sta.z _30
    lda.z _30+1
    adc #>screen
    sta.z _30+1
    lda #$49
    ldy #0
    sta (_30),y
    ldx.z y1
    inx
  b3:
  // draw vertical lines
    cpx.z y2
    bcs !b5+
    jmp b5
  !b5:
    lda.z x1
    clc
    adc.z q
    sta.z _4
    lda #0
    adc.z q+1
    sta.z _4+1
    clc
    lda.z _33
    adc #<screen
    sta.z _33
    lda.z _33+1
    adc #>screen
    sta.z _33+1
    // draw lower corners
    lda #$4a
    ldy #0
    sta (_33),y
    lda.z x2
    clc
    adc.z _5
    sta.z _5
    bcc !+
    inc.z _5+1
  !:
    clc
    lda.z _34
    adc #<screen
    sta.z _34
    lda.z _34+1
    adc #>screen
    sta.z _34+1
    lda #$4b
    ldy #0
    sta (_34),y
    lda.z x2
    sec
    sbc.z x1
    tax
    lda.z y2
    sec
    sbc.z y1
    cpx #1+1
    bcc breturn
    cmp #1+1
    bcs b7
  breturn:
    rts
  b7:
    ldy.z y1
    iny
    sty.z y3
  b4:
  // blank inside
    lda.z y3
    cmp.z y2
    bcc b9
    rts
  b9:
    lda.z y3
    asl
    asl
    clc
    adc.z y3
    sta.z z_2
    lda #0
    sta.z z_2+1
    asl.z z_2
    rol.z z_2+1
    asl.z z_2
    rol.z z_2+1
    asl.z z_2
    rol.z z_2+1
    ldx.z x1
    inx
  b10:
    cpx.z x2
    bcc b11
    inc.z y3
    jmp b4
  b11:
    txa
    clc
    adc.z z_2
    sta.z _26
    lda #0
    adc.z z_2+1
    sta.z _26+1
    clc
    lda.z _35
    adc #<screen
    sta.z _35
    lda.z _35+1
    adc #>screen
    sta.z _35+1
    lda #$20
    ldy #0
    sta (_35),y
    inx
    jmp b10
  b5:
    txa
    asl
    asl
    stx.z $ff
    clc
    adc.z $ff
    sta.z z_1
    lda #0
    sta.z z_1+1
    asl.z z_1
    rol.z z_1+1
    asl.z z_1
    rol.z z_1+1
    asl.z z_1
    rol.z z_1+1
    lda.z x1
    clc
    adc.z z_1
    sta.z _19
    lda #0
    adc.z z_1+1
    sta.z _19+1
    clc
    lda.z _31
    adc #<screen
    sta.z _31
    lda.z _31+1
    adc #>screen
    sta.z _31+1
    lda #$42
    ldy #0
    sta (_31),y
    lda.z x2
    clc
    adc.z _20
    sta.z _20
    bcc !+
    inc.z _20+1
  !:
    clc
    lda.z _32
    adc #<screen
    sta.z _32
    lda.z _32+1
    adc #>screen
    sta.z _32+1
    lda #$42
    ldy #0
    sta (_32),y
    inx
    jmp b3
  b2:
    txa
    clc
    adc.z z
    sta.z _14
    lda #0
    adc.z z+1
    sta.z _14+1
    clc
    lda.z _27
    adc #<screen
    sta.z _27
    lda.z _27+1
    adc #>screen
    sta.z _27+1
    lda #$43
    ldy #0
    sta (_27),y
    txa
    clc
    adc.z q
    sta.z _15
    tya
    adc.z q+1
    sta.z _15+1
    clc
    lda.z _28
    adc #<screen
    sta.z _28
    lda.z _28+1
    adc #>screen
    sta.z _28+1
    lda #$43
    sta (_28),y
    inx
    jmp b1
}
  text: .text "this is a small test with word wrap, if a word is too long it moves it to the next line. isn't that supercalifragilisticexpialidocious? i think it's cool!"
  .byte 0
  text2: .text "textbox by scan of desire"
  .byte 0
