.pc = $801 "Basic"
:BasicUpstart(__b1)
.pc = $80d "Program"
  .label VIC_MEMORY = $d018
  // CIA#2 Port A: Serial bus, RS-232, VIC memory bank
  .label CIA2_PORT_A = $dd00
  .const SCREEN1 = $e000
  .const SCREEN2 = $e400
  .const CHARSET = $e800
  .const PAGE1 = $8a
  // ((SCREEN1 >> 6) & 0xF0) | ((CHARSET >> 10) & 0x0E);
  .const PAGE2 = $9a
  .label print_line_cursor = 4
  .label print_char_cursor = 6
  .label last_time = $a
  .label rand_seed = $c
  .label Ticks = $10
  .label Ticks_1 = $13
__b1:
  lda #<0
  sta.z last_time
  sta.z last_time+1
  sta.z rand_seed
  sta.z rand_seed+1
  jsr main
  rts
main: {
    .label block = $e
    .label v = $f
    .label count = 4
    jsr start
    jsr makechar
    lda CIA2_PORT_A
    sta.z block
    lda #$fc
    and.z block
    sta CIA2_PORT_A
    lda VIC_MEMORY
    sta.z v
    lda #<$1f4
    sta.z count
    lda #>$1f4
    sta.z count+1
  /* Run the demo until a key was hit */
  __b1:
    lda.z count+1
    cmp #>0
    bne __b2
    lda.z count
    cmp #<0
    bne __b2
    lda.z v
    sta VIC_MEMORY
    lda.z block
    sta CIA2_PORT_A
    jsr end
    rts
  __b2:
    lda #<SCREEN1
    sta.z doplasma.scrn
    lda #>SCREEN1
    sta.z doplasma.scrn+1
    jsr doplasma
    lda #PAGE1
    sta VIC_MEMORY
    lda #<SCREEN2
    sta.z doplasma.scrn
    lda #>SCREEN2
    sta.z doplasma.scrn+1
    jsr doplasma
    lda #PAGE2
    sta VIC_MEMORY
    lda.z count
    bne !+
    dec.z count+1
  !:
    dec.z count
    jmp __b1
}
// doplasma(byte* zeropage(6) scrn)
doplasma: {
    .const c2A = 0
    .const c2B = 0
    .label c1a = 9
    .label c1b = $12
    .label ii = 8
    .label c2a = 2
    .label c2b = 3
    .label i = $15
    .label scrn = 6
    lda #0
    sta.z c1b
    sta.z c1a
    sta.z ii
  __b1:
    lda.z ii
    cmp #$19
    bcc __b2
    lda #c2B
    sta.z c2b
    lda #c2A
    sta.z c2a
    lda #0
    sta.z i
  __b3:
    lda.z i
    cmp #$28
    bcc __b4
    ldx #0
  __b5:
    cpx #$19
    bcc b1
    rts
  b1:
    ldy #0
  __b6:
    cpy #$28
    bcc __b7
    lda #$28
    clc
    adc.z scrn
    sta.z scrn
    bcc !+
    inc.z scrn+1
  !:
    inx
    jmp __b5
  __b7:
    lda xbuf,y
    clc
    adc ybuf,x
    sta (scrn),y
    iny
    jmp __b6
  __b4:
    ldy.z c2a
    lda sinustable,y
    ldy.z c2b
    clc
    adc sinustable,y
    ldy.z i
    sta xbuf,y
    lax.z c2a
    axs #-[3]
    stx.z c2a
    lax.z c2b
    axs #-[7]
    stx.z c2b
    inc.z i
    jmp __b3
  __b2:
    ldy.z c1a
    lda sinustable,y
    ldy.z c1b
    clc
    adc sinustable,y
    ldy.z ii
    sta ybuf,y
    lax.z c1a
    axs #-[4]
    stx.z c1a
    lax.z c1b
    axs #-[9]
    stx.z c1b
    inc.z ii
    jmp __b1
}
end: {
    lda.z last_time
    sta.z Ticks
    lda.z last_time+1
    sta.z Ticks+1
    jsr start
    lda.z last_time
    sec
    sbc.z Ticks
    sta.z last_time
    lda.z last_time+1
    sbc.z Ticks+1
    sta.z last_time+1
    lda.z last_time
    sta.z Ticks_1
    lda.z last_time+1
    sta.z Ticks_1+1
    jsr print_word
    jsr print_ln
    rts
}
// Print a newline
print_ln: {
    lda #<$400
    sta.z print_line_cursor
    lda #>$400
    sta.z print_line_cursor+1
  __b1:
    lda #$28
    clc
    adc.z print_line_cursor
    sta.z print_line_cursor
    bcc !+
    inc.z print_line_cursor+1
  !:
    lda.z print_line_cursor+1
    cmp.z print_char_cursor+1
    bcc __b1
    bne !+
    lda.z print_line_cursor
    cmp.z print_char_cursor
    bcc __b1
  !:
    rts
}
// Print a word as HEX
// print_word(word zeropage($13) w)
print_word: {
    .label w = $13
    lda.z w+1
    tax
    lda #<$400
    sta.z print_char_cursor
    lda #>$400
    sta.z print_char_cursor+1
    jsr print_byte
    lda.z w
    tax
    jsr print_byte
    rts
}
// Print a byte as HEX
// print_byte(byte register(X) b)
print_byte: {
    txa
    lsr
    lsr
    lsr
    lsr
    tay
    lda print_hextab,y
    jsr print_char
    lda #$f
    axs #0
    lda print_hextab,x
    jsr print_char
    rts
}
// Print a single char
// print_char(byte register(A) ch)
print_char: {
    ldy #0
    sta (print_char_cursor),y
    inc.z print_char_cursor
    bne !+
    inc.z print_char_cursor+1
  !:
    rts
}
start: {
    .label LAST_TIME = last_time
    jsr $ffde
    sta LAST_TIME
    stx LAST_TIME+1
    lda #<$194a
    sta.z rand_seed
    lda #>$194a
    sta.z rand_seed+1
    rts
}
makechar: {
    .label __5 = $15
    .label __8 = $13
    .label __9 = $13
    .label s = $12
    .label c = $10
    .label i = 8
    .label b = 9
    .label __10 = $13
    lda #<0
    sta.z c
    sta.z c+1
  __b1:
    lda.z c+1
    cmp #>$100
    bcc __b2
    bne !+
    lda.z c
    cmp #<$100
    bcc __b2
  !:
    rts
  __b2:
    lda.z c
    tay
    lda sinustable,y
    sta.z s
    lda #0
    sta.z i
  __b3:
    lda.z i
    cmp #8
    bcc b1
    inc.z c
    bne !+
    inc.z c+1
  !:
    jmp __b1
  b1:
    lda #0
    sta.z b
    tay
  __b5:
    cpy #8
    bcc __b6
    lda.z c
    asl
    sta.z __8
    lda.z c+1
    rol
    sta.z __8+1
    asl.z __8
    rol.z __8+1
    asl.z __8
    rol.z __8+1
    lda.z i
    clc
    adc.z __9
    sta.z __9
    bcc !+
    inc.z __9+1
  !:
    clc
    lda.z __10
    adc #<CHARSET
    sta.z __10
    lda.z __10+1
    adc #>CHARSET
    sta.z __10+1
    lda.z b
    ldy #0
    sta (__10),y
    inc.z i
    jmp __b3
  __b6:
    jsr rand
    and #$ff
    sta.z __5
    lda.z s
    cmp.z __5
    bcs __b8
    lda bittab,y
    ora.z b
    sta.z b
  __b8:
    iny
    jmp __b5
}
rand: {
    .label RAND_SEED = rand_seed
    ldx #8
    lda RAND_SEED+0
  __rand_loop:
    asl
    rol RAND_SEED+1
    bcc __no_eor
    eor #$2d
  __no_eor:
    dex
    bne __rand_loop
    sta RAND_SEED+0
    lda.z rand_seed
    rts
}
  print_hextab: .text "0123456789abcdef"
  // ((SCREEN2 >> 6) & 0xF0) | ((CHARSET >> 10) & 0x0E);
  .align $100
  sinustable: .byte $80, $7d, $7a, $77, $74, $70, $6d, $6a, $67, $64, $61, $5e, $5b, $58, $55, $52, $4f, $4d, $4a, $47, $44, $41, $3f, $3c, $39, $37, $34, $32, $2f, $2d, $2b, $28, $26, $24, $22, $20, $1e, $1c, $1a, $18, $16, $15, $13, $11, $10, $f, $d, $c, $b, $a, 8, 7, 6, 6, 5, 4, 3, 3, 2, 2, 2, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 3, 3, 4, 5, 6, 6, 7, 8, $a, $b, $c, $d, $f, $10, $11, $13, $15, $16, $18, $1a, $1c, $1e, $20, $22, $24, $26, $28, $2b, $2d, $2f, $32, $34, $37, $39, $3c, $3f, $41, $44, $47, $4a, $4d, $4f, $52, $55, $58, $5b, $5e, $61, $64, $67, $6a, $6d, $70, $74, $77, $7a, $7d, $80, $83, $86, $89, $8c, $90, $93, $96, $99, $9c, $9f, $a2, $a5, $a8, $ab, $ae, $b1, $b3, $b6, $b9, $bc, $bf, $c1, $c4, $c7, $c9, $cc, $ce, $d1, $d3, $d5, $d8, $da, $dc, $de, $e0, $e2, $e4, $e6, $e8, $ea, $eb, $ed, $ef, $f0, $f1, $f3, $f4, $f5, $f6, $f8, $f9, $fa, $fa, $fb, $fc, $fd, $fd, $fe, $fe, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $fe, $fe, $fe, $fd, $fd, $fc, $fb, $fa, $fa, $f9, $f8, $f6, $f5, $f4, $f3, $f1, $f0, $ef, $ed, $eb, $ea, $e8, $e6, $e4, $e2, $e0, $de, $dc, $da, $d8, $d5, $d3, $d1, $ce, $cc, $c9, $c7, $c4, $c1, $bf, $bc, $b9, $b6, $b3, $b1, $ae, $ab, $a8, $a5, $a2, $9f, $9c, $99, $96, $93, $90, $8c, $89, $86, $83
  xbuf: .fill $28, 0
  ybuf: .fill $19, 0
  bittab: .byte 1, 2, 4, 8, $10, $20, $40, $80
