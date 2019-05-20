// Tests the sizeof() operator on epressions
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .const SIZEOF_BYTE = 1
  .const SIZEOF_WORD = 2
  .const SIZEOF_POINTER = 2
  .label SCREEN = $400
  .const SIZEOF_NUMBER = $ff
main: {
    .const sz = $f
    .label b = 2
    .label w = 3
    // Simple types
    lda #0
    sta b
    sta w
    sta w+1
    //byte[] sb = { 'a', 'b', 'c', 0};
    lda #'0'+SIZEOF_NUMBER
    sta SCREEN
    lda #'0'+SIZEOF_BYTE
    sta SCREEN+1
    sta SCREEN+2
    sta SCREEN+3
    lda #'0'+SIZEOF_NUMBER
    sta SCREEN+5
    lda #'0'+SIZEOF_WORD
    sta SCREEN+6
    lda #'0'+SIZEOF_POINTER
    sta SCREEN+8
    sta SCREEN+9
    lda #'0'+3*SIZEOF_BYTE
    sta SCREEN+$b
    lda #'0'+3*SIZEOF_WORD
    sta SCREEN+$c
    lda #'0'+(sz+2)*SIZEOF_BYTE
    sta SCREEN+$d
    lda #'0'+4*SIZEOF_BYTE
    sta SCREEN+$e
    lda #'0'+8*SIZEOF_BYTE
    sta SCREEN+$f
    rts
}
