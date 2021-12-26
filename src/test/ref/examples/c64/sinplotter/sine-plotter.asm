// Generate a big sine and plot it on a bitmap
  // Commodore 64 PRG executable file
.file [name="sine-plotter.prg", type="prg", segments="Program"]
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
  /// $D016 Control register #2 Bit#3: CSEL Switch betweem 40 or 38 visible columns
  ///           CSEL|   Display window width   | First X coo. | Last X coo.
  ///           ----+--------------------------+--------------+------------
  ///             0 | 38 characters/304 pixels |   31 ($1f)   |  334 ($14e)
  ///             1 | 40 characters/320 pixels |   24 ($18)   |  343 ($157)
  .const VICII_CSEL = 8
  /// Mask for PROCESSOR_PORT_DDR which allows only memory configuration to be written
  .const PROCPORT_DDR_MEMORY_MASK = 7
  /// RAM in 0xA000, 0xE000 I/O in 0xD000
  .const PROCPORT_RAM_IO = 5
  .const WHITE = 1
  // PI*2 in u[4.28] format
  .const PI2_u4f28 = $6487ed51
  // PI in u[4.28] format
  .const PI_u4f28 = $3243f6a9
  // PI/2 in u[4.28] format
  .const PI_HALF_u4f28 = $1921fb54
  .const SIN_SIZE = $200
  .const SIZEOF_INT = 2
  .const OFFSET_STRUCT_MOS6526_CIA_PORT_A_DDR = 2
  .const OFFSET_STRUCT_MOS6569_VICII_BG_COLOR = $21
  /// $D011 Control Register #1
  /// @see #VICII_CONTROL1
  .label D011 = $d011
  /// $D016 Control register 2
  /// @see #VICII_CONTROL2
  .label D016 = $d016
  /// $D018 VIC-II base addresses
  // @see #VICII_MEMORY
  .label D018 = $d018
  /// Processor port data direction register
  .label PROCPORT_DDR = 0
  /// Processor Port Register controlling RAM/ROM configuration and the datasette
  .label PROCPORT = 1
  /// The VIC-II MOS 6567/6569
  .label VICII = $d000
  /// The CIA#2: Serial bus, RS-232, VIC memory bank
  .label CIA2 = $dd00
  .label SCREEN = $400
  .label BITMAP = $2000
  // Remainder after unsigned 16-bit division
  .label rem16u = $c
.segment Code
main: {
    .const vicSelectGfxBank1_toDd001_return = 3
    .const toD0181_return = (>(SCREEN&$3fff)*4)|(>BITMAP)/4&$f
    // asm
    sei
    // *PROCPORT_DDR = PROCPORT_DDR_MEMORY_MASK
    // Disable normal interrupt
    // Disable kernal & basic
    lda #PROCPORT_DDR_MEMORY_MASK
    sta.z PROCPORT_DDR
    // *PROCPORT = PROCPORT_RAM_IO
    lda #PROCPORT_RAM_IO
    sta.z PROCPORT
    // *D011 = VICII_BMM|VICII_DEN|VICII_RSEL|3
    lda #VICII_BMM|VICII_DEN|VICII_RSEL|3
    sta D011
    // CIA2->PORT_A_DDR = %00000011
    lda #3
    sta CIA2+OFFSET_STRUCT_MOS6526_CIA_PORT_A_DDR
    // CIA2->PORT_A = toDd00(gfx)
    lda #vicSelectGfxBank1_toDd001_return
    sta CIA2
    // *D016 = VICII_CSEL
    lda #VICII_CSEL
    sta D016
    // *D018 = toD018(SCREEN, BITMAP)
    lda #toD0181_return
    sta D018
    // bitmap_init(BITMAP, SCREEN)
    jsr bitmap_init
    // bitmap_clear(BLACK, WHITE)
    jsr bitmap_clear
    // sin16s_gen2(sin, SIN_SIZE, -320, 320)
    jsr sin16s_gen2
    // render_sine()
    jsr render_sine
  __b1:
    // (VICII->BG_COLOR)++;
    inc VICII+OFFSET_STRUCT_MOS6569_VICII_BG_COLOR
    jmp __b1
}
// Initialize bitmap plotting tables
// void bitmap_init(char *gfx, char *screen)
bitmap_init: {
    .label __7 = $26
    .label yoffs = $1a
    ldx #0
    lda #$80
  __b1:
    // bitmap_plot_bit[x] = bits
    sta bitmap_plot_bit,x
    // bits >>= 1
    lsr
    // if(bits==0)
    cmp #0
    bne __b2
    lda #$80
  __b2:
    // for(char x : 0..255)
    inx
    cpx #0
    bne __b1
    lda #<BITMAP
    sta.z yoffs
    lda #>BITMAP
    sta.z yoffs+1
    ldx #0
  __b3:
    // y&$7
    lda #7
    sax.z __7
    // BYTE0(yoffs)
    lda.z yoffs
    // y&$7 | BYTE0(yoffs)
    ora.z __7
    // bitmap_plot_ylo[y] = y&$7 | BYTE0(yoffs)
    sta bitmap_plot_ylo,x
    // BYTE1(yoffs)
    lda.z yoffs+1
    // bitmap_plot_yhi[y] = BYTE1(yoffs)
    sta bitmap_plot_yhi,x
    // if((y&$7)==7)
    lda #7
    cmp.z __7
    bne __b4
    // yoffs = yoffs + 40*8
    lda.z yoffs
    clc
    adc #<$28*8
    sta.z yoffs
    lda.z yoffs+1
    adc #>$28*8
    sta.z yoffs+1
  __b4:
    // for(char y : 0..255)
    inx
    cpx #0
    bne __b3
    // }
    rts
}
// Clear all graphics on the bitmap
// bgcol - the background color to fill the screen with
// fgcol - the foreground color to fill the screen with
// void bitmap_clear(char bgcol, char fgcol)
bitmap_clear: {
    .const col = WHITE*$10
    // memset(bitmap_screen, col, 1000uw)
    ldx #col
    lda #<SCREEN
    sta.z memset.str
    lda #>SCREEN
    sta.z memset.str+1
    lda #<$3e8
    sta.z memset.num
    lda #>$3e8
    sta.z memset.num+1
    jsr memset
    // memset(bitmap_gfx, 0, 8000uw)
    ldx #0
    lda #<BITMAP
    sta.z memset.str
    lda #>BITMAP
    sta.z memset.str+1
    lda #<$1f40
    sta.z memset.num
    lda #>$1f40
    sta.z memset.num+1
    jsr memset
    // }
    rts
}
// Generate signed int sine table - with values in the range min-max.
// sintab - the table to generate into
// wavelength - the number of sine points in a total sine wavelength (the size of the table)
// void sin16s_gen2(__zp($1c) int *sintab, unsigned int wavelength, int min, int max)
sin16s_gen2: {
    .const min = -$140
    .const max = $140
    .label ampl = max-min
    .label __6 = 2
    .label __8 = $a
    .label step = $22
    .label sintab = $1c
    // u[4.28]
    // Iterate over the table
    .label x = $1e
    .label i = $1a
    // unsigned long step = div32u16u(PI2_u4f28, wavelength)
  // ampl is always positive so shifting left does not alter the sign
  // u[4.28] step = PI*2/wavelength
    jsr div32u16u
    // unsigned long step = div32u16u(PI2_u4f28, wavelength)
    lda #<sin
    sta.z sintab
    lda #>sin
    sta.z sintab+1
    lda #<0
    sta.z x
    sta.z x+1
    lda #<0>>$10
    sta.z x+2
    lda #>0>>$10
    sta.z x+3
    lda #<0
    sta.z i
    sta.z i+1
  // u[4.28]
  __b1:
    // for( unsigned int i=0; i<wavelength; i++)
    lda.z i+1
    cmp #>SIN_SIZE
    bcc __b2
    bne !+
    lda.z i
    cmp #<SIN_SIZE
    bcc __b2
  !:
    // }
    rts
  __b2:
    // sin16s(x)
    lda.z x
    sta.z sin16s.x
    lda.z x+1
    sta.z sin16s.x+1
    lda.z x+2
    sta.z sin16s.x+2
    lda.z x+3
    sta.z sin16s.x+3
    jsr sin16s
    // mul16s(sin16s(x), ampl)
    jsr mul16s
    // WORD1(mul16s(sin16s(x), ampl))
    lda.z __6+2
    sta.z __8
    lda.z __6+3
    sta.z __8+1
    // *sintab++ = offs + (signed int)WORD1(mul16s(sin16s(x), ampl))
    ldy #0
    lda.z __8
    sta (sintab),y
    iny
    lda.z __8+1
    sta (sintab),y
    // *sintab++ = offs + (signed int)WORD1(mul16s(sin16s(x), ampl));
    lda #SIZEOF_INT
    clc
    adc.z sintab
    sta.z sintab
    bcc !+
    inc.z sintab+1
  !:
    // x = x + step
    clc
    lda.z x
    adc.z step
    sta.z x
    lda.z x+1
    adc.z step+1
    sta.z x+1
    lda.z x+2
    adc.z step+2
    sta.z x+2
    lda.z x+3
    adc.z step+3
    sta.z x+3
    // for( unsigned int i=0; i<wavelength; i++)
    inc.z i
    bne !+
    inc.z i+1
  !:
    jmp __b1
}
render_sine: {
    .label __1 = $c
    .label __4 = $18
    .label __11 = $18
    .label sin_val = $c
    .label sin2_val = $c
    .label xpos = $1a
    .label sin_idx = $1c
    lda #<0
    sta.z xpos
    sta.z xpos+1
    sta.z sin_idx
    sta.z sin_idx+1
  __b1:
    // for(unsigned int sin_idx=0; sin_idx<SIN_SIZE; sin_idx++)
    lda.z sin_idx+1
    cmp #>SIN_SIZE
    bcc __b2
    bne !+
    lda.z sin_idx
    cmp #<SIN_SIZE
    bcc __b2
  !:
    // }
    rts
  __b2:
    // sin+sin_idx
    lda.z sin_idx
    asl
    sta.z __11
    lda.z sin_idx+1
    rol
    sta.z __11+1
    lda.z __11
    clc
    adc #<sin
    sta.z __1
    lda.z __11+1
    adc #>sin
    sta.z __1+1
    // signed int sin_val = *(sin+sin_idx)
    ldy #0
    lda (sin_val),y
    pha
    iny
    lda (sin_val),y
    sta.z sin_val+1
    pla
    sta.z sin_val
    // char ypos = wrap_y(sin_val)
    jsr wrap_y
    // char ypos = wrap_y(sin_val)
    tax
    // bitmap_plot(xpos,ypos)
    jsr bitmap_plot
    // sin2+sin_idx
    lda.z __4
    clc
    adc #<sin2
    sta.z __4
    lda.z __4+1
    adc #>sin2
    sta.z __4+1
    // signed int sin2_val = *(sin2+sin_idx)
    ldy #0
    lda (__4),y
    sta.z sin2_val
    iny
    lda (__4),y
    sta.z sin2_val+1
    // char ypos2 = wrap_y(sin2_val+10)
    lda.z wrap_y.y
    clc
    adc #<$a
    sta.z wrap_y.y
    lda.z wrap_y.y+1
    adc #>$a
    sta.z wrap_y.y+1
    jsr wrap_y
    // char ypos2 = wrap_y(sin2_val+10)
    tax
    // bitmap_plot(xpos,ypos2)
    jsr bitmap_plot
    // xpos++;
    inc.z xpos
    bne !+
    inc.z xpos+1
  !:
    // if(xpos==320)
    lda.z xpos+1
    cmp #>$140
    bne __b3
    lda.z xpos
    cmp #<$140
    bne __b3
    lda #<0
    sta.z xpos
    sta.z xpos+1
  __b3:
    // for(unsigned int sin_idx=0; sin_idx<SIN_SIZE; sin_idx++)
    inc.z sin_idx
    bne !+
    inc.z sin_idx+1
  !:
    jmp __b1
}
// Copies the character c (an unsigned char) to the first num characters of the object pointed to by the argument str.
// void * memset(__zp($c) void *str, __register(X) char c, __zp($1a) unsigned int num)
memset: {
    .label end = $1a
    .label dst = $c
    .label num = $1a
    .label str = $c
    // if(num>0)
    lda.z num
    bne !+
    lda.z num+1
    beq __breturn
  !:
    // char* end = (char*)str + num
    clc
    lda.z end
    adc.z str
    sta.z end
    lda.z end+1
    adc.z str+1
    sta.z end+1
  __b2:
    // for(char* dst = str; dst!=end; dst++)
    lda.z dst+1
    cmp.z end+1
    bne __b3
    lda.z dst
    cmp.z end
    bne __b3
  __breturn:
    // }
    rts
  __b3:
    // *dst = c
    txa
    ldy #0
    sta (dst),y
    // for(char* dst = str; dst!=end; dst++)
    inc.z dst
    bne !+
    inc.z dst+1
  !:
    jmp __b2
}
// Divide unsigned 32-bit unsigned long dividend with a 16-bit unsigned int divisor
// The 16-bit unsigned int remainder can be found in rem16u after the division
// __zp($22) unsigned long div32u16u(unsigned long dividend, unsigned int divisor)
div32u16u: {
    .label return = $22
    .label quotient_hi = $18
    .label quotient_lo = $e
    // unsigned int quotient_hi = divr16u(WORD1(dividend), divisor, 0)
    lda #<PI2_u4f28>>$10
    sta.z divr16u.dividend
    lda #>PI2_u4f28>>$10
    sta.z divr16u.dividend+1
    lda #<0
    sta.z divr16u.rem
    sta.z divr16u.rem+1
    jsr divr16u
    // unsigned int quotient_hi = divr16u(WORD1(dividend), divisor, 0)
    lda.z divr16u.return
    sta.z quotient_hi
    lda.z divr16u.return+1
    sta.z quotient_hi+1
    // unsigned int quotient_lo = divr16u(WORD0(dividend), divisor, rem16u)
    lda #<PI2_u4f28&$ffff
    sta.z divr16u.dividend
    lda #>PI2_u4f28&$ffff
    sta.z divr16u.dividend+1
    jsr divr16u
    // unsigned int quotient_lo = divr16u(WORD0(dividend), divisor, rem16u)
    // unsigned long quotient = MAKELONG( quotient_hi, quotient_lo )
    lda.z quotient_hi
    sta.z return+2
    lda.z quotient_hi+1
    sta.z return+3
    lda.z quotient_lo
    sta.z return
    lda.z quotient_lo+1
    sta.z return+1
    // }
    rts
}
// Calculate signed int sine sin(x)
// x: unsigned long input u[4.28] in the interval $00000000 - PI2_u4f28
// result: signed int sin(x) s[0.15] - using the full range  -$7fff - $7fff
// __zp($c) int sin16s(__zp($14) unsigned long x)
sin16s: {
    .label __4 = 6
    .label x = $14
    .label return = $c
    .label x1 = $18
    .label x2 = $10
    .label x3 = $10
    .label x3_6 = $12
    .label usinx = $c
    .label x4 = $10
    .label x5 = $12
    .label x5_128 = $12
    .label sinx = $c
    // if(x >= PI_u4f28 )
    lda.z x+3
    cmp #>PI_u4f28>>$10
    bcc __b4
    bne !+
    lda.z x+2
    cmp #<PI_u4f28>>$10
    bcc __b4
    bne !+
    lda.z x+1
    cmp #>PI_u4f28
    bcc __b4
    bne !+
    lda.z x
    cmp #<PI_u4f28
    bcc __b4
  !:
    // x = x - PI_u4f28
    lda.z x
    sec
    sbc #<PI_u4f28
    sta.z x
    lda.z x+1
    sbc #>PI_u4f28
    sta.z x+1
    lda.z x+2
    sbc #<PI_u4f28>>$10
    sta.z x+2
    lda.z x+3
    sbc #>PI_u4f28>>$10
    sta.z x+3
    ldy #1
    jmp __b1
  __b4:
    ldy #0
  __b1:
    // if(x >= PI_HALF_u4f28 )
    lda.z x+3
    cmp #>PI_HALF_u4f28>>$10
    bcc __b2
    bne !+
    lda.z x+2
    cmp #<PI_HALF_u4f28>>$10
    bcc __b2
    bne !+
    lda.z x+1
    cmp #>PI_HALF_u4f28
    bcc __b2
    bne !+
    lda.z x
    cmp #<PI_HALF_u4f28
    bcc __b2
  !:
    // x = PI_u4f28 - x
    lda #<PI_u4f28
    sec
    sbc.z x
    sta.z x
    lda #>PI_u4f28
    sbc.z x+1
    sta.z x+1
    lda #<PI_u4f28>>$10
    sbc.z x+2
    sta.z x+2
    lda #>PI_u4f28>>$10
    sbc.z x+3
    sta.z x+3
  __b2:
    // x<<3
    lda.z x
    asl
    sta.z __4
    lda.z x+1
    rol
    sta.z __4+1
    lda.z x+2
    rol
    sta.z __4+2
    lda.z x+3
    rol
    sta.z __4+3
    asl.z __4
    rol.z __4+1
    rol.z __4+2
    rol.z __4+3
    asl.z __4
    rol.z __4+1
    rol.z __4+2
    rol.z __4+3
    // unsigned int x1 = WORD1(x<<3)
    // sinx = x - x^3/6 + x5/128;
    lda.z __4+2
    sta.z x1
    lda.z __4+3
    sta.z x1+1
    // unsigned int x2 = mulu16_sel(x1, x1, 0)
    lda.z x1
    sta.z mulu16_sel.v1
    lda.z x1+1
    sta.z mulu16_sel.v1+1
    lda.z x1
    sta.z mulu16_sel.v2
    lda.z x1+1
    sta.z mulu16_sel.v2+1
  // u[1.15]
    ldx #0
    jsr mulu16_sel
    // unsigned int x2 = mulu16_sel(x1, x1, 0)
    lda.z mulu16_sel.return
    sta.z x2
    lda.z mulu16_sel.return+1
    sta.z x2+1
    // unsigned int x3 = mulu16_sel(x2, x1, 1)
    lda.z x1
    sta.z mulu16_sel.v2
    lda.z x1+1
    sta.z mulu16_sel.v2+1
  // u[2.14] x^2
    ldx #1
    jsr mulu16_sel
    // unsigned int x3 = mulu16_sel(x2, x1, 1)
    lda.z mulu16_sel.return
    sta.z mulu16_sel.return_1
    lda.z mulu16_sel.return+1
    sta.z mulu16_sel.return_1+1
    // unsigned int x3_6 = mulu16_sel(x3, $10000/6, 1)
  // u[2.14] x^3
    ldx #1
    lda #<$10000/6
    sta.z mulu16_sel.v2
    lda #>$10000/6
    sta.z mulu16_sel.v2+1
    jsr mulu16_sel
    // unsigned int x3_6 = mulu16_sel(x3, $10000/6, 1)
    // unsigned int usinx = x1 - x3_6
    // u[1.15] x^3/6;
    lda.z x1
    sec
    sbc.z x3_6
    sta.z usinx
    lda.z x1+1
    sbc.z x3_6+1
    sta.z usinx+1
    // unsigned int x4 = mulu16_sel(x3, x1, 0)
    lda.z x1
    sta.z mulu16_sel.v2
    lda.z x1+1
    sta.z mulu16_sel.v2+1
  // u[1.15] x - x^3/6
    ldx #0
    jsr mulu16_sel
    // unsigned int x4 = mulu16_sel(x3, x1, 0)
    lda.z mulu16_sel.return
    sta.z mulu16_sel.return_1
    lda.z mulu16_sel.return+1
    sta.z mulu16_sel.return_1+1
    // unsigned int x5 = mulu16_sel(x4, x1, 0)
    lda.z x1
    sta.z mulu16_sel.v2
    lda.z x1+1
    sta.z mulu16_sel.v2+1
  // u[3.13] x^4
    ldx #0
    jsr mulu16_sel
    // unsigned int x5 = mulu16_sel(x4, x1, 0)
    // unsigned int x5_128 = x5>>4
    // u[4.12] x^5
    lsr.z x5_128+1
    ror.z x5_128
    lsr.z x5_128+1
    ror.z x5_128
    lsr.z x5_128+1
    ror.z x5_128
    lsr.z x5_128+1
    ror.z x5_128
    // usinx = usinx + x5_128
    clc
    lda.z usinx
    adc.z x5_128
    sta.z usinx
    lda.z usinx+1
    adc.z x5_128+1
    sta.z usinx+1
    // if(isUpper!=0)
    cpy #0
    beq __b3
    // sinx = -(signed int)usinx
    lda #0
    sec
    sbc.z sinx
    sta.z sinx
    lda #0
    sbc.z sinx+1
    sta.z sinx+1
  __b3:
    // }
    rts
}
// Multiply of two signed ints to a signed long
// Fixes offsets introduced by using unsigned multiplication
// __zp(2) long mul16s(__zp($c) int a, int b)
mul16s: {
    .label __6 = $18
    .label __11 = $18
    .label a = $c
    .label return = 2
    .label m = 2
    // unsigned long m = mul16u((unsigned int)a, (unsigned int) b)
    lda.z a
    sta.z mul16u.a
    lda.z a+1
    sta.z mul16u.a+1
    lda #<sin16s_gen2.ampl
    sta.z mul16u.b
    lda #>sin16s_gen2.ampl
    sta.z mul16u.b+1
    jsr mul16u
    // unsigned long m = mul16u((unsigned int)a, (unsigned int) b)
    // if(a<0)
    lda.z a+1
    bpl __b2
    // WORD1(m)
    lda.z m+2
    sta.z __6
    lda.z m+3
    sta.z __6+1
    // WORD1(m) = WORD1(m)-(unsigned int)b
    lda.z __11
    sec
    sbc #<sin16s_gen2.ampl
    sta.z __11
    lda.z __11+1
    sbc #>sin16s_gen2.ampl
    sta.z __11+1
    lda.z __11
    sta.z m+2
    lda.z __11+1
    sta.z m+3
  __b2:
    // return (signed long)m;
    // }
    rts
}
// __register(A) char wrap_y(__zp($c) int y)
wrap_y: {
    .label y = $c
  __b1:
    // while(y>=200)
    lda.z y
    cmp #<$c8
    lda.z y+1
    sbc #>$c8
    bvc !+
    eor #$80
  !:
    bpl __b2
  __b3:
    // while(y<0)
    lda.z y+1
    bmi __b4
    // return (char)y;
    lda.z y
    // }
    rts
  __b4:
    // y += 200
    clc
    lda.z y
    adc #<$c8
    sta.z y
    lda.z y+1
    adc #>$c8
    sta.z y+1
    jmp __b3
  __b2:
    // y -= 200
    lda.z y
    sec
    sbc #<$c8
    sta.z y
    lda.z y+1
    sbc #>$c8
    sta.z y+1
    jmp __b1
}
// Plot a single dot in the bitmap
// void bitmap_plot(__zp($1a) unsigned int x, __register(X) char y)
bitmap_plot: {
    .label __1 = $10
    .label plotter = $12
    .label x = $1a
    // MAKEWORD( bitmap_plot_yhi[y], bitmap_plot_ylo[y] )
    lda bitmap_plot_yhi,x
    sta.z plotter+1
    lda bitmap_plot_ylo,x
    sta.z plotter
    // x & $fff8
    lda.z x
    and #<$fff8
    sta.z __1
    lda.z x+1
    and #>$fff8
    sta.z __1+1
    // plotter += ( x & $fff8 )
    clc
    lda.z plotter
    adc.z __1
    sta.z plotter
    lda.z plotter+1
    adc.z __1+1
    sta.z plotter+1
    // BYTE0(x)
    ldx.z x
    // *plotter |= bitmap_plot_bit[BYTE0(x)]
    lda bitmap_plot_bit,x
    ldy #0
    ora (plotter),y
    sta (plotter),y
    // }
    rts
}
// Performs division on two 16 bit unsigned ints and an initial remainder
// Returns the quotient dividend/divisor.
// The final remainder will be set into the global variable rem16u
// Implemented using simple binary division
// __zp($e) unsigned int divr16u(__zp($10) unsigned int dividend, unsigned int divisor, __zp($c) unsigned int rem)
divr16u: {
    .label rem = $c
    .label dividend = $10
    .label quotient = $e
    .label return = $e
    ldx #0
    txa
    sta.z quotient
    sta.z quotient+1
  __b1:
    // rem = rem << 1
    asl.z rem
    rol.z rem+1
    // BYTE1(dividend)
    lda.z dividend+1
    // BYTE1(dividend) & $80
    and #$80
    // if( (BYTE1(dividend) & $80) != 0 )
    cmp #0
    beq __b2
    // rem = rem | 1
    lda #1
    ora.z rem
    sta.z rem
  __b2:
    // dividend = dividend << 1
    asl.z dividend
    rol.z dividend+1
    // quotient = quotient << 1
    asl.z quotient
    rol.z quotient+1
    // if(rem>=divisor)
    lda.z rem+1
    cmp #>SIN_SIZE
    bcc __b3
    bne !+
    lda.z rem
    cmp #<SIN_SIZE
    bcc __b3
  !:
    // quotient++;
    inc.z quotient
    bne !+
    inc.z quotient+1
  !:
    // rem = rem - divisor
    lda.z rem
    sec
    sbc #<SIN_SIZE
    sta.z rem
    lda.z rem+1
    sbc #>SIN_SIZE
    sta.z rem+1
  __b3:
    // for( char i : 0..15)
    inx
    cpx #$10
    bne __b1
    // rem16u = rem
    // }
    rts
}
// Calculate val*val for two unsigned int values - the result is 16 selected bits of the 32-bit result.
// The select parameter indicates how many of the highest bits of the 32-bit result to skip
// __zp($12) unsigned int mulu16_sel(__zp($10) unsigned int v1, __zp($e) unsigned int v2, __register(X) char select)
mulu16_sel: {
    .label __0 = 2
    .label __1 = 2
    .label v1 = $10
    .label v2 = $e
    .label return = $12
    .label return_1 = $10
    // mul16u(v1, v2)
    lda.z v1
    sta.z mul16u.a
    lda.z v1+1
    sta.z mul16u.a+1
    jsr mul16u
    // mul16u(v1, v2)
    // mul16u(v1, v2)<<select
    cpx #0
    beq !e+
  !:
    asl.z __1
    rol.z __1+1
    rol.z __1+2
    rol.z __1+3
    dex
    bne !-
  !e:
    // WORD1(mul16u(v1, v2)<<select)
    lda.z __1+2
    sta.z return
    lda.z __1+3
    sta.z return+1
    // }
    rts
}
// Perform binary multiplication of two unsigned 16-bit unsigned ints into a 32-bit unsigned long
// __zp(2) unsigned long mul16u(__zp($a) unsigned int a, __zp($e) unsigned int b)
mul16u: {
    .label a = $a
    .label b = $e
    .label return = 2
    .label mb = 6
    .label res = 2
    // unsigned long mb = b
    lda.z b
    sta.z mb
    lda.z b+1
    sta.z mb+1
    lda #0
    sta.z mb+2
    sta.z mb+3
    sta.z res
    sta.z res+1
    lda #<0>>$10
    sta.z res+2
    lda #>0>>$10
    sta.z res+3
  __b1:
    // while(a!=0)
    lda.z a
    ora.z a+1
    bne __b2
    // }
    rts
  __b2:
    // a&1
    lda #1
    and.z a
    // if( (a&1) != 0)
    cmp #0
    beq __b3
    // res = res + mb
    clc
    lda.z res
    adc.z mb
    sta.z res
    lda.z res+1
    adc.z mb+1
    sta.z res+1
    lda.z res+2
    adc.z mb+2
    sta.z res+2
    lda.z res+3
    adc.z mb+3
    sta.z res+3
  __b3:
    // a = a>>1
    lsr.z a+1
    ror.z a
    // mb = mb<<1
    asl.z mb
    rol.z mb+1
    rol.z mb+2
    rol.z mb+3
    jmp __b1
}
.segment Data
  // Tables for the plotter - initialized by calling bitmap_init();
  bitmap_plot_ylo: .fill $100, 0
  bitmap_plot_yhi: .fill $100, 0
  bitmap_plot_bit: .fill $100, 0
  .align $100
  sin: .fill 2*$200, 0
sin2:
.for(var i=0; i<512; i++) {
  	  .word sin(toRadians([i*360]/512))*320
    }

