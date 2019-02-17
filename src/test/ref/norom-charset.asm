// Generate a charset based on a 5x3 pattern stored in 2 bytes
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label VIC_MEMORY = $d018
  .label SCREEN = $400
  .label CHARSET = $3000
main: {
    .label charset = 2
    .label c = 4
    lda #0
    sta c
    lda #<CHARSET+8
    sta charset
    lda #>CHARSET+8
    sta charset+1
  b1:
    ldy c
    lda charset_spec_row,y
    sta gen_char3.spec
    lda charset_spec_row+1,y
    sta gen_char3.spec+1
    jsr gen_char3
    lda charset
    clc
    adc #8
    sta charset
    bcc !+
    inc charset+1
  !:
    lda c
    clc
    adc #2
    sta c
    cmp #6
    bne b1
    lda #SCREEN/$40|CHARSET/$400
    sta VIC_MEMORY
    rts
}
// Generate one 5x3 character from a 16-bit char spec
// The 5x3 char is stored as 5x 3-bit rows followed by a zero. %aaabbbcc cdddeee0
gen_char3: {
    .label dst = 2
    .label spec = 6
    .label r = 5
    lda #0
    sta r
  b1:
    ldx #0
    ldy #0
  b2:
    lda spec+1
    and #$80
    cmp #0
    beq b3
    tya
    ora #1
    tay
  b3:
    tya
    asl
    tay
    asl spec
    rol spec+1
    inx
    cpx #3
    bne b2
    tya
    ldy r
    sta (dst),y
    inc r
    lda r
    cmp #5
    bne b1
    rts
}
  // Stores chars as 15 bits (in 2 bytes) specifying the 3x5
  // The 5x3 char is stored as 5x 3-bit rows followed by a zero. %aaabbbcc cdddeee0
  charset_spec_row: .word $f7da, $f7de, $f24e, $d6de
