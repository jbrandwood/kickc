// Illustrates both break & continue statements in a loop
// Prints a message ending at NUL skipping all spaces
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .label screen = 2
    lda #<$400
    sta.z screen
    lda #>$400
    sta.z screen+1
    ldx #0
  __b1:
    lda str,x
    cmp #0
    bne __b2
  __breturn:
    rts
  __b2:
    lda str,x
    cmp #' '
    beq __b4
    lda str,x
    ldy #0
    sta (screen),y
    inc.z screen
    bne !+
    inc.z screen+1
  !:
  __b4:
    inx
    cpx #0
    beq __breturn
    jmp __b1
    str: .text "hello brave new world"
    .byte 0
}
