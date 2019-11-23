.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label zp1 = $61
  // #define zp1 *(byte *)0x61 -- allows "zp1" vs "*zp1" below -- not supported --  https://gitlab.com/camelot/kickc/issues/169
  .label zp2 = $62
  .label TIMEHI = $a1
  .label TIMELO = $a2
  .label VICBANK = $d018
main: {
    .label __3 = $17
    .label __4 = $17
    .label __5 = $11
    .label __12 = $17
    .label __13 = $17
    .label __14 = $f
    .label v = 4
    // test performance of 'div16u(10)'
    // test performance of 'div10'
    .label u = 2
    lda #$17
    sta VICBANK
    lda #0
    sta zp1
    sta.z v
    sta.z v+1
    lda #<$6e85
    sta.z u
    lda #>$6e85
    sta.z u+1
  __b1:
    lda zp1
    cmp #$a
    bcc __b2
    lda #0
    sta zp1
    lda #<$6e85
    sta.z u
    lda #>$6e85
    sta.z u+1
  __b7:
    lda zp1
    cmp #$a
    bcc __b8
    rts
  __b8:
    lda #0
    sta TIMEHI
    sta TIMELO
    sta zp2
  __b9:
    lda zp2
    cmp #$c8
    bcc __b10
    lda TIMEHI
    sta.z __12
    lda #0
    sta.z __12+1
    lda.z __13
    sta.z __13+1
    lda #0
    sta.z __13
    lda TIMELO
    sta.z __14
    lda #0
    sta.z __14+1
    lda.z myprintf.w3
    clc
    adc.z __14
    sta.z myprintf.w3
    lda.z myprintf.w3+1
    adc.z __14+1
    sta.z myprintf.w3+1
    lda #<str1
    sta.z myprintf.str
    lda #>str1
    sta.z myprintf.str+1
    jsr myprintf
    jsr Print
    lda.z u
    sec
    sbc #<$4d2
    sta.z u
    lda.z u+1
    sbc #>$4d2
    sta.z u+1
    inc zp1
    jmp __b7
  __b10:
    jsr div10
    inc zp2
    jmp __b9
  __b2:
    lda #0
    sta TIMEHI
    sta TIMELO
    sta zp2
  __b4:
    lda zp2
    cmp #$c8
    bcc __b5
    lda TIMEHI
    sta.z __3
    lda #0
    sta.z __3+1
    lda.z __4
    sta.z __4+1
    lda #0
    sta.z __4
    lda TIMELO
    sta.z __5
    lda #0
    sta.z __5+1
    lda.z myprintf.w3
    clc
    adc.z __5
    sta.z myprintf.w3
    lda.z myprintf.w3+1
    adc.z __5+1
    sta.z myprintf.w3+1
    lda #<str
    sta.z myprintf.str
    lda #>str
    sta.z myprintf.str+1
    jsr myprintf
    jsr Print
    lda.z u
    sec
    sbc #<$4d2
    sta.z u
    lda.z u+1
    sbc #>$4d2
    sta.z u+1
    inc zp1
    jmp __b1
  __b5:
    jsr div16u
    inc zp2
    jmp __b4
    str: .text "200 DIV16U: %5d,%4d IN %04d FRAMESm"
    .byte 0
    str1: .text "200 DIV10 : %5d,%4d IN %04d FRAMESm"
    .byte 0
}
// Performs division on two 16 bit unsigned words
// Returns the quotient dividend/divisor.
// The remainder will be set into the global variable rem16u
// Implemented using simple binary division
// div16u(word zeropage(2) dividend)
div16u: {
    .label divisor = $a
    .label return = 4
    .label dividend = 2
    lda.z dividend
    sta.z divr16u.dividend
    lda.z dividend+1
    sta.z divr16u.dividend+1
    jsr divr16u
    rts
}
// Performs division on two 16 bit unsigned words and an initial remainder
// Returns the quotient dividend/divisor.
// The final remainder will be set into the global variable rem16u
// Implemented using simple binary division
// divr16u(word zeropage(6) dividend, word zeropage($17) rem)
divr16u: {
    .label rem = $17
    .label dividend = 6
    .label quotient = 4
    .label return = 4
    ldx #0
    txa
    sta.z quotient
    sta.z quotient+1
    sta.z rem
    sta.z rem+1
  __b1:
    asl.z rem
    rol.z rem+1
    lda.z dividend+1
    and #$80
    cmp #0
    beq __b2
    lda #1
    ora.z rem
    sta.z rem
  __b2:
    asl.z dividend
    rol.z dividend+1
    asl.z quotient
    rol.z quotient+1
    lda.z rem+1
    cmp #>div16u.divisor
    bcc __b3
    bne !+
    lda.z rem
    cmp #<div16u.divisor
    bcc __b3
  !:
    inc.z quotient
    bne !+
    inc.z quotient+1
  !:
    lda.z rem
    sec
    sbc #<div16u.divisor
    sta.z rem
    lda.z rem+1
    sbc #>div16u.divisor
    sta.z rem+1
  __b3:
    inx
    cpx #$10
    bne __b1
    rts
}
Print: {
    // can this assembly be placed in a separate file and call it from the C code here?
    ldy #0
  loop:
    lda strTemp,y
    beq done
    jsr $ffd2
    iny
    jmp loop
  done:
    rts
}
// myprintf(byte* zeropage(6) str, word zeropage(2) w1, word zeropage(4) w2, word zeropage($17) w3)
myprintf: {
    .label str = 6
    .label bDigits = $d
    .label bLen = $e
    // formats
    .label b = $c
    .label bArg = 9
    .label w1 = 2
    .label w2 = 4
    .label w3 = $17
    .label w = $f
    .label bFormat = 8
    .label bTrailing = $a
    .label bLeadZero = $b
    lda #0
    sta.z bLeadZero
    sta.z bDigits
    sta.z bTrailing
    sta.z w
    sta.z w+1
    sta.z bArg
    sta.z bLen
    sta.z bFormat
  __b1:
    ldy #0
    lda (str),y
    cmp #0
    bne __b2
    tya
    ldy.z bLen
    sta strTemp,y
    rts
  __b2:
    ldy #0
    lda (str),y
    tax
    lda.z bFormat
    cmp #0
    bne !__b4+
    jmp __b4
  !__b4:
    cpx #'0'
    bne __b5
    lda #1
    sta.z bLeadZero
  __b32:
    inc.z str
    bne !+
    inc.z str+1
  !:
    jmp __b1
  __b5:
    cpx #'1'
    bcc __b6
    cpx #'9'
    bcs !__b28+
    jmp __b28
  !__b28:
    bne !__b28+
    jmp __b28
  !__b28:
  __b6:
    cpx #'-'
    bne __b7
    lda #1
    sta.z bTrailing
    jmp __b32
  __b7:
    cpx #'c'
    bne !__b8+
    jmp __b8
  !__b8:
    cpx #'d'
    beq __b9
    cpx #'x'
    beq __b31
    cpx #'X'
    beq __b31
  b1:
    lda #0
    sta.z bFormat
    jmp __b32
  __b31:
    lda.z w
    lsr
    lsr
    lsr
    lsr
    ldx #$f
    axs #0
    cpx #$a
    bcc __b10
    lda #$57
    jmp __b11
  __b10:
    lda #'0'
  __b11:
    stx.z $ff
    clc
    adc.z $ff
    ldy.z bLen
    sta strTemp,y
    iny
    lda.z w
    ldx #$f
    axs #0
    cpx #$a
    bcc __b12
    lda #$57
    jmp __b13
  __b12:
    lda #'0'
  __b13:
    stx.z $ff
    clc
    adc.z $ff
    sta strTemp,y
    iny
    sty.z bLen
    jmp b1
  __b9:
    lda.z w
    sta.z utoa.value
    lda.z w+1
    sta.z utoa.value+1
    jsr utoa
    lda #1
    sta.z b
  __b14:
    ldy.z b
    lda buf6,y
    cmp #0
    bne __b15
    lda.z bTrailing
    cmp #0
    bne b2
    tya
    cmp.z bDigits
    bcs b2
  __b18:
    lda.z b
    cmp.z bDigits
    bcc __b19
  b2:
    ldx #0
  __b22:
    cpx.z b
    bcc __b23
    lda.z bTrailing
    cmp #0
    beq b1
    lda.z b
    cmp.z bDigits
    bcc !b1+
    jmp b1
  !b1:
  __b25:
    lda.z b
    cmp.z bDigits
    bcc __b26
    jmp b1
  __b26:
    lda #' '
    ldy.z bLen
    sta strTemp,y
    inc.z bLen
    dec.z bDigits
    jmp __b25
  __b23:
    lda buf6,x
    ldy.z bLen
    sta strTemp,y
    inc.z bLen
    inx
    jmp __b22
  __b19:
    lda.z bLeadZero
    cmp #0
    beq __b20
    lda #'0'
    jmp __b21
  __b20:
    lda #' '
  __b21:
    ldy.z bLen
    sta strTemp,y
    inc.z bLen
    dec.z bDigits
    jmp __b18
  __b15:
    inc.z b
    jmp __b14
  __b8:
    lda.z w
    // "switch" is the normal way -- not supported -- https://gitlab.com/camelot/kickc/issues/170
    ldy.z bLen
    sta strTemp,y
    inc.z bLen
    jmp b1
  __b28:
    txa
    axs #'0'
    stx.z bDigits
    jmp __b32
  __b4:
    cpx #'%'
    bne __b33
    // default format
    //w = (bArg == 0) ? w1 : ((bArg == 1) ? w2 : w3); -- "?" is the normal way, but error "sequence does not contain all blocks" -- https://gitlab.com/camelot/kickc/issues/185 [FIXED]
    lda.z bArg
    cmp #0
    beq __b34
    lda #1
    cmp.z bArg
    beq __b35
    lda.z w3
    sta.z w
    lda.z w3+1
    sta.z w+1
  __b36:
    inc.z bArg
    lda #0
    sta.z bLeadZero
    lda #1
    sta.z bDigits
    lda #0
    sta.z bTrailing
    lda #1
    sta.z bFormat
    jmp __b32
  __b35:
    lda.z w2
    sta.z w
    lda.z w2+1
    sta.z w+1
    jmp __b36
  __b34:
    lda.z w1
    sta.z w
    lda.z w1+1
    sta.z w+1
    jmp __b36
  __b33:
    cpx #$41
    bcc b4
    cpx #$5a+1
    bcs b4
    txa
    axs #-[$20]
  b4:
    // swap 0x41 / 0x61 when in lower case mode
    ldy.z bLen
    txa
    sta strTemp,y
    inc.z bLen
    jmp __b32
    buf6: .fill 6, 0
}
// utoa(word zeropage($11) value, byte* zeropage($13) dst)
utoa: {
    .label value = $11
    .label dst = $13
    lda.z value+1
    cmp #>$2710
    bcc !+
    beq !__b5+
    jmp __b5
  !__b5:
    lda.z value
    cmp #<$2710
    bcc !__b5+
    jmp __b5
  !__b5:
  !:
    lda #<myprintf.buf6
    sta.z dst
    lda #>myprintf.buf6
    sta.z dst+1
    ldx #0
  __b1:
    cpx #1
    beq __b6
    lda.z value+1
    cmp #>$3e8
    bcc !+
    bne __b6
    lda.z value
    cmp #<$3e8
    bcs __b6
  !:
  __b2:
    cpx #1
    beq __b7
    lda.z value+1
    bne __b7
    lda.z value
    cmp #$64
    bcs __b7
  !:
  __b3:
    cpx #1
    beq __b8
    lda.z value+1
    bne __b8
    lda.z value
    cmp #$a
    bcs __b8
  !:
  __b4:
    lda.z value
    clc
    adc #'0'
    ldy #0
    sta (dst),y
    inc.z dst
    bne !+
    inc.z dst+1
  !:
    lda #0
    tay
    sta (dst),y
    rts
  __b8:
    lda #<$a
    sta.z append.sub
    lda #>$a
    sta.z append.sub+1
    jsr append
    inc.z dst
    bne !+
    inc.z dst+1
  !:
    jmp __b4
  __b7:
    lda #<$64
    sta.z append.sub
    lda #>$64
    sta.z append.sub+1
    jsr append
    inc.z dst
    bne !+
    inc.z dst+1
  !:
    ldx #1
    jmp __b3
  __b6:
    lda #<$3e8
    sta.z append.sub
    lda #>$3e8
    sta.z append.sub+1
    jsr append
    inc.z dst
    bne !+
    inc.z dst+1
  !:
    ldx #1
    jmp __b2
  __b5:
    lda #<$2710
    sta.z append.sub
    lda #>$2710
    sta.z append.sub+1
    lda #<myprintf.buf6
    sta.z append.dst
    lda #>myprintf.buf6
    sta.z append.dst+1
    jsr append
    lda #<myprintf.buf6+1
    sta.z dst
    lda #>myprintf.buf6+1
    sta.z dst+1
    ldx #1
    jmp __b1
}
// simple 'utoa' without using multiply or divide
// append(byte* zeropage($13) dst, word zeropage($11) value, word zeropage($15) sub)
append: {
    .label value = $11
    .label return = $11
    .label dst = $13
    .label sub = $15
    lda #'0'
    ldy #0
    sta (dst),y
  __b1:
    lda.z sub+1
    cmp.z value+1
    bne !+
    lda.z sub
    cmp.z value
    beq __b2
  !:
    bcc __b2
    rts
  __b2:
    ldy #0
    lda (dst),y
    clc
    adc #1
    sta (dst),y
    lda.z value
    sec
    sbc.z sub
    sta.z value
    lda.z value+1
    sbc.z sub+1
    sta.z value+1
    jmp __b1
}
// div10(word zeropage($13) val)
div10: {
    .label __0 = $13
    .label __2 = $15
    .label __3 = $17
    .label __4 = 4
    .label val = $13
    .label val_1 = $15
    .label val_2 = $17
    .label val_3 = 4
    .label return = 4
    .label val_4 = 2
    lda.z val_4+1
    lsr
    sta.z __0+1
    lda.z val_4
    ror
    sta.z __0
    inc.z val
    bne !+
    inc.z val+1
  !:
    lda.z val
    asl
    sta.z __2
    lda.z val+1
    rol
    sta.z __2+1
    lda.z val_1
    clc
    adc.z val
    sta.z val_1
    lda.z val_1+1
    adc.z val+1
    sta.z val_1+1
    lsr
    sta.z __3+1
    lda.z val_1
    ror
    sta.z __3
    lsr.z __3+1
    ror.z __3
    lsr.z __3+1
    ror.z __3
    lsr.z __3+1
    ror.z __3
    lda.z val_2
    clc
    adc.z val_1
    sta.z val_2
    lda.z val_2+1
    adc.z val_1+1
    sta.z val_2+1
    sta.z __4
    lda #0
    sta.z __4+1
    lda.z val_3
    clc
    adc.z val_2
    sta.z val_3
    lda.z val_3+1
    adc.z val_2+1
    sta.z val_3+1
    lsr.z return+1
    ror.z return
    lsr.z return+1
    ror.z return
    lsr.z return+1
    ror.z return
    lsr.z return+1
    ror.z return
    rts
}
  // "char buf16[16]" is the normal way -- not supported -- https://gitlab.com/camelot/kickc/issues/162
  strTemp: .fill $64, 0
