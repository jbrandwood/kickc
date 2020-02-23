.pc = $801 "Basic"
:BasicUpstart(__b1)
.pc = $80d "Program"
  .label VIC_MEMORY = $d018
  // CIA#2 Port A: Serial bus, RS-232, VIC memory bank
  .label CIA2_PORT_A = $dd00
  .label SCREEN1 = $e000
  .label SCREEN2 = $e400
  .label CHARSET = $e800
  .const PAGE1 = SCREEN1>>6&$f0|CHARSET>>$a&$e
  .const PAGE2 = SCREEN2>>6&$f0|CHARSET>>$a&$e
  .label last_time = $a
  .label rand_seed = $c
  .label print_line_cursor = 4
  .label print_char_cursor = 6
  .label Ticks = $10
  .label Ticks_1 = $13
__b1:
  // last_time
  lda #<0
  sta.z last_time
  sta.z last_time+1
  // rand_seed
  sta.z rand_seed
  sta.z rand_seed+1
  jsr main
  rts
main: {
    .label block = $e
    .label v = $f
    .label count = 4
    // rand_seed = 6474
    lda #<$194a
    sta.z rand_seed
    lda #>$194a
    sta.z rand_seed+1
    // makechar()
    jsr makechar
    // start()
    jsr start
    // block = *CIA2_PORT_A
    lda CIA2_PORT_A
    sta.z block
    // tmp = block & 0xFC
    lda #$fc
    and.z block
    // *CIA2_PORT_A = tmp
    sta CIA2_PORT_A
    // v = *VIC_MEMORY
    lda VIC_MEMORY
    sta.z v
    lda #<$1f4
    sta.z count
    lda #>$1f4
    sta.z count+1
  /* Run the demo until a key was hit */
  __b1:
    // while (count)
    lda.z count+1
    cmp #>0
    bne __b2
    lda.z count
    cmp #<0
    bne __b2
    // *VIC_MEMORY = v
    lda.z v
    sta VIC_MEMORY
    // *CIA2_PORT_A = block
    lda.z block
    sta CIA2_PORT_A
    // end()
    jsr end
    // }
    rts
  __b2:
    // doplasma ((char*)SCREEN1)
    lda #<SCREEN1
    sta.z doplasma.scrn
    lda #>SCREEN1
    sta.z doplasma.scrn+1
    jsr doplasma
    // *VIC_MEMORY = PAGE1
    lda #PAGE1
    sta VIC_MEMORY
    // doplasma ((char*)SCREEN2)
    lda #<SCREEN2
    sta.z doplasma.scrn
    lda #>SCREEN2
    sta.z doplasma.scrn+1
    jsr doplasma
    // *VIC_MEMORY = PAGE2
    lda #PAGE2
    sta VIC_MEMORY
    // --count;
    lda.z count
    bne !+
    dec.z count+1
  !:
    dec.z count
    jmp __b1
}
// doplasma(byte* zp(6) scrn)
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
    // for (ii = 0; ii < 25; ++ii)
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
    // for (i = 0; i < 40; ++i)
    lda.z i
    cmp #$28
    bcc __b4
    ldx #0
  __b5:
    // for (jj = 0; jj < 25; ++jj)
    cpx #$19
    bcc b1
    // }
    rts
  b1:
    ldy #0
  __b6:
    // for (j = 0; j < 40; ++j)
    cpy #$28
    bcc __b7
    // scrn += 40
    lda #$28
    clc
    adc.z scrn
    sta.z scrn
    bcc !+
    inc.z scrn+1
  !:
    // for (jj = 0; jj < 25; ++jj)
    inx
    jmp __b5
  __b7:
    // xbuf[j] + ybuf[jj]
    lda xbuf,y
    clc
    adc ybuf,x
    // scrn[j] = (xbuf[j] + ybuf[jj])
    sta (scrn),y
    // for (j = 0; j < 40; ++j)
    iny
    jmp __b6
  __b4:
    // sinustable[c2a] + sinustable[c2b]
    ldy.z c2a
    lda sinustable,y
    ldy.z c2b
    clc
    adc sinustable,y
    // xbuf[i] = (sinustable[c2a] + sinustable[c2b])
    ldy.z i
    sta xbuf,y
    // c2a += 3
    lax.z c2a
    axs #-[3]
    stx.z c2a
    // c2b += 7
    lax.z c2b
    axs #-[7]
    stx.z c2b
    // for (i = 0; i < 40; ++i)
    inc.z i
    jmp __b3
  __b2:
    // sinustable[c1a] + sinustable[c1b]
    ldy.z c1a
    lda sinustable,y
    ldy.z c1b
    clc
    adc sinustable,y
    // ybuf[ii] = (sinustable[c1a] + sinustable[c1b])
    ldy.z ii
    sta ybuf,y
    // c1a += 4
    lax.z c1a
    axs #-[4]
    stx.z c1a
    // c1b += 9
    lax.z c1b
    axs #-[9]
    stx.z c1b
    // for (ii = 0; ii < 25; ++ii)
    inc.z ii
    jmp __b1
}
end: {
    // Ticks = last_time
    lda.z last_time
    sta.z Ticks
    lda.z last_time+1
    sta.z Ticks+1
    // start()
    jsr start
    // last_time -= Ticks
    lda.z last_time
    sec
    sbc.z Ticks
    sta.z last_time
    lda.z last_time+1
    sbc.z Ticks+1
    sta.z last_time+1
    // Ticks = last_time
    lda.z last_time
    sta.z Ticks_1
    lda.z last_time+1
    sta.z Ticks_1+1
    // print_word(Ticks)
    jsr print_word
    // print_ln()
    jsr print_ln
    // }
    rts
}
// Print a newline
print_ln: {
    lda #<$400
    sta.z print_line_cursor
    lda #>$400
    sta.z print_line_cursor+1
  __b1:
    // print_line_cursor + $28
    lda #$28
    clc
    adc.z print_line_cursor
    sta.z print_line_cursor
    bcc !+
    inc.z print_line_cursor+1
  !:
    // while (print_line_cursor<print_char_cursor)
    lda.z print_line_cursor+1
    cmp.z print_char_cursor+1
    bcc __b1
    bne !+
    lda.z print_line_cursor
    cmp.z print_char_cursor
    bcc __b1
  !:
    // }
    rts
}
// Print a word as HEX
// print_word(word zp($13) w)
print_word: {
    .label w = $13
    // print_byte(>w)
    lda.z w+1
    tax
    lda #<$400
    sta.z print_char_cursor
    lda #>$400
    sta.z print_char_cursor+1
    jsr print_byte
    // print_byte(<w)
    lda.z w
    tax
    jsr print_byte
    // }
    rts
}
// Print a byte as HEX
// print_byte(byte register(X) b)
print_byte: {
    // b>>4
    txa
    lsr
    lsr
    lsr
    lsr
    // print_char(print_hextab[b>>4])
    tay
    lda print_hextab,y
    jsr print_char
    // b&$f
    lda #$f
    axs #0
    // print_char(print_hextab[b&$f])
    lda print_hextab,x
    jsr print_char
    // }
    rts
}
// Print a single char
// print_char(byte register(A) ch)
print_char: {
    // *(print_char_cursor++) = ch
    ldy #0
    sta (print_char_cursor),y
    // *(print_char_cursor++) = ch;
    inc.z print_char_cursor
    bne !+
    inc.z print_char_cursor+1
  !:
    // }
    rts
}
start: {
    .label LAST_TIME = last_time
    // asm
    jsr $ffde
    sta LAST_TIME
    stx LAST_TIME+1
    // rand_seed = 6474
    lda #<$194a
    sta.z rand_seed
    lda #>$194a
    sta.z rand_seed+1
    // }
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
    // for (c = 0; c < 0x100; ++c)
    lda.z c+1
    cmp #>$100
    bcc __b2
    bne !+
    lda.z c
    cmp #<$100
    bcc __b2
  !:
    // }
    rts
  __b2:
    // (char)c
    lda.z c
    // s = sinustable[(char)c]
    tay
    lda sinustable,y
    sta.z s
    lda #0
    sta.z i
  __b3:
    // for (i = 0; i < 8; ++i)
    lda.z i
    cmp #8
    bcc b1
    // for (c = 0; c < 0x100; ++c)
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
    // for (ii = 0; ii < 8; ++ii)
    cpy #8
    bcc __b6
    // c<<3
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
    // (c<<3) + i
    lda.z i
    clc
    adc.z __9
    sta.z __9
    bcc !+
    inc.z __9+1
  !:
    // ((char*)CHARSET) [(c<<3) + i] = b
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
    // for (i = 0; i < 8; ++i)
    inc.z i
    jmp __b3
  __b6:
    // rand()
    jsr rand
    // rand() & 0xFF
    and #$ff
    sta.z __5
    // if ((rand() & 0xFF) > s)
    lda.z s
    cmp.z __5
    bcs __b8
    // b |= bittab[ii]
    lda bittab,y
    ora.z b
    sta.z b
  __b8:
    // for (ii = 0; ii < 8; ++ii)
    iny
    jmp __b5
}
rand: {
    .label RAND_SEED = rand_seed
    // asm
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
    // (char)rand_seed
    lda.z rand_seed
    // }
    rts
}
  print_hextab: .text "0123456789abcdef"
  .align $100
  sinustable: .byte $80, $7d, $7a, $77, $74, $70, $6d, $6a, $67, $64, $61, $5e, $5b, $58, $55, $52, $4f, $4d, $4a, $47, $44, $41, $3f, $3c, $39, $37, $34, $32, $2f, $2d, $2b, $28, $26, $24, $22, $20, $1e, $1c, $1a, $18, $16, $15, $13, $11, $10, $f, $d, $c, $b, $a, 8, 7, 6, 6, 5, 4, 3, 3, 2, 2, 2, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 3, 3, 4, 5, 6, 6, 7, 8, $a, $b, $c, $d, $f, $10, $11, $13, $15, $16, $18, $1a, $1c, $1e, $20, $22, $24, $26, $28, $2b, $2d, $2f, $32, $34, $37, $39, $3c, $3f, $41, $44, $47, $4a, $4d, $4f, $52, $55, $58, $5b, $5e, $61, $64, $67, $6a, $6d, $70, $74, $77, $7a, $7d, $80, $83, $86, $89, $8c, $90, $93, $96, $99, $9c, $9f, $a2, $a5, $a8, $ab, $ae, $b1, $b3, $b6, $b9, $bc, $bf, $c1, $c4, $c7, $c9, $cc, $ce, $d1, $d3, $d5, $d8, $da, $dc, $de, $e0, $e2, $e4, $e6, $e8, $ea, $eb, $ed, $ef, $f0, $f1, $f3, $f4, $f5, $f6, $f8, $f9, $fa, $fa, $fb, $fc, $fd, $fd, $fe, $fe, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $fe, $fe, $fe, $fd, $fd, $fc, $fb, $fa, $fa, $f9, $f8, $f6, $f5, $f4, $f3, $f1, $f0, $ef, $ed, $eb, $ea, $e8, $e6, $e4, $e2, $e0, $de, $dc, $da, $d8, $d5, $d3, $d1, $ce, $cc, $c9, $c7, $c4, $c1, $bf, $bc, $b9, $b6, $b3, $b1, $ae, $ab, $a8, $a5, $a2, $9f, $9c, $99, $96, $93, $90, $8c, $89, $86, $83
  xbuf: .fill $28, 0
  ybuf: .fill $19, 0
  bittab: .byte 1, 2, 4, 8, $10, $20, $40, $80
