// Tests that identical strings are consolidated
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label screen = 2
main: {
    lda #<$400
    sta screen
    lda #>$400
    sta screen+1
    jsr print
    jsr print
    jsr print
    rts
    string: .text "rex@"
}
// print(byte* zeropage(4) string)
print: {
    .label string = 4
    lda #<main.string
    sta string
    lda #>main.string
    sta string+1
  b1:
    ldy #0
    lda (string),y
    cmp #'@'
    bne b2
    rts
  b2:
    ldy #0
    lda (string),y
    sta (screen),y
    inc screen
    bne !+
    inc screen+1
  !:
    inc string
    bne !+
    inc string+1
  !:
    jmp b1
}