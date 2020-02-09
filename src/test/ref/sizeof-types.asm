// Tests the sizeof() operator on types
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
  .const SIZEOF_BYTE = 1
  .const SIZEOF_SIGNED_BYTE = 1
  .const SIZEOF_BOOL = 1
  .const SIZEOF_WORD = 2
  .const SIZEOF_SIGNED_WORD = 2
  .const SIZEOF_POINTER = 2
  .const SIZEOF_DWORD = 4
  .const SIZEOF_SIGNED_DWORD = 4
main: {
    lda #'0'
    sta SCREEN
    lda #'0'+SIZEOF_BYTE
    sta SCREEN+2
    lda #'0'+SIZEOF_SIGNED_BYTE
    sta SCREEN+3
    lda #'0'+SIZEOF_BYTE
    sta SCREEN+4
    lda #'0'+SIZEOF_SIGNED_BYTE
    sta SCREEN+5
    lda #'0'+SIZEOF_BOOL
    sta SCREEN+6
    lda #'0'+SIZEOF_WORD
    sta SCREEN+8
    lda #'0'+SIZEOF_SIGNED_WORD
    sta SCREEN+9
    lda #'0'+SIZEOF_WORD
    sta SCREEN+$a
    lda #'0'+SIZEOF_SIGNED_WORD
    sta SCREEN+$b
    lda #'0'+SIZEOF_WORD
    sta SCREEN+$c
    lda #'0'+SIZEOF_SIGNED_WORD
    sta SCREEN+$d
    lda #'0'+SIZEOF_POINTER
    sta SCREEN+$f
    sta SCREEN+$10
    sta SCREEN+$11
    sta SCREEN+$12
    sta SCREEN+$13
    lda #'0'+SIZEOF_DWORD
    sta SCREEN+$15
    lda #'0'+SIZEOF_SIGNED_DWORD
    sta SCREEN+$16
    lda #'0'+SIZEOF_DWORD
    sta SCREEN+$17
    lda #'0'+SIZEOF_SIGNED_DWORD
    sta SCREEN+$18
    rts
}
