// Tests the sizeof() operator on arrays
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
  .const SIZEOF_BYTE = 1
  .const SIZEOF_WORD = 2
main: {
    .const sz = 7
    // SCREEN[idx++] = '0'+sizeof(ba)/sizeof(byte)
    lda #'0'+3*SIZEOF_BYTE/SIZEOF_BYTE
    sta SCREEN
    // SCREEN[idx++] = '0'+sizeof(wa)/sizeof(word)
    lda #'0'+3*SIZEOF_WORD/SIZEOF_WORD
    sta SCREEN+1
    // SCREEN[idx++] = '0'+sizeof(bb)/sizeof(byte)
    lda #'0'+(sz+2)*SIZEOF_BYTE/SIZEOF_BYTE
    sta SCREEN+2
    // SCREEN[idx++] = '0'+sizeof(wb)/sizeof(word)
    lda #'0'+4*SIZEOF_WORD/SIZEOF_WORD
    sta SCREEN+3
    // SCREEN[idx++] = '0'+sizeof(sa)/sizeof(byte)
    lda #'0'+8*SIZEOF_BYTE/SIZEOF_BYTE
    sta SCREEN+4
    // SCREEN[idx++] = '0'+sizeof(sb)/sizeof(byte)
    lda #'0'+4*SIZEOF_BYTE/SIZEOF_BYTE
    sta SCREEN+5
    // }
    rts
}
