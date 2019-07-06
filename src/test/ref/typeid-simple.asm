// Test typeid() of the different types
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
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
main: {
    .label SCREEN = $400
    // Simple types
    lda #TYPEID_VOID
    sta SCREEN
    lda #TYPEID_BYTE
    sta SCREEN+1
    lda #TYPEID_SIGNED_BYTE
    sta SCREEN+2
    lda #TYPEID_WORD
    sta SCREEN+3
    lda #TYPEID_SIGNED_WORD
    sta SCREEN+4
    lda #TYPEID_DWORD
    sta SCREEN+5
    lda #TYPEID_SIGNED_DWORD
    sta SCREEN+6
    lda #TYPEID_BOOL
    sta SCREEN+7
    // Pointer types
    lda #TYPEID_POINTER_BYTE
    sta SCREEN+8
    lda #TYPEID_POINTER_SIGNED_BYTE
    sta SCREEN+9
    lda #TYPEID_POINTER_WORD
    sta SCREEN+$a
    lda #TYPEID_POINTER_SIGNED_WORD
    sta SCREEN+$b
    lda #TYPEID_POINTER_DWORD
    sta SCREEN+$c
    lda #TYPEID_POINTER_SIGNED_DWORD
    sta SCREEN+$d
    lda #TYPEID_POINTER_BOOL
    sta SCREEN+$e
    // Pointer to procedure
    lda #TYPEID_POINTER_PROCEDURE
    sta SCREEN+$f
    // Pointer to pointer
    lda #TYPEID_POINTER_POINTER_BYTE
    sta SCREEN+$10
    // Test C types
    lda #TYPEID_BYTE
    sta SCREEN+$28
    sta SCREEN+$29
    lda #TYPEID_SIGNED_BYTE
    sta SCREEN+$2a
    lda #TYPEID_SIGNED_WORD
    sta SCREEN+$2b
    lda #TYPEID_WORD
    sta SCREEN+$2c
    lda #TYPEID_SIGNED_WORD
    sta SCREEN+$2d
    sta SCREEN+$2e
    lda #TYPEID_WORD
    sta SCREEN+$2f
    lda #TYPEID_SIGNED_WORD
    sta SCREEN+$30
    lda #TYPEID_SIGNED_DWORD
    sta SCREEN+$31
    lda #TYPEID_DWORD
    sta SCREEN+$32
    lda #TYPEID_SIGNED_DWORD
    sta SCREEN+$33
    rts
}
