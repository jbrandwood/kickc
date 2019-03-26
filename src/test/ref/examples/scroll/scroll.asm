.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
  .label RASTER = $d012
  .label BGCOL = $d020
  .label SCROLL = $d016
main: {
    .label line = SCREEN+$28
    .label nxt = 2
    jsr fillscreen
    lda #<TEXT
    sta nxt
    lda #>TEXT
    sta nxt+1
    ldx #7
  // Wait for raster
  b2:
    lda #$fe
    cmp RASTER
    bne b2
  b3:
    lda #$ff
    cmp RASTER
    bne b3
    inc BGCOL
    dex
    cpx #$ff
    bne b4
    ldx #0
  // Hard scroll
  b5:
    lda line+1,x
    sta line,x
    inx
    cpx #$27
    bne b5
    // Render next char
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
    dec BGCOL
    jmp b2
}
fillscreen: {
    .const fill = $20
    .label cursor = 2
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
