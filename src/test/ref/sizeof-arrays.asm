// Tests the sizeof() operator on arrays
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .const SIZEOF_BYTE = 1
  .const SIZEOF_WORD = 2
  .label SCREEN = $400
main: {
    .const sz = 7
    lda #'0'+3*SIZEOF_BYTE/SIZEOF_BYTE
    sta SCREEN
    lda #'0'+3*SIZEOF_WORD/SIZEOF_WORD
    sta SCREEN+1
    lda #'0'+(sz+2)*SIZEOF_BYTE/SIZEOF_BYTE
    sta SCREEN+2
    lda #'0'+4*SIZEOF_WORD/SIZEOF_WORD
    sta SCREEN+3
    lda #'0'+8*SIZEOF_BYTE/SIZEOF_BYTE
    sta SCREEN+4
    lda #'0'+4*SIZEOF_BYTE/SIZEOF_BYTE
    sta SCREEN+5
    rts
}
