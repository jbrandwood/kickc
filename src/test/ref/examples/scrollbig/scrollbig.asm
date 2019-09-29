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
    sta.z current_chargen
    lda #>CHARGEN
    sta.z current_chargen+1
    lda #<TEXT
    sta.z nxt
    lda #>TEXT
    sta.z nxt+1
    lda #1
    sta.z current_bit
    ldx #7
  // Wait for raster
  __b1:
    lda #$fe
    cmp RASTER
    bne __b1
  __b2:
    lda #$ff
    cmp RASTER
    bne __b2
    inc BGCOL
    jsr scroll_soft
    dec BGCOL
    jmp __b1
}
scroll_soft: {
    dex
    cpx #$ff
    bne __b1
    jsr scroll_bit
    ldx #7
  __b1:
    stx SCROLL
    rts
}
scroll_bit: {
    .label __7 = 7
    .label c = 7
    .label sc = 3
    lsr.z current_bit
    lda.z current_bit
    cmp #0
    bne __b1
    jsr next_char
    txa
    sta.z c
    lda #0
    sta.z c+1
    asl.z __7
    rol.z __7+1
    asl.z __7
    rol.z __7+1
    asl.z __7
    rol.z __7+1
    clc
    lda.z current_chargen
    adc #<CHARGEN
    sta.z current_chargen
    lda.z current_chargen+1
    adc #>CHARGEN
    sta.z current_chargen+1
    lda #$80
    sta.z current_bit
  __b1:
    jsr scroll_hard
    sei
    lda #$32
    sta PROCPORT
    lda #<SCREEN+$28+$27
    sta.z sc
    lda #>SCREEN+$28+$27
    sta.z sc+1
    ldx #0
  __b3:
    txa
    tay
    lda (current_chargen),y
    and.z current_bit
    cmp #0
    beq b1
    lda #$80+' '
    jmp __b4
  b1:
    lda #' '
  __b4:
    ldy #0
    sta (sc),y
    lda #$28
    clc
    adc.z sc
    sta.z sc
    bcc !+
    inc.z sc+1
  !:
    inx
    cpx #8
    bne __b3
    lda #$37
    sta PROCPORT
    cli
    rts
}
scroll_hard: {
    ldx #0
  // Hard scroll
  __b1:
    cpx #$27
    bne __b2
    rts
  __b2:
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
    jmp __b1
}
// Find the next char of the scroll text
next_char: {
    ldy #0
    lda (nxt),y
    tax
    cpx #0
    bne __b1
    ldx TEXT
    lda #<TEXT
    sta.z nxt
    lda #>TEXT
    sta.z nxt+1
  __b1:
    inc.z nxt
    bne !+
    inc.z nxt+1
  !:
    rts
}
// Fill the screen with one char
fillscreen: {
    .const fill = $20
    .label cursor = 7
    lda #<SCREEN
    sta.z cursor
    lda #>SCREEN
    sta.z cursor+1
  __b1:
    lda.z cursor+1
    cmp #>SCREEN+$3e8
    bcc __b2
    bne !+
    lda.z cursor
    cmp #<SCREEN+$3e8
    bcc __b2
  !:
    rts
  __b2:
    lda #fill
    ldy #0
    sta (cursor),y
    inc.z cursor
    bne !+
    inc.z cursor+1
  !:
    jmp __b1
}
  TEXT: .text "-= this is rex of camelot testing a scroller created in kickc. kickc is an optimizing c-compiler for 6502 assembler. =-     "
  .byte 0
