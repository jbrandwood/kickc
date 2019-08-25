// Generate a charset based on a 5x3 pattern stored in 2 bytes
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label VIC_MEMORY = $d018
  .label SCREEN = $400
  .label CHARSET = $3000
main: {
    .label charset = 3
    .label c = 2
    lda #<CHARSET+8
    sta.z charset
    lda #>CHARSET+8
    sta.z charset+1
    lda #0
    sta.z c
  b1:
    lda #4
    cmp.z c
    bne b2
    lda #SCREEN/$40|CHARSET/$400
    sta VIC_MEMORY
    rts
  b2:
    lda.z c
    asl
    tax
    lda charset_spec_row,x
    sta.z gen_char3.spec
    lda charset_spec_row+1,x
    sta.z gen_char3.spec+1
    jsr gen_char3
    lda #8
    clc
    adc.z charset
    sta.z charset
    bcc !+
    inc.z charset+1
  !:
    inc.z c
    jmp b1
}
// Generate one 5x3 character from a 16-bit char spec
// The 5x3 char is stored as 5x 3-bit rows followed by a zero. %aaabbbcc cdddeee0
// gen_char3(byte* zeropage(3) dst, word zeropage(6) spec)
gen_char3: {
    .label dst = 3
    .label spec = 6
    .label r = 5
    lda #0
    sta.z r
  b1:
    ldx #0
    ldy #0
  b2:
    lda.z spec+1
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
    asl.z spec
    rol.z spec+1
    inx
    cpx #3
    bne b2
    tya
    ldy.z r
    sta (dst),y
    inc.z r
    lda #5
    cmp.z r
    bne b1
    rts
}
  // Stores chars as 15 bits (in 2 bytes) specifying the 3x5
  // The 5x3 char is stored as 5x 3-bit rows followed by a zero. %aaabbbcc cdddeee0
  charset_spec_row: .word $f7da, $f7de, $f24e, $d6de
