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
  .label current_chargen = 3
  .label nxt = 7
  jsr main
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
  b2:
    lda RASTER
    cmp #$fe
    bne b2
  b3:
    lda RASTER
    cmp #$ff
    bne b3
    inc BGCOL
    jsr scroll_soft
    dec BGCOL
    jmp b2
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
    .label _4 = 3
    .label c = 3
    .label sc = 5
    lsr current_bit
    lda current_bit
    cmp #0
    bne b1
    jsr next_char
    sta c
    lda #0
    sta c+1
    asl _4
    rol _4+1
    asl _4
    rol _4+1
    asl _4
    rol _4+1
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
  b2:
    txa
    tay
    lda (current_chargen),y
    and current_bit
    cmp #0
    beq b4
    lda #$80+' '
    jmp b3
  b4:
    lda #' '
  b3:
    ldy #0
    sta (sc),y
    lda sc
    clc
    adc #$28
    sta sc
    bcc !+
    inc sc+1
  !:
    inx
    cpx #8
    bne b2
    lda #$37
    sta PROCPORT
    cli
    rts
}
scroll_hard: {
    ldx #0
  b1:
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
    cpx #$27
    bne b1
    rts
}
next_char: {
    ldy #0
    lda (nxt),y
    cmp #'@'
    bne b1
    lda TEXT
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
fillscreen: {
    .const fill = $20
    .label cursor = 3
    lda #<SCREEN
    sta cursor
    lda #>SCREEN
    sta cursor+1
  b1:
    lda #fill
    ldy #0
    sta (cursor),y
    inc cursor
    bne !+
    inc cursor+1
  !:
    lda cursor+1
    cmp #>SCREEN+$3e8
    bcc b1
    bne !+
    lda cursor
    cmp #<SCREEN+$3e8
    bcc b1
  !:
    rts
}
  TEXT: .text "-= this is rex of camelot testing a scroller created in kickc. kickc is an optimizing c-compiler for 6502 assembler. =-     @"
