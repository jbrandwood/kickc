// Tests the sizeof() operator on values/expressions
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
  .const SIZEOF_BYTE = 1
  .const SIZEOF_NUMBER = $ff
  .const SIZEOF_WORD = 2
  .const SIZEOF_POINTER = 2
main: {
    .label b = 2
    .label w = 3
    // Simple types
    lda #0
    sta.z b
    sta.z w
    sta.z w+1
    lda #'0'+SIZEOF_NUMBER
    sta SCREEN
    lda #'0'+SIZEOF_BYTE
    sta SCREEN+1
    sta SCREEN+2
    lda #'0'+SIZEOF_NUMBER
    sta SCREEN+3
    sta SCREEN+5
    lda #'0'+SIZEOF_WORD
    sta SCREEN+6
    lda #'0'+SIZEOF_POINTER
    sta SCREEN+8
    sta SCREEN+9
    rts
}
