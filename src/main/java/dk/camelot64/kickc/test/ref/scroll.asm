  .const SCREEN = $400
  .const RASTER = $d012
  .const BGCOL = $d020
  .const SCROLL = $d016
  TEXT: .text "-= this is rex of camelot testing a scroller created in kickc. kickc is an optimizing c-compiler for 6502 assembler. =-     @"
  jsr main
main: {
    .const line = SCREEN+$28
    .label nxt = 2
    jsr fillscreen
    lda #<TEXT
    sta nxt
    lda #>TEXT
    sta nxt+1
    ldx #7
  b2:
    lda RASTER
    cmp #$fe
    bne b2
  b3:
    lda RASTER
    cmp #$ff
    bne b3
    lda BGCOL
    clc
    adc #1
    sta BGCOL
    dex
    cpx #$ff
    bne b4
    ldx #0
  b5:
    lda line+1,x
    sta line,x
    inx
    cpx #$27
    bne b5
    ldy #0
    lda (nxt),y
    tax
    cpx #'@'
    bne b6
    ldx TEXT
    lda #<TEXT
    sta nxt
    lda #>TEXT
    sta nxt+1
  b6:
    stx line+$27
    inc nxt
    bne !+
    inc nxt+1
  !:
    ldx #7
  b4:
    stx SCROLL
    lda BGCOL
    sec
    sbc #1
    sta BGCOL
    jmp b2
    rts
}
fillscreen: {
    .const fill = $20
    .label cursor = 2
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
