// Test assigning address of inline string to pointer
// The result should be an labelled .text in the ASM
// Erroneously tries to inline the string completely leading to a CompileError
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .label PTR = $9ffe
    .label SCREEN = $400
    .label ptr = 2
    // *PTR = <STRING
    lda #<STRING
    sta PTR
    // *(PTR+1)= >STRING
    lda #>STRING
    sta PTR+1
    // (byte*) { *(PTR+1), *PTR }
    lda PTR
    sta.z ptr
    lda PTR+1
    sta.z ptr+1
    // *SCREEN = *ptr
    ldy #0
    lda (ptr),y
    sta SCREEN
    // }
    rts
    STRING: .text "camelot"
}
