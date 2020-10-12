// Commodore 64 Registers and Constants
// The MOS 6526 Complex Interface Adapter (CIA)
// http://archive.6502.org/datasheets/mos_6526_cia_recreated.pdf
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .const VIC_BMM = $20
  .const VIC_DEN = $10
  .const VIC_RSEL = 8
  .const BLUE = 6
  .label BORDER_COLOR = $d020
  .label D011 = $d011
  .label VIC_MEMORY = $d018
  .label SCREEN = $400
  .label BITMAP = $2000
main: {
    .label i = 2
    // fill(BITMAP,40*25*8,0)
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
    // fill(SCREEN,40*25,$16)
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
    // *BORDER_COLOR = BLUE
    lda #BLUE
    sta BORDER_COLOR
    // *D011 = VIC_BMM|VIC_DEN|VIC_RSEL|3
    lda #VIC_BMM|VIC_DEN|VIC_RSEL|3
    sta D011
    // *VIC_MEMORY =  (byte)((((word)SCREEN&$3fff)/$40)|(((word)BITMAP&$3fff)/$400))
    lda #(SCREEN&$3fff)/$40|(BITMAP&$3fff)/$400
    sta VIC_MEMORY
    lda #<1
    sta.z i
    lda #>1
    sta.z i+1
  __b1:
    // for (int i = 1; i < 180; i += 5)
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
    // circle(160,100,i)
    lda.z i
    sta.z circle.r
    lda.z i+1
    sta.z circle.r+1
    jsr circle
    // i += 5
    clc
    lda.z i
    adc #<5
    sta.z i
    lda.z i+1
    adc #>5
    sta.z i+1
    jmp __b1
}
// Fill some memory with a value
// fill(signed word zp(4) size, byte register(X) val)
fill: {
    .label end = 4
    .label addr = 6
    .label size = 4
    // end = start + size
    lda.z end
    clc
    adc.z addr
    sta.z end
    lda.z end+1
    adc.z addr+1
    sta.z end+1
  __b1:
    // for(byte* addr = start; addr!=end; addr++)
    lda.z addr+1
    cmp.z end+1
    bne __b2
    lda.z addr
    cmp.z end
    bne __b2
    // }
    rts
  __b2:
    // *addr = val
    txa
    ldy #0
    sta (addr),y
    // for(byte* addr = start; addr!=end; addr++)
    inc.z addr
    bne !+
    inc.z addr+1
  !:
    jmp __b1
}
// circle(signed word zp(6) r)
circle: {
    .const xc = $a0
    .const yc = $64
    .label __0 = 8
    .label __5 = $a
    .label __6 = $a
    .label __7 = 8
    .label __9 = $c
    .label __10 = 8
    .label r = 6
    .label p = 8
    .label y = 6
    .label x1 = 4
    // r << 1
    lda.z r
    asl
    sta.z __0
    lda.z r+1
    rol
    sta.z __0+1
    // p = 3-(r << 1)
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
    // for(int x = 0; x <= y; x ++)
    lda.z y
    cmp.z x1
    lda.z y+1
    sbc.z x1+1
    bvc !+
    eor #$80
  !:
    bpl __b2
    // }
    rts
  __b2:
    // if(p < 0)
    lda.z p+1
    bpl !__b3+
    jmp __b3
  !__b3:
    // y=y-1
    sec
    lda.z y
    sbc #1
    sta.z y
    bcs !+
    dec.z y+1
  !:
    // x-y
    lda.z x1
    sec
    sbc.z y
    sta.z __5
    lda.z x1+1
    sbc.z y+1
    sta.z __5+1
    // (x-y) << 2
    asl.z __6
    rol.z __6+1
    asl.z __6
    rol.z __6+1
    // p + ((x-y) << 2)
    lda.z __7
    clc
    adc.z __6
    sta.z __7
    lda.z __7+1
    adc.z __6+1
    sta.z __7+1
    // p = p + ((x-y) << 2) + 10
    clc
    lda.z p
    adc #<$a
    sta.z p
    lda.z p+1
    adc #>$a
    sta.z p+1
  __b4:
    // plot(xc+x,yc-y)
    clc
    lda.z x1
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
    // plot(xc-x,yc-y)
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
    // plot(xc+x,yc+y)
    clc
    lda.z x1
    adc #<xc
    sta.z plot.x
    lda.z x1+1
    adc #>xc
    sta.z plot.x+1
    clc
    lda.z y
    adc #<yc
    sta.z plot.y
    lda.z y+1
    adc #>yc
    sta.z plot.y+1
    jsr plot
    // plot(xc-x,yc+y)
    lda #<xc
    sec
    sbc.z x1
    sta.z plot.x
    lda #>xc
    sbc.z x1+1
    sta.z plot.x+1
    clc
    lda.z y
    adc #<yc
    sta.z plot.y
    lda.z y+1
    adc #>yc
    sta.z plot.y+1
    jsr plot
    // plot(xc+y,yc-x)
    clc
    lda.z y
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
    // plot(xc-y,yc-x)
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
    // plot(xc+y,yc+x)
    clc
    lda.z y
    adc #<xc
    sta.z plot.x
    lda.z y+1
    adc #>xc
    sta.z plot.x+1
    clc
    lda.z x1
    adc #<yc
    sta.z plot.y
    lda.z x1+1
    adc #>yc
    sta.z plot.y+1
    jsr plot
    // plot(xc-y,yc+x)
    lda #<xc
    sec
    sbc.z y
    sta.z plot.x
    lda #>xc
    sbc.z y+1
    sta.z plot.x+1
    clc
    lda.z x1
    adc #<yc
    sta.z plot.y
    lda.z x1+1
    adc #>yc
    sta.z plot.y+1
    jsr plot
    // for(int x = 0; x <= y; x ++)
    inc.z x1
    bne !+
    inc.z x1+1
  !:
    jmp __b1
  __b3:
    // x << 2
    lda.z x1
    asl
    sta.z __9
    lda.z x1+1
    rol
    sta.z __9+1
    asl.z __9
    rol.z __9+1
    // p + (x << 2)
    lda.z __10
    clc
    adc.z __9
    sta.z __10
    lda.z __10+1
    adc.z __9+1
    sta.z __10+1
    // p = p + (x << 2) + 6
    clc
    lda.z p
    adc #<6
    sta.z p
    lda.z p+1
    adc #>6
    sta.z p+1
    jmp __b4
}
// plot(signed word zp($a) x, signed word zp($c) y)
plot: {
    .label __8 = $e
    .label __11 = $c
    .label __12 = $10
    .label x = $a
    .label y = $c
    .label location = $e
    .label __15 = $10
    .label __16 = $10
    // if (x < 0 || x > 319 || y < 0 || y > 199)
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
    // x & $fff8
    lda.z x
    and #<$fff8
    sta.z __8
    lda.z x+1
    and #>$fff8
    sta.z __8+1
    // location += x & $fff8
    clc
    lda.z location
    adc #<BITMAP
    sta.z location
    lda.z location+1
    adc #>BITMAP
    sta.z location+1
    // <y
    lda.z y
    // <y & 7
    and #7
    // location += <y & 7
    clc
    adc.z location
    sta.z location
    bcc !+
    inc.z location+1
  !:
    // y >> 3
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
    // (y >> 3) * 320
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
    // location += ((y >> 3) * 320)
    lda.z location
    clc
    adc.z __12
    sta.z location
    lda.z location+1
    adc.z __12+1
    sta.z location+1
    // x & 7
    lda #7
    and.z x
    // (*location) | bitmask[x & 7]
    tay
    lda bitmask,y
    ldy #0
    ora (location),y
    // (*location) = (*location) | bitmask[x & 7]
    sta (location),y
  __breturn:
    // }
    rts
}
  bitmask: .byte $80, $40, $20, $10, 8, 4, 2, 1
