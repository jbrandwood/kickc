// Tests the simple bitmap plotter - and counts plots per frame in an IRQ
// Plots a spiral
.pc = $801 "Basic"
:BasicUpstart(__b1)
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
  .label rem16u = $15
  .label frame_cnt = $12
__b1:
  // Counts frames - updated by the IRQ
  lda #1
  sta.z frame_cnt
  jsr main
  rts
main: {
    .const toD0181_return = (>(SCREEN&$3fff)*4)|(>BITMAP)/4&$f
    .label __7 = $1c
    .label __8 = $1c
    .label __13 = $13
    .label __14 = $13
    .label __31 = $24
    .label __32 = $24
    .label cos_x = $24
    .label xpos = $a
    .label x = $1c
    .label sin_y = $24
    .label ypos = $a
    .label y = $13
    .label idx_x = 2
    .label idx_y = $e
    .label r = 4
    .label r_add = $17
    .label __33 = $24
    .label __34 = $24
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
  __b2:
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
    jsr mul16s
    lda.z xpos+2
    sta.z __7
    lda.z xpos+3
    sta.z __7+1
    lda.z __8+1
    cmp #$80
    ror.z __8+1
    ror.z __8
    lda.z __8+1
    cmp #$80
    ror.z __8+1
    ror.z __8
    clc
    lda.z x
    adc #<$a0
    sta.z x
    lda.z x+1
    adc #>$a0
    sta.z x+1
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
    jsr mul16s
    lda.z ypos+2
    sta.z __13
    lda.z ypos+3
    sta.z __13+1
    lda.z __14+1
    cmp #$80
    ror.z __14+1
    ror.z __14
    lda.z __14+1
    cmp #$80
    ror.z __14+1
    ror.z __14
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
    lda.z r_add
    clc
    adc.z idx_y
    sta.z idx_y
    bcc !+
    inc.z idx_y+1
  !:
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
    clc
    lda.z r
    adc.z r_add
    sta.z r
    lda.z r+1
    adc #0
    sta.z r+1
    lda.z idx_x
    bne b1
    lda.z idx_x+1
    bne b1
    lda #1
    cmp.z r_add
    beq b1
    lsr.z r_add
  b1:
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
    inc BORDERCOL
    jmp __b7
}
// Plot a single dot in the bitmap
// bitmap_plot(word zeropage($1c) x, byte register(X) y)
bitmap_plot: {
    .label __1 = $15
    .label plotter = $13
    .label x = $1c
    lda bitmap_plot_yhi,x
    sta.z plotter+1
    lda bitmap_plot_ylo,x
    sta.z plotter
    lda.z x
    and #<$fff8
    sta.z __1
    lda.z x+1
    and #>$fff8
    sta.z __1+1
    lda.z plotter
    clc
    adc.z __1
    sta.z plotter
    lda.z plotter+1
    adc.z __1+1
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
// mul16s(signed word zeropage(4) a, signed word zeropage($24) b)
mul16s: {
    .label __9 = $15
    .label __13 = $22
    .label __16 = $15
    .label __17 = $22
    .label m = $a
    .label return = $a
    .label a = 4
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
    bpl __b1
    lda.z m+2
    sta.z __9
    lda.z m+3
    sta.z __9+1
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
    lda.z b+1
    bpl __b2
    lda.z m+2
    sta.z __13
    lda.z m+3
    sta.z __13+1
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
    rts
}
// Perform binary multiplication of two unsigned 16-bit words into a 32-bit unsigned double word
// mul16u(word zeropage($15) a, word zeropage($13) b)
mul16u: {
    .label mb = $1e
    .label a = $15
    .label res = $a
    .label b = $13
    .label return = $a
    .label b_1 = 2
    lda #0
    sta.z res
    sta.z res+1
    sta.z res+2
    sta.z res+3
  __b1:
    lda.z a
    bne __b2
    lda.z a+1
    bne __b2
    rts
  __b2:
    lda #1
    and.z a
    cmp #0
    beq __b3
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
    lsr.z a+1
    ror.z a
    asl.z mb
    rol.z mb+1
    rol.z mb+2
    rol.z mb+3
    jmp __b1
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
// memset(void* zeropage($e) str, byte register(X) c, word zeropage(4) num)
memset: {
    .label end = 4
    .label dst = $e
    .label num = 4
    .label str = $e
    lda.z num
    bne !+
    lda.z num+1
    beq __breturn
  !:
    lda.z end
    clc
    adc.z str
    sta.z end
    lda.z end+1
    adc.z str+1
    sta.z end+1
  __b2:
    lda.z dst+1
    cmp.z end+1
    bne __b3
    lda.z dst
    cmp.z end
    bne __b3
  __breturn:
    rts
  __b3:
    txa
    ldy #0
    sta (dst),y
    inc.z dst
    bne !+
    inc.z dst+1
  !:
    jmp __b2
}
// Initialize bitmap plotting tables
bitmap_init: {
    .label __7 = $17
    .label yoffs = $24
    ldx #0
    lda #$80
  __b1:
    sta bitmap_plot_bit,x
    lsr
    cmp #0
    bne __b2
    lda #$80
  __b2:
    inx
    cpx #0
    bne __b1
    lda #<BITMAP
    sta.z yoffs
    lda #>BITMAP
    sta.z yoffs+1
    ldx #0
  __b3:
    lda #7
    sax.z __7
    lda.z yoffs
    ora.z __7
    sta bitmap_plot_ylo,x
    lda.z yoffs+1
    sta bitmap_plot_yhi,x
    lda #7
    cmp.z __7
    bne __b4
    clc
    lda.z yoffs
    adc #<$28*8
    sta.z yoffs
    lda.z yoffs+1
    adc #>$28*8
    sta.z yoffs+1
  __b4:
    inx
    cpx #0
    bne __b3
    rts
}
// Generate signed word sinus table - with values in the range min-max.
// sintab - the table to generate into
// wavelength - the number of sinus points in a total sinus wavelength (the size of the table)
// sin16s_gen2(signed word* zeropage($10) sintab)
sin16s_gen2: {
    .label wavelength = $200
    .const min = -$1001
    .const max = $1001
    .const ampl = max-min
    .label __6 = $a
    .label __9 = $1c
    .label step = $18
    .label sintab = $10
    .label x = 6
    .label i = $e
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
  // u[4.28]
  __b1:
    lda.z i+1
    cmp #>wavelength
    bcc __b2
    bne !+
    lda.z i
    cmp #<wavelength
    bcc __b2
  !:
    rts
  __b2:
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
    lda.z __6+2
    sta.z __9
    lda.z __6+3
    sta.z __9+1
    ldy #0
    lda.z __9
    sta (sintab),y
    iny
    lda.z __9+1
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
    jmp __b1
}
// Calculate signed word sinus sin(x)
// x: unsigned dword input u[4.28] in the interval $00000000 - PI2_u4f28
// result: signed word sin(x) s[0.15] - using the full range  -$7fff - $7fff
// sin16s(dword zeropage($a) x)
sin16s: {
    .label __4 = $1e
    .label x = $a
    .label return = 4
    .label x1 = $22
    .label x2 = $13
    .label x3 = $13
    .label x3_6 = $24
    .label usinx = 4
    .label x4 = $13
    .label x5 = $24
    .label x5_128 = $24
    .label sinx = 4
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
    lda.z __4+2
    sta.z x1
    lda.z __4+3
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
    sta.z mulu16_sel.return_1
    lda.z mulu16_sel.return+1
    sta.z mulu16_sel.return_1+1
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
    cpy #0
    beq __b3
    sec
    lda #0
    sbc.z sinx
    sta.z sinx
    lda #0
    sbc.z sinx+1
    sta.z sinx+1
  __b3:
    rts
}
// Calculate val*val for two unsigned word values - the result is 16 selected bits of the 32-bit result.
// The select parameter indicates how many of the highest bits of the 32-bit result to skip
// mulu16_sel(word zeropage($13) v1, word zeropage(2) v2, byte register(X) select)
mulu16_sel: {
    .label __0 = $a
    .label __1 = $a
    .label v1 = $13
    .label v2 = 2
    .label return = $24
    .label return_1 = $13
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
    asl.z __1
    rol.z __1+1
    rol.z __1+2
    rol.z __1+3
    dex
    bne !-
  !e:
    lda.z __1+2
    sta.z return
    lda.z __1+3
    sta.z return+1
    rts
}
// Divide unsigned 32-bit dword dividend with a 16-bit word divisor
// The 16-bit word remainder can be found in rem16u after the division
div32u16u: {
    .label quotient_hi = $24
    .label quotient_lo = $10
    .label return = $18
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
// divr16u(word zeropage($e) dividend, word zeropage($15) rem)
divr16u: {
    .label rem = $15
    .label dividend = $e
    .label quotient = $10
    .label return = $10
    ldx #0
    txa
    sta.z quotient
    sta.z quotient+1
  __b1:
    asl.z rem
    rol.z rem+1
    lda.z dividend+1
    and #$80
    cmp #0
    beq __b2
    lda #1
    ora.z rem
    sta.z rem
  __b2:
    asl.z dividend
    rol.z dividend+1
    asl.z quotient
    rol.z quotient+1
    lda.z rem+1
    cmp #>sin16s_gen2.wavelength
    bcc __b3
    bne !+
    lda.z rem
    cmp #<sin16s_gen2.wavelength
    bcc __b3
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
  __b3:
    inx
    cpx #$10
    bne __b1
    rts
}
// Interrupt Routine counting frames
irq: {
    sta rega+1
    lda #WHITE
    sta BGCOL
    lda #0
    cmp.z frame_cnt
    beq __b1
    inc.z frame_cnt
  __b1:
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
