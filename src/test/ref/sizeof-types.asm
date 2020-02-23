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
    // SCREEN[idx++] = '0'+sizeof(void)
    lda #'0'
    sta SCREEN
    // SCREEN[idx++] = '0'+sizeof(byte)
    lda #'0'+SIZEOF_BYTE
    sta SCREEN+2
    // SCREEN[idx++] = '0'+sizeof(signed byte)
    lda #'0'+SIZEOF_SIGNED_BYTE
    sta SCREEN+3
    // SCREEN[idx++] = '0'+sizeof(unsigned char)
    lda #'0'+SIZEOF_BYTE
    sta SCREEN+4
    // SCREEN[idx++] = '0'+sizeof(signed char)
    lda #'0'+SIZEOF_SIGNED_BYTE
    sta SCREEN+5
    // SCREEN[idx++] = '0'+sizeof(bool)
    lda #'0'+SIZEOF_BOOL
    sta SCREEN+6
    // SCREEN[idx++] = '0'+sizeof(word)
    lda #'0'+SIZEOF_WORD
    sta SCREEN+8
    // SCREEN[idx++] = '0'+sizeof(signed word)
    lda #'0'+SIZEOF_SIGNED_WORD
    sta SCREEN+9
    // SCREEN[idx++] = '0'+sizeof(unsigned int)
    lda #'0'+SIZEOF_WORD
    sta SCREEN+$a
    // SCREEN[idx++] = '0'+sizeof(signed int)
    lda #'0'+SIZEOF_SIGNED_WORD
    sta SCREEN+$b
    // SCREEN[idx++] = '0'+sizeof(unsigned short)
    lda #'0'+SIZEOF_WORD
    sta SCREEN+$c
    // SCREEN[idx++] = '0'+sizeof(signed short)
    lda #'0'+SIZEOF_SIGNED_WORD
    sta SCREEN+$d
    // SCREEN[idx++] = '0'+sizeof(byte*)
    lda #'0'+SIZEOF_POINTER
    sta SCREEN+$f
    // SCREEN[idx++] = '0'+sizeof(word*)
    sta SCREEN+$10
    // SCREEN[idx++] = '0'+sizeof(int**)
    sta SCREEN+$11
    // SCREEN[idx++] = '0'+sizeof(int***)
    sta SCREEN+$12
    // SCREEN[idx++] = '0'+sizeof(byte[])
    sta SCREEN+$13
    // SCREEN[idx++] = '0'+sizeof(dword)
    lda #'0'+SIZEOF_DWORD
    sta SCREEN+$15
    // SCREEN[idx++] = '0'+sizeof(signed dword)
    lda #'0'+SIZEOF_SIGNED_DWORD
    sta SCREEN+$16
    // SCREEN[idx++] = '0'+sizeof(unsigned long)
    lda #'0'+SIZEOF_DWORD
    sta SCREEN+$17
    // SCREEN[idx++] = '0'+sizeof(signed long)
    lda #'0'+SIZEOF_SIGNED_DWORD
    sta SCREEN+$18
    // }
    rts
}
