// Tests the simple bitmap plotter - and counts plots per frame in an IRQ
// Plots a spiral
.pc = $801 "Basic"
:BasicUpstart(bbegin)
.pc = $80d "Program"
  .const SIZEOF_SIGNED_WORD = 2
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
  .label BITMAP = $2000
  .label SCREEN = $400
  .label rem16u = $19
  .label frame_cnt = $16
bbegin:
  // Counts frames - updated by the IRQ
  lda #1
  sta.z frame_cnt
  jsr main
  rts
main: {
    .const toD0181_return = (>(SCREEN&$3fff)*4)|(>BITMAP)/4&$f
    .label _10 = $20
    .label _11 = $20
    .label _16 = $17
    .label _17 = $17
    .label _32 = $24
    .label _33 = $24
    .label cos_x = $24
    .label xpos = $e
    .label x = $20
    .label sin_y = $24
    .label ypos = $e
    .label y = $17
    .label idx_x = 2
    .label idx_y = $12
    .label r = 8
    .label r_add = $1b
    .label _34 = $24
    .label _35 = $24
    jsr sin16s_gen2
    jsr bitmap_init
    jsr bitmap_clear
    lda #VIC_BMM|VIC_DEN|VIC_RSEL|3
    sta D011
    lda #toD0181_return
    sta D018
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
  b2:
    lda.z idx_x
    asl
    sta.z _32
    lda.z idx_x+1
    rol
    sta.z _32+1
    clc
    lda.z _34
    adc #<SINUS
    sta.z _34
    lda.z _34+1
    adc #>SINUS
    sta.z _34+1
    ldy #0
    lda (cos_x),y
    tax
    iny
    lda (cos_x),y
    stx.z cos_x
    sta.z cos_x+1
    jsr mul16s
    lda.z xpos+2
    sta.z _10
    lda.z xpos+3
    sta.z _10+1
    lda.z _11+1
    cmp #$80
    ror.z _11+1
    ror.z _11
    lda.z _11+1
    cmp #$80
    ror.z _11+1
    ror.z _11
    clc
    lda.z x
    adc #<$a0
    sta.z x
    lda.z x+1
    adc #>$a0
    sta.z x+1
    lda.z idx_y
    asl
    sta.z _33
    lda.z idx_y+1
    rol
    sta.z _33+1
    clc
    lda.z _35
    adc #<SINUS
    sta.z _35
    lda.z _35+1
    adc #>SINUS
    sta.z _35+1
    ldy #0
    lda (sin_y),y
    tax
    iny
    lda (sin_y),y
    stx.z sin_y
    sta.z sin_y+1
    jsr mul16s
    lda.z ypos+2
    sta.z _16
    lda.z ypos+3
    sta.z _16+1
    lda.z _17+1
    cmp #$80
    ror.z _17+1
    ror.z _17
    lda.z _17+1
    cmp #$80
    ror.z _17+1
    ror.z _17
    lda.z y
    clc
    adc #<$64
    sta.z y
    lda.z y+1
    adc #>$64
    sta.z y+1
    lda.z y
    tax
    jsr bitmap_plot
    ldx.z frame_cnt
    inc plots_per_frame,x
    lda.z r_add
    clc
    adc.z idx_x
    sta.z idx_x
    bcc !+
    inc.z idx_x+1
  !:
    lda.z idx_x+1
    cmp #>$200
    bcc b3
    bne !+
    lda.z idx_x
    cmp #<$200
    bcc b3
  !:
    lda #<0
    sta.z idx_x
    sta.z idx_x+1
  b3:
    lda.z r_add
    clc
    adc.z idx_y
    sta.z idx_y
    bcc !+
    inc.z idx_y+1
  !:
    lda.z idx_y+1
    cmp #>$200
    bcc b4
    bne !+
    lda.z idx_y
    cmp #<$200
    bcc b4
  !:
    lda #<0
    sta.z idx_y
    sta.z idx_y+1
  b4:
    clc
    lda.z r
    adc.z r_add
    sta.z r
    lda.z r+1
    adc #0
    sta.z r+1
    lda.z idx_x
    bne b5
    lda.z idx_x+1
    bne b5
    lda #1
    cmp.z r_add
    beq b5
    lsr.z r_add
  b5:
    lda.z r
    cmp #<$200*$c+$100
    lda.z r+1
    sbc #>$200*$c+$100
    bvc !+
    eor #$80
  !:
    bpl b7
    jmp b2
  b7:
    inc BORDERCOL
    jmp b7
}
// Plot a single dot in the bitmap
// bitmap_plot(word zeropage($20) x, byte register(X) y)
bitmap_plot: {
    .label _1 = $19
    .label plotter = $17
    .label x = $20
    lda bitmap_plot_yhi,x
    sta.z plotter+1
    lda bitmap_plot_ylo,x
    sta.z plotter
    lda.z x
    and #<$fff8
    sta.z _1
    lda.z x+1
    and #>$fff8
    sta.z _1+1
    lda.z plotter
    clc
    adc.z _1
    sta.z plotter
    lda.z plotter+1
    adc.z _1+1
    sta.z plotter+1
    lda.z x
    tay
    lda bitmap_plot_bit,y
    ldy #0
    ora (plotter),y
    sta (plotter),y
    rts
}
// Multiply of two signed words to a signed double word
// Fixes offsets introduced by using unsigned multiplication
// mul16s(signed word zeropage(8) a, signed word zeropage($24) b)
mul16s: {
    .label _9 = $19
    .label _13 = $22
    .label _16 = $19
    .label _17 = $22
    .label m = $e
    .label return = $e
    .label a = 8
    .label b = $24
    lda.z a
    sta.z mul16u.a
    lda.z a+1
    sta.z mul16u.a+1
    lda.z b
    sta.z mul16u.b
    lda.z b+1
    sta.z mul16u.b+1
    lda.z mul16u.b
    sta.z mul16u.mb
    lda.z mul16u.b+1
    sta.z mul16u.mb+1
    lda #0
    sta.z mul16u.mb+2
    sta.z mul16u.mb+3
    jsr mul16u
    lda.z a+1
    bpl b1
    lda.z m+2
    sta.z _9
    lda.z m+3
    sta.z _9+1
    lda.z _16
    sec
    sbc.z b
    sta.z _16
    lda.z _16+1
    sbc.z b+1
    sta.z _16+1
    lda.z _16
    sta.z m+2
    lda.z _16+1
    sta.z m+3
  b1:
    lda.z b+1
    bpl b2
    lda.z m+2
    sta.z _13
    lda.z m+3
    sta.z _13+1
    lda.z _17
    sec
    sbc.z a
    sta.z _17
    lda.z _17+1
    sbc.z a+1
    sta.z _17+1
    lda.z _17
    sta.z m+2
    lda.z _17+1
    sta.z m+3
  b2:
    rts
}
// Perform binary multiplication of two unsigned 16-bit words into a 32-bit unsigned double word
// mul16u(word zeropage($19) a, word zeropage($17) b)
mul16u: {
    .label mb = 4
    .label a = $19
    .label res = $e
    .label b = $17
    .label return = $e
    .label b_1 = 2
    lda #0
    sta.z res
    sta.z res+1
    sta.z res+2
    sta.z res+3
  b1:
    lda.z a
    bne b2
    lda.z a+1
    bne b2
    rts
  b2:
    lda.z a
    and #1
    cmp #0
    beq b3
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
  b3:
    lsr.z a+1
    ror.z a
    asl.z mb
    rol.z mb+1
    rol.z mb+2
    rol.z mb+3
    jmp b1
}
// Setup the IRQ
init_irq: {
    sei
    // Disable kernal & basic
    lda #PROCPORT_DDR_MEMORY_MASK
    sta PROCPORT_DDR
    lda #PROCPORT_RAM_IO
    sta PROCPORT
    // Disable CIA 1 Timer IRQ
    lda #CIA_INTERRUPT_CLEAR
    sta CIA1_INTERRUPT
    // Set raster line to $100
    lda #$80
    ora VIC_CONTROL
    sta VIC_CONTROL
    lda #0
    sta RASTER
    // Enable Raster Interrupt
    lda #IRQ_RASTER
    sta IRQ_ENABLE
    // Set the IRQ routine
    lda #<irq
    sta HARDWARE_IRQ
    lda #>irq
    sta HARDWARE_IRQ+1
    cli
    rts
}
// Clear all graphics on the bitmap
// bgcol - the background color to fill the screen with
// fgcol - the foreground color to fill the screen with
bitmap_clear: {
    .const col = WHITE*$10
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
    rts
}
// Copies the character c (an unsigned char) to the first num characters of the object pointed to by the argument str.
// memset(void* zeropage($12) str, byte register(X) c, word zeropage(8) num)
memset: {
    .label end = 8
    .label dst = $12
    .label num = 8
    .label str = $12
    lda.z num
    bne !+
    lda.z num+1
    beq breturn
  !:
    lda.z end
    clc
    adc.z str
    sta.z end
    lda.z end+1
    adc.z str+1
    sta.z end+1
  b2:
    lda.z dst+1
    cmp.z end+1
    bne b3
    lda.z dst
    cmp.z end
    bne b3
  breturn:
    rts
  b3:
    txa
    ldy #0
    sta (dst),y
    inc.z dst
    bne !+
    inc.z dst+1
  !:
    jmp b2
}
// Initialize bitmap plotting tables
bitmap_init: {
    .label _7 = $1b
    .label yoffs = $24
    ldx #0
    lda #$80
  b1:
    sta bitmap_plot_bit,x
    lsr
    cmp #0
    bne b2
    lda #$80
  b2:
    inx
    cpx #0
    bne b1
    lda #<BITMAP
    sta.z yoffs
    lda #>BITMAP
    sta.z yoffs+1
    ldx #0
  b3:
    lda #7
    sax.z _7
    lda.z yoffs
    ora.z _7
    sta bitmap_plot_ylo,x
    lda.z yoffs+1
    sta bitmap_plot_yhi,x
    lda #7
    cmp.z _7
    bne b4
    clc
    lda.z yoffs
    adc #<$28*8
    sta.z yoffs
    lda.z yoffs+1
    adc #>$28*8
    sta.z yoffs+1
  b4:
    inx
    cpx #0
    bne b3
    rts
}
// Generate signed word sinus table - with values in the range min-max.
// sintab - the table to generate into
// wavelength - the number of sinus points in a total sinus wavelength (the size of the table)
// sin16s_gen2(signed word* zeropage($14) sintab)
sin16s_gen2: {
    .label wavelength = $200
    .const min = -$1001
    .const max = $1001
    .const ampl = max-min
    .label _6 = $e
    .label _9 = $20
    .label step = $1c
    .label sintab = $14
    .label x = $a
    .label i = $12
    jsr div32u16u
    lda #<SINUS
    sta.z sintab
    lda #>SINUS
    sta.z sintab+1
    lda #0
    sta.z x
    sta.z x+1
    sta.z x+2
    sta.z x+3
    sta.z i
    sta.z i+1
  b2:
    lda.z x
    sta.z sin16s.x
    lda.z x+1
    sta.z sin16s.x+1
    lda.z x+2
    sta.z sin16s.x+2
    lda.z x+3
    sta.z sin16s.x+3
    jsr sin16s
    lda #<ampl
    sta.z mul16s.b
    lda #>ampl
    sta.z mul16s.b+1
    jsr mul16s
    lda.z _6+2
    sta.z _9
    lda.z _6+3
    sta.z _9+1
    ldy #0
    lda.z _9
    sta (sintab),y
    iny
    lda.z _9+1
    sta (sintab),y
    lda #SIZEOF_SIGNED_WORD
    clc
    adc.z sintab
    sta.z sintab
    bcc !+
    inc.z sintab+1
  !:
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
    inc.z i
    bne !+
    inc.z i+1
  !:
  // u[4.28]
    lda.z i+1
    cmp #>wavelength
    bcc b2
    bne !+
    lda.z i
    cmp #<wavelength
    bcc b2
  !:
    rts
}
// Calculate signed word sinus sin(x)
// x: unsigned dword input u[4.28] in the interval $00000000 - PI2_u4f28
// result: signed word sin(x) s[0.15] - using the full range  -$7fff - $7fff
// sin16s(dword zeropage($e) x)
sin16s: {
    .label _4 = $e
    .label x = $e
    .label return = 8
    .label x1 = $22
    .label x2 = $17
    .label x3 = $17
    .label x3_6 = $24
    .label usinx = 8
    .label x4 = $17
    .label x5 = $24
    .label x5_128 = $24
    .label sinx = 8
    .label isUpper = $1b
    lda.z x+3
    cmp #>PI_u4f28>>$10
    bcc b4
    bne !+
    lda.z x+2
    cmp #<PI_u4f28>>$10
    bcc b4
    bne !+
    lda.z x+1
    cmp #>PI_u4f28
    bcc b4
    bne !+
    lda.z x
    cmp #<PI_u4f28
    bcc b4
  !:
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
    lda #1
    sta.z isUpper
    jmp b1
  b4:
    lda #0
    sta.z isUpper
  b1:
    lda.z x+3
    cmp #>PI_HALF_u4f28>>$10
    bcc b2
    bne !+
    lda.z x+2
    cmp #<PI_HALF_u4f28>>$10
    bcc b2
    bne !+
    lda.z x+1
    cmp #>PI_HALF_u4f28
    bcc b2
    bne !+
    lda.z x
    cmp #<PI_HALF_u4f28
    bcc b2
  !:
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
  b2:
    ldy #3
  !:
    asl.z _4
    rol.z _4+1
    rol.z _4+2
    rol.z _4+3
    dey
    bne !-
    lda.z _4+2
    sta.z x1
    lda.z _4+3
    sta.z x1+1
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
    lda.z mulu16_sel.return
    sta.z x2
    lda.z mulu16_sel.return+1
    sta.z x2+1
    lda.z x1
    sta.z mulu16_sel.v2
    lda.z x1+1
    sta.z mulu16_sel.v2+1
    ldx #1
    jsr mulu16_sel
    lda.z mulu16_sel.return
    sta.z mulu16_sel.return_1
    lda.z mulu16_sel.return+1
    sta.z mulu16_sel.return_1+1
    ldx #1
    lda #<$10000/6
    sta.z mulu16_sel.v2
    lda #>$10000/6
    sta.z mulu16_sel.v2+1
    jsr mulu16_sel
    lda.z x1
    sec
    sbc.z x3_6
    sta.z usinx
    lda.z x1+1
    sbc.z x3_6+1
    sta.z usinx+1
    lda.z x1
    sta.z mulu16_sel.v2
    lda.z x1+1
    sta.z mulu16_sel.v2+1
    ldx #0
    jsr mulu16_sel
    lda.z mulu16_sel.return
    sta.z mulu16_sel.return_10
    lda.z mulu16_sel.return+1
    sta.z mulu16_sel.return_10+1
    lda.z x1
    sta.z mulu16_sel.v2
    lda.z x1+1
    sta.z mulu16_sel.v2+1
    ldx #0
    jsr mulu16_sel
    lsr.z x5_128+1
    ror.z x5_128
    lsr.z x5_128+1
    ror.z x5_128
    lsr.z x5_128+1
    ror.z x5_128
    lsr.z x5_128+1
    ror.z x5_128
    lda.z usinx
    clc
    adc.z x5_128
    sta.z usinx
    lda.z usinx+1
    adc.z x5_128+1
    sta.z usinx+1
    lda.z isUpper
    cmp #0
    beq b3
    sec
    lda #0
    sbc.z sinx
    sta.z sinx
    lda #0
    sbc.z sinx+1
    sta.z sinx+1
  b3:
    rts
}
// Calculate val*val for two unsigned word values - the result is 16 selected bits of the 32-bit result.
// The select parameter indicates how many of the highest bits of the 32-bit result to skip
// mulu16_sel(word zeropage($17) v1, word zeropage(2) v2, byte register(X) select)
mulu16_sel: {
    .label _0 = $e
    .label _1 = $e
    .label v1 = $17
    .label v2 = 2
    .label return = $24
    .label return_1 = $17
    .label return_10 = $17
    lda.z v1
    sta.z mul16u.a
    lda.z v1+1
    sta.z mul16u.a+1
    lda.z mul16u.b_1
    sta.z mul16u.mb
    lda.z mul16u.b_1+1
    sta.z mul16u.mb+1
    lda #0
    sta.z mul16u.mb+2
    sta.z mul16u.mb+3
    jsr mul16u
    cpx #0
    beq !e+
  !:
    asl.z _1
    rol.z _1+1
    rol.z _1+2
    rol.z _1+3
    dex
    bne !-
  !e:
    lda.z _1+2
    sta.z return
    lda.z _1+3
    sta.z return+1
    rts
}
// Divide unsigned 32-bit dword dividend with a 16-bit word divisor
// The 16-bit word remainder can be found in rem16u after the division
div32u16u: {
    .label quotient_hi = $24
    .label quotient_lo = $14
    .label return = $1c
    lda #<PI2_u4f28>>$10
    sta.z divr16u.dividend
    lda #>PI2_u4f28>>$10
    sta.z divr16u.dividend+1
    lda #<0
    sta.z divr16u.rem
    sta.z divr16u.rem+1
    jsr divr16u
    lda.z divr16u.return
    sta.z quotient_hi
    lda.z divr16u.return+1
    sta.z quotient_hi+1
    lda #<PI2_u4f28&$ffff
    sta.z divr16u.dividend
    lda #>PI2_u4f28&$ffff
    sta.z divr16u.dividend+1
    jsr divr16u
    lda.z quotient_hi
    sta.z return+2
    lda.z quotient_hi+1
    sta.z return+3
    lda.z quotient_lo
    sta.z return
    lda.z quotient_lo+1
    sta.z return+1
    rts
}
// Performs division on two 16 bit unsigned words and an initial remainder
// Returns the quotient dividend/divisor.
// The final remainder will be set into the global variable rem16u
// Implemented using simple binary division
// divr16u(word zeropage($12) dividend, word zeropage($19) rem)
divr16u: {
    .label rem = $19
    .label dividend = $12
    .label quotient = $14
    .label return = $14
    ldx #0
    txa
    sta.z quotient
    sta.z quotient+1
  b1:
    asl.z rem
    rol.z rem+1
    lda.z dividend+1
    and #$80
    cmp #0
    beq b2
    lda #1
    ora.z rem
    sta.z rem
  b2:
    asl.z dividend
    rol.z dividend+1
    asl.z quotient
    rol.z quotient+1
    lda.z rem+1
    cmp #>sin16s_gen2.wavelength
    bcc b3
    bne !+
    lda.z rem
    cmp #<sin16s_gen2.wavelength
    bcc b3
  !:
    inc.z quotient
    bne !+
    inc.z quotient+1
  !:
    lda.z rem
    sec
    sbc #<sin16s_gen2.wavelength
    sta.z rem
    lda.z rem+1
    sbc #>sin16s_gen2.wavelength
    sta.z rem+1
  b3:
    inx
    cpx #$10
    bne b1
    rts
}
// Interrupt Routine counting frames
irq: {
    sta rega+1
    lda #WHITE
    sta BGCOL
    lda #0
    cmp.z frame_cnt
    beq b1
    inc.z frame_cnt
  b1:
    lda #BLACK
    sta BGCOL
    // Acknowledge the IRQ
    lda #IRQ_RASTER
    sta IRQ_STATUS
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
