// An 8x8 char letter scroller
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label PROCPORT = 1
  .label CHARGEN = $d000
  .label SCREEN = $400
  .label RASTER = $d012
  .label BGCOL = $d020
  .label SCROLL = $d016
  .label current_bit = 2
  .label current_chargen = 7
  .label nxt = 5
main: {
    jsr fillscreen
    lda #<CHARGEN
    sta current_chargen
    lda #>CHARGEN
    sta current_chargen+1
    lda #<TEXT
    sta nxt
    lda #>TEXT
    sta nxt+1
    lda #1
    sta current_bit
    ldx #7
  // Wait for raster
  b1:
    lda #$fe
    cmp RASTER
    bne b1
  b2:
    lda #$ff
    cmp RASTER
    bne b2
    inc BGCOL
    jsr scroll_soft
    dec BGCOL
    jmp b1
}
scroll_soft: {
    dex
    cpx #$ff
    bne b1
    jsr scroll_bit
    ldx #7
  b1:
    stx SCROLL
    rts
}
scroll_bit: {
    .label _7 = 7
    .label c = 7
    .label sc = 3
    lsr current_bit
    lda current_bit
    cmp #0
    bne b1
    jsr next_char
    txa
    sta c
    lda #0
    sta c+1
    asl _7
    rol _7+1
    asl _7
    rol _7+1
    asl _7
    rol _7+1
    clc
    lda current_chargen
    adc #<CHARGEN
    sta current_chargen
    lda current_chargen+1
    adc #>CHARGEN
    sta current_chargen+1
    lda #$80
    sta current_bit
  b1:
    jsr scroll_hard
    sei
    lda #$32
    sta PROCPORT
    lda #<SCREEN+$28+$27
    sta sc
    lda #>SCREEN+$28+$27
    sta sc+1
    ldx #0
  b3:
    txa
    tay
    lda (current_chargen),y
    and current_bit
    cmp #0
    beq b2
    lda #$80+' '
    jmp b4
  b2:
    lda #' '
  b4:
    ldy #0
    sta (sc),y
    lda #$28
    clc
    adc sc
    sta sc
    bcc !+
    inc sc+1
  !:
    inx
    cpx #8
    bne b3
    lda #$37
    sta PROCPORT
    cli
    rts
}
scroll_hard: {
    ldx #0
  b2:
    lda SCREEN+1,x
    sta SCREEN,x
    lda SCREEN+$28*1+1,x
    sta SCREEN+$28*1,x
    lda SCREEN+$28*2+1,x
    sta SCREEN+$28*2,x
    lda SCREEN+$28*3+1,x
    sta SCREEN+$28*3,x
    lda SCREEN+$28*4+1,x
    sta SCREEN+$28*4,x
    lda SCREEN+$28*5+1,x
    sta SCREEN+$28*5,x
    lda SCREEN+$28*6+1,x
    sta SCREEN+$28*6,x
    lda SCREEN+$28*7+1,x
    sta SCREEN+$28*7,x
    inx
  // Hard scroll
    cpx #$27
    bne b2
    rts
}
// Find the next char of the scroll text
next_char: {
    ldy #0
    lda (nxt),y
    tax
    cpx #0
    bne b1
    ldx TEXT
    lda #<TEXT
    sta nxt
    lda #>TEXT
    sta nxt+1
  b1:
    inc nxt
    bne !+
    inc nxt+1
  !:
    rts
}
// Fill the screen with one char
fillscreen: {
    .const fill = $20
    .label cursor = 7
    lda #<SCREEN
    sta cursor
    lda #>SCREEN
    sta cursor+1
  b2:
    lda #fill
    ldy #0
    sta (cursor),y
    inc cursor
    bne !+
    inc cursor+1
  !:
    lda cursor+1
    cmp #>SCREEN+$3e8
    bcc b2
    bne !+
    lda cursor
    cmp #<SCREEN+$3e8
    bcc b2
  !:
    rts
}
  TEXT: .text "-= this is rex of camelot testing a scroller created in kickc. kickc is an optimizing c-compiler for 6502 assembler. =-     "
  .byte 0
