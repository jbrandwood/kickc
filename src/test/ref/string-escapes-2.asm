// Test using some simple supported string escape characters in PETSCII
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label memA = $ff
main: {
    .label i = 2
    lda #0
    sta.z i
  __b1:
    lda #0
    ldy.z i
    cmp MESSAGE,y
    bne __b2
    rts
  __b2:
    ldy.z i
    lda MESSAGE,y
    jsr chrout
    inc.z i
    jmp __b1
}
// chrout(byte register(A) c)
chrout: {
    sta memA
    jsr $ffd2
    rts
}
.encoding "petscii_mixed"
  MESSAGE: .text @"hello\nworld\\"
  .byte 0
