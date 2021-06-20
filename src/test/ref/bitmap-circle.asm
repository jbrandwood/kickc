// Plots a circle on a bitmap using Bresenham's Circle algorithm
// Coded by Richard-William Loerakker
// Original Source https://bcaorganizer.blogspot.com/p/c-program-for_21.html?fbclid=IwAR0iL8pYcCqhCPa6LmtQ9qej-YonYVepY2cBegYRIWO0l8RPeOnTVniMAac
  // Commodore 64 PRG executable file
.file [name="bitmap-circle.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  /// $D011 Control Register #1  Bit#5: BMM Turn Bitmap Mode on/off
  .const VICII_BMM = $20
  /// $D011 Control Register #1  Bit#4: DEN Switch VIC-II output on/off
  .const VICII_DEN = $10
  /// $D011 Control Register #1  Bit#3: RSEL Switch betweem 25 or 24 visible rows
  ///          RSEL|  Display window height   | First line  | Last line
  ///          ----+--------------------------+-------------+----------
  ///            0 | 24 text lines/192 pixels |   55 ($37)  | 246 ($f6)
  ///            1 | 25 text lines/200 pixels |   51 ($33)  | 250 ($fa)
  .const VICII_RSEL = 8
  .const BLUE = 6
  /// $D020 Border Color
  .label BORDER_COLOR = $d020
  /// $D011 Control Register #1
  /// @see #VICII_CONTROL1
  .label D011 = $d011
  /// $D018 VIC-II base addresses
  /// - Bit#0: not used
  /// - Bit#1-#3: CB Address Bits 11-13 of the Character Set (*2048)
  /// - Bit#4-#7: VM Address Bits 10-13 of the Screen RAM (*1024)
  /// Initial Value: %00010100
  .label VICII_MEMORY = $d018
  .label SCREEN = $400
  .label BITMAP = $2000
.segment Code
main: {
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
    // *D011 = VICII_BMM|VICII_DEN|VICII_RSEL|3
    lda #VICII_BMM|VICII_DEN|VICII_RSEL|3
    sta D011
    // *VICII_MEMORY =  (byte)((((word)SCREEN&$3fff)/$40)|(((word)BITMAP&$3fff)/$400))
    lda #(SCREEN&$3fff)/$40|(BITMAP&$3fff)/$400
    sta VICII_MEMORY
    // circle(100,100,50)
    jsr circle
  __b1:
    jmp __b1
}
// Fill some memory with a value
// fill(signed word zp(2) size, byte register(X) val)
fill: {
    .label end = 2
    .label addr = 4
    .label size = 2
    // byte* end = start + size
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
circle: {
    .const xc = $64
    .const yc = $64
    .const r = $32
    .label __5 = 8
    .label __6 = 8
    .label __7 = 6
    .label __9 = $a
    .label __10 = 6
    .label p = 6
    .label y = 4
    .label x1 = 2
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
// plot(signed word zp(8) x, signed word zp($a) y)
plot: {
    .label __0 = $c
    .label __2 = $a
    .label __3 = $e
    .label x = 8
    .label y = $a
    .label location = $c
    .label __7 = $e
    .label __8 = $e
    // x & $fff8
    lda.z x
    and #<$fff8
    sta.z __0
    lda.z x+1
    and #>$fff8
    sta.z __0+1
    // location += x & $fff8
    clc
    lda.z location
    adc #<BITMAP
    sta.z location
    lda.z location+1
    adc #>BITMAP
    sta.z location+1
    // (char)y & 7
    lda.z y
    and #7
    // location += (char)y & 7
    clc
    adc.z location
    sta.z location
    bcc !+
    inc.z location+1
  !:
    // y >> 3
    lda.z __2+1
    cmp #$80
    ror.z __2+1
    ror.z __2
    lda.z __2+1
    cmp #$80
    ror.z __2+1
    ror.z __2
    lda.z __2+1
    cmp #$80
    ror.z __2+1
    ror.z __2
    // (y >> 3) * 320
    lda.z __2
    asl
    sta.z __7
    lda.z __2+1
    rol
    sta.z __7+1
    asl.z __7
    rol.z __7+1
    lda.z __8
    clc
    adc.z __2
    sta.z __8
    lda.z __8+1
    adc.z __2+1
    sta.z __8+1
    lda.z __3+1
    sta.z $ff
    lda.z __3
    sta.z __3+1
    lda #0
    sta.z __3
    lsr.z $ff
    ror.z __3+1
    ror.z __3
    lsr.z $ff
    ror.z __3+1
    ror.z __3
    // location += ((y >> 3) * 320)
    lda.z location
    clc
    adc.z __3
    sta.z location
    lda.z location+1
    adc.z __3+1
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
    // }
    rts
}
.segment Data
  bitmask: .byte $80, $40, $20, $10, 8, 4, 2, 1
