// Tests that identical strings are consolidated
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label screen = 2
main: {
    // print(rex1)
    lda #<$400
    sta.z screen
    lda #>$400
    sta.z screen+1
    jsr print
    // print(rex2)
    jsr print
    // print("rex")
    jsr print
    // }
    rts
}
// print(byte* zp(4) string)
print: {
    .label string = 4
    lda #<rex1
    sta.z string
    lda #>rex1
    sta.z string+1
  __b1:
    // while(*string)
    ldy #0
    lda (string),y
    cmp #0
    bne __b2
    // }
    rts
  __b2:
    // *screen++ = *string++
    ldy #0
    lda (string),y
    sta (screen),y
    // *screen++ = *string++;
    inc.z screen
    bne !+
    inc.z screen+1
  !:
    inc.z string
    bne !+
    inc.z string+1
  !:
    jmp __b1
}
  rex1: .text "rex"
  .byte 0
