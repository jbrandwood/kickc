//  Test assigning address of inline string to pointer
//  The result should be an labelled .text in the ASM
//  Erroneously tries to inline the string completely leading to a CompileError
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .label PTR = $9ffe
    .label SCREEN = $400
    .label _6 = 2
    lda #<STRING
    sta PTR
    lda #>STRING
    sta PTR+1
    lda PTR
    sta _6
    lda PTR+1
    sta _6+1
    ldy #0
    lda (_6),y
    sta SCREEN
    rts
    STRING: .text "camelot"
}
