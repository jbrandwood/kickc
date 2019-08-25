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
    sta.z x
    lda #<SCREEN+$28+1
    sta.z screen
    lda #>SCREEN+$28+1
    sta.z screen+1
    lda #0
    sta.z ch
  b1:
    ldx #0
  b2:
    lda.z ch
    ldy #0
    sta (screen),y
    inc.z screen
    bne !+
    inc.z screen+1
  !:
    inc.z ch
    inx
    cpx #$10
    bne b2
    lda #$28-$10
    clc
    adc.z screen
    sta.z screen
    bcc !+
    inc.z screen+1
  !:
    inc.z x
    lda #$10
    cmp.z x
    bne b1
    rts
}
// Copies the character c (an unsigned char) to the first num characters of the object pointed to by the argument str.
memset: {
    .const c = ' '
    .const num = $3e8
    .label str = SCREEN
    .label end = str+num
    .label dst = 4
    lda #<str
    sta.z dst
    lda #>str
    sta.z dst+1
  b1:
    lda.z dst+1
    cmp #>end
    bne b2
    lda.z dst
    cmp #<end
    bne b2
    rts
  b2:
    lda #c
    ldy #0
    sta (dst),y
    inc.z dst
    bne !+
    inc.z dst+1
  !:
    jmp b1
}
