// Testing hex to decimal conversion
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label control = $d011
  .label raster = $d012
  .label bordercol = $d020
main: {
    .label _1 = 4
    .label time_start = 8
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
    lda raster
    sta time_start
    lda #<$400
    sta utoa10b.dst
    lda #>$400
    sta utoa10b.dst+1
    lda #0
    sta utoa10b.value
    sta utoa10b.value+1
    jsr utoa10b
    inc bordercol
    lda #<$400+$28
    sta utoa10b.dst
    lda #>$400+$28
    sta utoa10b.dst+1
    lda #<$4d2
    sta utoa10b.value
    lda #>$4d2
    sta utoa10b.value+1
    jsr utoa10b
    inc bordercol
    lda #<$400+$28+$28
    sta utoa10b.dst
    lda #>$400+$28+$28
    sta utoa10b.dst+1
    lda #<$162e
    sta utoa10b.value
    lda #>$162e
    sta utoa10b.value+1
    jsr utoa10b
    inc bordercol
    lda #<$400+$28+$28+$28
    sta utoa10b.dst
    lda #>$400+$28+$28+$28
    sta utoa10b.dst+1
    lda #<$270f
    sta utoa10b.value
    lda #>$270f
    sta utoa10b.value+1
    jsr utoa10b
    inc bordercol
    lda #<$400+$28+$28+$28+$28
    sta utoa10b.dst
    lda #>$400+$28+$28+$28+$28
    sta utoa10b.dst+1
    lda #<$e608
    sta utoa10b.value
    lda #>$e608
    sta utoa10b.value+1
    jsr utoa10b
    ldx raster
    lda #0
    sta bordercol
    txa
    sec
    sbc time_start
    sta utoa10b.value
    lda #0
    sta utoa10b.value+1
    lda #<$400+$28+$28+$28+$28+$50
    sta utoa10b.dst
    lda #>$400+$28+$28+$28+$28+$50
    sta utoa10b.dst+1
    jsr utoa10b
    ldx #0
  b3:
    lda msg,x
    sta $400+$28+$28+$28+$28+$50+3,x
    inx
    lda msg,x
    cmp #0
    bne b3
    jmp b1
    msg: .text "raster lines@"
}
// Decimal utoa() without using multiply or divide
// utoa10b(word zeropage(2) value, byte* zeropage(6) dst)
utoa10b: {
    .label value = 2
    .label digit = 4
    .label dst = 6
    .label bStarted = 5
    lda #0
    sta bStarted
    sta digit
    tax
  b1:
    txa
    asl
    tay
    lda SUB+1,y
    cmp value+1
    bne !+
    lda SUB,y
    cmp value
    beq b2
  !:
    bcc b2
    txa
    and #1
    cmp #0
    beq b6
    lda bStarted
    cmp #0
    beq b7
    ldy digit
    lda DIGITS,y
    ldy #0
    sta (dst),y
    inc dst
    bne !+
    inc dst+1
  !:
  b7:
    lda #0
    sta digit
  b6:
    inx
    cpx #8
    bne b1
    lda value
    tay
    lda DIGITS,y
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
  b2:
    lda VAL,x
    clc
    adc digit
    sta digit
    txa
    asl
    tay
    sec
    lda value
    sbc SUB,y
    sta value
    lda value+1
    sbc SUB+1,y
    sta value+1
    lda #1
    sta bStarted
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
  DIGITS: .text "0123456789abcdef@"
  SUB: .word $7530, $2710, $bb8, $3e8, $12c, $64, $1e, $a
  VAL: .byte 3, 1, 3, 1, 3, 1, 3, 1
