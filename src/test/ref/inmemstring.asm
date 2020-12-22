  // Commodore 64 PRG executable file
.file [name="inmemstring.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .label SCREEN = $400
.segment Code
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
.segment Data
  TEXT: .text "camelot "
