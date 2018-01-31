.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
  jsr main
main: {
    .label cursor = 2
    lda #<SCREEN
    sta cursor
    lda #>SCREEN
    sta cursor+1
    ldx #0
  b1:
    lda TEXT,x
    ldy #0
    sta (cursor),y
    inx
    cpx #8
    bne b2
    ldx #0
  b2:
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
  TEXT: .text "camelot "
