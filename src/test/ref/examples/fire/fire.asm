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
    sei
    lda #BLACK
    sta BORDERCOL
    sta BGCOL
    lda #<BUFFER
    sta.z fillscreen.screen
    lda #>BUFFER
    sta.z fillscreen.screen+1
    ldx #0
    jsr fillscreen
    lda #<SCREEN1
    sta.z fillscreen.screen
    lda #>SCREEN1
    sta.z fillscreen.screen+1
    ldx #0
    jsr fillscreen
    lda #<SCREEN2
    sta.z fillscreen.screen
    lda #>SCREEN2
    sta.z fillscreen.screen+1
    ldx #0
    jsr fillscreen
    lda #<COLS
    sta.z fillscreen.screen
    lda #>COLS
    sta.z fillscreen.screen+1
    ldx #YELLOW
    jsr fillscreen
    jsr sid_rnd_init
    jsr makecharset
  b1:
    lda #<SCREEN1
    sta.z fire.screen
    lda #>SCREEN1
    sta.z fire.screen+1
    jsr fire
    lda #toD0181_return
    sta D018
    lda #<SCREEN2
    sta.z fire.screen
    lda #>SCREEN2
    sta.z fire.screen+1
    jsr fire
    lda #toD0182_return
    sta D018
    jmp b1
}
// Animate the fire on the passed screen. Uses BUFFER to store the current values.
fire: {
    .label screen = 2
    .label screen_2 = $b
    .label buffer = 4
    .label buffer_3 = 9
    .label screen_4 = $b
    .label buffer_10 = 9
    .label screen_11 = $b
    lda.z screen
    sta.z screen_11
    lda.z screen+1
    sta.z screen_11+1
    lda #<BUFFER
    sta.z buffer
    lda #>BUFFER
    sta.z buffer+1
  b1:
    lda.z buffer+1
    cmp #>BUFFER+$18*$28
    bne b2
    lda.z buffer
    cmp #<BUFFER+$18*$28
    bne b2
    clc
    lda.z screen
    adc #<$18*$28
    sta.z screen
    lda.z screen+1
    adc #>$18*$28
    sta.z screen+1
    lda #<BUFFER+$18*$28
    sta.z buffer_10
    lda #>BUFFER+$18*$28
    sta.z buffer_10+1
  b6:
    lda.z buffer_10+1
    cmp #>BUFFER+$19*$28
    bne b7
    lda.z buffer_10
    cmp #<BUFFER+$19*$28
    bne b7
    rts
  b7:
    jsr sid_rnd
    lsr
    lsr
    lsr
    lsr
    clc
    adc #$30
    ldy #0
    sta (buffer_10),y
    lda (buffer_10),y
    sta (screen),y
    inc.z screen
    bne !+
    inc.z screen+1
  !:
    inc.z buffer_3
    bne !+
    inc.z buffer_3+1
  !:
    jmp b6
  b2:
    ldy #$28-1
    clc
    lda (buffer),y
    adc (buffer),y
    ldy #$28
    clc
    adc (buffer),y
    ldy #$29
    clc
    adc (buffer),y
    lsr
    lsr
    cmp #2+1
    bcc b4
    sec
    sbc #3
  b4:
    ldy #0
    sta (buffer),y
    lda (buffer),y
    sta (screen_4),y
    inc.z screen_2
    bne !+
    inc.z screen_2+1
  !:
    inc.z buffer
    bne !+
    inc.z buffer+1
  !:
    jmp b1
}
// Get a random number from the SID voice 3,
// Must be initialized with sid_rnd_init()
sid_rnd: {
    lda SID_VOICE3_OSC
    rts
}
// Make a fire-friendly charset in chars $00-$3f of the passed charset
makecharset: {
    .label _13 = $d
    .label _15 = $b
    .label _16 = $b
    .label _17 = $b
    .label font = 2
    .label font1 = 4
    .label c = 6
    .label i = 7
    .label ii = 8
    .label _18 = $b
    lda #<CHARSET
    sta.z font
    lda #>CHARSET
    sta.z font+1
  b1:
    lda.z font+1
    cmp #>CHARSET+1*8
    beq !b2+
    jmp b2
  !b2:
    lda.z font
    cmp #<CHARSET+1*8
    beq !b2+
    jmp b2
  !b2:
    lda #<CHARSET+$40*8
    sta.z font1
    lda #>CHARSET+$40*8
    sta.z font1+1
  b3:
    lda.z font1+1
    cmp #>CHARSET+$100*8
    beq !b4+
    jmp b4
  !b4:
    lda.z font1
    cmp #<CHARSET+$100*8
    beq !b4+
    jmp b4
  !b4:
    lda #0
    sta.z c
  b5:
    lda.z c
    cmp #$40
    bcc b7
    rts
  b7:
    ldx #0
    txa
    sta.z i
  b6:
    lda.z i
    cmp #8
    bcc b10
    inc.z c
    jmp b5
  b10:
    ldy #0
    tya
    sta.z ii
  b8:
    lda.z ii
    cmp #8
    bcc b9
    lda.z c
    sta.z _15
    lda #0
    sta.z _15+1
    asl.z _16
    rol.z _16+1
    asl.z _16
    rol.z _16+1
    asl.z _16
    rol.z _16+1
    lda.z i
    clc
    adc.z _17
    sta.z _17
    bcc !+
    inc.z _17+1
  !:
    clc
    lda.z _18
    adc #<CHARSET+1*8
    sta.z _18
    lda.z _18+1
    adc #>CHARSET+1*8
    sta.z _18+1
    tya
    ldy #0
    sta (_18),y
    inc.z i
    jmp b6
  b9:
    txa
    clc
    adc.z c
    tax
    cpx #$3f+1
    bcc b11
    txa
    axs #$40
    lda #1
    and.z i
    clc
    adc.z ii
    and #7
    sta.z _13
    tya
    ldy.z _13
    clc
    adc bittab,y
    tay
  b11:
    inc.z ii
    jmp b8
  b4:
    lda #$ff
    ldy #0
    sta (font1),y
    inc.z font1
    bne !+
    inc.z font1+1
  !:
    jmp b3
  b2:
    lda #0
    tay
    sta (font),y
    inc.z font
    bne !+
    inc.z font+1
  !:
    jmp b1
    bittab: .byte 1, 2, 4, 8, $10, $20, $40, $80
}
// Initialize SID voice 3 for random number generation
sid_rnd_init: {
    lda #<$ffff
    sta SID_VOICE3_FREQ
    lda #>$ffff
    sta SID_VOICE3_FREQ+1
    lda #SID_CONTROL_NOISE
    sta SID_VOICE3_CONTROL
    rts
}
// Fill a screen (1000 bytes) with a specific byte
// fillscreen(byte* zeropage($b) screen, byte register(X) fill)
fillscreen: {
    .label screen = $b
    .label i = 9
    lda #<0
    sta.z i
    sta.z i+1
  b1:
    txa
    ldy #0
    sta (screen),y
    inc.z screen
    bne !+
    inc.z screen+1
  !:
    inc.z i
    bne !+
    inc.z i+1
  !:
    lda.z i+1
    cmp #>$3e8
    bne b1
    lda.z i
    cmp #<$3e8
    bne b1
    rts
}
