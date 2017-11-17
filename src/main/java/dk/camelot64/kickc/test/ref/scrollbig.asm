.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .const PROCPORT = 1
  .const CHARGEN = $d000
  .const SCREEN = $400
  .const RASTER = $d012
  .const BGCOL = $d020
  .const SCROLL = $d016
  .label current_bit = 2
  .label nxt = 7
  .label current_chargen = 3
  TEXT: .text "-= this is rex of camelot testing a scroller created in kickc. kickc is an optimizing c-compiler for 6502 assembler. =-     @"
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
    rts
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
    .label _8 = 3
    .label c = 9
    .label sc = 5
    jsr scroll_hard
    lda current_bit
    lsr
    sta current_bit
    bne b1
    jsr next_char
    sta c
    lda #0
    sta c+1
    asl c
    rol c+1
    asl c
    rol c+1
    asl c
    rol c+1
    lda #<CHARGEN
    clc
    adc c
    sta _8
    lda #>CHARGEN
    adc c+1
    sta _8+1
    lda #$80
    sta current_bit
  b1:
    sei
    lda #$32
    sta PROCPORT
    lda #<SCREEN+$28+$27
    sta sc
    lda #>SCREEN+$28+$27
    sta sc+1
    ldx #0
  b2:
    stx $ff
    ldy $ff
    lda (current_chargen),y
    and current_bit
    cmp #0
    beq b3_from_b2
    lda #'*'
    jmp b3
  b3_from_b2:
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
scroll_hard: {
    .const line0 = SCREEN+$28*0
    .const line1 = SCREEN+$28*1
    .const line2 = SCREEN+$28*2
    .const line3 = SCREEN+$28*3
    .const line4 = SCREEN+$28*4
    .const line5 = SCREEN+$28*5
    .const line6 = SCREEN+$28*6
    .const line7 = SCREEN+$28*7
    ldx #0
  b1:
    lda line0+1,x
    sta line0,x
    lda line1+1,x
    sta line1,x
    lda line2+1,x
    sta line2,x
    lda line3+1,x
    sta line3,x
    lda line4+1,x
    sta line4,x
    lda line5+1,x
    sta line5,x
    lda line6+1,x
    sta line6,x
    lda line7+1,x
    sta line7,x
    inx
    cpx #$27
    bne b1
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
    ldy #0
    lda #fill
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
