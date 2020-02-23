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
  __b1:
    // *cursor = TEXT[i]
    lda TEXT,x
    ldy #0
    sta (cursor),y
    // if(++i==8)
    inx
    cpx #8
    bne __b2
    ldx #0
  __b2:
    // while(++cursor<SCREEN+1000)
    inc.z cursor
    bne !+
    inc.z cursor+1
  !:
    lda.z cursor+1
    cmp #>SCREEN+$3e8
    bcc __b1
    bne !+
    lda.z cursor
    cmp #<SCREEN+$3e8
    bcc __b1
  !:
    // }
    rts
}
  TEXT: .text "camelot "
