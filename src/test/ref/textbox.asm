/* Textbox routine with word wrap for KickC by Scan/Desire */
// Commodore 64 Registers and Constants
// The MOS 6526 Complex Interface Adapter (CIA)
// http://archive.6502.org/datasheets/mos_6526_cia_recreated.pdf
  // Commodore 64 PRG executable file
.file [name="textbox.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .label screen = $400
.segment Code
main: {
    .label wait = 3
    .label x = 2
    lda #0
    sta.z x
  __b1:
    // for (byte x = 0; x < 15; x += 2)
    lda.z x
    cmp #$f
    bcc __b2
    // textbox(0,12,20,24,text)
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
    // textbox(3,3,37,9,text)
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
    // textbox(30,8,39,24,text)
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
    // x+x
    lda.z x
    asl
    // textbox(x,x,x+x+1,x+10,text2)
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
    // for (word wait = 0; wait < 35000; wait++)
    lda.z wait+1
    cmp #>$88b8
    bcc __b5
    bne !+
    lda.z wait
    cmp #<$88b8
    bcc __b5
  !:
    // x += 2
    lda.z x
    clc
    adc #2
    sta.z x
    jmp __b1
  __b5:
    // for (word wait = 0; wait < 35000; wait++)
    inc.z wait
    bne !+
    inc.z wait+1
  !:
    jmp __b4
}
// textbox(byte zp(2) x1, byte zp(5) y1, byte zp(6) x2, byte zp(7) y2, byte* zp(8) text)
textbox: {
    .label __8 = $10
    .label __17 = $12
    .label __31 = $c
    .label x1 = 2
    .label y1 = 5
    .label x2 = 6
    .label y2 = 7
    .label y = 5
    .label x = $b
    .label z = $c
    .label i = $a
    .label text = 8
    .label __32 = $10
    .label __33 = $e
    .label __34 = $c
    // draw_window(x1, y1, x2, y2)
    jsr draw_window
    // y = y1+1
    inc.z y
    // x = x1+1
    ldy.z x1
    iny
    sty.z x
    // (word)y*40
    lda.z y
    sta.z __31
    lda #0
    sta.z __31+1
    // z = (word)y*40
    lda.z __31
    asl
    sta.z __33
    lda.z __31+1
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
    // if (x == x2 || y == y2)
    tya
    cmp.z x2
    beq __breturn
    lda.z y
    cmp.z y2
    beq __breturn
    lda #0
    sta.z i
  __b1:
    // z+x
    lda.z x
    clc
    adc.z z
    sta.z __8
    lda #0
    adc.z z+1
    sta.z __8+1
    // screen[z+x] = text[i]
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
    // if (text[i] == $20)
    ldy.z i
    lda (text),y
    cmp #$20
    bne __b2
    // ls = i+1
    iny
    ldx #0
  __b3:
    // while (text[ls] != $20 && text[ls] != $00)
    lda #$20
    cmp (text),y
    beq __b5
    lda (text),y
    cmp #0
    bne __b4
  __b5:
    // c+x
    txa
    clc
    adc.z x
    tay
    // x2-x1
    lda.z x2
    sec
    sbc.z x1
    sta.z __17
    // if (c+x >= x2 && c < x2-x1)
    cpy.z x2
    bcc __b2
    cpx.z __17
    bcc __b6
  __b2:
    // i++;
    inc.z i
    // x++;
    inc.z x
    // if (x == x2)
    lda.z x
    cmp.z x2
    bne __b8
    // x = x1+1
    ldy.z x1
    iny
    sty.z x
    // y++;
    inc.z y
    // if (y == y2)
    lda.z y
    cmp.z y2
    bne __b9
  __breturn:
    // }
    rts
  __b9:
    // z = y*40
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
    // while (text[i] != 0)
    ldy.z i
    lda (text),y
    cmp #0
    beq !__b1+
    jmp __b1
  !__b1:
    rts
  __b6:
    // y++;
    inc.z y
    // if (y == y2)
    lda.z y
    cmp.z y2
    bne __b7
    rts
  __b7:
    // z = y*40
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
    // ls++;
    iny
    // c++;
    inx
    jmp __b3
}
// draw_window(byte zp(2) x1, byte zp(5) y1, byte zp(6) x2, byte zp(7) y2)
draw_window: {
    .label __2 = $17
    .label __3 = $13
    .label __4 = $19
    .label __5 = $15
    .label __14 = $23
    .label __15 = $25
    .label __19 = $21
    .label __20 = $1f
    .label __26 = $1d
    .label x1 = 2
    .label y1 = 5
    .label x2 = 6
    .label y2 = 7
    .label z = $13
    .label q = $15
    .label z_1 = $1f
    .label y3 = $12
    .label z_2 = $1b
    .label __27 = $23
    .label __28 = $25
    .label __29 = $17
    .label __30 = $13
    .label __31 = $21
    .label __32 = $1f
    .label __33 = $19
    .label __34 = $15
    .label __35 = $1d
    // z = y1*40
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
    // q = y2*40
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
    // x = x1+1
    ldx.z x1
    inx
  __b1:
  // draw horizontal lines
    // for (byte x = x1+1; x < x2; x++)
    cpx.z x2
    bcs !__b2+
    jmp __b2
  !__b2:
    // z+x1
    lda.z x1
    clc
    adc.z z
    sta.z __2
    lda #0
    adc.z z+1
    sta.z __2+1
    // screen[z+x1] = $55
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
    // z+x2
    lda.z x2
    clc
    adc.z __3
    sta.z __3
    bcc !+
    inc.z __3+1
  !:
    // screen[z+x2] = $49
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
    // y = y1+1
    ldx.z y1
    inx
  __b3:
  // draw vertical lines
    // for (byte y = y1+1; y < y2; y++)
    cpx.z y2
    bcs !__b5+
    jmp __b5
  !__b5:
    // q+x1
    lda.z x1
    clc
    adc.z q
    sta.z __4
    lda #0
    adc.z q+1
    sta.z __4+1
    // screen[q+x1] = $4a
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
    // q+x2
    lda.z x2
    clc
    adc.z __5
    sta.z __5
    bcc !+
    inc.z __5+1
  !:
    // screen[q+x2] = $4b
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
    // x2-x1
    lda.z x2
    sec
    sbc.z x1
    tax
    // y2-y1
    lda.z y2
    sec
    sbc.z y1
    // if (x2-x1 > 1 && y2-y1 > 1)
    cpx #1+1
    bcc __breturn
    cmp #1+1
    bcs __b7
  __breturn:
    // }
    rts
  __b7:
    // y = y1+1
    ldy.z y1
    iny
    sty.z y3
  __b4:
  // blank inside
    // for(byte y = y1+1; y < y2; y++)
    lda.z y3
    cmp.z y2
    bcc __b9
    rts
  __b9:
    // z = y*40
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
    // x = x1+1
    ldx.z x1
    inx
  __b10:
    // for(byte x = x1+1; x < x2; x++)
    cpx.z x2
    bcc __b11
    // for(byte y = y1+1; y < y2; y++)
    inc.z y3
    jmp __b4
  __b11:
    // z+x
    txa
    clc
    adc.z z_2
    sta.z __26
    lda #0
    adc.z z_2+1
    sta.z __26+1
    // screen[z+x] = $20
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
    // for(byte x = x1+1; x < x2; x++)
    inx
    jmp __b10
  __b5:
    // z = y*40
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
    // z+x1
    lda.z x1
    clc
    adc.z z_1
    sta.z __19
    lda #0
    adc.z z_1+1
    sta.z __19+1
    // screen[z+x1] = $42
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
    // z+x2
    lda.z x2
    clc
    adc.z __20
    sta.z __20
    bcc !+
    inc.z __20+1
  !:
    // screen[z+x2] = $42
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
    // for (byte y = y1+1; y < y2; y++)
    inx
    jmp __b3
  __b2:
    // z+x
    txa
    clc
    adc.z z
    sta.z __14
    lda #0
    adc.z z+1
    sta.z __14+1
    // screen[z+x] = $43
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
    // q+x
    txa
    clc
    adc.z q
    sta.z __15
    tya
    adc.z q+1
    sta.z __15+1
    // screen[q+x] = $43
    clc
    lda.z __28
    adc #<screen
    sta.z __28
    lda.z __28+1
    adc #>screen
    sta.z __28+1
    lda #$43
    sta (__28),y
    // for (byte x = x1+1; x < x2; x++)
    inx
    jmp __b1
}
.segment Data
  text: .text "this is a small test with word wrap, if a word is too long it moves it to the next line. isn't that supercalifragilisticexpialidocious? i think it's cool!"
  .byte 0
  text2: .text "textbox by scan of desire"
  .byte 0
