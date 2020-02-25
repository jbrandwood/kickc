// A KickC version of the fire routine from the CC65 samples
// (w)2002 by groepaz/hitmen
// Cleanup and porting to CC65 by Ullrich von Bassewitz and Greg King .
// Ported to KickC by Jesper Gravgaard.
// Original source https://github.com/cc65/cc65/blob/master/samples/fire.c
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label BORDERCOL = $d020
  .label BGCOL = $d021
  .label D018 = $d018
  // Color Ram
  .label COLS = $d800
  // The colors of the C64
  .const BLACK = 0
  .const YELLOW = 7
  // SID registers for random number generation
  .label SID_VOICE3_FREQ = $d40e
  .label SID_VOICE3_CONTROL = $d412
  .const SID_CONTROL_NOISE = $80
  .label SID_VOICE3_OSC = $d41b
  .label SCREEN1 = $3800
  .label SCREEN2 = $3c00
  .label BUFFER = $4000
  .label CHARSET = $3000
main: {
    .const toD0181_return = (>(SCREEN1&$3fff)*4)|(>CHARSET)/4&$f
    .const toD0182_return = (>(SCREEN2&$3fff)*4)|(>CHARSET)/4&$f
    // asm
    sei
    // *BORDERCOL = BLACK
    lda #BLACK
    sta BORDERCOL
    // *BGCOL = BLACK
    sta BGCOL
    // fillscreen(BUFFER, 00)
    lda #<BUFFER
    sta.z fillscreen.screen
    lda #>BUFFER
    sta.z fillscreen.screen+1
    ldx #0
    jsr fillscreen
    // fillscreen(SCREEN1, 00)
    lda #<SCREEN1
    sta.z fillscreen.screen
    lda #>SCREEN1
    sta.z fillscreen.screen+1
    ldx #0
    jsr fillscreen
    // fillscreen(SCREEN2, 00)
    lda #<SCREEN2
    sta.z fillscreen.screen
    lda #>SCREEN2
    sta.z fillscreen.screen+1
    ldx #0
    jsr fillscreen
    // fillscreen(COLS, YELLOW)
    lda #<COLS
    sta.z fillscreen.screen
    lda #>COLS
    sta.z fillscreen.screen+1
    ldx #YELLOW
    jsr fillscreen
    // sid_rnd_init()
    jsr sid_rnd_init
    // makecharset(CHARSET)
    jsr makecharset
  __b1:
    // fire(SCREEN1)
    lda #<SCREEN1
    sta.z fire.screen
    lda #>SCREEN1
    sta.z fire.screen+1
    jsr fire
    // *D018 = toD018(SCREEN1, CHARSET)
    lda #toD0181_return
    sta D018
    // fire(SCREEN2)
    lda #<SCREEN2
    sta.z fire.screen
    lda #>SCREEN2
    sta.z fire.screen+1
    jsr fire
    // *D018 = toD018(SCREEN2, CHARSET)
    lda #toD0182_return
    sta D018
    jmp __b1
}
// Animate the fire on the passed screen. Uses BUFFER to store the current values.
fire: {
    .label screen = 2
    .label screen_1 = $b
    .label buffer = 4
    .label buffer_1 = 9
    lda.z screen
    sta.z screen_1
    lda.z screen+1
    sta.z screen_1+1
    lda #<BUFFER
    sta.z buffer
    lda #>BUFFER
    sta.z buffer+1
  __b1:
    // while (buffer != (BUFFER + (24 * 40)))
    lda.z buffer+1
    cmp #>BUFFER+$18*$28
    bne __b2
    lda.z buffer
    cmp #<BUFFER+$18*$28
    bne __b2
    // screen = (screenbase + (24 * 40))
    clc
    lda.z screen
    adc #<$18*$28
    sta.z screen
    lda.z screen+1
    adc #>$18*$28
    sta.z screen+1
    lda #<BUFFER+$18*$28
    sta.z buffer_1
    lda #>BUFFER+$18*$28
    sta.z buffer_1+1
  __b6:
    // for(; buffer != (BUFFER+(25*40)); ++screen, ++buffer)
    lda.z buffer_1+1
    cmp #>BUFFER+$19*$28
    bne __b7
    lda.z buffer_1
    cmp #<BUFFER+$19*$28
    bne __b7
    // }
    rts
  __b7:
    // sid_rnd()
    jsr sid_rnd
    // (sid_rnd())/$10
    lsr
    lsr
    lsr
    lsr
    // 0x30 + (sid_rnd())/$10
    clc
    adc #$30
    // *buffer = 0x30 + (sid_rnd())/$10
    ldy #0
    sta (buffer_1),y
    // *screen = *buffer = 0x30 + (sid_rnd())/$10
    lda (buffer_1),y
    sta (screen),y
    // for(; buffer != (BUFFER+(25*40)); ++screen, ++buffer)
    inc.z screen
    bne !+
    inc.z screen+1
  !:
    inc.z buffer_1
    bne !+
    inc.z buffer_1+1
  !:
    jmp __b6
  __b2:
    // buffer[40-1] + buffer[40-1]
    ldy #$28-1
    clc
    lda (buffer),y
    adc (buffer),y
    // buffer[40-1] + buffer[40-1] + buffer[40]
    ldy #$28
    clc
    adc (buffer),y
    // buffer[40-1] + buffer[40-1] + buffer[40] + buffer[41]
    ldy #$29
    clc
    adc (buffer),y
    // c = ( buffer[40-1] + buffer[40-1] + buffer[40] + buffer[41] )/4
    lsr
    lsr
    // if (c > 2)
    cmp #2+1
    bcc __b4
    // c -= 3
    sec
    sbc #3
  __b4:
    // *buffer = c
    ldy #0
    sta (buffer),y
    // *screen = *buffer = c
    lda (buffer),y
    sta (screen_1),y
    // ++screen;
    inc.z screen_1
    bne !+
    inc.z screen_1+1
  !:
    // ++buffer;
    inc.z buffer
    bne !+
    inc.z buffer+1
  !:
    jmp __b1
}
// Get a random number from the SID voice 3,
// Must be initialized with sid_rnd_init()
sid_rnd: {
    // return *SID_VOICE3_OSC;
    lda SID_VOICE3_OSC
    // }
    rts
}
// Make a fire-friendly charset in chars $00-$3f of the passed charset
makecharset: {
    .label __13 = $d
    .label __15 = $b
    .label __16 = $b
    .label __17 = $b
    .label font = 2
    .label font1 = 4
    .label c = 6
    .label i = 7
    .label ii = 8
    .label __18 = $b
    lda #<CHARSET
    sta.z font
    lda #>CHARSET
    sta.z font+1
  __b1:
    // for (unsigned char *font = charset; font != (charset+(1*8)); ++font)
    lda.z font+1
    cmp #>CHARSET+1*8
    beq !__b2+
    jmp __b2
  !__b2:
    lda.z font
    cmp #<CHARSET+1*8
    beq !__b2+
    jmp __b2
  !__b2:
    lda #<CHARSET+$40*8
    sta.z font1
    lda #>CHARSET+$40*8
    sta.z font1+1
  __b3:
    // for (unsigned char *font = (charset+(64*8)); font != (charset+(256*8)); ++font)
    lda.z font1+1
    cmp #>CHARSET+$100*8
    beq !__b4+
    jmp __b4
  !__b4:
    lda.z font1
    cmp #<CHARSET+$100*8
    beq !__b4+
    jmp __b4
  !__b4:
    lda #0
    sta.z c
  __b5:
    // for (unsigned char c = 0; c < 0x40; ++c)
    lda.z c
    cmp #$40
    bcc b1
    // }
    rts
  b1:
    ldx #0
    txa
    sta.z i
  __b6:
    // for (unsigned char bc = 0, i = 0; i < 8; i++)
    lda.z i
    cmp #8
    bcc b2
    // for (unsigned char c = 0; c < 0x40; ++c)
    inc.z c
    jmp __b5
  b2:
    ldy #0
    tya
    sta.z ii
  __b8:
    // for (unsigned char ii = 0; ii < 8; ii++)
    lda.z ii
    cmp #8
    bcc __b9
    // (unsigned short)c
    lda.z c
    sta.z __15
    lda #0
    sta.z __15+1
    // ((unsigned short)c) << 3
    asl.z __16
    rol.z __16+1
    asl.z __16
    rol.z __16+1
    asl.z __16
    rol.z __16+1
    // (((unsigned short)c) << 3) + i
    lda.z i
    clc
    adc.z __17
    sta.z __17
    bcc !+
    inc.z __17+1
  !:
    // (charset + (1 * 8)) [(((unsigned short)c) << 3) + i] = b
    clc
    lda.z __18
    adc #<CHARSET+1*8
    sta.z __18
    lda.z __18+1
    adc #>CHARSET+1*8
    sta.z __18+1
    tya
    ldy #0
    sta (__18),y
    // for (unsigned char bc = 0, i = 0; i < 8; i++)
    inc.z i
    jmp __b6
  __b9:
    // bc += c
    txa
    clc
    adc.z c
    tax
    // if (bc > 0x3f)
    cpx #$3f+1
    bcc __b11
    // bc = bc - 0x40
    txa
    axs #$40
    // i & 1
    lda #1
    and.z i
    // ii + (i & 1)
    clc
    adc.z ii
    // (ii + (i & 1)) & 0x7
    and #7
    sta.z __13
    // b += bittab[(ii + (i & 1)) & 0x7]
    tya
    ldy.z __13
    clc
    adc bittab,y
    tay
  __b11:
    // for (unsigned char ii = 0; ii < 8; ii++)
    inc.z ii
    jmp __b8
  __b4:
    // *font = 0xff
    lda #$ff
    ldy #0
    sta (font1),y
    // for (unsigned char *font = (charset+(64*8)); font != (charset+(256*8)); ++font)
    inc.z font1
    bne !+
    inc.z font1+1
  !:
    jmp __b3
  __b2:
    // *font = 0x00
    lda #0
    tay
    sta (font),y
    // for (unsigned char *font = charset; font != (charset+(1*8)); ++font)
    inc.z font
    bne !+
    inc.z font+1
  !:
    jmp __b1
    bittab: .byte 1, 2, 4, 8, $10, $20, $40, $80
}
// Initialize SID voice 3 for random number generation
sid_rnd_init: {
    // *SID_VOICE3_FREQ = $ffff
    lda #<$ffff
    sta SID_VOICE3_FREQ
    lda #>$ffff
    sta SID_VOICE3_FREQ+1
    // *SID_VOICE3_CONTROL = SID_CONTROL_NOISE
    lda #SID_CONTROL_NOISE
    sta SID_VOICE3_CONTROL
    // }
    rts
}
// Fill a screen (1000 bytes) with a specific byte
// fillscreen(byte* zp($b) screen, byte register(X) fill)
fillscreen: {
    .label screen = $b
    .label i = 9
    lda #<0
    sta.z i
    sta.z i+1
  __b1:
    // *screen++ = fill
    txa
    ldy #0
    sta (screen),y
    // *screen++ = fill;
    inc.z screen
    bne !+
    inc.z screen+1
  !:
    // for( unsigned word i : 0..999)
    inc.z i
    bne !+
    inc.z i+1
  !:
    lda.z i+1
    cmp #>$3e8
    bne __b1
    lda.z i
    cmp #<$3e8
    bne __b1
    // }
    rts
}
