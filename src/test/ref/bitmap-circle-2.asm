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
    .label i = 6
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
    lda #<1
    sta.z i
    lda #>1
    sta.z i+1
  __b1:
    lda.z i
    cmp #<$b4
    lda.z i+1
    sbc #>$b4
    bvc !+
    eor #$80
  !:
    bmi __b2
  __b3:
    jmp __b3
  __b2:
    lda.z i
    sta.z circle.r
    lda.z i+1
    sta.z circle.r+1
    jsr circle
    lda.z i
    clc
    adc #<5
    sta.z i
    lda.z i+1
    adc #>5
    sta.z i+1
    jmp __b1
}
// circle(signed word zeropage(2) r)
circle: {
    .const xc = $a0
    .const yc = $64
    .label __0 = 4
    .label __5 = $a
    .label __6 = $a
    .label __7 = 4
    .label __9 = $c
    .label __10 = 4
    .label r = 2
    .label p = 4
    .label y = 2
    .label x1 = 8
    lda.z r
    asl
    sta.z __0
    lda.z r+1
    rol
    sta.z __0+1
    sec
    lda #<3
    sbc.z p
    sta.z p
    lda #>3
    sbc.z p+1
    sta.z p+1
    lda #<0
    sta.z x1
    sta.z x1+1
  __b1:
    lda.z y
    cmp.z x1
    lda.z y+1
    sbc.z x1+1
    bvc !+
    eor #$80
  !:
    bpl __b2
    rts
  __b2:
    lda.z p+1
    bpl !__b3+
    jmp __b3
  !__b3:
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
    sta.z __5
    lda.z x1+1
    sbc.z y+1
    sta.z __5+1
    asl.z __6
    rol.z __6+1
    asl.z __6
    rol.z __6+1
    lda.z __7
    clc
    adc.z __6
    sta.z __7
    lda.z __7+1
    adc.z __6+1
    sta.z __7+1
    lda.z p
    clc
    adc #<$a
    sta.z p
    lda.z p+1
    adc #>$a
    sta.z p+1
  __b4:
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
    jmp __b1
  __b3:
    lda.z x1
    asl
    sta.z __9
    lda.z x1+1
    rol
    sta.z __9+1
    asl.z __9
    rol.z __9+1
    lda.z __10
    clc
    adc.z __9
    sta.z __10
    lda.z __10+1
    adc.z __9+1
    sta.z __10+1
    lda.z p
    clc
    adc #<6
    sta.z p
    lda.z p+1
    adc #>6
    sta.z p+1
    jmp __b4
}
// plot(signed word zeropage($a) x, signed word zeropage($c) y)
plot: {
    .label __8 = $e
    .label __11 = $c
    .label __12 = $10
    .label x = $a
    .label y = $c
    .label location = $e
    .label __15 = $10
    .label __16 = $10
    lda.z x+1
    bpl !__breturn+
    jmp __breturn
  !__breturn:
    lda #<$13f
    cmp.z x
    lda #>$13f
    sbc.z x+1
    bvc !+
    eor #$80
  !:
    bpl !__breturn+
    jmp __breturn
  !__breturn:
    lda.z y+1
    bpl !__breturn+
    jmp __breturn
  !__breturn:
    lda.z y
    cmp #<$c7+1
    lda.z y+1
    sbc #>$c7+1
    bvc !+
    eor #$80
  !:
    bmi !__breturn+
    jmp __breturn
  !__breturn:
    lda.z x
    and #<$fff8
    sta.z __8
    lda.z x+1
    and #>$fff8
    sta.z __8+1
    clc
    lda.z location
    adc #<BITMAP
    sta.z location
    lda.z location+1
    adc #>BITMAP
    sta.z location+1
    lda.z y
    and #7
    clc
    adc.z location
    sta.z location
    bcc !+
    inc.z location+1
  !:
    lda.z __11+1
    cmp #$80
    ror.z __11+1
    ror.z __11
    lda.z __11+1
    cmp #$80
    ror.z __11+1
    ror.z __11
    lda.z __11+1
    cmp #$80
    ror.z __11+1
    ror.z __11
    lda.z __11
    asl
    sta.z __15
    lda.z __11+1
    rol
    sta.z __15+1
    asl.z __15
    rol.z __15+1
    lda.z __16
    clc
    adc.z __11
    sta.z __16
    lda.z __16+1
    adc.z __11+1
    sta.z __16+1
    lda.z __12+1
    sta.z $ff
    lda.z __12
    sta.z __12+1
    lda #0
    sta.z __12
    lsr.z $ff
    ror.z __12+1
    ror.z __12
    lsr.z $ff
    ror.z __12+1
    ror.z __12
    lda.z location
    clc
    adc.z __12
    sta.z location
    lda.z location+1
    adc.z __12+1
    sta.z location+1
    lda #7
    and.z x
    tay
    lda bitmask,y
    ldy #0
    ora (location),y
    sta (location),y
  __breturn:
    rts
}
// Fill some memory with a value
// fill(signed word zeropage(6) size, byte register(X) val)
fill: {
    .label end = 6
    .label addr = 8
    .label size = 6
    lda.z end
    clc
    adc.z addr
    sta.z end
    lda.z end+1
    adc.z addr+1
    sta.z end+1
  __b1:
    lda.z addr+1
    cmp.z end+1
    bne __b2
    lda.z addr
    cmp.z end
    bne __b2
    rts
  __b2:
    txa
    ldy #0
    sta (addr),y
    inc.z addr
    bne !+
    inc.z addr+1
  !:
    jmp __b1
}
  bitmask: .byte $80, $40, $20, $10, 8, 4, 2, 1
