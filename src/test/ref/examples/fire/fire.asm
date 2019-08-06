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
    sta fillscreen.screen
    lda #>BUFFER
    sta fillscreen.screen+1
    ldx #0
    jsr fillscreen
    lda #<SCREEN1
    sta fillscreen.screen
    lda #>SCREEN1
    sta fillscreen.screen+1
    ldx #0
    jsr fillscreen
    lda #<SCREEN2
    sta fillscreen.screen
    lda #>SCREEN2
    sta fillscreen.screen+1
    ldx #0
    jsr fillscreen
    lda #<COLS
    sta fillscreen.screen
    lda #>COLS
    sta fillscreen.screen+1
    ldx #YELLOW
    jsr fillscreen
    jsr sid_rnd_init
    jsr makecharset
  b1:
    lda #<SCREEN1
    sta fire.screen
    lda #>SCREEN1
    sta fire.screen+1
    jsr fire
    lda #toD0181_return
    sta D018
    lda #<SCREEN2
    sta fire.screen
    lda #>SCREEN2
    sta fire.screen+1
    jsr fire
    lda #toD0182_return
    sta D018
    jmp b1
}
// Animate the fire on the passed screen. Uses BUFFER to store the current values.
fire: {
    .label screen = 2
    .label screen_2 = $c
    .label buffer = 4
    .label buffer_3 = 9
    .label buffer_7 = 9
    .label screen_10 = $c
    .label screen_15 = $c
    lda screen
    sta screen_15
    lda screen+1
    sta screen_15+1
    lda #<BUFFER
    sta buffer
    lda #>BUFFER
    sta buffer+1
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
    sta (screen_10),y
    inc screen_2
    bne !+
    inc screen_2+1
  !:
    inc buffer
    bne !+
    inc buffer+1
  !:
    lda buffer+1
    cmp #>BUFFER+$18*$28
    bne b2
    lda buffer
    cmp #<BUFFER+$18*$28
    bne b2
    clc
    lda screen
    adc #<$18*$28
    sta screen
    lda screen+1
    adc #>$18*$28
    sta screen+1
    lda #<BUFFER+$18*$28
    sta buffer_7
    lda #>BUFFER+$18*$28
    sta buffer_7+1
  b6:
    jsr sid_rnd
    lsr
    lsr
    lsr
    lsr
    clc
    adc #$30
    ldy #0
    sta (buffer_7),y
    lda (buffer_7),y
    sta (screen),y
    inc screen
    bne !+
    inc screen+1
  !:
    inc buffer_3
    bne !+
    inc buffer_3+1
  !:
    lda buffer_3+1
    cmp #>BUFFER+$19*$28
    bne b6
    lda buffer_3
    cmp #<BUFFER+$19*$28
    bne b6
    rts
}
// Get a random number from the SID voice 3,
// Must be initialized with sid_rnd_init()
sid_rnd: {
    lda SID_VOICE3_OSC
    rts
}
// Make a fire-friendly charset in chars $00-$3f of the passed charset
makecharset: {
    .label _10 = $b
    .label _13 = $c
    .label _14 = $c
    .label _15 = $c
    .label font = 2
    .label font1 = 4
    .label ii = 8
    .label i = 7
    .label c = 6
    .label _18 = $c
    lda #<CHARSET
    sta font
    lda #>CHARSET
    sta font+1
  b1:
    lda #0
    tay
    sta (font),y
    inc font
    bne !+
    inc font+1
  !:
    lda font+1
    cmp #>CHARSET+1*8
    bne b1
    lda font
    cmp #<CHARSET+1*8
    bne b1
    lda #<CHARSET+$40*8
    sta font1
    lda #>CHARSET+$40*8
    sta font1+1
  b2:
    lda #$ff
    ldy #0
    sta (font1),y
    inc font1
    bne !+
    inc font1+1
  !:
    lda font1+1
    cmp #>CHARSET+$100*8
    bne b2
    lda font1
    cmp #<CHARSET+$100*8
    bne b2
    lda #0
    sta c
  b3:
    lda #0
    sta i
    tax
  b4:
    ldy #0
    tya
    sta ii
  b5:
    txa
    clc
    adc c
    tax
    cpx #$3f+1
    bcc b6
    txa
    axs #$40
    lda #1
    and i
    clc
    adc ii
    and #7
    sta _10
    tya
    ldy _10
    clc
    adc bittab,y
    tay
  b6:
    inc ii
    lda ii
    cmp #8
    bcc b5
    lda c
    sta _13
    lda #0
    sta _13+1
    asl _14
    rol _14+1
    asl _14
    rol _14+1
    asl _14
    rol _14+1
    lda i
    clc
    adc _15
    sta _15
    bcc !+
    inc _15+1
  !:
    clc
    lda _18
    adc #<CHARSET+1*8
    sta _18
    lda _18+1
    adc #>CHARSET+1*8
    sta _18+1
    tya
    ldy #0
    sta (_18),y
    inc i
    lda i
    cmp #8
    bcc b4
    inc c
    lda c
    cmp #$40
    bcc b3
    rts
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
// fillscreen(byte* zeropage($c) screen, byte register(X) fill)
fillscreen: {
    .label screen = $c
    .label i = 9
    lda #<0
    sta i
    sta i+1
  b1:
    txa
    ldy #0
    sta (screen),y
    inc screen
    bne !+
    inc screen+1
  !:
    inc i
    bne !+
    inc i+1
  !:
    lda i+1
    cmp #>$3e8
    bne b1
    lda i
    cmp #<$3e8
    bne b1
    rts
}
