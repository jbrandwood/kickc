// Inline Strings in method calls are automatically converted to local constant variables byte[] st = "..."; - generating an ASM .text).
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label screen = 2
main: {
    lda #<$400
    sta screen
    lda #>$400
    sta screen+1
    lda #<msg1
    sta print.msg
    lda #>msg1
    sta print.msg+1
    jsr print
    lda #<msg2
    sta print.msg
    lda #>msg2
    sta print.msg+1
    jsr print
    lda #<msg
    sta print.msg
    lda #>msg
    sta print.msg+1
    jsr print
    rts
    msg: .text "message 3 "
    .byte 0
    msg2: .text "message 2 "
    .byte 0
}
// print(byte* zeropage(4) msg)
print: {
    .label msg = 4
  b1:
    ldy #0
    lda (msg),y
    cmp #0
    bne b2
    rts
  b2:
    ldy #0
    lda (msg),y
    sta (screen),y
    inc screen
    bne !+
    inc screen+1
  !:
    inc msg
    bne !+
    inc msg+1
  !:
    jmp b1
}
  msg1: .text "message 1 "
  .byte 0
