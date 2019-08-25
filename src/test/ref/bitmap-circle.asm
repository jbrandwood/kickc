// Plots a circle on a bitmap using Bresenham's Circle algorithm
// Coded by Richard-William Loerakker
// Original Source https://bcaorganizer.blogspot.com/p/c-program-for_21.html?fbclid=IwAR0iL8pYcCqhCPa6LmtQ9qej-YonYVepY2cBegYRIWO0l8RPeOnTVniMAac
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label BORDERCOL = $d020
  .label D011 = $d011
  .const VIC_BMM = $20
  .const VIC_DEN = $10
  .const VIC_RSEL = 8
  .label VIC_MEMORY = $d018
  .const BLUE = 6
  .label SCREEN = $400
  .label BITMAP = $2000
main: {
    ldx #0
    lda #<$28*$19*8
    sta.z fill.size
    lda #>$28*$19*8
    sta.z fill.size+1
    lda #<BITMAP
    sta.z fill.addr
    lda #>BITMAP
    sta.z fill.addr+1
    jsr fill
    ldx #$16
    lda #<$28*$19
    sta.z fill.size
    lda #>$28*$19
    sta.z fill.size+1
    lda #<SCREEN
    sta.z fill.addr
    lda #>SCREEN
    sta.z fill.addr+1
    jsr fill
    lda #BLUE
    sta BORDERCOL
    lda #VIC_BMM|VIC_DEN|VIC_RSEL|3
    sta D011
    lda #(SCREEN&$3fff)/$40|(BITMAP&$3fff)/$400
    sta VIC_MEMORY
    jsr circle
  b1:
    jmp b1
}
circle: {
    .const xc = $64
    .const yc = $64
    .const r = $32
    .label _5 = 8
    .label _6 = 8
    .label _7 = 2
    .label _9 = $a
    .label _10 = 2
    .label p = 2
    .label y = 6
    .label x1 = 4
    lda #<3-(r<<1)
    sta.z p
    lda #>3-(r<<1)
    sta.z p+1
    lda #<r
    sta.z y
    lda #>r
    sta.z y+1
    lda #<0
    sta.z x1
    sta.z x1+1
  b1:
    lda.z y
    cmp.z x1
    lda.z y+1
    sbc.z x1+1
    bvc !+
    eor #$80
  !:
    bpl b2
    rts
  b2:
    lda.z p+1
    bpl !b3+
    jmp b3
  !b3:
    sec
    lda.z y
    sbc #1
    sta.z y
    bcs !+
    dec.z y+1
  !:
    lda.z x1
    sec
    sbc.z y
    sta.z _5
    lda.z x1+1
    sbc.z y+1
    sta.z _5+1
    asl.z _6
    rol.z _6+1
    asl.z _6
    rol.z _6+1
    lda.z _7
    clc
    adc.z _6
    sta.z _7
    lda.z _7+1
    adc.z _6+1
    sta.z _7+1
    lda.z p
    clc
    adc #<$a
    sta.z p
    lda.z p+1
    adc #>$a
    sta.z p+1
  b4:
    lda.z x1
    clc
    adc #<xc
    sta.z plot.x
    lda.z x1+1
    adc #>xc
    sta.z plot.x+1
    lda #<yc
    sec
    sbc.z y
    sta.z plot.y
    lda #>yc
    sbc.z y+1
    sta.z plot.y+1
    jsr plot
    lda #<xc
    sec
    sbc.z x1
    sta.z plot.x
    lda #>xc
    sbc.z x1+1
    sta.z plot.x+1
    lda #<yc
    sec
    sbc.z y
    sta.z plot.y
    lda #>yc
    sbc.z y+1
    sta.z plot.y+1
    jsr plot
    lda.z x1
    clc
    adc #<xc
    sta.z plot.x
    lda.z x1+1
    adc #>xc
    sta.z plot.x+1
    lda.z y
    clc
    adc #<yc
    sta.z plot.y
    lda.z y+1
    adc #>yc
    sta.z plot.y+1
    jsr plot
    lda #<xc
    sec
    sbc.z x1
    sta.z plot.x
    lda #>xc
    sbc.z x1+1
    sta.z plot.x+1
    lda.z y
    clc
    adc #<yc
    sta.z plot.y
    lda.z y+1
    adc #>yc
    sta.z plot.y+1
    jsr plot
    lda.z y
    clc
    adc #<xc
    sta.z plot.x
    lda.z y+1
    adc #>xc
    sta.z plot.x+1
    lda #<yc
    sec
    sbc.z x1
    sta.z plot.y
    lda #>yc
    sbc.z x1+1
    sta.z plot.y+1
    jsr plot
    lda #<xc
    sec
    sbc.z y
    sta.z plot.x
    lda #>xc
    sbc.z y+1
    sta.z plot.x+1
    lda #<yc
    sec
    sbc.z x1
    sta.z plot.y
    lda #>yc
    sbc.z x1+1
    sta.z plot.y+1
    jsr plot
    lda.z y
    clc
    adc #<xc
    sta.z plot.x
    lda.z y+1
    adc #>xc
    sta.z plot.x+1
    lda.z x1
    clc
    adc #<yc
    sta.z plot.y
    lda.z x1+1
    adc #>yc
    sta.z plot.y+1
    jsr plot
    lda #<xc
    sec
    sbc.z y
    sta.z plot.x
    lda #>xc
    sbc.z y+1
    sta.z plot.x+1
    lda.z x1
    clc
    adc #<yc
    sta.z plot.y
    lda.z x1+1
    adc #>yc
    sta.z plot.y+1
    jsr plot
    inc.z x1
    bne !+
    inc.z x1+1
  !:
    jmp b1
  b3:
    lda.z x1
    asl
    sta.z _9
    lda.z x1+1
    rol
    sta.z _9+1
    asl.z _9
    rol.z _9+1
    lda.z _10
    clc
    adc.z _9
    sta.z _10
    lda.z _10+1
    adc.z _9+1
    sta.z _10+1
    lda.z p
    clc
    adc #<6
    sta.z p
    lda.z p+1
    adc #>6
    sta.z p+1
    jmp b4
}
// plot(signed word zeropage(8) x, signed word zeropage($a) y)
plot: {
    .label _0 = $c
    .label _3 = $a
    .label _4 = $e
    .label x = 8
    .label y = $a
    .label location = $c
    .label _7 = $e
    .label _8 = $e
    lda.z x
    and #<$fff8
    sta.z _0
    lda.z x+1
    and #>$fff8
    sta.z _0+1
    lda #<BITMAP
    clc
    adc.z location
    sta.z location
    lda #>BITMAP
    adc.z location+1
    sta.z location+1
    lda.z y
    and #7
    clc
    adc.z location
    sta.z location
    bcc !+
    inc.z location+1
  !:
    lda.z _3+1
    cmp #$80
    ror.z _3+1
    ror.z _3
    lda.z _3+1
    cmp #$80
    ror.z _3+1
    ror.z _3
    lda.z _3+1
    cmp #$80
    ror.z _3+1
    ror.z _3
    lda.z _3
    asl
    sta.z _7
    lda.z _3+1
    rol
    sta.z _7+1
    asl.z _7
    rol.z _7+1
    lda.z _8
    clc
    adc.z _3
    sta.z _8
    lda.z _8+1
    adc.z _3+1
    sta.z _8+1
    lda.z _4+1
    sta.z $ff
    lda.z _4
    sta.z _4+1
    lda #0
    sta.z _4
    lsr.z $ff
    ror.z _4+1
    ror.z _4
    lsr.z $ff
    ror.z _4+1
    ror.z _4
    lda.z location
    clc
    adc.z _4
    sta.z location
    lda.z location+1
    adc.z _4+1
    sta.z location+1
    lda #7
    and.z x
    tay
    lda bitmask,y
    ldy #0
    ora (location),y
    sta (location),y
    rts
}
// Fill some memory with a value
// fill(signed word zeropage(4) size, byte register(X) val)
fill: {
    .label end = 4
    .label addr = 6
    .label size = 4
    lda.z addr
    clc
    adc.z end
    sta.z end
    lda.z addr+1
    adc.z end+1
    sta.z end+1
  b1:
    lda.z addr+1
    cmp.z end+1
    bne b2
    lda.z addr
    cmp.z end
    bne b2
    rts
  b2:
    txa
    ldy #0
    sta (addr),y
    inc.z addr
    bne !+
    inc.z addr+1
  !:
    jmp b1
}
  bitmask: .byte $80, $40, $20, $10, 8, 4, 2, 1
