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
  __b1:
    // for(byte c=0;c!=4;c++)
    lda #4
    cmp.z c
    bne __b2
    // *VIC_MEMORY = (byte)(((word)SCREEN/$40)|((word)CHARSET/$400))
    lda #SCREEN/$40|CHARSET/$400
    sta VIC_MEMORY
    // }
    rts
  __b2:
    // gen_char3(charset, charset_spec_row[c])
    lda.z c
    asl
    tax
    lda.z charset
    sta.z gen_char3.dst
    lda.z charset+1
    sta.z gen_char3.dst+1
    lda charset_spec_row,x
    sta.z gen_char3.spec
    lda charset_spec_row+1,x
    sta.z gen_char3.spec+1
    jsr gen_char3
    // charset = charset+8
    lda #8
    clc
    adc.z charset
    sta.z charset
    bcc !+
    inc.z charset+1
  !:
    // for(byte c=0;c!=4;c++)
    inc.z c
    jmp __b1
}
// Generate one 5x3 character from a 16-bit char spec
// The 5x3 char is stored as 5x 3-bit rows followed by a zero. %aaabbbcc cdddeee0
// gen_char3(byte* zp(8) dst, word zp(6) spec)
gen_char3: {
    .label dst = 8
    .label spec = 6
    .label r = 5
    lda #0
    sta.z r
  __b1:
    ldx #0
    ldy #0
  __b2:
    // >spec
    lda.z spec+1
    // >spec&$80
    and #$80
    // if((>spec&$80)!=0)
    cmp #0
    beq __b3
    // b = b|1
    tya
    ora #1
    tay
  __b3:
    // b = b*2
    tya
    asl
    tay
    // spec = spec*2
    asl.z spec
    rol.z spec+1
    // for(byte c: 0..2 )
    inx
    cpx #3
    bne __b2
    // dst[r] = b
    tya
    ldy.z r
    sta (dst),y
    // for(byte r : 0..4 )
    inc.z r
    lda #5
    cmp.z r
    bne __b1
    // }
    rts
}
  // Stores chars as 15 bits (in 2 bytes) specifying the 3x5
  // The 5x3 char is stored as 5x 3-bit rows followed by a zero. %aaabbbcc cdddeee0
  charset_spec_row: .word $f7da, $f7de, $f24e, $d6de
