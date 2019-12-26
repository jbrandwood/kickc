// Tests that identical strings are consolidated
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label screen = 2
main: {
    lda #<$400
    sta.z screen
    lda #>$400
    sta.z screen+1
    jsr print
    jsr print
    jsr print
    rts
    rex1: .text "rex"
    .byte 0
}
// print(byte* zp(4) string)
print: {
    .label string = 4
    lda #<main.rex1
    sta.z string
    lda #>main.rex1
    sta.z string+1
  __b1:
    ldy #0
    lda (string),y
    cmp #0
    bne __b2
    rts
  __b2:
    ldy #0
    lda (string),y
    sta (screen),y
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
