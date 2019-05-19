// Testing hex to decimal conversion
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label control = $d011
  .label raster = $d012
  .label bordercol = $d020
main: {
    .label _1 = 8
    sei
    jsr cls
  b1:
    lda #$80
    and control
    sta _1
    lda raster
    lsr
    ora _1
    cmp #$30
    bne b1
    lda #1
    sta bordercol
    lda #<$400
    sta utoa.dst
    lda #>$400
    sta utoa.dst+1
    lda #0
    sta utoa.value
    sta utoa.value+1
    jsr utoa
    inc bordercol
    lda #<$400+$28
    sta utoa.dst
    lda #>$400+$28
    sta utoa.dst+1
    lda #<$4d2
    sta utoa.value
    lda #>$4d2
    sta utoa.value+1
    jsr utoa
    inc bordercol
    lda #<$400+$28+$28
    sta utoa.dst
    lda #>$400+$28+$28
    sta utoa.dst+1
    lda #<$162e
    sta utoa.value
    lda #>$162e
    sta utoa.value+1
    jsr utoa
    inc bordercol
    lda #<$400+$28+$28+$28
    sta utoa.dst
    lda #>$400+$28+$28+$28
    sta utoa.dst+1
    lda #<$270f
    sta utoa.value
    lda #>$270f
    sta utoa.value+1
    jsr utoa
    inc bordercol
    lda #<$400+$28+$28+$28+$28
    sta utoa.dst
    lda #>$400+$28+$28+$28+$28
    sta utoa.dst+1
    lda #<$ea5f
    sta utoa.value
    lda #>$ea5f
    sta utoa.value+1
    jsr utoa
    lda #0
    sta bordercol
    jmp b1
}
// utoa(word zeropage(2) value, byte* zeropage(4) dst)
utoa: {
    .label value = 2
    .label dst = 4
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
    lda #$a
    sta append.sub
    lda #0
    sta append.sub+1
    jsr append
    inc dst
    bne !+
    inc dst+1
  !:
    jmp b4
  b7:
    lda #$64
    sta append.sub
    lda #0
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
    jsr append
    inc dst
    bne !+
    inc dst+1
  !:
    ldx #1
    jmp b1
}
// simple 'utoa' without using multiply or divide
// append(byte* zeropage(4) dst, word zeropage(2) value, word zeropage(6) sub)
append: {
    .label _0 = 9
    .label sub3 = 9
    .label value = 2
    .label dst = 4
    .label return = 2
    .label sub = 6
    lda #'0'
    ldy #0
    sta (dst),y
    lda sub
    asl
    sta _0
    lda sub+1
    rol
    sta _0+1
    lda sub3
    clc
    adc sub
    sta sub3
    lda sub3+1
    adc sub+1
    sta sub3+1
  b1:
    lda sub3+1
    cmp value+1
    bne !+
    lda sub3
    cmp value
  !:
    bcc b2
    beq b2
  b3:
    lda sub+1
    cmp value+1
    bne !+
    lda sub
    cmp value
  !:
    bcc b4
    beq b4
    rts
  b4:
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
    jmp b3
  b2:
    lda #3
    clc
    ldy #0
    adc (dst),y
    sta (dst),y
    lda value
    sec
    sbc sub3
    sta value
    lda value+1
    sbc sub3+1
    sta value+1
    jmp b1
}
cls: {
    .label screen = $400
    .label sc = 2
    lda #<screen
    sta sc
    lda #>screen
    sta sc+1
  b1:
    lda #' '
    ldy #0
    sta (sc),y
    inc sc
    bne !+
    inc sc+1
  !:
    lda sc+1
    cmp #>screen+$3e7+1
    bne b1
    lda sc
    cmp #<screen+$3e7+1
    bne b1
    rts
}
