// Tests the simple bitmap plotter - and counts plots per frame in an IRQ
// Plots a spiral
.pc = $801 "Basic"
:BasicUpstart(__bbegin)
.pc = $80d "Program"
  // Processor port data direction register
  .label PROCPORT_DDR = 0
  // Mask for PROCESSOR_PORT_DDR which allows only memory configuration to be written
  .const PROCPORT_DDR_MEMORY_MASK = 7
  // Processor Port Register controlling RAM/ROM configuration and the datasette
  .label PROCPORT = 1
  // RAM in $A000, $E000 I/O in $D000
  .const PROCPORT_RAM_IO = 5
  .label RASTER = $d012
  .label BORDERCOL = $d020
  .label BGCOL = $d021
  .label VIC_CONTROL = $d011
  .label D011 = $d011
  .const VIC_BMM = $20
  .const VIC_DEN = $10
  .const VIC_RSEL = 8
  .label D018 = $d018
  // VIC II IRQ Status Register
  .label IRQ_STATUS = $d019
  // VIC II IRQ Enable Register
  .label IRQ_ENABLE = $d01a
  // Bits for the IRQ Status/Enable Registers
  .const IRQ_RASTER = 1
  // CIA#1 Interrupt Status & Control Register
  .label CIA1_INTERRUPT = $dc0d
  // Value that disables all CIA interrupts when stored to the CIA Interrupt registers
  .const CIA_INTERRUPT_CLEAR = $7f
  // The vector used when the HARDWARE serves IRQ interrupts
  .label HARDWARE_IRQ = $fffe
  // The colors of the C64
  .const BLACK = 0
  .const WHITE = 1
  // PI*2 in u[4.28] format
  .const PI2_u4f28 = $6487ed51
  // PI in u[4.28] format
  .const PI_u4f28 = $3243f6a9
  // PI/2 in u[4.28] format
  .const PI_HALF_u4f28 = $1921fb54
  .const SIZEOF_SIGNED_WORD = 2
  .label BITMAP = $2000
  .label SCREEN = $400
  .label frame_cnt = $10
  // Remainder after unsigned 16-bit division
  .label rem16u = $13
__bbegin:
  // frame_cnt = 1
  // Counts frames - updated by the IRQ
  lda #1
  sta.z frame_cnt
  jsr main
  rts
main: {
    .const toD0181_return = (>(SCREEN&$3fff)*4)|(>BITMAP)/4&$f
    .label __7 = $11
    .label __8 = $11
    .label __13 = $13
    .label __14 = $13
    .label __31 = $c
    .label __32 = $c
    .label cos_x = $c
    .label xpos = 8
    .label x = $11
    .label sin_y = $c
    .label ypos = 8
    .label y = $13
    .label idx_x = $e
    .label idx_y = $20
    .label r = 2
    .label r_add = $17
    .label __33 = $c
    .label __34 = $c
    // sin16s_gen2(SINUS, 512, -0x1001, 0x1001)
    jsr sin16s_gen2
    // bitmap_init(BITMAP, SCREEN)
    jsr bitmap_init
    // bitmap_clear(BLACK, WHITE)
    jsr bitmap_clear
    // *D011 = VIC_BMM|VIC_DEN|VIC_RSEL|3
    lda #VIC_BMM|VIC_DEN|VIC_RSEL|3
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
    // cos_x = SINUS[idx_x]
    lda.z idx_x
    asl
    sta.z __31
    lda.z idx_x+1
    rol
    sta.z __31+1
    clc
    lda.z __33
    adc #<SINUS
    sta.z __33
    lda.z __33+1
    adc #>SINUS
    sta.z __33+1
    ldy #0
    lda (cos_x),y
    pha
    iny
    lda (cos_x),y
    sta.z cos_x+1
    pla
    sta.z cos_x
    // mul16s(r, cos_x)
    jsr mul16s
    // mul16s(r, cos_x)
    // xpos = mul16s(r, cos_x)
    // >xpos
    lda.z xpos+2
    sta.z __7
    lda.z xpos+3
    sta.z __7+1
    // ((signed word)>xpos)>>2
    lda.z __8+1
    cmp #$80
    ror.z __8+1
    ror.z __8
    lda.z __8+1
    cmp #$80
    ror.z __8+1
    ror.z __8
    // 160 + ((signed word)>xpos)>>2
    clc
    lda.z x
    adc #<$a0
    sta.z x
    lda.z x+1
    adc #>$a0
    sta.z x+1
    // sin_y = SINUS[idx_y]
    lda.z idx_y
    asl
    sta.z __32
    lda.z idx_y+1
    rol
    sta.z __32+1
    clc
    lda.z __34
    adc #<SINUS
    sta.z __34
    lda.z __34+1
    adc #>SINUS
    sta.z __34+1
    ldy #0
    lda (sin_y),y
    pha
    iny
    lda (sin_y),y
    sta.z sin_y+1
    pla
    sta.z sin_y
    // mul16s(r, sin_y)
    jsr mul16s
    // mul16s(r, sin_y)
    // ypos = mul16s(r, sin_y)
    // >ypos
    lda.z ypos+2
    sta.z __13
    lda.z ypos+3
    sta.z __13+1
    // ((signed word)>ypos)>>2
    lda.z __14+1
    cmp #$80
    ror.z __14+1
    ror.z __14
    lda.z __14+1
    cmp #$80
    ror.z __14+1
    ror.z __14
    // 100 + ((signed word)>ypos)>>2
    lda.z y
    clc
    adc #<$64
    sta.z y
    lda.z y+1
    adc #>$64
    sta.z y+1
    // bitmap_plot(x, (byte)y)
    lda.z y
    tax
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
    clc
    lda.z r
    adc.z r_add
    sta.z r
    lda.z r+1
    adc #0
    sta.z r+1
    // if((idx_x==0) && (r_add!=1))
    lda.z idx_x
    bne b1
    lda.z idx_x+1
    bne b1
    lda #1
    cmp.z r_add
    beq b1
    // r_add /= 2
    lsr.z r_add
  b1:
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
    // (*BORDERCOL)++;
    inc BORDERCOL
    jmp __b7
}
// Plot a single dot in the bitmap
// bitmap_plot(word zp($11) x, byte register(X) y)
bitmap_plot: {
    .label __1 = $15
    .label plotter = $13
    .label x = $11
    // (byte*) { bitmap_plot_yhi[y], bitmap_plot_ylo[y] }
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
    lda.z plotter
    clc
    adc.z __1
    sta.z plotter
    lda.z plotter+1
    adc.z __1+1
    sta.z plotter+1
    // <x
    lda.z x
    // *plotter |= bitmap_plot_bit[<x]
    tay
    lda bitmap_plot_bit,y
    ldy #0
    ora (plotter),y
    sta (plotter),y
    // }
    rts
}
// Multiply of two signed words to a signed double word
// Fixes offsets introduced by using unsigned multiplication
// mul16s(signed word zp(2) a, signed word zp($c) b)
mul16s: {
    .label __9 = $15
    .label __13 = $22
    .label __16 = $15
    .label __17 = $22
    .label m = 8
    .label return = 8
    .label a = 2
    .label b = $c
    // mul16u((word)a, (word) b)
    lda.z a
    sta.z mul16u.a
    lda.z a+1
    sta.z mul16u.a+1
    lda.z b
    sta.z mul16u.b
    lda.z b+1
    sta.z mul16u.b+1
    jsr mul16u
    // mul16u((word)a, (word) b)
    // m = mul16u((word)a, (word) b)
    // if(a<0)
    lda.z a+1
    bpl __b1
    // >m
    lda.z m+2
    sta.z __9
    lda.z m+3
    sta.z __9+1
    // >m = (>m)-(word)b
    lda.z __16
    sec
    sbc.z b
    sta.z __16
    lda.z __16+1
    sbc.z b+1
    sta.z __16+1
    lda.z __16
    sta.z m+2
    lda.z __16+1
    sta.z m+3
  __b1:
    // if(b<0)
    lda.z b+1
    bpl __b2
    // >m
    lda.z m+2
    sta.z __13
    lda.z m+3
    sta.z __13+1
    // >m = (>m)-(word)a
    lda.z __17
    sec
    sbc.z a
    sta.z __17
    lda.z __17+1
    sbc.z a+1
    sta.z __17+1
    lda.z __17
    sta.z m+2
    lda.z __17+1
    sta.z m+3
  __b2:
    // (signed dword)m
    // }
    rts
}
// Perform binary multiplication of two unsigned 16-bit words into a 32-bit unsigned double word
// mul16u(word zp($15) a, word zp($13) b)
mul16u: {
    .label mb = $1c
    .label a = $15
    .label res = 8
    .label b = $13
    .label return = 8
    // mb = b
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
    bne __b2
    lda.z a+1
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
    lda.z res
    clc
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
    // *CIA1_INTERRUPT = CIA_INTERRUPT_CLEAR
    // Disable CIA 1 Timer IRQ
    lda #CIA_INTERRUPT_CLEAR
    sta CIA1_INTERRUPT
    // *VIC_CONTROL |=$80
    // Set raster line to $100
    lda #$80
    ora VIC_CONTROL
    sta VIC_CONTROL
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
// Clear all graphics on the bitmap
// bgcol - the background color to fill the screen with
// fgcol - the foreground color to fill the screen with
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
// Copies the character c (an unsigned char) to the first num characters of the object pointed to by the argument str.
// memset(void* zp(2) str, byte register(X) c, word zp($e) num)
memset: {
    .label end = $e
    .label dst = 2
    .label num = $e
    .label str = 2
    // if(num>0)
    lda.z num
    bne !+
    lda.z num+1
    beq __breturn
  !:
    // end = (char*)str + num
    lda.z end
    clc
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
// Initialize bitmap plotting tables
bitmap_init: {
    .label __7 = $17
    .label yoffs = $20
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
    // <yoffs
    lda.z yoffs
    // y&$7 | <yoffs
    ora.z __7
    // bitmap_plot_ylo[y] = y&$7 | <yoffs
    sta bitmap_plot_ylo,x
    // >yoffs
    lda.z yoffs+1
    // bitmap_plot_yhi[y] = >yoffs
    sta bitmap_plot_yhi,x
    // if((y&$7)==7)
    lda #7
    cmp.z __7
    bne __b4
    // yoffs = yoffs + 40*8
    clc
    lda.z yoffs
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
// Generate signed word sinus table - with values in the range min-max.
// sintab - the table to generate into
// wavelength - the number of sinus points in a total sinus wavelength (the size of the table)
// sin16s_gen2(signed word* zp($11) sintab)
sin16s_gen2: {
    .label wavelength = $200
    .const min = -$1001
    .const max = $1001
    .const ampl = max-min
    .label __6 = 8
    .label __9 = $22
    .label step = $18
    .label sintab = $11
    // u[4.28]
    // Iterate over the table
    .label x = 4
    .label i = $e
    // div32u16u(PI2_u4f28, wavelength)
    jsr div32u16u
    // div32u16u(PI2_u4f28, wavelength)
    // step = div32u16u(PI2_u4f28, wavelength)
    lda #<SINUS
    sta.z sintab
    lda #>SINUS
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
    // for( word i=0; i<wavelength; i++)
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
    // >mul16s(sin16s(x), ampl)
    lda.z __6+2
    sta.z __9
    lda.z __6+3
    sta.z __9+1
    // *sintab++ = offs + (signed word)>mul16s(sin16s(x), ampl)
    ldy #0
    lda.z __9
    sta (sintab),y
    iny
    lda.z __9+1
    sta (sintab),y
    // *sintab++ = offs + (signed word)>mul16s(sin16s(x), ampl);
    lda #SIZEOF_SIGNED_WORD
    clc
    adc.z sintab
    sta.z sintab
    bcc !+
    inc.z sintab+1
  !:
    // x = x + step
    lda.z x
    clc
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
    // for( word i=0; i<wavelength; i++)
    inc.z i
    bne !+
    inc.z i+1
  !:
    jmp __b1
}
// Calculate signed word sinus sin(x)
// x: unsigned dword input u[4.28] in the interval $00000000 - PI2_u4f28
// result: signed word sin(x) s[0.15] - using the full range  -$7fff - $7fff
// sin16s(dword zp(8) x)
sin16s: {
    .label __4 = $1c
    .label x = 8
    .label return = 2
    .label x1 = $22
    .label x2 = $c
    .label x3 = $c
    .label x3_6 = $20
    .label usinx = 2
    .label x4 = $c
    .label x5 = $20
    .label x5_128 = $20
    .label sinx = 2
    // if(x >= PI_u4f28 )
    lda.z x+3
    cmp #>PI_u4f28>>$10
    bcc b1
    bne !+
    lda.z x+2
    cmp #<PI_u4f28>>$10
    bcc b1
    bne !+
    lda.z x+1
    cmp #>PI_u4f28
    bcc b1
    bne !+
    lda.z x
    cmp #<PI_u4f28
    bcc b1
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
  b1:
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
    // x1 = >x<<3
    lda.z __4+2
    sta.z x1
    lda.z __4+3
    sta.z x1+1
    // mulu16_sel(x1, x1, 0)
    lda.z x1
    sta.z mulu16_sel.v1
    lda.z x1+1
    sta.z mulu16_sel.v1+1
    lda.z x1
    sta.z mulu16_sel.v2
    lda.z x1+1
    sta.z mulu16_sel.v2+1
    ldx #0
    jsr mulu16_sel
    // mulu16_sel(x1, x1, 0)
    // x2 = mulu16_sel(x1, x1, 0)
    lda.z mulu16_sel.return
    sta.z x2
    lda.z mulu16_sel.return+1
    sta.z x2+1
    // mulu16_sel(x2, x1, 1)
    lda.z x1
    sta.z mulu16_sel.v2
    lda.z x1+1
    sta.z mulu16_sel.v2+1
    ldx #1
    jsr mulu16_sel
    // mulu16_sel(x2, x1, 1)
    lda.z mulu16_sel.return
    sta.z mulu16_sel.return_1
    lda.z mulu16_sel.return+1
    sta.z mulu16_sel.return_1+1
    // x3 = mulu16_sel(x2, x1, 1)
    // mulu16_sel(x3, $10000/6, 1)
    ldx #1
    lda #<$10000/6
    sta.z mulu16_sel.v2
    lda #>$10000/6
    sta.z mulu16_sel.v2+1
    jsr mulu16_sel
    // mulu16_sel(x3, $10000/6, 1)
    // x3_6 = mulu16_sel(x3, $10000/6, 1)
    // usinx = x1 - x3_6
    lda.z x1
    sec
    sbc.z x3_6
    sta.z usinx
    lda.z x1+1
    sbc.z x3_6+1
    sta.z usinx+1
    // mulu16_sel(x3, x1, 0)
    lda.z x1
    sta.z mulu16_sel.v2
    lda.z x1+1
    sta.z mulu16_sel.v2+1
    ldx #0
    jsr mulu16_sel
    // mulu16_sel(x3, x1, 0)
    lda.z mulu16_sel.return
    sta.z mulu16_sel.return_1
    lda.z mulu16_sel.return+1
    sta.z mulu16_sel.return_1+1
    // x4 = mulu16_sel(x3, x1, 0)
    // mulu16_sel(x4, x1, 0)
    lda.z x1
    sta.z mulu16_sel.v2
    lda.z x1+1
    sta.z mulu16_sel.v2+1
    ldx #0
    jsr mulu16_sel
    // mulu16_sel(x4, x1, 0)
    // x5 = mulu16_sel(x4, x1, 0)
    // x5_128 = x5>>4
    lsr.z x5_128+1
    ror.z x5_128
    lsr.z x5_128+1
    ror.z x5_128
    lsr.z x5_128+1
    ror.z x5_128
    lsr.z x5_128+1
    ror.z x5_128
    // usinx = usinx + x5_128
    lda.z usinx
    clc
    adc.z x5_128
    sta.z usinx
    lda.z usinx+1
    adc.z x5_128+1
    sta.z usinx+1
    // if(isUpper!=0)
    cpy #0
    beq __b3
    // sinx = -(signed word)usinx
    sec
    lda #0
    sbc.z sinx
    sta.z sinx
    lda #0
    sbc.z sinx+1
    sta.z sinx+1
  __b3:
    // }
    rts
}
// Calculate val*val for two unsigned word values - the result is 16 selected bits of the 32-bit result.
// The select parameter indicates how many of the highest bits of the 32-bit result to skip
// mulu16_sel(word zp($c) v1, word zp($13) v2, byte register(X) select)
mulu16_sel: {
    .label __0 = 8
    .label __1 = 8
    .label v1 = $c
    .label v2 = $13
    .label return = $20
    .label return_1 = $c
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
    // >mul16u(v1, v2)<<select
    lda.z __1+2
    sta.z return
    lda.z __1+3
    sta.z return+1
    // }
    rts
}
// Divide unsigned 32-bit dword dividend with a 16-bit word divisor
// The 16-bit word remainder can be found in rem16u after the division
div32u16u: {
    .label quotient_hi = $22
    .label quotient_lo = $e
    .label return = $18
    // divr16u(>dividend, divisor, 0)
    lda #<PI2_u4f28>>$10
    sta.z divr16u.dividend
    lda #>PI2_u4f28>>$10
    sta.z divr16u.dividend+1
    lda #<0
    sta.z divr16u.rem
    sta.z divr16u.rem+1
    jsr divr16u
    // divr16u(>dividend, divisor, 0)
    // quotient_hi = divr16u(>dividend, divisor, 0)
    lda.z divr16u.return
    sta.z quotient_hi
    lda.z divr16u.return+1
    sta.z quotient_hi+1
    // divr16u(<dividend, divisor, rem16u)
    lda #<PI2_u4f28&$ffff
    sta.z divr16u.dividend
    lda #>PI2_u4f28&$ffff
    sta.z divr16u.dividend+1
    jsr divr16u
    // divr16u(<dividend, divisor, rem16u)
    // quotient_lo = divr16u(<dividend, divisor, rem16u)
    // quotient = { quotient_hi, quotient_lo}
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
// Performs division on two 16 bit unsigned words and an initial remainder
// Returns the quotient dividend/divisor.
// The final remainder will be set into the global variable rem16u
// Implemented using simple binary division
// divr16u(word zp($15) dividend, word zp($13) rem)
divr16u: {
    .label rem = $13
    .label dividend = $15
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
    // >dividend
    lda.z dividend+1
    // >dividend & $80
    and #$80
    // if( (>dividend & $80) != 0 )
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
    // for( byte i : 0..15)
    inx
    cpx #$10
    bne __b1
    // rem16u = rem
    // }
    rts
}
// Interrupt Routine counting frames
irq: {
    sta rega+1
    // *BGCOL = WHITE
    lda #WHITE
    sta BGCOL
    // if(frame_cnt)
    lda #0
    cmp.z frame_cnt
    beq __b1
    // frame_cnt++;
    inc.z frame_cnt
  __b1:
    // *BGCOL = BLACK
    lda #BLACK
    sta BGCOL
    // *IRQ_STATUS = IRQ_RASTER
    // Acknowledge the IRQ
    lda #IRQ_RASTER
    sta IRQ_STATUS
    // }
  rega:
    lda #00
    rti
}
  // Tables for the plotter - initialized by calling bitmap_init();
  bitmap_plot_ylo: .fill $100, 0
  bitmap_plot_yhi: .fill $100, 0
  bitmap_plot_bit: .fill $100, 0
  plots_per_frame: .fill $100, 0
  .align $100
  SINUS: .fill 2*$200, 0
