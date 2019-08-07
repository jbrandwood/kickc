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
    sta.z nxt
    lda #>TEXT
    sta.z nxt+1
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
    dex
    cpx #$ff
    bne b4
    ldx #0
  b6:
    lda line+1,x
    sta line,x
    inx
  // Hard scroll
    cpx #$27
    bne b6
    // Render next char
    ldy #0
    lda (nxt),y
    tax
    cpx #0
    bne b9
    ldx TEXT
    lda #<TEXT
    sta.z nxt
    lda #>TEXT
    sta.z nxt+1
  b9:
    stx line+$27
    inc.z nxt
    bne !+
    inc.z nxt+1
  !:
    ldx #7
  b4:
    stx SCROLL
    dec BGCOL
    jmp b1
}
fillscreen: {
    .const fill = $20
    .label cursor = 2
    lda #<SCREEN
    sta.z cursor
    lda #>SCREEN
    sta.z cursor+1
  b2:
    lda #fill
    ldy #0
    sta (cursor),y
    inc.z cursor
    bne !+
    inc.z cursor+1
  !:
    lda.z cursor+1
    cmp #>SCREEN+$3e8
    bcc b2
    bne !+
    lda.z cursor
    cmp #<SCREEN+$3e8
    bcc b2
  !:
    rts
}
  TEXT: .text "-= this is rex of camelot testing a scroller created in kickc. kickc is an optimizing c-compiler for 6502 assembler. =-     "
  .byte 0
