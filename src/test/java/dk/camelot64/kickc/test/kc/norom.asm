.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label VIC_MEMORY = $d018
  .label SCREEN = $400
  .label CHARSET = $3000
main: {
    .label charset = 2
    .label c = 4
    .label spec = 5
    .label b = 7

    lda #26
    sta c
    lda #<CHARSET+8
    sta charset
    lda #>CHARSET+8
    sta charset+1
  b2:

    ldy #0
  gb1:
    ldx #0
    stx b
  gb2:
sr1:asl charset_spec_row_lo
sr2:rol charset_spec_row_hi
    rol b
    inx
    cpx #3
    bne gb2
    lda b
    sta (charset),y
    iny
    cpy #5
    bne gb1

    lda charset
    clc
    adc #8
    sta charset
    bcc !+
    inc charset+1
  !:
    inc sr1+1
    inc sr2+1
    dec c
    bne b2
    lda #SCREEN/$40|CHARSET/$400
    sta VIC_MEMORY
    rts
}

charset_spec_hi:
    .word /*A*/ %11110111, /*B*/ %11110111, /*C*/ %11110010, /*D*/ %11010110
    .word /*E*/ %11110011, /*F*/ %11110011, /*G*/ %11110010, /*H*/ %10110111
    .word /*I*/ %11101001, /*J*/ %11100100, /*K*/ %10110111, /*L*/ %10010010
    .word /*M*/ %10111111, /*N*/ %11010110, /*O*/ %11110110, /*P*/ %11110111
    .word /*Q*/ %11110110, /*R*/ %11110111, /*S*/ %11110011, /*T*/ %11101001
    .word /*U*/ %10110110, /*V*/ %10110101, /*W*/ %10110111, /*X*/ %10110101
    .word /*Y*/ %10110111, /*Z*/ %11100101


charset_spec_lo:
    .byte /*A*/ %11011010, /*B*/ %11011110, /*C*/ %01001110, /*D*/ %11011110
    .byte /*E*/ %01001110, /*F*/ %01001000, /*G*/ %11011110, /*H*/ %11011010
    .byte /*I*/ %00101110, /*J*/ %11011100, /*K*/ %01011010, /*L*/ %01001110
    .byte /*M*/ %11011010, /*N*/ %11011010, /*O*/ %11011110, /*P*/ %11001000
    .byte /*Q*/ %11110110, /*R*/ %01011010, /*S*/ %10011110, /*T*/ %00100100
    .byte /*U*/ %11011110, /*V*/ %10110010, /*W*/ %11111010, /*X*/ %01011010
    .byte /*Y*/ %10100100, /*Z*/ %01001110