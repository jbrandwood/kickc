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
  .const TYPEID_CHAR = 1
  .const TYPEID_SIGNED_CHAR = 2
  .const TYPEID_UNSIGNED_INT = 3
  .const TYPEID_INT = 4
  .const TYPEID_UNSIGNED_LONG = 5
  .const TYPEID_LONG = 6
  .const TYPEID_BOOL = 7
  .const TYPEID_POINTER_CHAR = $11
  .const TYPEID_POINTER_SIGNED_CHAR = $12
  .const TYPEID_POINTER_UNSIGNED_INT = $13
  .const TYPEID_POINTER_INT = $14
  .const TYPEID_POINTER_UNSIGNED_LONG = $15
  .const TYPEID_POINTER_LONG = $16
  .const TYPEID_POINTER_BOOL = $17
  .const TYPEID_POINTER_PROCEDURE = $1f
  .const TYPEID_POINTER_POINTER_CHAR = $21
.segment Code
main: {
    .label SCREEN = $400
    // SCREEN[idx++] = typeid(void)
    // Simple types
    lda #TYPEID_VOID
    sta SCREEN
    // SCREEN[idx++] = typeid(byte)
    lda #TYPEID_CHAR
    sta SCREEN+1
    // SCREEN[idx++] = typeid(signed byte)
    lda #TYPEID_SIGNED_CHAR
    sta SCREEN+2
    // SCREEN[idx++] = typeid(word)
    lda #TYPEID_UNSIGNED_INT
    sta SCREEN+3
    // SCREEN[idx++] = typeid(signed word)
    lda #TYPEID_INT
    sta SCREEN+4
    // SCREEN[idx++] = typeid(dword)
    lda #TYPEID_UNSIGNED_LONG
    sta SCREEN+5
    // SCREEN[idx++] = typeid(signed dword)
    lda #TYPEID_LONG
    sta SCREEN+6
    // SCREEN[idx++] = typeid(bool)
    lda #TYPEID_BOOL
    sta SCREEN+7
    // SCREEN[idx++] = typeid(byte*)
    // Pointer types
    lda #TYPEID_POINTER_CHAR
    sta SCREEN+8
    // SCREEN[idx++] = typeid(signed byte*)
    lda #TYPEID_POINTER_SIGNED_CHAR
    sta SCREEN+9
    // SCREEN[idx++] = typeid(word*)
    lda #TYPEID_POINTER_UNSIGNED_INT
    sta SCREEN+$a
    // SCREEN[idx++] = typeid(signed word*)
    lda #TYPEID_POINTER_INT
    sta SCREEN+$b
    // SCREEN[idx++] = typeid(dword*)
    lda #TYPEID_POINTER_UNSIGNED_LONG
    sta SCREEN+$c
    // SCREEN[idx++] = typeid(signed dword*)
    lda #TYPEID_POINTER_LONG
    sta SCREEN+$d
    // SCREEN[idx++] = typeid(bool*)
    lda #TYPEID_POINTER_BOOL
    sta SCREEN+$e
    // SCREEN[idx++] = typeid(PROC_PTR)
    // Pointer to procedure
    lda #TYPEID_POINTER_PROCEDURE
    sta SCREEN+$f
    // SCREEN[idx++] = typeid(byte**)
    // Pointer to pointer
    lda #TYPEID_POINTER_POINTER_CHAR
    sta SCREEN+$10
    // SCREEN[idx++] = typeid(char)
    // Test C types
    lda #TYPEID_CHAR
    sta SCREEN+$28
    // SCREEN[idx++] = typeid(signed char)
    lda #TYPEID_SIGNED_CHAR
    sta SCREEN+$29
    // SCREEN[idx++] = typeid(unsigned char)
    lda #TYPEID_CHAR
    sta SCREEN+$2a
    // SCREEN[idx++] = typeid(short)
    lda #TYPEID_INT
    sta SCREEN+$2b
    // SCREEN[idx++] = typeid(short int)
    sta SCREEN+$2c
    // SCREEN[idx++] = typeid(signed)
    sta SCREEN+$2d
    // SCREEN[idx++] = typeid(int)
    sta SCREEN+$2e
    // SCREEN[idx++] = typeid(signed short)
    sta SCREEN+$2f
    // SCREEN[idx++] = typeid(signed short int)
    sta SCREEN+$30
    // SCREEN[idx++] = typeid(signed int)
    sta SCREEN+$31
    // SCREEN[idx++] = typeid(unsigned short)
    lda #TYPEID_UNSIGNED_INT
    sta SCREEN+$32
    // SCREEN[idx++] = typeid(unsigned short int)
    sta SCREEN+$33
    // SCREEN[idx++] = typeid(unsigned int)
    sta SCREEN+$34
    // SCREEN[idx++] = typeid(long)
    lda #TYPEID_LONG
    sta SCREEN+$35
    // SCREEN[idx++] = typeid(signed long)
    sta SCREEN+$36
    // SCREEN[idx++] = typeid(signed long int)
    sta SCREEN+$37
    // SCREEN[idx++] = typeid(unsigned long)
    lda #TYPEID_UNSIGNED_LONG
    sta SCREEN+$38
    // SCREEN[idx++] = typeid(unsigned long int)
    sta SCREEN+$39
    // }
    rts
}
