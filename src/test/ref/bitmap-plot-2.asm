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
  .const PROCPORT_RAM_IO = $35
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
  .label rem16u = $2e
  .label frame_cnt = $34
bbegin:
  // Counts frames - updated by the IRQ
  lda #1
  sta frame_cnt
  jsr main
  rts
main: {
    .const toD0181_return = (>(SCREEN&$3fff)*4)|(>BITMAP)/4&$f
    .label _10 = $35
    .label _11 = $35
    .label _16 = $37
    .label _17 = $37
    .label _32 = 9
    .label _33 = 9
    .label cos_x = 9
    .label xpos = $b
    .label x = $35
    .label sin_y = 9
    .label ypos = $b
    .label y = $37
    .label idx_x = 2
    .label idx_y = 6
    .label r = 4
    .label r_add = 8
    .label _34 = 9
    .label _35 = 9
    jsr sin16s_gen2
    jsr bitmap_init
    jsr bitmap_clear
    lda #VIC_BMM|VIC_DEN|VIC_RSEL|3
    sta D011
    lda #toD0181_return
    sta D018
    jsr init_irq
    lda #$20
    sta r_add
    lda #<$80
    sta idx_y
    lda #>$80
    sta idx_y+1
    lda #<0
    sta r
    sta r+1
    sta idx_x
    sta idx_x+1
  b2:
    lda idx_x
    asl
    sta _32
    lda idx_x+1
    rol
    sta _32+1
    clc
    lda _34
    adc #<SINUS
    sta _34
    lda _34+1
    adc #>SINUS
    sta _34+1
    ldy #0
    lda (cos_x),y
    tax
    iny
    lda (cos_x),y
    stx cos_x
    sta cos_x+1
    jsr mul16s
    lda xpos+2
    sta _10
    lda xpos+3
    sta _10+1
    lda _11+1
    cmp #$80
    ror _11+1
    ror _11
    lda _11+1
    cmp #$80
    ror _11+1
    ror _11
    clc
    lda x
    adc #<$a0
    sta x
    lda x+1
    adc #>$a0
    sta x+1
    lda idx_y
    asl
    sta _33
    lda idx_y+1
    rol
    sta _33+1
    clc
    lda _35
    adc #<SINUS
    sta _35
    lda _35+1
    adc #>SINUS
    sta _35+1
    ldy #0
    lda (sin_y),y
    tax
    iny
    lda (sin_y),y
    stx sin_y
    sta sin_y+1
    jsr mul16s
    lda ypos+2
    sta _16
    lda ypos+3
    sta _16+1
    lda _17+1
    cmp #$80
    ror _17+1
    ror _17
    lda _17+1
    cmp #$80
    ror _17+1
    ror _17
    lda y
    clc
    adc #<$64
    sta y
    lda y+1
    adc #>$64
    sta y+1
    lda y
    tax
    jsr bitmap_plot
    ldx frame_cnt
    inc plots_per_frame,x
    lda r_add
    clc
    adc idx_x
    sta idx_x
    bcc !+
    inc idx_x+1
  !:
    lda idx_x+1
    cmp #>$200
    bcc b3
    bne !+
    lda idx_x
    cmp #<$200
    bcc b3
  !:
    lda #<0
    sta idx_x
    sta idx_x+1
  b3:
    lda r_add
    clc
    adc idx_y
    sta idx_y
    bcc !+
    inc idx_y+1
  !:
    lda idx_y+1
    cmp #>$200
    bcc b4
    bne !+
    lda idx_y
    cmp #<$200
    bcc b4
  !:
    lda #<0
    sta idx_y
    sta idx_y+1
  b4:
    clc
    lda r
    adc r_add
    sta r
    lda r+1
    adc #0
    sta r+1
    lda idx_x
    bne b5
    lda idx_x+1
    bne b5
    lda #1
    cmp r_add
    beq b5
    lsr r_add
  b5:
    lda r
    cmp #<$200*$c+$100
    lda r+1
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
// bitmap_plot(word zeropage($35) x, byte register(X) y)
bitmap_plot: {
    .label _1 = $3b
    .label plotter = $39
    .label x = $35
    lda bitmap_plot_yhi,x
    sta plotter+1
    lda bitmap_plot_ylo,x
    sta plotter
    lda x
    and #<$fff8
    sta _1
    lda x+1
    and #>$fff8
    sta _1+1
    lda plotter
    clc
    adc _1
    sta plotter
    lda plotter+1
    adc _1+1
    sta plotter+1
    lda x
    tay
    lda bitmap_plot_bit,y
    ldy #0
    ora (plotter),y
    sta (plotter),y
    rts
}
// Multiply of two signed words to a signed double word
// Fixes offsets introduced by using unsigned multiplication
// mul16s(signed word zeropage(4) a, signed word zeropage(9) b)
mul16s: {
    .label _9 = $3d
    .label _13 = $3f
    .label _16 = $3d
    .label _17 = $3f
    .label m = $b
    .label return = $b
    .label a = 4
    .label b = 9
    lda a
    sta mul16u.a
    lda a+1
    sta mul16u.a+1
    lda b
    sta mul16u.b
    lda b+1
    sta mul16u.b+1
    lda mul16u.b
    sta mul16u.mb
    lda mul16u.b+1
    sta mul16u.mb+1
    lda #0
    sta mul16u.mb+2
    sta mul16u.mb+3
    jsr mul16u
    lda a+1
    bpl b1
    lda m+2
    sta _9
    lda m+3
    sta _9+1
    lda _16
    sec
    sbc b
    sta _16
    lda _16+1
    sbc b+1
    sta _16+1
    lda _16
    sta m+2
    lda _16+1
    sta m+3
  b1:
    lda b+1
    bpl b2
    lda m+2
    sta _13
    lda m+3
    sta _13+1
    lda _17
    sec
    sbc a
    sta _17
    lda _17+1
    sbc a+1
    sta _17+1
    lda _17
    sta m+2
    lda _17+1
    sta m+3
  b2:
    rts
}
// Perform binary multiplication of two unsigned 16-bit words into a 32-bit unsigned double word
// mul16u(word zeropage($13) a, word zeropage($f) b)
mul16u: {
    .label mb = $15
    .label a = $13
    .label res = $b
    .label b = $f
    .label return = $b
    .label b_1 = $11
    lda #0
    sta res
    sta res+1
    sta res+2
    sta res+3
  b1:
    lda a
    bne b2
    lda a+1
    bne b2
    rts
  b2:
    lda a
    and #1
    cmp #0
    beq b3
    lda res
    clc
    adc mb
    sta res
    lda res+1
    adc mb+1
    sta res+1
    lda res+2
    adc mb+2
    sta res+2
    lda res+3
    adc mb+3
    sta res+3
  b3:
    lsr a+1
    ror a
    asl mb
    rol mb+1
    rol mb+2
    rol mb+3
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
    sta memset.str
    lda #>SCREEN
    sta memset.str+1
    lda #<$3e8
    sta memset.num
    lda #>$3e8
    sta memset.num+1
    jsr memset
    ldx #0
    lda #<BITMAP
    sta memset.str
    lda #>BITMAP
    sta memset.str+1
    lda #<$1f40
    sta memset.num
    lda #>$1f40
    sta memset.num+1
    jsr memset
    rts
}
// Copies the character c (an unsigned char) to the first num characters of the object pointed to by the argument str.
// memset(void* zeropage($1b) str, byte register(X) c, word zeropage($19) num)
memset: {
    .label end = $19
    .label dst = $1b
    .label num = $19
    .label str = $1b
    lda num
    beq breturn
    lda num+1
    beq breturn
    lda end
    clc
    adc str
    sta end
    lda end+1
    adc str+1
    sta end+1
  b2:
    txa
    ldy #0
    sta (dst),y
    inc dst
    bne !+
    inc dst+1
  !:
    lda dst+1
    cmp end+1
    bne b2
    lda dst
    cmp end
    bne b2
  breturn:
    rts
}
// Initialize bitmap plotting tables
bitmap_init: {
    .label _7 = $41
    .label yoffs = $1d
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
    sta yoffs
    lda #>BITMAP
    sta yoffs+1
    ldx #0
  b3:
    lda #7
    sax _7
    lda yoffs
    ora _7
    sta bitmap_plot_ylo,x
    lda yoffs+1
    sta bitmap_plot_yhi,x
    lda #7
    cmp _7
    bne b4
    clc
    lda yoffs
    adc #<$28*8
    sta yoffs
    lda yoffs+1
    adc #>$28*8
    sta yoffs+1
  b4:
    inx
    cpx #0
    bne b3
    rts
}
// Generate signed word sinus table - with values in the range min-max.
// sintab - the table to generate into
// wavelength - the number of sinus points in a total sinus wavelength (the size of the table)
// sin16s_gen2(signed word* zeropage($23) sintab)
sin16s_gen2: {
    .label wavelength = $200
    .const min = -$1001
    .const max = $1001
    .const ampl = max-min
    .label _5 = $b
    .label _8 = $46
    .label step = $42
    .label sintab = $23
    .label x = $1f
    .label i = $25
    jsr div32u16u
    lda #<0
    sta i
    sta i+1
    lda #<SINUS
    sta sintab
    lda #>SINUS
    sta sintab+1
    lda #0
    sta x
    sta x+1
    sta x+2
    sta x+3
  // u[4.28]
  b1:
    lda x
    sta sin16s.x
    lda x+1
    sta sin16s.x+1
    lda x+2
    sta sin16s.x+2
    lda x+3
    sta sin16s.x+3
    jsr sin16s
    lda #<ampl
    sta mul16s.b
    lda #>ampl
    sta mul16s.b+1
    jsr mul16s
    lda _5+2
    sta _8
    lda _5+3
    sta _8+1
    ldy #0
    lda _8
    sta (sintab),y
    iny
    lda _8+1
    sta (sintab),y
    lda #SIZEOF_SIGNED_WORD
    clc
    adc sintab
    sta sintab
    bcc !+
    inc sintab+1
  !:
    lda x
    clc
    adc step
    sta x
    lda x+1
    adc step+1
    sta x+1
    lda x+2
    adc step+2
    sta x+2
    lda x+3
    adc step+3
    sta x+3
    inc i
    bne !+
    inc i+1
  !:
    lda i+1
    cmp #>wavelength
    bcc b1
    bne !+
    lda i
    cmp #<wavelength
    bcc b1
  !:
    rts
}
// Calculate signed word sinus sin(x)
// x: unsigned dword input u[4.28] in the interval $00000000 - PI2_u4f28
// result: signed word sin(x) s[0.15] - using the full range  -$7fff - $7fff
// sin16s(dword zeropage($28) x)
sin16s: {
    .label _4 = $28
    .label x = $28
    .label return = 4
    .label x1 = $48
    .label x2 = $2c
    .label x3 = $2c
    .label x3_6 = $4a
    .label usinx = 4
    .label x4 = $2c
    .label x5 = $4a
    .label x5_128 = $4a
    .label sinx = 4
    .label isUpper = $27
    lda x+3
    cmp #>PI_u4f28>>$10
    bcc b4
    bne !+
    lda x+2
    cmp #<PI_u4f28>>$10
    bcc b4
    bne !+
    lda x+1
    cmp #>PI_u4f28
    bcc b4
    bne !+
    lda x
    cmp #<PI_u4f28
    bcc b4
  !:
    lda x
    sec
    sbc #<PI_u4f28
    sta x
    lda x+1
    sbc #>PI_u4f28
    sta x+1
    lda x+2
    sbc #<PI_u4f28>>$10
    sta x+2
    lda x+3
    sbc #>PI_u4f28>>$10
    sta x+3
    lda #1
    sta isUpper
    jmp b1
  b4:
    lda #0
    sta isUpper
  b1:
    lda x+3
    cmp #>PI_HALF_u4f28>>$10
    bcc b2
    bne !+
    lda x+2
    cmp #<PI_HALF_u4f28>>$10
    bcc b2
    bne !+
    lda x+1
    cmp #>PI_HALF_u4f28
    bcc b2
    bne !+
    lda x
    cmp #<PI_HALF_u4f28
    bcc b2
  !:
    lda #<PI_u4f28
    sec
    sbc x
    sta x
    lda #>PI_u4f28
    sbc x+1
    sta x+1
    lda #<PI_u4f28>>$10
    sbc x+2
    sta x+2
    lda #>PI_u4f28>>$10
    sbc x+3
    sta x+3
  b2:
    ldy #3
  !:
    asl _4
    rol _4+1
    rol _4+2
    rol _4+3
    dey
    bne !-
    lda _4+2
    sta x1
    lda _4+3
    sta x1+1
    lda x1
    sta mulu16_sel.v1
    lda x1+1
    sta mulu16_sel.v1+1
    lda x1
    sta mulu16_sel.v2
    lda x1+1
    sta mulu16_sel.v2+1
    ldx #0
    jsr mulu16_sel
    lda mulu16_sel.return
    sta x2
    lda mulu16_sel.return+1
    sta x2+1
    lda x1
    sta mulu16_sel.v2
    lda x1+1
    sta mulu16_sel.v2+1
    ldx #1
    jsr mulu16_sel
    lda mulu16_sel.return
    sta mulu16_sel.return_1
    lda mulu16_sel.return+1
    sta mulu16_sel.return_1+1
    ldx #1
    lda #<$10000/6
    sta mulu16_sel.v2
    lda #>$10000/6
    sta mulu16_sel.v2+1
    jsr mulu16_sel
    lda x1
    sec
    sbc x3_6
    sta usinx
    lda x1+1
    sbc x3_6+1
    sta usinx+1
    lda x1
    sta mulu16_sel.v2
    lda x1+1
    sta mulu16_sel.v2+1
    ldx #0
    jsr mulu16_sel
    lda mulu16_sel.return
    sta mulu16_sel.return_10
    lda mulu16_sel.return+1
    sta mulu16_sel.return_10+1
    lda x1
    sta mulu16_sel.v2
    lda x1+1
    sta mulu16_sel.v2+1
    ldx #0
    jsr mulu16_sel
    lsr x5_128+1
    ror x5_128
    lsr x5_128+1
    ror x5_128
    lsr x5_128+1
    ror x5_128
    lsr x5_128+1
    ror x5_128
    lda usinx
    clc
    adc x5_128
    sta usinx
    lda usinx+1
    adc x5_128+1
    sta usinx+1
    lda isUpper
    cmp #0
    beq b3
    sec
    lda #0
    sbc sinx
    sta sinx
    lda #0
    sbc sinx+1
    sta sinx+1
  b3:
    rts
}
// Calculate val*val for two unsigned word values - the result is 16 selected bits of the 32-bit result.
// The select parameter indicates how many of the highest bits of the 32-bit result to skip
// mulu16_sel(word zeropage($2c) v1, word zeropage($11) v2, byte register(X) select)
mulu16_sel: {
    .label _0 = $b
    .label _1 = $b
    .label v1 = $2c
    .label v2 = $11
    .label return = $4a
    .label return_1 = $2c
    .label return_10 = $2c
    lda v1
    sta mul16u.a
    lda v1+1
    sta mul16u.a+1
    lda mul16u.b_1
    sta mul16u.mb
    lda mul16u.b_1+1
    sta mul16u.mb+1
    lda #0
    sta mul16u.mb+2
    sta mul16u.mb+3
    jsr mul16u
    cpx #0
    beq !e+
  !:
    asl _1
    rol _1+1
    rol _1+2
    rol _1+3
    dex
    bne !-
  !e:
    lda _1+2
    sta return
    lda _1+3
    sta return+1
    rts
}
// Divide unsigned 32-bit dword dividend with a 16-bit word divisor
// The 16-bit word remainder can be found in rem16u after the division
div32u16u: {
    .label quotient_hi = $4c
    .label quotient_lo = $32
    .label return = $42
    lda #<PI2_u4f28>>$10
    sta divr16u.dividend
    lda #>PI2_u4f28>>$10
    sta divr16u.dividend+1
    lda #<0
    sta divr16u.rem
    sta divr16u.rem+1
    jsr divr16u
    lda divr16u.return
    sta quotient_hi
    lda divr16u.return+1
    sta quotient_hi+1
    lda #<PI2_u4f28&$ffff
    sta divr16u.dividend
    lda #>PI2_u4f28&$ffff
    sta divr16u.dividend+1
    jsr divr16u
    lda quotient_hi
    sta return+2
    lda quotient_hi+1
    sta return+3
    lda quotient_lo
    sta return
    lda quotient_lo+1
    sta return+1
    rts
}
// Performs division on two 16 bit unsigned words and an initial remainder
// Returns the quotient dividend/divisor.
// The final remainder will be set into the global variable rem16u
// Implemented using simple binary division
// divr16u(word zeropage($30) dividend, word zeropage($2e) rem)
divr16u: {
    .label rem = $2e
    .label dividend = $30
    .label quotient = $32
    .label return = $32
    ldx #0
    txa
    sta quotient
    sta quotient+1
  b1:
    asl rem
    rol rem+1
    lda dividend+1
    and #$80
    cmp #0
    beq b2
    lda #1
    ora rem
    sta rem
  b2:
    asl dividend
    rol dividend+1
    asl quotient
    rol quotient+1
    lda rem+1
    cmp #>sin16s_gen2.wavelength
    bcc b3
    bne !+
    lda rem
    cmp #<sin16s_gen2.wavelength
    bcc b3
  !:
    inc quotient
    bne !+
    inc quotient+1
  !:
    lda rem
    sec
    sbc #<sin16s_gen2.wavelength
    sta rem
    lda rem+1
    sbc #>sin16s_gen2.wavelength
    sta rem+1
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
    cmp frame_cnt
    beq b1
    inc frame_cnt
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
