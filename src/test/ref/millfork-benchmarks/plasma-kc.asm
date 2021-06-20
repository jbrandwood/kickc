/// @file
/// A lightweight library for printing on the C64.
///
/// Printing with this library is done by calling print_ function for each element
  // Commodore 64 PRG executable file
.file [name="plasma-kc.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(__start)
  .const PAGE1 = SCREEN1>>6&$f0|CHARSET>>$a&$e
  .const PAGE2 = SCREEN2>>6&$f0|CHARSET>>$a&$e
  /// $D018 VIC-II base addresses
  /// - Bit#0: not used
  /// - Bit#1-#3: CB Address Bits 11-13 of the Character Set (*2048)
  /// - Bit#4-#7: VM Address Bits 10-13 of the Screen RAM (*1024)
  /// Initial Value: %00010100
  .label VICII_MEMORY = $d018
  /// The CIA#2: Serial bus, RS-232, VIC memory bank
  .label CIA2 = $dd00
  .label SCREEN1 = $e000
  .label SCREEN2 = $e400
  .label CHARSET = $e800
  .label print_screen = $400
  .label last_time = $a
  .label print_line_cursor = $f
  // The random state variable
  .label rand_state = 2
  .label Ticks = $14
  .label Ticks_1 = $16
  .label print_char_cursor = $11
.segment Code
__start: {
    // unsigned int last_time
    lda #<0
    sta.z last_time
    sta.z last_time+1
    jsr main
    rts
}
main: {
    .label block = $c
    .label v = $d
    .label count = 2
    // makechar()
    jsr makechar
    // start()
    jsr start
    // block = CIA2->PORT_A
    lda CIA2
    sta.z block
    // tmp = block & 0xFC
    lda #$fc
    and.z block
    // CIA2->PORT_A = tmp
    sta CIA2
    // v = *VICII_MEMORY
    lda VICII_MEMORY
    sta.z v
    lda #<$1f4
    sta.z count
    lda #>$1f4
    sta.z count+1
  /* Run the demo until a key was hit */
  __b1:
    // while (count)
    lda.z count
    ora.z count+1
    bne __b2
    // *VICII_MEMORY = v
    lda.z v
    sta VICII_MEMORY
    // CIA2->PORT_A = block
    lda.z block
    sta CIA2
    // end()
    /* Reset screen colors */
    jsr end
    // }
    rts
  __b2:
    // doplasma ((char*)SCREEN1)
  /* Build page 1, then make it visible */
    lda #<SCREEN1
    sta.z doplasma.scrn
    lda #>SCREEN1
    sta.z doplasma.scrn+1
    jsr doplasma
    // *VICII_MEMORY = PAGE1
    lda #PAGE1
    sta VICII_MEMORY
    // doplasma ((char*)SCREEN2)
  /* Build page 2, then make it visible */
    lda #<SCREEN2
    sta.z doplasma.scrn
    lda #>SCREEN2
    sta.z doplasma.scrn+1
    jsr doplasma
    // *VICII_MEMORY = PAGE2
    lda #PAGE2
    sta VICII_MEMORY
    // --count;
    lda.z count
    bne !+
    dec.z count+1
  !:
    dec.z count
    jmp __b1
}
makechar: {
    .label __3 = $11
    .label __4 = $13
    .label __7 = $f
    .label __8 = $f
    .label s = $e
    .label c = 8
    .label i = 4
    .label __10 = $f
    lda #<1
    sta.z rand_state
    lda #>1
    sta.z rand_state+1
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
    // s = sinetable[(char)c]
    ldx.z c
    lda sinetable,x
    sta.z s
    lda #0
    sta.z i
  __b3:
    // for (i = 0; i < 8; ++i)
    lda.z i
    cmp #8
    bcc __b4
    // for (c = 0; c < 0x100; ++c)
    inc.z c
    bne !+
    inc.z c+1
  !:
    jmp __b1
  __b4:
    ldy #0
    ldx #0
  __b5:
    // for (ii = 0; ii < 8; ++ii)
    cpx #8
    bcc __b6
    // c<<3
    lda.z c
    asl
    sta.z __7
    lda.z c+1
    rol
    sta.z __7+1
    asl.z __7
    rol.z __7+1
    asl.z __7
    rol.z __7+1
    // (c<<3) + i
    lda.z i
    clc
    adc.z __8
    sta.z __8
    bcc !+
    inc.z __8+1
  !:
    // ((char*)CHARSET) [(c<<3) + i] = b
    clc
    lda.z __10
    adc #<CHARSET
    sta.z __10
    lda.z __10+1
    adc #>CHARSET
    sta.z __10+1
    tya
    ldy #0
    sta (__10),y
    // for (i = 0; i < 8; ++i)
    inc.z i
    jmp __b3
  __b6:
    // rand()
    jsr rand
    // rand() & 0xFF
    lda #$ff
    and.z __3
    sta.z __4
    // if ((rand() & 0xFF) > s)
    lda.z s
    cmp.z __4
    bcs __b8
    // b |= bittab[ii]
    tya
    ora bittab,x
    tay
  __b8:
    // for (ii = 0; ii < 8; ++ii)
    inx
    jmp __b5
}
start: {
    .label LAST_TIME = last_time
    // asm
    jsr $ffde
    sta LAST_TIME
    stx LAST_TIME+1
    // }
    rts
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
    // print_uint(Ticks)
    jsr print_uint
    // print_ln()
    jsr print_ln
    // }
    rts
}
// doplasma(byte* zp(8) scrn)
doplasma: {
    .const c2A = 0
    .const c2B = 0
    .label c1a = $e
    .label c1b = $13
    .label ii = 4
    .label c2a = 6
    .label c2b = 7
    .label i = 5
    .label scrn = 8
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
    bcc __b8
    // }
    rts
  __b8:
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
    // sinetable[c2a] + sinetable[c2b]
    ldy.z c2a
    lda sinetable,y
    ldy.z c2b
    clc
    adc sinetable,y
    // xbuf[i] = (sinetable[c2a] + sinetable[c2b])
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
    // sinetable[c1a] + sinetable[c1b]
    ldy.z c1a
    lda sinetable,y
    ldy.z c1b
    clc
    adc sinetable,y
    // ybuf[ii] = (sinetable[c1a] + sinetable[c1b])
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
// Returns a pseudo-random number in the range of 0 to RAND_MAX (65535)
// Uses an xorshift pseudorandom number generator that hits all different values
// Information https://en.wikipedia.org/wiki/Xorshift
// Source http://www.retroprogramming.com/2017/07/xorshift-pseudorandom-numbers-in-z80.html
rand: {
    .label __0 = $14
    .label __1 = $16
    .label __2 = $18
    .label return = $11
    // rand_state << 7
    lda.z rand_state+1
    lsr
    lda.z rand_state
    ror
    sta.z __0+1
    lda #0
    ror
    sta.z __0
    // rand_state ^= rand_state << 7
    lda.z rand_state
    eor.z __0
    sta.z rand_state
    lda.z rand_state+1
    eor.z __0+1
    sta.z rand_state+1
    // rand_state >> 9
    lsr
    sta.z __1
    lda #0
    sta.z __1+1
    // rand_state ^= rand_state >> 9
    lda.z rand_state
    eor.z __1
    sta.z rand_state
    lda.z rand_state+1
    eor.z __1+1
    sta.z rand_state+1
    // rand_state << 8
    lda.z rand_state
    sta.z __2+1
    lda #0
    sta.z __2
    // rand_state ^= rand_state << 8
    lda.z rand_state
    eor.z __2
    sta.z rand_state
    lda.z rand_state+1
    eor.z __2+1
    sta.z rand_state+1
    // return rand_state;
    lda.z rand_state
    sta.z return
    lda.z rand_state+1
    sta.z return+1
    // }
    rts
}
// Print a unsigned int as HEX
// print_uint(word zp($16) w)
print_uint: {
    .label w = $16
    // print_uchar(BYTE1(w))
    ldx.z w+1
    lda #<print_screen
    sta.z print_char_cursor
    lda #>print_screen
    sta.z print_char_cursor+1
    jsr print_uchar
    // print_uchar(BYTE0(w))
    ldx.z w
    jsr print_uchar
    // }
    rts
}
// Print a newline
print_ln: {
    lda #<print_screen
    sta.z print_line_cursor
    lda #>print_screen
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
// Print a char as HEX
// print_uchar(byte register(X) b)
print_uchar: {
    // b>>4
    txa
    lsr
    lsr
    lsr
    lsr
    // print_char(print_hextab[b>>4])
    tay
    lda print_hextab,y
  // Table of hexadecimal digits
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
.segment Data
  print_hextab: .text "0123456789abcdef"
  .align $100
  sinetable: .byte $80, $7d, $7a, $77, $74, $70, $6d, $6a, $67, $64, $61, $5e, $5b, $58, $55, $52, $4f, $4d, $4a, $47, $44, $41, $3f, $3c, $39, $37, $34, $32, $2f, $2d, $2b, $28, $26, $24, $22, $20, $1e, $1c, $1a, $18, $16, $15, $13, $11, $10, $f, $d, $c, $b, $a, 8, 7, 6, 6, 5, 4, 3, 3, 2, 2, 2, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 3, 3, 4, 5, 6, 6, 7, 8, $a, $b, $c, $d, $f, $10, $11, $13, $15, $16, $18, $1a, $1c, $1e, $20, $22, $24, $26, $28, $2b, $2d, $2f, $32, $34, $37, $39, $3c, $3f, $41, $44, $47, $4a, $4d, $4f, $52, $55, $58, $5b, $5e, $61, $64, $67, $6a, $6d, $70, $74, $77, $7a, $7d, $80, $83, $86, $89, $8c, $90, $93, $96, $99, $9c, $9f, $a2, $a5, $a8, $ab, $ae, $b1, $b3, $b6, $b9, $bc, $bf, $c1, $c4, $c7, $c9, $cc, $ce, $d1, $d3, $d5, $d8, $da, $dc, $de, $e0, $e2, $e4, $e6, $e8, $ea, $eb, $ed, $ef, $f0, $f1, $f3, $f4, $f5, $f6, $f8, $f9, $fa, $fa, $fb, $fc, $fd, $fd, $fe, $fe, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $fe, $fe, $fe, $fd, $fd, $fc, $fb, $fa, $fa, $f9, $f8, $f6, $f5, $f4, $f3, $f1, $f0, $ef, $ed, $eb, $ea, $e8, $e6, $e4, $e2, $e0, $de, $dc, $da, $d8, $d5, $d3, $d1, $ce, $cc, $c9, $c7, $c4, $c1, $bf, $bc, $b9, $b6, $b3, $b1, $ae, $ab, $a8, $a5, $a2, $9f, $9c, $99, $96, $93, $90, $8c, $89, $86, $83
  xbuf: .fill $28, 0
  ybuf: .fill $19, 0
  bittab: .byte 1, 2, 4, 8, $10, $20, $40, $80
