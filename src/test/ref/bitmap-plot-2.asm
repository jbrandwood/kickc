// Tests the simple bitmap plotter - and counts plots per frame in an IRQ
// Plots a spiral
/// @file
/// Commodore 64 Registers and Constants
/// @file
/// The MOS 6526 Complex Interface Adapter (CIA)
///
/// http://archive.6502.org/datasheets/mos_6526_cia_recreated.pdf
  // Commodore 64 PRG executable file
.file [name="bitmap-plot-2.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(__start)
  /// Value that disables all CIA interrupts when stored to the CIA Interrupt registers
  .const CIA_INTERRUPT_CLEAR = $7f
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
  /// VICII IRQ Status/Enable Raster
  // @see #IRQ_ENABLE #IRQ_STATUS
  ///  0 | RST| Reaching a certain raster line. The line is specified by writing
  ///    |    | to register 0xd012 and bit 7 of $d011 and internally stored by
  ///    |    | the VIC for the raster compare. The test for reaching the
  ///    |    | interrupt raster line is done in cycle 0 of every line (for line
  ///    |    | 0, in cycle 1).
  .const IRQ_RASTER = 1
  /// Mask for PROCESSOR_PORT_DDR which allows only memory configuration to be written
  .const PROCPORT_DDR_MEMORY_MASK = 7
  /// RAM in 0xA000, 0xE000 I/O in 0xD000
  .const PROCPORT_RAM_IO = 5
  /// The colors of the C64
  .const BLACK = 0
  .const WHITE = 1
  // PI*2 in u[4.28] format
  .const PI2_u4f28 = $6487ed51
  // PI in u[4.28] format
  .const PI_u4f28 = $3243f6a9
  // PI/2 in u[4.28] format
  .const PI_HALF_u4f28 = $1921fb54
  .const SIZEOF_INT = 2
  .const OFFSET_STRUCT_MOS6526_CIA_INTERRUPT = $d
  /// $D012 RASTER Raster counter
  .label RASTER = $d012
  /// $D020 Border Color
  .label BORDER_COLOR = $d020
  /// $D021 Background Color 0
  .label BG_COLOR = $d021
  /// $D011 Control Register #1
  /// - Bit#0-#2: YSCROLL Screen Soft Scroll Vertical
  /// - Bit#3: RSEL Switch betweem 25 or 24 visible rows
  ///          RSEL|  Display window height   | First line  | Last line
  ///          ----+--------------------------+-------------+----------
  ///            0 | 24 text lines/192 pixels |   55 ($37)  | 246 ($f6)
  ///            1 | 25 text lines/200 pixels |   51 ($33)  | 250 ($fa)
  /// - Bit#4: DEN Switch VIC-II output on/off
  /// - Bit#5: BMM Turn Bitmap Mode on/off
  /// - Bit#6: ECM Turn Extended Color Mode on/off
  /// - Bit#7: RST8 9th Bit for $D012 Rasterline counter
  /// Initial Value: %10011011
  .label VICII_CONTROL1 = $d011
  /// $D011 Control Register #1
  /// @see #VICII_CONTROL1
  .label D011 = $d011
  /// $D018 VIC-II base addresses
  // @see #VICII_MEMORY
  .label D018 = $d018
  /// VIC II IRQ Status Register
  .label IRQ_STATUS = $d019
  /// VIC II IRQ Enable Register
  .label IRQ_ENABLE = $d01a
  /// Processor port data direction register
  .label PROCPORT_DDR = 0
  /// Processor Port Register controlling RAM/ROM configuration and the datasette
  .label PROCPORT = 1
  /// The CIA#1: keyboard matrix, joystick #1/#2
  .label CIA1 = $dc00
  /// The vector used when the HARDWARE serves IRQ interrupts
  .label HARDWARE_IRQ = $fffe
  .label BITMAP = $2000
  .label SCREEN = $400
  // Counts frames - updated by the IRQ
  .label frame_cnt = $30
  // Remainder after unsigned 16-bit division
  .label rem16u = $20
.segment Code
__start: {
    // volatile byte frame_cnt = 1
    lda #1
    sta.z frame_cnt
    jsr main
    rts
}
// Interrupt Routine counting frames
irq: {
    sta rega+1
    // *BG_COLOR = WHITE
    lda #WHITE
    sta BG_COLOR
    // if(frame_cnt)
    lda.z frame_cnt
    beq __b1
    // frame_cnt++;
    inc.z frame_cnt
  __b1:
    // *BG_COLOR = BLACK
    lda #BLACK
    sta BG_COLOR
    // *IRQ_STATUS = IRQ_RASTER
    // Acknowledge the IRQ
    lda #IRQ_RASTER
    sta IRQ_STATUS
    // }
  rega:
    lda #0
    rti
}
main: {
    .const toD0181_return = (>(SCREEN&$3fff)*4)|(>BITMAP)/4&$f
    .label __7 = $10
    .label __11 = $1a
    .label __26 = $1e
    .label __27 = $1e
    .label __28 = $10
    .label __29 = $1a
    .label cos_x = $1e
    .label xpos = 2
    .label x = $10
    .label sin_y = $1e
    .label ypos = 2
    .label y = $1a
    .label idx_x = $2c
    .label idx_y = $2e
    .label r = $16
    .label r_add = $2b
    .label __30 = $1e
    .label __31 = $1e
    // sin16s_gen2(SINE, 512, -0x1001, 0x1001)
    jsr sin16s_gen2
    // bitmap_init(BITMAP, SCREEN)
    jsr bitmap_init
    // bitmap_clear(BLACK, WHITE)
    jsr bitmap_clear
    // *D011 = VICII_BMM|VICII_DEN|VICII_RSEL|3
    lda #VICII_BMM|VICII_DEN|VICII_RSEL|3
    sta D011
    // *D018 = toD018(SCREEN, BITMAP)
    lda #toD0181_return
    sta D018
    // init_irq()
    jsr init_irq
    lda #$20
    sta.z r_add
    lda #<$80
    sta.z idx_y
    lda #>$80
    sta.z idx_y+1
    lda #<0
    sta.z r
    sta.z r+1
    sta.z idx_x
    sta.z idx_x+1
  __b2:
    // signed word cos_x = SINE[idx_x]
    lda.z idx_x
    asl
    sta.z __26
    lda.z idx_x+1
    rol
    sta.z __26+1
    lda.z __30
    clc
    adc #<SINE
    sta.z __30
    lda.z __30+1
    adc #>SINE
    sta.z __30+1
    ldy #0
    lda (cos_x),y
    pha
    iny
    lda (cos_x),y
    sta.z cos_x+1
    pla
    sta.z cos_x
    // signed dword xpos = mul16s(r, cos_x)
    jsr mul16s
    // signed dword xpos = mul16s(r, cos_x)
    // WORD1(xpos)
    lda.z xpos+2
    sta.z __28
    lda.z xpos+3
    sta.z __28+1
    // ((signed word)WORD1(xpos))>>2
    lda.z __7+1
    cmp #$80
    ror.z __7+1
    ror.z __7
    lda.z __7+1
    cmp #$80
    ror.z __7+1
    ror.z __7
    // 160 + ((signed word)WORD1(xpos))>>2
    clc
    lda.z x
    adc #<$a0
    sta.z x
    lda.z x+1
    adc #>$a0
    sta.z x+1
    // signed word sin_y = SINE[idx_y]
    lda.z idx_y
    asl
    sta.z __27
    lda.z idx_y+1
    rol
    sta.z __27+1
    lda.z __31
    clc
    adc #<SINE
    sta.z __31
    lda.z __31+1
    adc #>SINE
    sta.z __31+1
    ldy #0
    lda (sin_y),y
    pha
    iny
    lda (sin_y),y
    sta.z sin_y+1
    pla
    sta.z sin_y
    // signed dword ypos = mul16s(r, sin_y)
    jsr mul16s
    // signed dword ypos = mul16s(r, sin_y)
    // WORD1(ypos)
    lda.z ypos+2
    sta.z __29
    lda.z ypos+3
    sta.z __29+1
    // ((signed word)WORD1(ypos))>>2
    lda.z __11+1
    cmp #$80
    ror.z __11+1
    ror.z __11
    lda.z __11+1
    cmp #$80
    ror.z __11+1
    ror.z __11
    // 100 + ((signed word)WORD1(ypos))>>2
    lda.z y
    clc
    adc #<$64
    sta.z y
    lda.z y+1
    adc #>$64
    sta.z y+1
    // bitmap_plot(x, (byte)y)
    ldx.z y
    jsr bitmap_plot
    // plots_per_frame[frame_cnt]++;
    ldx.z frame_cnt
    inc plots_per_frame,x
    // idx_x += r_add
    lda.z r_add
    clc
    adc.z idx_x
    sta.z idx_x
    bcc !+
    inc.z idx_x+1
  !:
    // if(idx_x>=512)
    lda.z idx_x+1
    cmp #>$200
    bcc __b3
    bne !+
    lda.z idx_x
    cmp #<$200
    bcc __b3
  !:
    lda #<0
    sta.z idx_x
    sta.z idx_x+1
  __b3:
    // idx_y += r_add
    lda.z r_add
    clc
    adc.z idx_y
    sta.z idx_y
    bcc !+
    inc.z idx_y+1
  !:
    // if(idx_y>=512)
    lda.z idx_y+1
    cmp #>$200
    bcc __b4
    bne !+
    lda.z idx_y
    cmp #<$200
    bcc __b4
  !:
    lda #<0
    sta.z idx_y
    sta.z idx_y+1
  __b4:
    // r += r_add
    lda.z r
    clc
    adc.z r_add
    sta.z r
    lda.z r+1
    adc #0
    sta.z r+1
    // if((idx_x==0) && (r_add!=1))
    lda.z idx_x
    ora.z idx_x+1
    bne __b5
    lda #1
    cmp.z r_add
    beq __b5
    // r_add /= 2
    lsr.z r_add
  __b5:
    // if(r>=512*12+256)
    lda.z r
    cmp #<$200*$c+$100
    lda.z r+1
    sbc #>$200*$c+$100
    bvc !+
    eor #$80
  !:
    bpl __b7
    jmp __b2
  __b7:
    // (*BORDER_COLOR)++;
    inc BORDER_COLOR
    jmp __b7
}
// Generate signed int sine table - with values in the range min-max.
// sintab - the table to generate into
// wavelength - the number of sine points in a total sine wavelength (the size of the table)
// void sin16s_gen2(__zp($1c) int *sintab, unsigned int wavelength, int min, int max)
sin16s_gen2: {
    .const min = -$1001
    .const max = $1001
    .const ampl = max-min
    .label wavelength = $200
    .label __6 = 2
    .label __8 = $c
    .label step = $26
    .label sintab = $1c
    // u[4.28]
    // Iterate over the table
    .label x = $22
    .label i = $1a
    // unsigned long step = div32u16u(PI2_u4f28, wavelength)
  // ampl is always positive so shifting left does not alter the sign
  // u[4.28] step = PI*2/wavelength
    jsr div32u16u
    // unsigned long step = div32u16u(PI2_u4f28, wavelength)
    lda #<SINE
    sta.z sintab
    lda #>SINE
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
    cmp #>wavelength
    bcc __b2
    bne !+
    lda.z i
    cmp #<wavelength
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
    lda #<ampl
    sta.z mul16s.b
    lda #>ampl
    sta.z mul16s.b+1
    jsr mul16s
    // mul16s(sin16s(x), ampl)
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
// Initialize bitmap plotting tables
// void bitmap_init(char *gfx, char *screen)
bitmap_init: {
    .label __7 = $2a
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
// Setup the IRQ
init_irq: {
    // asm
    sei
    // *PROCPORT_DDR = PROCPORT_DDR_MEMORY_MASK
    // Disable kernal & basic
    lda #PROCPORT_DDR_MEMORY_MASK
    sta PROCPORT_DDR
    // *PROCPORT = PROCPORT_RAM_IO
    lda #PROCPORT_RAM_IO
    sta PROCPORT
    // CIA1->INTERRUPT = CIA_INTERRUPT_CLEAR
    // Disable CIA 1 Timer IRQ
    lda #CIA_INTERRUPT_CLEAR
    sta CIA1+OFFSET_STRUCT_MOS6526_CIA_INTERRUPT
    // *VICII_CONTROL1 |=$80
    // Set raster line to $100
    lda #$80
    ora VICII_CONTROL1
    sta VICII_CONTROL1
    // *RASTER = $00
    lda #0
    sta RASTER
    // *IRQ_ENABLE = IRQ_RASTER
    // Enable Raster Interrupt
    lda #IRQ_RASTER
    sta IRQ_ENABLE
    // *HARDWARE_IRQ = &irq
    // Set the IRQ routine
    lda #<irq
    sta HARDWARE_IRQ
    lda #>irq
    sta HARDWARE_IRQ+1
    // asm
    cli
    // }
    rts
}
// Multiply of two signed ints to a signed long
// Fixes offsets introduced by using unsigned multiplication
// __zp(2) long mul16s(__zp($16) int a, __zp($1e) int b)
mul16s: {
    .label __6 = $a
    .label __9 = $18
    .label __11 = $a
    .label __12 = $18
    .label a = $16
    .label return = 2
    .label m = 2
    .label b = $1e
    // unsigned long m = mul16u((unsigned int)a, (unsigned int) b)
    lda.z a
    sta.z mul16u.a
    lda.z a+1
    sta.z mul16u.a+1
    lda.z b
    sta.z mul16u.b
    lda.z b+1
    sta.z mul16u.b+1
    jsr mul16u
    // unsigned long m = mul16u((unsigned int)a, (unsigned int) b)
    // if(a<0)
    lda.z a+1
    bpl __b1
    // WORD1(m)
    lda.z m+2
    sta.z __6
    lda.z m+3
    sta.z __6+1
    // WORD1(m) = WORD1(m)-(unsigned int)b
    lda.z __11
    sec
    sbc.z b
    sta.z __11
    lda.z __11+1
    sbc.z b+1
    sta.z __11+1
    lda.z __11
    sta.z m+2
    lda.z __11+1
    sta.z m+3
  __b1:
    // if(b<0)
    lda.z b+1
    bpl __b2
    // WORD1(m)
    lda.z m+2
    sta.z __9
    lda.z m+3
    sta.z __9+1
    // WORD1(m) = WORD1(m)-(unsigned int)a
    lda.z __12
    sec
    sbc.z a
    sta.z __12
    lda.z __12+1
    sbc.z a+1
    sta.z __12+1
    lda.z __12
    sta.z m+2
    lda.z __12+1
    sta.z m+3
  __b2:
    // return (signed long)m;
    // }
    rts
}
// Plot a single dot in the bitmap
// void bitmap_plot(__zp($10) unsigned int x, __register(X) char y)
bitmap_plot: {
    .label __1 = $a
    .label plotter = $c
    .label x = $10
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
// Divide unsigned 32-bit unsigned long dividend with a 16-bit unsigned int divisor
// The 16-bit unsigned int remainder can be found in rem16u after the division
// __zp($26) unsigned long div32u16u(unsigned long dividend, unsigned int divisor)
div32u16u: {
    .label return = $26
    .label quotient_hi = $18
    .label quotient_lo = $10
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
    lda.z rem16u
    sta.z divr16u.rem
    lda.z rem16u+1
    sta.z divr16u.rem+1
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
// __zp($16) int sin16s(__zp($12) unsigned long x)
sin16s: {
    .label __4 = 6
    .label x = $12
    .label return = $16
    .label x1 = $18
    .label x2 = $e
    .label x3 = $e
    .label x3_6 = $a
    .label usinx = $16
    .label x4 = $e
    .label x5 = $a
    .label x5_128 = $a
    .label sinx = $16
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
// Copies the character c (an unsigned char) to the first num characters of the object pointed to by the argument str.
// void * memset(__zp($c) void *str, __register(X) char c, __zp($1c) unsigned int num)
memset: {
    .label end = $1c
    .label dst = $c
    .label num = $1c
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
// Perform binary multiplication of two unsigned 16-bit unsigned ints into a 32-bit unsigned long
// __zp(2) unsigned long mul16u(__zp($a) unsigned int a, __zp($c) unsigned int b)
mul16u: {
    .label a = $a
    .label b = $c
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
// Performs division on two 16 bit unsigned ints and an initial remainder
// Returns the quotient dividend/divisor.
// The final remainder will be set into the global variable rem16u
// Implemented using simple binary division
// __zp($10) unsigned int divr16u(__zp($e) unsigned int dividend, unsigned int divisor, __zp($a) unsigned int rem)
divr16u: {
    .label rem = $a
    .label dividend = $e
    .label quotient = $10
    .label return = $10
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
    cmp #>sin16s_gen2.wavelength
    bcc __b3
    bne !+
    lda.z rem
    cmp #<sin16s_gen2.wavelength
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
    sbc #<sin16s_gen2.wavelength
    sta.z rem
    lda.z rem+1
    sbc #>sin16s_gen2.wavelength
    sta.z rem+1
  __b3:
    // for( char i : 0..15)
    inx
    cpx #$10
    bne __b1
    // rem16u = rem
    lda.z rem
    sta.z rem16u
    lda.z rem+1
    sta.z rem16u+1
    // }
    rts
}
// Calculate val*val for two unsigned int values - the result is 16 selected bits of the 32-bit result.
// The select parameter indicates how many of the highest bits of the 32-bit result to skip
// __zp($a) unsigned int mulu16_sel(__zp($e) unsigned int v1, __zp($c) unsigned int v2, __register(X) char select)
mulu16_sel: {
    .label __0 = 2
    .label __1 = 2
    .label v1 = $e
    .label v2 = $c
    .label return = $a
    .label return_1 = $e
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
.segment Data
  // Tables for the plotter - initialized by calling bitmap_init();
  bitmap_plot_ylo: .fill $100, 0
  bitmap_plot_yhi: .fill $100, 0
  bitmap_plot_bit: .fill $100, 0
  plots_per_frame: .fill $100, 0
  .align $100
  SINE: .fill 2*$200, 0
