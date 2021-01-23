// Tests that multiple different identical strings are consolidated to a root variable
  // Commodore 64 PRG executable file
.file [name="string-const-consolidation-root.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .label screen = 2
.segment Code
main: {
    // print1()
    jsr print1
    // print2()
    jsr print2
    // }
    rts
}
print1: {
    // print("string1")
    lda #<$400
    sta.z screen
    lda #>$400
    sta.z screen+1
    lda #<string_0
    sta.z print.s
    lda #>string_0
    sta.z print.s+1
    jsr print
    // print("string2")
    lda #<string_1
    sta.z print.s
    lda #>string_1
    sta.z print.s+1
    jsr print
    // print(s)
    lda #<s
    sta.z print.s
    lda #>s
    sta.z print.s+1
    jsr print
    // }
    rts
}
print2: {
    // print("string1")
    lda #<string_0
    sta.z print.s
    lda #>string_0
    sta.z print.s+1
    jsr print
    // print("string2")
    lda #<string_1
    sta.z print.s
    lda #>string_1
    sta.z print.s+1
    jsr print
    // print(s1)
    lda #<s1
    sta.z print.s
    lda #>s1
    sta.z print.s+1
    jsr print
    // }
    rts
}
// print(byte* zp(4) s)
print: {
    .label s = 4
  __b1:
    // while(*s)
    ldy #0
    lda (s),y
    cmp #0
    bne __b2
    // }
    rts
  __b2:
    // *screen++ = *s++
    ldy #0
    lda (s),y
    sta (screen),y
    // *screen++ = *s++;
    inc.z screen
    bne !+
    inc.z screen+1
  !:
    inc.z s
    bne !+
    inc.z s+1
  !:
    jmp __b1
}
.segment Data
  s: .text "string3"
  .byte 0
  s1: .text "string4"
  .byte 0
  string_0: .text "string1"
  .byte 0
  string_1: .text "string2"
  .byte 0
