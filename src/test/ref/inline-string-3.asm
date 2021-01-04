// Test assigning address of inline string to pointer
// The result should be an labelled .text in the ASM
// Erroneously tries to inline the string completely leading to a CompileError
  // Commodore 64 PRG executable file
.file [name="inline-string-3.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
.segment Code
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
    // ptr = (byte*) { *(PTR+1), *PTR }
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
  .segment Data
    STRING: .text "camelot"
}
