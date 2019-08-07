// Animated lines drawn on a single color bitmap
.pc = $801 "Basic"
:BasicUpstart(main)
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
  .label D011 = $d011
  .const VIC_BMM = $20
  .const VIC_DEN = $10
  .const VIC_RSEL = 8
  .label D018 = $d018
  // CIA#2 Port A: Serial bus, RS-232, VIC memory bank
  .label CIA2_PORT_A = $dd00
  // CIA #2 Port A data direction register.
  .label CIA2_PORT_A_DDR = $dd02
  .label BITMAP = $a000
  .label SCREEN = $8800
  // The number of points
  .const SIZE = 4
  // The delay between pixels
  .const DELAY = 8
main: {
    .const vicSelectGfxBank1_toDd001_return = 3^(>SCREEN)/$40
    .const toD0181_return = (>(SCREEN&$3fff)*4)|(>BITMAP)/4&$f
    .label i = $12
    // Disable normal interrupt
    sei
    // Disable kernal & basic
    lda #PROCPORT_DDR_MEMORY_MASK
    sta PROCPORT_DDR
    lda #PROCPORT_RAM_IO
    sta PROCPORT
    lda #VIC_BMM|VIC_DEN|VIC_RSEL|3
    sta D011
    lda #3
    sta CIA2_PORT_A_DDR
    lda #vicSelectGfxBank1_toDd001_return
    sta CIA2_PORT_A
    lda #toD0181_return
    sta D018
    jsr bitmap_init
    jsr bitmap_clear
    jsr screen_fill
    lda #0
    sta.z i
  b1:
    jsr point_init
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
    inc.z i
    lda #SIZE-1+1
    cmp.z i
    bne b1
  b2:
    lda #$ff
    cmp RASTER
    bne b2
    inc BORDERCOL
    jmp b2
}
// Plot a single dot in the bitmap
// bitmap_plot(word zeropage($a) x, byte register(X) y)
bitmap_plot: {
    .label _1 = $e
    .label x = $a
    .label plotter = $c
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
// Initialize the points to be animated
// point_init(byte zeropage($12) point_idx)
point_init: {
    .label _3 = 6
    .label _4 = $c
    .label _9 = $e
    .label _10 = $10
    .label _11 = $10
    .label point_idx = $12
    .label y_diff = 6
    .label abs16s1_return = 2
    .label abs16s2_return = 4
    .label x_stepf = $a
    .label x_diff = 8
    lda.z point_idx
    asl
    tay
    sec
    lda x_end,y
    sbc x_start,y
    sta.z x_diff
    lda x_end+1,y
    sbc x_start+1,y
    sta.z x_diff+1
    ldy.z point_idx
    lda y_end,y
    sta.z _3
    lda #0
    sta.z _3+1
    lda y_start,y
    sta.z _4
    lda #0
    sta.z _4+1
    lda.z y_diff
    sec
    sbc.z _4
    sta.z y_diff
    lda.z y_diff+1
    sbc.z _4+1
    sta.z y_diff+1
    lda.z x_diff+1
    bpl !abs16s1_b1+
    jmp abs16s1_b1
  !abs16s1_b1:
    lda.z x_diff
    sta.z abs16s1_return
    lda.z x_diff+1
    sta.z abs16s1_return+1
  abs16s2:
    lda.z y_diff+1
    bpl !abs16s2_b1+
    jmp abs16s2_b1
  !abs16s2_b1:
    lda.z y_diff
    sta.z abs16s2_return
    lda.z y_diff+1
    sta.z abs16s2_return+1
  b6:
    lda.z abs16s2_return+1
    cmp.z abs16s1_return+1
    bcc b1
    bne !+
    lda.z abs16s2_return
    cmp.z abs16s1_return
    bcc b1
  !:
  b2:
    lda.z point_idx
    asl
    tax
    lda x_start,x
    sta.z _9
    lda x_start+1,x
    sta.z _9+1
    asl.z _9
    rol.z _9+1
    asl.z _9
    rol.z _9+1
    asl.z _9
    rol.z _9+1
    asl.z _9
    rol.z _9+1
    lda.z _9
    sta x_cur,x
    lda.z _9+1
    sta x_cur+1,x
    ldy.z point_idx
    lda y_start,y
    sta.z _10
    lda #0
    sta.z _10+1
    asl.z _11
    rol.z _11+1
    asl.z _11
    rol.z _11+1
    asl.z _11
    rol.z _11+1
    asl.z _11
    rol.z _11+1
    lda.z _11
    sta y_cur,x
    lda.z _11+1
    sta y_cur+1,x
    lda #DELAY
    sta delay,y
    rts
  b1:
    // X is driver - abs(y/x) is < 1
    lda.z x_diff+1
    bmi b4
    // x add = 1.0
    lda #$10
    ldy.z point_idx
    sta x_add,y
  b5:
    jsr divr16s
    lda.z x_stepf+1
    lsr
    lsr
    lsr
    lsr
    ldy.z point_idx
    sta y_add,y
    jmp b2
  b4:
    // x add = -1.0
    lda #-$10
    ldy.z point_idx
    sta x_add,y
    jmp b5
  abs16s2_b1:
    sec
    lda #0
    sbc.z y_diff
    sta.z abs16s2_return
    lda #0
    sbc.z y_diff+1
    sta.z abs16s2_return+1
    jmp b6
  abs16s1_b1:
    sec
    lda #0
    sbc.z x_diff
    sta.z abs16s1_return
    lda #0
    sbc.z x_diff+1
    sta.z abs16s1_return+1
    jmp abs16s2
}
// Perform division on two signed 16-bit numbers with an initial remainder.
// Returns dividend/divisor. The remainder will be set into the global variable rem16s.
// Implemented using simple binary division
// Follows the C99 standard by truncating toward zero on negative results.
// See http://www.open-std.org/jtc1/sc22/wg14/www/docs/n1124.pdf section 6.5.5
// divr16s(signed word zeropage(8) divisor, signed word zeropage(6) rem)
divr16s: {
    .label remu = 6
    .label divisoru = 8
    .label resultu = $a
    .label return = $a
    .label divisor = 8
    .label rem = 6
    lda.z rem+1
    bmi b1
    ldy #0
  b2:
    lda.z divisor+1
    bmi b3
  b4:
    jsr divr16u
    cpy #0
    beq breturn
    sec
    lda #0
    sbc.z return
    sta.z return
    lda #0
    sbc.z return+1
    sta.z return+1
  breturn:
    rts
  b3:
    sec
    lda #0
    sbc.z divisoru
    sta.z divisoru
    lda #0
    sbc.z divisoru+1
    sta.z divisoru+1
    tya
    eor #1
    tay
    jmp b4
  b1:
    sec
    lda #0
    sbc.z remu
    sta.z remu
    lda #0
    sbc.z remu+1
    sta.z remu+1
    ldy #1
    jmp b2
}
// Performs division on two 16 bit unsigned words and an initial remainder
// Returns the quotient dividend/divisor.
// The final remainder will be set into the global variable rem16u
// Implemented using simple binary division
// divr16u(word zeropage(2) dividend, word zeropage(8) divisor, word zeropage(6) rem)
divr16u: {
    .label rem = 6
    .label dividend = 2
    .label quotient = $a
    .label return = $a
    .label divisor = 8
    ldx #0
    txa
    sta.z quotient
    sta.z quotient+1
    sta.z dividend
    sta.z dividend+1
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
    cmp.z divisor+1
    bcc b3
    bne !+
    lda.z rem
    cmp.z divisor
    bcc b3
  !:
    inc.z quotient
    bne !+
    inc.z quotient+1
  !:
    lda.z rem
    sec
    sbc.z divisor
    sta.z rem
    lda.z rem+1
    sbc.z divisor+1
    sta.z rem+1
  b3:
    inx
    cpx #$10
    bne b1
    rts
}
// Fill the screen with a specific char
// screen_fill(byte* zeropage(4) screen)
screen_fill: {
    .const ch = $10
    .label screen = 4
    .label y = $12
    lda #0
    sta.z y
    lda #<SCREEN
    sta.z screen
    lda #>SCREEN
    sta.z screen+1
  b1:
    ldx #0
  b2:
    lda #ch
    ldy #0
    sta (screen),y
    inc.z screen
    bne !+
    inc.z screen+1
  !:
    inx
    cpx #$28
    bne b2
    inc.z y
    lda #$19
    cmp.z y
    bne b1
    rts
}
// Clear all graphics on the bitmap
bitmap_clear: {
    .label bitmap = 6
    .label y = $12
    lda bitmap_plot_ylo
    sta.z bitmap
    lda bitmap_plot_yhi
    sta.z bitmap+1
    lda #0
    sta.z y
  b1:
    ldx #0
  b2:
    lda #0
    tay
    sta (bitmap),y
    inc.z bitmap
    bne !+
    inc.z bitmap+1
  !:
    inx
    cpx #$c8
    bne b2
    inc.z y
    lda #$28
    cmp.z y
    bne b1
    rts
}
bitmap_init: {
    .label _7 = $12
    .label yoffs = 8
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
  // The coordinates of the lines to animate
  x_start: .word $a, $14, $1e, $1e
  y_start: .byte $a, $a, $a, $14
  x_end: .word $14, $a, $14, $14
  y_end: .byte $14, $14, $a, $14
  // Tables for the plotter - initialized by calling bitmap_init();
  bitmap_plot_ylo: .fill $100, 0
  bitmap_plot_yhi: .fill $100, 0
  bitmap_plot_bit: .fill $100, 0
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
