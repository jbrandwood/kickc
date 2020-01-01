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
  __b1:
    lda.z x
    cmp #$f
    bcc __b2
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
  __b7:
    jmp __b7
  __b2:
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
  __b4:
    lda.z wait+1
    cmp #>$88b8
    bcc __b5
    bne !+
    lda.z wait
    cmp #<$88b8
    bcc __b5
  !:
    lda.z x
    clc
    adc #2
    sta.z x
    jmp __b1
  __b5:
    inc.z wait
    bne !+
    inc.z wait+1
  !:
    jmp __b4
}
// textbox(byte zp(2) x1, byte zp(3) y1, byte zp(4) x2, byte zp(5) y2, byte* zp(6) text)
textbox: {
    .label __3 = $b
    .label __9 = $f
    .label __18 = $a
    .label x1 = 2
    .label y1 = 3
    .label x2 = 4
    .label y2 = 5
    .label y = 3
    .label x = 8
    .label z = $b
    .label i = 9
    .label text = 6
    .label __32 = $f
    .label __33 = $d
    .label __34 = $b
    jsr draw_window
    inc.z y
    ldy.z x1
    iny
    sty.z x
    lda.z y
    sta.z __3
    lda #0
    sta.z __3+1
    lda.z __3
    asl
    sta.z __33
    lda.z __3+1
    rol
    sta.z __33+1
    asl.z __33
    rol.z __33+1
    lda.z __34
    clc
    adc.z __33
    sta.z __34
    lda.z __34+1
    adc.z __33+1
    sta.z __34+1
    asl.z z
    rol.z z+1
    asl.z z
    rol.z z+1
    asl.z z
    rol.z z+1
    tya
    cmp.z x2
    beq __breturn
    lda.z y
    cmp.z y2
    beq __breturn
    lda #0
    sta.z i
  __b1:
    lda.z x
    clc
    adc.z z
    sta.z __9
    lda #0
    adc.z z+1
    sta.z __9+1
    clc
    lda.z __32
    adc #<screen
    sta.z __32
    lda.z __32+1
    adc #>screen
    sta.z __32+1
    ldy.z i
    lda (text),y
    ldy #0
    sta (__32),y
    ldy.z i
    lda (text),y
    cmp #$20
    bne __b2
    iny
    ldx #0
  __b3:
    lda #$20
    cmp (text),y
    beq __b5
    lda (text),y
    cmp #0
    bne __b4
  __b5:
    txa
    clc
    adc.z x
    tay
    lda.z x2
    sec
    sbc.z x1
    sta.z __18
    cpy.z x2
    bcc __b2
    cpx.z __18
    bcc __b6
  __b2:
    inc.z i
    inc.z x
    lda.z x
    cmp.z x2
    bne __b8
    ldy.z x1
    iny
    sty.z x
    inc.z y
    lda.z y
    cmp.z y2
    bne __b9
  __breturn:
    rts
  __b9:
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
  __b8:
    ldy.z i
    lda (text),y
    cmp #0
    beq !__b1+
    jmp __b1
  !__b1:
    rts
  __b6:
    inc.z y
    lda.z y
    cmp.z y2
    bne __b7
    rts
  __b7:
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
    jmp __b2
  __b4:
    iny
    inx
    jmp __b3
}
// draw_window(byte zp(2) x1, byte zp(3) y1, byte zp(4) x2, byte zp(5) y2)
draw_window: {
    .label __2 = $f
    .label __3 = $b
    .label __4 = $11
    .label __5 = $d
    .label __14 = $1b
    .label __15 = $1d
    .label __19 = $19
    .label __20 = $17
    .label __26 = $15
    .label x1 = 2
    .label y1 = 3
    .label x2 = 4
    .label y2 = 5
    .label z = $b
    .label q = $d
    .label z_1 = $17
    .label y3 = 9
    .label z_2 = $13
    .label __27 = $1b
    .label __28 = $1d
    .label __29 = $f
    .label __30 = $b
    .label __31 = $19
    .label __32 = $17
    .label __33 = $11
    .label __34 = $d
    .label __35 = $15
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
    bcs !__b2+
    jmp __b2
  !__b2:
    lda.z x1
    clc
    adc.z z
    sta.z __2
    lda #0
    adc.z z+1
    sta.z __2+1
    clc
    lda.z __29
    adc #<screen
    sta.z __29
    lda.z __29+1
    adc #>screen
    sta.z __29+1
    // draw upper corners
    lda #$55
    ldy #0
    sta (__29),y
    lda.z x2
    clc
    adc.z __3
    sta.z __3
    bcc !+
    inc.z __3+1
  !:
    clc
    lda.z __30
    adc #<screen
    sta.z __30
    lda.z __30+1
    adc #>screen
    sta.z __30+1
    lda #$49
    ldy #0
    sta (__30),y
    ldx.z y1
    inx
  b2:
  // draw vertical lines
    cpx.z y2
    bcs !__b5+
    jmp __b5
  !__b5:
    lda.z x1
    clc
    adc.z q
    sta.z __4
    lda #0
    adc.z q+1
    sta.z __4+1
    clc
    lda.z __33
    adc #<screen
    sta.z __33
    lda.z __33+1
    adc #>screen
    sta.z __33+1
    // draw lower corners
    lda #$4a
    ldy #0
    sta (__33),y
    lda.z x2
    clc
    adc.z __5
    sta.z __5
    bcc !+
    inc.z __5+1
  !:
    clc
    lda.z __34
    adc #<screen
    sta.z __34
    lda.z __34+1
    adc #>screen
    sta.z __34+1
    lda #$4b
    ldy #0
    sta (__34),y
    lda.z x2
    sec
    sbc.z x1
    tax
    lda.z y2
    sec
    sbc.z y1
    cpx #1+1
    bcc __breturn
    cmp #1+1
    bcs __b7
  __breturn:
    rts
  __b7:
    ldy.z y1
    iny
    sty.z y3
  b3:
  // blank inside
    lda.z y3
    cmp.z y2
    bcc __b9
    rts
  __b9:
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
  __b10:
    cpx.z x2
    bcc __b11
    inc.z y3
    jmp b3
  __b11:
    txa
    clc
    adc.z z_2
    sta.z __26
    lda #0
    adc.z z_2+1
    sta.z __26+1
    clc
    lda.z __35
    adc #<screen
    sta.z __35
    lda.z __35+1
    adc #>screen
    sta.z __35+1
    lda #$20
    ldy #0
    sta (__35),y
    inx
    jmp __b10
  __b5:
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
    sta.z __19
    lda #0
    adc.z z_1+1
    sta.z __19+1
    clc
    lda.z __31
    adc #<screen
    sta.z __31
    lda.z __31+1
    adc #>screen
    sta.z __31+1
    lda #$42
    ldy #0
    sta (__31),y
    lda.z x2
    clc
    adc.z __20
    sta.z __20
    bcc !+
    inc.z __20+1
  !:
    clc
    lda.z __32
    adc #<screen
    sta.z __32
    lda.z __32+1
    adc #>screen
    sta.z __32+1
    lda #$42
    ldy #0
    sta (__32),y
    inx
    jmp b2
  __b2:
    txa
    clc
    adc.z z
    sta.z __14
    lda #0
    adc.z z+1
    sta.z __14+1
    clc
    lda.z __27
    adc #<screen
    sta.z __27
    lda.z __27+1
    adc #>screen
    sta.z __27+1
    lda #$43
    ldy #0
    sta (__27),y
    txa
    clc
    adc.z q
    sta.z __15
    tya
    adc.z q+1
    sta.z __15+1
    clc
    lda.z __28
    adc #<screen
    sta.z __28
    lda.z __28+1
    adc #>screen
    sta.z __28+1
    lda #$43
    sta (__28),y
    inx
    jmp b1
}
  text: .text "this is a small test with word wrap, if a word is too long it moves it to the next line. isn't that supercalifragilisticexpialidocious? i think it's cool!"
  .byte 0
  text2: .text "textbox by scan of desire"
  .byte 0
