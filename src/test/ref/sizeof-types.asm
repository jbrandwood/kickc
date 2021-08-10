// Tests the sizeof() operator on types
  // Commodore 64 PRG executable file
.file [name="sizeof-types.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .const SIZEOF_CHAR = 1
  .const SIZEOF_SIGNED_CHAR = 1
  .const SIZEOF_BOOL = 1
  .const SIZEOF_UNSIGNED_INT = 2
  .const SIZEOF_INT = 2
  .const SIZEOF_POINTER = 2
  .const SIZEOF_UNSIGNED_LONG = 4
  .const SIZEOF_LONG = 4
  .label SCREEN = $400
.segment Code
main: {
    // SCREEN[idx++] = '0'+sizeof(void)
    lda #'0'
    sta SCREEN
    // SCREEN[idx++] = '0'+sizeof(byte)
    lda #'0'+SIZEOF_CHAR
    sta SCREEN+2
    // SCREEN[idx++] = '0'+sizeof(signed byte)
    lda #'0'+SIZEOF_SIGNED_CHAR
    sta SCREEN+3
    // SCREEN[idx++] = '0'+sizeof(unsigned char)
    lda #'0'+SIZEOF_CHAR
    sta SCREEN+4
    // SCREEN[idx++] = '0'+sizeof(signed char)
    lda #'0'+SIZEOF_SIGNED_CHAR
    sta SCREEN+5
    // SCREEN[idx++] = '0'+sizeof(bool)
    lda #'0'+SIZEOF_BOOL
    sta SCREEN+6
    // SCREEN[idx++] = '0'+sizeof(word)
    lda #'0'+SIZEOF_UNSIGNED_INT
    sta SCREEN+8
    // SCREEN[idx++] = '0'+sizeof(signed word)
    lda #'0'+SIZEOF_INT
    sta SCREEN+9
    // SCREEN[idx++] = '0'+sizeof(unsigned int)
    lda #'0'+SIZEOF_UNSIGNED_INT
    sta SCREEN+$a
    // SCREEN[idx++] = '0'+sizeof(signed int)
    lda #'0'+SIZEOF_INT
    sta SCREEN+$b
    // SCREEN[idx++] = '0'+sizeof(unsigned short)
    lda #'0'+SIZEOF_UNSIGNED_INT
    sta SCREEN+$c
    // SCREEN[idx++] = '0'+sizeof(signed short)
    lda #'0'+SIZEOF_INT
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
    // SCREEN[idx++] = '0'+sizeof(dword)
    lda #'0'+SIZEOF_UNSIGNED_LONG
    sta SCREEN+$14
    // SCREEN[idx++] = '0'+sizeof(signed dword)
    lda #'0'+SIZEOF_LONG
    sta SCREEN+$15
    // SCREEN[idx++] = '0'+sizeof(unsigned long)
    lda #'0'+SIZEOF_UNSIGNED_LONG
    sta SCREEN+$16
    // SCREEN[idx++] = '0'+sizeof(signed long)
    lda #'0'+SIZEOF_LONG
    sta SCREEN+$17
    // }
    rts
}
