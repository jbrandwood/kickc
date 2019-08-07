.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
main: {
    .label cursor = 2
    lda #<SCREEN
    sta.z cursor
    lda #>SCREEN
    sta.z cursor+1
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
    inc.z cursor
    bne !+
    inc.z cursor+1
  !:
    lda.z cursor+1
    cmp #>SCREEN+$3e8
    bcc b1
    bne !+
    lda.z cursor
    cmp #<SCREEN+$3e8
    bcc b1
  !:
    rts
}
  TEXT: .text "camelot "
