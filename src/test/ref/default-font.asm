// Show default font on screen
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
main: {
    .label screen = 4
    .label ch = 3
    .label x = 2
    jsr memset
    lda #0
    sta x
    lda #<SCREEN+$28+1
    sta screen
    lda #>SCREEN+$28+1
    sta screen+1
    lda #0
    sta ch
  b1:
    ldx #0
  b2:
    lda ch
    ldy #0
    sta (screen),y
    inc screen
    bne !+
    inc screen+1
  !:
    inc ch
    inx
    cpx #$10
    bne b2
    lda #$28-$10
    clc
    adc screen
    sta screen
    bcc !+
    inc screen+1
  !:
    inc x
    lda #$10
    cmp x
    bne b1
    rts
}
// Copies the character c (an unsigned char) to the first num characters of the object pointed to by the argument str.
memset: {
    .const c = ' '
    .const num = $3e8
    .label str = SCREEN
    .label end = str+num
    .label dst = 6
    lda #<str
    sta dst
    lda #>str
    sta dst+1
  b1:
    lda #c
    ldy #0
    sta (dst),y
    inc dst
    bne !+
    inc dst+1
  !:
    lda dst+1
    cmp #>end
    bne b1
    lda dst
    cmp #<end
    bne b1
    rts
}
