// Illustrates both break & continue statements in a loop
// Prints a message ending at '@' skipping all spaces
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .label screen = 2
    lda #<$400
    sta screen
    lda #>$400
    sta screen+1
    ldx #0
  b1:
    lda str,x
    cmp #'@'
    bne b2
  breturn:
    rts
  b2:
    lda str,x
    cmp #' '
    beq b4
    lda str,x
    ldy #0
    sta (screen),y
    inc screen
    bne !+
    inc screen+1
  !:
  b4:
    inx
    cpx #0
    beq breturn
    jmp b1
    str: .text "hello brave new world"
    .byte 0
}
