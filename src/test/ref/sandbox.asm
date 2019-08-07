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
    .label _3 = $17
    .label _4 = $17
    .label _5 = $11
    .label _12 = $17
    .label _13 = $17
    .label _14 = $f
    .label v = 4
    .label u = 2
    lda #$17
    sta VICBANK
    lda #0
    sta zp1
    sta v
    sta v+1
    lda #<$6e85
    sta u
    lda #>$6e85
    sta u+1
  b1:
    lda zp1
    cmp #$a
    bcc b2
    lda #0
    sta zp1
    lda #<$6e85
    sta u
    lda #>$6e85
    sta u+1
  b7:
    lda zp1
    cmp #$a
    bcc b8
    rts
  b8:
    lda #0
    sta TIMEHI
    sta TIMELO
    sta zp2
  b9:
    lda zp2
    cmp #$c8
    bcc b10
    lda TIMEHI
    sta _12
    lda #0
    sta _12+1
    lda _13
    sta _13+1
    lda #0
    sta _13
    lda TIMELO
    sta _14
    lda #0
    sta _14+1
    lda myprintf.w3
    clc
    adc _14
    sta myprintf.w3
    lda myprintf.w3+1
    adc _14+1
    sta myprintf.w3+1
    lda #<str1
    sta myprintf.str
    lda #>str1
    sta myprintf.str+1
    jsr myprintf
    jsr Print
    lda u
    sec
    sbc #<$4d2
    sta u
    lda u+1
    sbc #>$4d2
    sta u+1
    inc zp1
    jmp b7
  b10:
    jsr div10
    inc zp2
    jmp b9
  b2:
    lda #0
    sta TIMEHI
    sta TIMELO
    sta zp2
  b4:
    lda zp2
    cmp #$c8
    bcc b5
    lda TIMEHI
    sta _3
    lda #0
    sta _3+1
    lda _4
    sta _4+1
    lda #0
    sta _4
    lda TIMELO
    sta _5
    lda #0
    sta _5+1
    lda myprintf.w3
    clc
    adc _5
    sta myprintf.w3
    lda myprintf.w3+1
    adc _5+1
    sta myprintf.w3+1
    lda #<str
    sta myprintf.str
    lda #>str
    sta myprintf.str+1
    jsr myprintf
    jsr Print
    lda u
    sec
    sbc #<$4d2
    sta u
    lda u+1
    sbc #>$4d2
    sta u+1
    inc zp1
    jmp b1
  b5:
    jsr div16u
    inc zp2
    jmp b4
    str: .text "200 DIV16U: %5d,%4d IN %04d FRAMESm@"
    str1: .text "200 DIV10 : %5d,%4d IN %04d FRAMESm@"
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
    lda dividend
    sta divr16u.dividend
    lda dividend+1
    sta divr16u.dividend+1
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
    sta quotient
    sta quotient+1
    sta rem
    sta rem+1
  b1:
    asl rem
    rol rem+1
    lda dividend+1
    and #$80
    cmp #0
    beq b2
    lda #1
    ora rem
    sta rem
  b2:
    asl dividend
    rol dividend+1
    asl quotient
    rol quotient+1
    lda rem+1
    cmp #>div16u.divisor
    bcc b3
    bne !+
    lda rem
    cmp #<div16u.divisor
    bcc b3
  !:
    inc quotient
    bne !+
    inc quotient+1
  !:
    lda rem
    sec
    sbc #<div16u.divisor
    sta rem
    lda rem+1
    sbc #>div16u.divisor
    sta rem+1
  b3:
    inx
    cpx #$10
    bne b1
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
    .label bDigits = $d
    .label bLen = $e
    .label b = $c
    .label bArg = 9
    .label str = 6
    .label w1 = 2
    .label w2 = 4
    .label w3 = $17
    .label w = $f
    .label bFormat = 8
    .label bTrailing = $a
    .label bLeadZero = $b
    lda #0
    sta bLeadZero
    sta bDigits
    sta bTrailing
    sta w
    sta w+1
    sta bArg
    sta bLen
    sta bFormat
  b1:
    ldy #0
    lda (str),y
    cmp #0
    bne b2
    tya
    ldy bLen
    sta strTemp,y
    rts
  b2:
    ldy #0
    lda (str),y
    tax
    lda bFormat
    cmp #0
    bne !b4+
    jmp b4
  !b4:
    cpx #'0'
    bne b5
    lda #1
    sta bLeadZero
    jmp b1
  b5:
    cpx #'1'
    bcc b6
    cpx #'9'
    bcs !b28+
    jmp b28
  !b28:
    bne !b28+
    jmp b28
  !b28:
  b6:
    cpx #'-'
    bne b7
    lda #1
    sta bTrailing
    jmp b1
  b7:
    cpx #'c'
    bne !b8+
    jmp b8
  !b8:
    cpx #'d'
    beq b9
    cpx #'x'
    beq b31
    cpx #'X'
    beq b31
  b3:
    lda #0
    sta bFormat
    jmp b1
  b31:
    lda w
    lsr
    lsr
    lsr
    lsr
    ldx #$f
    axs #0
    cpx #$a
    bcc b10
    lda #$57
    jmp b11
  b10:
    lda #'0'
  b11:
    stx $ff
    clc
    adc $ff
    ldy bLen
    sta strTemp,y
    iny
    lda w
    ldx #$f
    axs #0
    cpx #$a
    bcc b12
    lda #$57
    jmp b13
  b12:
    lda #'0'
  b13:
    stx $ff
    clc
    adc $ff
    sta strTemp,y
    iny
    sty bLen
    jmp b3
  b9:
    lda w
    sta utoa.value
    lda w+1
    sta utoa.value+1
    jsr utoa
    lda #1
    sta b
  b14:
    ldy b
    lda buf6,y
    cmp #0
    bne b15
    lda bTrailing
    cmp #0
    bne b17
    tya
    cmp bDigits
    bcs b17
  b18:
    lda b
    cmp bDigits
    bcc b19
  b17:
    ldx #0
  b22:
    cpx b
    bcc b23
    lda bTrailing
    cmp #0
    beq b3
    lda b
    cmp bDigits
    bcc !b3+
    jmp b3
  !b3:
  b25:
    lda b
    cmp bDigits
    bcc b26
    jmp b3
  b26:
    lda #' '
    ldy bLen
    sta strTemp,y
    inc bLen
    dec bDigits
    jmp b25
  b23:
    lda buf6,x
    ldy bLen
    sta strTemp,y
    inc bLen
    inx
    jmp b22
  b19:
    lda bLeadZero
    cmp #0
    beq b20
    lda #'0'
    jmp b21
  b20:
    lda #' '
  b21:
    ldy bLen
    sta strTemp,y
    inc bLen
    dec bDigits
    jmp b18
  b15:
    inc b
    jmp b14
  b8:
    lda w
    // "switch" is the normal way -- not supported -- https://gitlab.com/camelot/kickc/issues/170
    ldy bLen
    sta strTemp,y
    inc bLen
    jmp b3
  b28:
    txa
    axs #'0'
    stx bDigits
    jmp b1
  b4:
    cpx #'%'
    bne b32
    // default format
    //w = (bArg == 0) ? w1 : ((bArg == 1) ? w2 : w3); -- "?" is the normal way, but error "sequence does not contain all blocks" -- https://gitlab.com/camelot/kickc/issues/185 [FIXED]
    lda bArg
    cmp #0
    beq b33
    lda #1
    cmp bArg
    beq b34
    lda w3
    sta w
    lda w3+1
    sta w+1
  b35:
    inc bArg
    lda #0
    sta bLeadZero
    lda #1
    sta bDigits
    lda #0
    sta bTrailing
    lda #1
    sta bFormat
    jmp b1
  b34:
    lda w2
    sta w
    lda w2+1
    sta w+1
    jmp b35
  b33:
    lda w1
    sta w
    lda w1+1
    sta w+1
    jmp b35
  b32:
    cpx #$41
    bcc b36
    cpx #$5a+1
    bcs b36
    txa
    axs #-[$20]
  b36:
    // swap 0x41 / 0x61 when in lower case mode
    ldy bLen
    txa
    sta strTemp,y
    inc bLen
    inc str
    bne !+
    inc str+1
  !:
    jmp b1
    buf6: .fill 6, 0
}
// utoa(word zeropage($11) value, byte* zeropage($13) dst)
utoa: {
    .label value = $11
    .label dst = $13
    lda value+1
    cmp #>$2710
    bcc !+
    beq !b5+
    jmp b5
  !b5:
    lda value
    cmp #<$2710
    bcc !b5+
    jmp b5
  !b5:
  !:
    lda #<myprintf.buf6
    sta dst
    lda #>myprintf.buf6
    sta dst+1
    ldx #0
  b1:
    cpx #1
    beq b6
    lda value+1
    cmp #>$3e8
    bcc !+
    bne b6
    lda value
    cmp #<$3e8
    bcs b6
  !:
  b2:
    cpx #1
    beq b7
    lda value+1
    cmp #>$64
    bcc !+
    bne b7
    lda value
    cmp #<$64
    bcs b7
  !:
  b3:
    cpx #1
    beq b8
    lda value+1
    cmp #>$a
    bcc !+
    bne b8
    lda value
    cmp #<$a
    bcs b8
  !:
  b4:
    lda value
    clc
    adc #'0'
    ldy #0
    sta (dst),y
    inc dst
    bne !+
    inc dst+1
  !:
    lda #0
    tay
    sta (dst),y
    rts
  b8:
    lda #<$a
    sta append.sub
    lda #>$a
    sta append.sub+1
    jsr append
    inc dst
    bne !+
    inc dst+1
  !:
    jmp b4
  b7:
    lda #<$64
    sta append.sub
    lda #>$64
    sta append.sub+1
    jsr append
    inc dst
    bne !+
    inc dst+1
  !:
    ldx #1
    jmp b3
  b6:
    lda #<$3e8
    sta append.sub
    lda #>$3e8
    sta append.sub+1
    jsr append
    inc dst
    bne !+
    inc dst+1
  !:
    ldx #1
    jmp b2
  b5:
    lda #<$2710
    sta append.sub
    lda #>$2710
    sta append.sub+1
    lda #<myprintf.buf6
    sta append.dst
    lda #>myprintf.buf6
    sta append.dst+1
    jsr append
    lda #<myprintf.buf6+1
    sta dst
    lda #>myprintf.buf6+1
    sta dst+1
    ldx #1
    jmp b1
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
  b1:
    lda sub+1
    cmp value+1
    bne !+
    lda sub
    cmp value
    beq b2
  !:
    bcc b2
    rts
  b2:
    ldy #0
    lda (dst),y
    clc
    adc #1
    sta (dst),y
    lda value
    sec
    sbc sub
    sta value
    lda value+1
    sbc sub+1
    sta value+1
    jmp b1
}
// div10(word zeropage($13) val)
div10: {
    .label _0 = $13
    .label _2 = $15
    .label _3 = $17
    .label _4 = 4
    .label val = $13
    .label val_1 = $15
    .label val_2 = $17
    .label val_3 = 4
    .label return = 4
    .label val_4 = 2
    lda val_4+1
    lsr
    sta _0+1
    lda val_4
    ror
    sta _0
    inc val
    bne !+
    inc val+1
  !:
    lda val
    asl
    sta _2
    lda val+1
    rol
    sta _2+1
    lda val_1
    clc
    adc val
    sta val_1
    lda val_1+1
    adc val+1
    sta val_1+1
    lsr
    sta _3+1
    lda val_1
    ror
    sta _3
    lsr _3+1
    ror _3
    lsr _3+1
    ror _3
    lsr _3+1
    ror _3
    lda val_2
    clc
    adc val_1
    sta val_2
    lda val_2+1
    adc val_1+1
    sta val_2+1
    sta _4
    lda #0
    sta _4+1
    lda val_3
    clc
    adc val_2
    sta val_3
    lda val_3+1
    adc val_2+1
    sta val_3+1
    lsr return+1
    ror return
    lsr return+1
    ror return
    lsr return+1
    ror return
    lsr return+1
    ror return
    rts
}
  // "char buf16[16]" is the normal way -- not supported -- https://gitlab.com/camelot/kickc/issues/162
  strTemp: .fill $64, 0
