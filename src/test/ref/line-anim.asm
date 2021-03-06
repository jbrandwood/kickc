// Animated lines drawn on a single color bitmap
/// @file
/// Commodore 64 Registers and Constants
/// @file
/// The MOS 6526 Complex Interface Adapter (CIA)
///
/// http://archive.6502.org/datasheets/mos_6526_cia_recreated.pdf
  // Commodore 64 PRG executable file
.file [name="line-anim.prg", type="prg", segments="Program"]
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
  /// Mask for PROCESSOR_PORT_DDR which allows only memory configuration to be written
  .const PROCPORT_DDR_MEMORY_MASK = 7
  /// RAM in 0xA000, 0xE000 I/O in 0xD000
  .const PROCPORT_RAM_IO = 5
  // The number of points
  .const SIZE = 4
  // The delay between pixels
  .const DELAY = 8
  .const OFFSET_STRUCT_MOS6526_CIA_PORT_A_DDR = 2
  /// $D012 RASTER Raster counter
  .label RASTER = $d012
  /// $D020 Border Color
  .label BORDER_COLOR = $d020
  /// $D011 Control Register #1
  /// @see #VICII_CONTROL1
  .label D011 = $d011
  /// $D018 VIC-II base addresses
  // @see #VICII_MEMORY
  .label D018 = $d018
  /// Processor port data direction register
  .label PROCPORT_DDR = 0
  /// Processor Port Register controlling RAM/ROM configuration and the datasette
  .label PROCPORT = 1
  /// The CIA#2: Serial bus, RS-232, VIC memory bank
  .label CIA2 = $dd00
  .label BITMAP = $a000
  .label SCREEN = $8800
.segment Code
main: {
    .const vicSelectGfxBank1_toDd001_return = 3^(>SCREEN)/$40
    .const toD0181_return = (>(SCREEN&$3fff)*4)|(>BITMAP)/4&$f
    .label i = $13
    // asm
    // Disable normal interrupt
    sei
    // *PROCPORT_DDR = PROCPORT_DDR_MEMORY_MASK
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
    // *D018 =  toD018(SCREEN, BITMAP)
    lda #toD0181_return
    sta D018
    // bitmap_init(BITMAP)
    jsr bitmap_init
    // bitmap_clear()
    jsr bitmap_clear
    // screen_fill(SCREEN, $10)
    jsr screen_fill
    lda #0
    sta.z i
  __b1:
    // point_init(i)
    jsr point_init
    // bitmap_plot(x_start[i], y_start[i])
    lda.z i
    asl
    tay
    lda x_start,y
    sta.z bitmap_plot.x
    lda x_start+1,y
    sta.z bitmap_plot.x+1
    ldy.z i
    ldx y_start,y
    jsr bitmap_plot
    // for( byte i : 0..SIZE-1)
    inc.z i
    lda #SIZE-1+1
    cmp.z i
    bne __b1
  __b2:
    // while(*RASTER!=$ff)
    lda #$ff
    cmp RASTER
    bne __b2
    // (*BORDER_COLOR)++;
    inc BORDER_COLOR
    jmp __b2
}
// void bitmap_init(char *bitmap)
bitmap_init: {
    .label __7 = $e
    .label yoffs = $a
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
    // for(byte x : 0..255)
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
    // for(byte y : 0..255)
    inx
    cpx #0
    bne __b3
    // }
    rts
}
// Clear all graphics on the bitmap
bitmap_clear: {
    .label bitmap = $a
    .label y = $e
    // MAKEWORD( bitmap_plot_yhi[0], bitmap_plot_ylo[0] )
    lda bitmap_plot_yhi
    sta.z bitmap+1
    lda bitmap_plot_ylo
    sta.z bitmap
    lda #0
    sta.z y
  __b1:
    ldx #0
  __b2:
    // *bitmap++ = 0
    lda #0
    tay
    sta (bitmap),y
    // *bitmap++ = 0;
    inc.z bitmap
    bne !+
    inc.z bitmap+1
  !:
    // for( byte x: 0..199 )
    inx
    cpx #$c8
    bne __b2
    // for( byte y: 0..39 )
    inc.z y
    lda #$28
    cmp.z y
    bne __b1
    // }
    rts
}
// Fill the screen with a specific char
// void screen_fill(__zp($a) char *screen, char ch)
screen_fill: {
    .const ch = $10
    .label screen = $a
    .label y = $e
    lda #0
    sta.z y
    lda #<SCREEN
    sta.z screen
    lda #>SCREEN
    sta.z screen+1
  __b1:
    ldx #0
  __b2:
    // *screen++ = ch
    lda #ch
    ldy #0
    sta (screen),y
    // *screen++ = ch;
    inc.z screen
    bne !+
    inc.z screen+1
  !:
    // for(byte x:0..39)
    inx
    cpx #$28
    bne __b2
    // for( byte y: 0..24)
    inc.z y
    lda #$19
    cmp.z y
    bne __b1
    // }
    rts
}
// Initialize the points to be animated
// void point_init(__zp($13) char point_idx)
point_init: {
    .label __5 = $11
    .label __6 = $f
    .label __13 = $e
    .label __17 = 2
    .label __18 = 6
    .label __19 = $f
    .label point_idx = $13
    .label y_diff = 2
    .label abs16s1_return = $a
    .label abs16s2_return = $c
    .label x_stepf = 4
    .label x_diff = 8
    // signed word x_diff = ((signed word)x_end[point_idx])-((signed word)x_start[point_idx])
    lda.z point_idx
    asl
    sta.z __13
    tay
    sec
    lda x_end,y
    sbc x_start,y
    sta.z x_diff
    lda x_end+1,y
    sbc x_start+1,y
    sta.z x_diff+1
    // signed word y_diff = ((signed word)y_end[point_idx])-((signed word)y_start[point_idx])
    ldy.z point_idx
    lda y_end,y
    sta.z __17
    lda #0
    sta.z __17+1
    lda y_start,y
    sta.z __18
    lda #0
    sta.z __18+1
    lda.z y_diff
    sec
    sbc.z __18
    sta.z y_diff
    lda.z y_diff+1
    sbc.z __18+1
    sta.z y_diff+1
    // if(w<0)
    lda.z x_diff+1
    bpl !abs16s1___b1+
    jmp abs16s1___b1
  !abs16s1___b1:
    lda.z x_diff
    sta.z abs16s1_return
    lda.z x_diff+1
    sta.z abs16s1_return+1
  abs16s2:
    // if(w<0)
    lda.z y_diff+1
    bpl !abs16s2___b1+
    jmp abs16s2___b1
  !abs16s2___b1:
    lda.z y_diff
    sta.z abs16s2_return
    lda.z y_diff+1
    sta.z abs16s2_return+1
  __b6:
    // if(abs16s(x_diff)>abs16s(y_diff))
    lda.z abs16s2_return+1
    cmp.z abs16s1_return+1
    bcc __b1
    bne !+
    lda.z abs16s2_return
    cmp.z abs16s1_return
    bcc __b1
  !:
  __b2:
    // x_start[point_idx]*$10
    ldy.z __13
    lda x_start,y
    asl
    sta.z __5
    lda x_start+1,y
    rol
    sta.z __5+1
    asl.z __5
    rol.z __5+1
    asl.z __5
    rol.z __5+1
    asl.z __5
    rol.z __5+1
    // x_cur[point_idx] = x_start[point_idx]*$10
    lda.z __5
    sta x_cur,y
    lda.z __5+1
    sta x_cur+1,y
    // ((word)y_start[point_idx])*$10
    ldy.z point_idx
    lda y_start,y
    sta.z __19
    lda #0
    sta.z __19+1
    asl.z __6
    rol.z __6+1
    asl.z __6
    rol.z __6+1
    asl.z __6
    rol.z __6+1
    asl.z __6
    rol.z __6+1
    // y_cur[point_idx] = ((word)y_start[point_idx])*$10
    ldy.z __13
    lda.z __6
    sta y_cur,y
    lda.z __6+1
    sta y_cur+1,y
    // delay[point_idx] = DELAY
    lda #DELAY
    ldy.z point_idx
    sta delay,y
    // }
    rts
  __b1:
    // if(x_diff<0)
    // X is driver - abs(y/x) is < 1
    lda.z x_diff+1
    bmi __b4
    // x_add[point_idx] = $10
    // x add = 1.0
    lda #$10
    ldy.z point_idx
    sta x_add,y
  __b5:
    // signed word x_stepf = divr16s(0, x_diff, y_diff)
    jsr divr16s
    // signed word x_stepf = divr16s(0, x_diff, y_diff)
    // BYTE1(x_stepf)
    lda.z x_stepf+1
    // BYTE1(x_stepf)/$10
    lsr
    lsr
    lsr
    lsr
    // y_add[point_idx] = (signed byte)(BYTE1(x_stepf)/$10)
    ldy.z point_idx
    sta y_add,y
    jmp __b2
  __b4:
    // x_add[point_idx] = -$10
    // x add = -1.0
    lda #-$10
    ldy.z point_idx
    sta x_add,y
    jmp __b5
  abs16s2___b1:
    // -w
    sec
    lda #0
    sbc.z y_diff
    sta.z abs16s2_return
    lda #0
    sbc.z y_diff+1
    sta.z abs16s2_return+1
    jmp __b6
  abs16s1___b1:
    // -w
    sec
    lda #0
    sbc.z x_diff
    sta.z abs16s1_return
    lda #0
    sbc.z x_diff+1
    sta.z abs16s1_return+1
    jmp abs16s2
}
// Plot a single dot in the bitmap
// void bitmap_plot(__zp($c) unsigned int x, __register(X) char y)
bitmap_plot: {
    .label __1 = 8
    .label x = $c
    .label plotter = 2
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
// Perform division on two signed 16-bit numbers with an initial remainder.
// Returns dividend/divisor. The remainder will be set into the global variable rem16s.
// Implemented using simple binary division
// Follows the C99 standard by truncating toward zero on negative results.
// See http://www.open-std.org/jtc1/sc22/wg14/www/docs/n1124.pdf section 6.5.5
// __zp(4) int divr16s(int dividend, __zp(8) int divisor, __zp(2) int rem)
divr16s: {
    .label remu = 2
    .label divisoru = 8
    .label resultu = 4
    .label return = 4
    .label divisor = 8
    .label rem = 2
    // if(dividend<0 || rem<0)
    lda.z rem+1
    bmi __b1
    ldy #0
  __b2:
    // if(divisor<0)
    lda.z divisor+1
    bmi __b3
  __b4:
    // unsigned int resultu = divr16u(dividendu, divisoru, remu)
    jsr divr16u
    // unsigned int resultu = divr16u(dividendu, divisoru, remu)
    // if(neg==0)
    cpy #0
    beq __breturn
    // return -(signed int)resultu;
    lda #0
    sec
    sbc.z return
    sta.z return
    lda #0
    sbc.z return+1
    sta.z return+1
  __breturn:
    // }
    rts
  __b3:
    // -divisor
    lda #0
    sec
    sbc.z divisoru
    sta.z divisoru
    lda #0
    sbc.z divisoru+1
    sta.z divisoru+1
    // neg = neg ^ 1
    tya
    eor #1
    tay
    jmp __b4
  __b1:
    // -rem
    lda #0
    sec
    sbc.z remu
    sta.z remu
    lda #0
    sbc.z remu+1
    sta.z remu+1
    ldy #1
    jmp __b2
}
// Performs division on two 16 bit unsigned ints and an initial remainder
// Returns the quotient dividend/divisor.
// The final remainder will be set into the global variable rem16u
// Implemented using simple binary division
// __zp(4) unsigned int divr16u(__zp(6) unsigned int dividend, __zp(8) unsigned int divisor, __zp(2) unsigned int rem)
divr16u: {
    .label rem = 2
    .label dividend = 6
    .label quotient = 4
    .label return = 4
    .label divisor = 8
    ldx #0
    txa
    sta.z quotient
    sta.z quotient+1
    sta.z dividend
    sta.z dividend+1
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
    cmp.z divisor+1
    bcc __b3
    bne !+
    lda.z rem
    cmp.z divisor
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
    sbc.z divisor
    sta.z rem
    lda.z rem+1
    sbc.z divisor+1
    sta.z rem+1
  __b3:
    // for( char i : 0..15)
    inx
    cpx #$10
    bne __b1
    // }
    rts
}
.segment Data
  // The coordinates of the lines to animate
  x_start: .word $a, $14, $1e, $1e
  y_start: .byte $a, $a, $a, $14
  x_end: .word $14, $a, $14, $14
  y_end: .byte $14, $14, $a, $14
  // Current x position fixed point [12.4]
  x_cur: .fill 2*SIZE, 0
  // Current y position fixed point [12.4]
  y_cur: .fill 2*SIZE, 0
  // X position addition per frame s[3.4]
  x_add: .fill SIZE, 0
  // Y position addition per frame s[3.4]
  y_add: .fill SIZE, 0
  // Frame delay (counted down to 0)
  delay: .fill SIZE, 0
  // Tables for the plotter - initialized by calling bitmap_init();
  bitmap_plot_ylo: .fill $100, 0
  bitmap_plot_yhi: .fill $100, 0
  bitmap_plot_bit: .fill $100, 0
