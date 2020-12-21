// Test typeid() of the different types
  // Commodore 64 PRG executable file
.file [name="typeid-simple.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .const TYPEID_VOID = 0
  .const TYPEID_BYTE = 1
  .const TYPEID_SIGNED_BYTE = 2
  .const TYPEID_WORD = 3
  .const TYPEID_SIGNED_WORD = 4
  .const TYPEID_DWORD = 5
  .const TYPEID_SIGNED_DWORD = 6
  .const TYPEID_BOOL = 7
  .const TYPEID_POINTER_BYTE = $11
  .const TYPEID_POINTER_SIGNED_BYTE = $12
  .const TYPEID_POINTER_WORD = $13
  .const TYPEID_POINTER_SIGNED_WORD = $14
  .const TYPEID_POINTER_DWORD = $15
  .const TYPEID_POINTER_SIGNED_DWORD = $16
  .const TYPEID_POINTER_BOOL = $17
  .const TYPEID_POINTER_PROCEDURE = $1f
  .const TYPEID_POINTER_POINTER_BYTE = $21
.segment Code
main: {
    .label SCREEN = $400
    // SCREEN[idx++] = typeid(void)
    // Simple types
    lda #TYPEID_VOID
    sta SCREEN
    // SCREEN[idx++] = typeid(byte)
    lda #TYPEID_BYTE
    sta SCREEN+1
    // SCREEN[idx++] = typeid(signed byte)
    lda #TYPEID_SIGNED_BYTE
    sta SCREEN+2
    // SCREEN[idx++] = typeid(word)
    lda #TYPEID_WORD
    sta SCREEN+3
    // SCREEN[idx++] = typeid(signed word)
    lda #TYPEID_SIGNED_WORD
    sta SCREEN+4
    // SCREEN[idx++] = typeid(dword)
    lda #TYPEID_DWORD
    sta SCREEN+5
    // SCREEN[idx++] = typeid(signed dword)
    lda #TYPEID_SIGNED_DWORD
    sta SCREEN+6
    // SCREEN[idx++] = typeid(bool)
    lda #TYPEID_BOOL
    sta SCREEN+7
    // SCREEN[idx++] = typeid(byte*)
    // Pointer types
    lda #TYPEID_POINTER_BYTE
    sta SCREEN+8
    // SCREEN[idx++] = typeid(signed byte*)
    lda #TYPEID_POINTER_SIGNED_BYTE
    sta SCREEN+9
    // SCREEN[idx++] = typeid(word*)
    lda #TYPEID_POINTER_WORD
    sta SCREEN+$a
    // SCREEN[idx++] = typeid(signed word*)
    lda #TYPEID_POINTER_SIGNED_WORD
    sta SCREEN+$b
    // SCREEN[idx++] = typeid(dword*)
    lda #TYPEID_POINTER_DWORD
    sta SCREEN+$c
    // SCREEN[idx++] = typeid(signed dword*)
    lda #TYPEID_POINTER_SIGNED_DWORD
    sta SCREEN+$d
    // SCREEN[idx++] = typeid(bool*)
    lda #TYPEID_POINTER_BOOL
    sta SCREEN+$e
    // SCREEN[idx++] = typeid(byte()*)
    // Pointer to procedure
    lda #TYPEID_POINTER_PROCEDURE
    sta SCREEN+$f
    // SCREEN[idx++] = typeid(byte**)
    // Pointer to pointer
    lda #TYPEID_POINTER_POINTER_BYTE
    sta SCREEN+$10
    // SCREEN[idx++] = typeid(char)
    // Test C types
    lda #TYPEID_BYTE
    sta SCREEN+$28
    // SCREEN[idx++] = typeid(unsigned char)
    sta SCREEN+$29
    // SCREEN[idx++] = typeid(signed char)
    lda #TYPEID_SIGNED_BYTE
    sta SCREEN+$2a
    // SCREEN[idx++] = typeid(short)
    lda #TYPEID_SIGNED_WORD
    sta SCREEN+$2b
    // SCREEN[idx++] = typeid(unsigned short)
    lda #TYPEID_WORD
    sta SCREEN+$2c
    // SCREEN[idx++] = typeid(signed short)
    lda #TYPEID_SIGNED_WORD
    sta SCREEN+$2d
    // SCREEN[idx++] = typeid(int)
    sta SCREEN+$2e
    // SCREEN[idx++] = typeid(unsigned int)
    lda #TYPEID_WORD
    sta SCREEN+$2f
    // SCREEN[idx++] = typeid(signed int)
    lda #TYPEID_SIGNED_WORD
    sta SCREEN+$30
    // SCREEN[idx++] = typeid(long)
    lda #TYPEID_SIGNED_DWORD
    sta SCREEN+$31
    // SCREEN[idx++] = typeid(unsigned long)
    lda #TYPEID_DWORD
    sta SCREEN+$32
    // SCREEN[idx++] = typeid(signed long)
    lda #TYPEID_SIGNED_DWORD
    sta SCREEN+$33
    // }
    rts
}
