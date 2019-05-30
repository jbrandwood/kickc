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
  .const PROCPORT_RAM_IO = $35
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
    .label i = 2
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
    sta i
  b1:
    jsr point_init
    lda i
    asl
    tay
    lda x_start,y
    sta bitmap_plot.x
    lda x_start+1,y
    sta bitmap_plot.x+1
    ldy i
    ldx y_start,y
    jsr bitmap_plot
    inc i
    lda #SIZE-1+1
    cmp i
    bne b1
  b2:
    lda #$ff
    cmp RASTER
    bne b2
    inc BORDERCOL
    jmp b2
}
// Plot a single dot in the bitmap
// bitmap_plot(word zeropage(3) x, byte register(X) y)
bitmap_plot: {
    .label _1 = 7
    .label x = 3
    .label plotter = 5
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
// Initialize the points to be animated
// point_init(byte zeropage(2) point_idx)
point_init: {
    .label _3 = 7
    .label _4 = 3
    .label _9 = 3
    .label _10 = 3
    .label _11 = 3
    .label point_idx = 2
    .label y_diff = 7
    .label abs16s1_return = 3
    .label abs16s2_return = 5
    .label x_stepf = 3
    .label x_diff = 9
    lda point_idx
    asl
    tay
    sec
    lda x_end,y
    sbc x_start,y
    sta x_diff
    lda x_end+1,y
    sbc x_start+1,y
    sta x_diff+1
    ldy point_idx
    lda y_end,y
    sta _3
    lda #0
    sta _3+1
    lda y_start,y
    sta _4
    lda #0
    sta _4+1
    lda y_diff
    sec
    sbc _4
    sta y_diff
    lda y_diff+1
    sbc _4+1
    sta y_diff+1
    lda x_diff+1
    bpl !abs16s1_b1+
    jmp abs16s1_b1
  !abs16s1_b1:
    lda x_diff
    sta abs16s1_return
    lda x_diff+1
    sta abs16s1_return+1
  abs16s2:
    lda y_diff+1
    bpl !abs16s2_b1+
    jmp abs16s2_b1
  !abs16s2_b1:
    lda y_diff
    sta abs16s2_return
    lda y_diff+1
    sta abs16s2_return+1
  b6:
    lda abs16s2_return+1
    cmp abs16s1_return+1
    bcc b1
    bne !+
    lda abs16s2_return
    cmp abs16s1_return
    bcc b1
  !:
  b2:
    lda point_idx
    asl
    tax
    lda x_start,x
    sta _9
    lda x_start+1,x
    sta _9+1
    asl _9
    rol _9+1
    asl _9
    rol _9+1
    asl _9
    rol _9+1
    asl _9
    rol _9+1
    lda _9
    sta x_cur,x
    lda _9+1
    sta x_cur+1,x
    ldy point_idx
    lda y_start,y
    sta _10
    lda #0
    sta _10+1
    asl _11
    rol _11+1
    asl _11
    rol _11+1
    asl _11
    rol _11+1
    asl _11
    rol _11+1
    lda _11
    sta y_cur,x
    lda _11+1
    sta y_cur+1,x
    lda #DELAY
    sta delay,y
    rts
  b1:
    // X is driver - abs(y/x) is < 1
    lda x_diff+1
    bmi b4
    // x add = 1.0
    lda #$10
    ldy point_idx
    sta x_add,y
  b5:
    jsr divr16s
    lda x_stepf+1
    lsr
    lsr
    lsr
    lsr
    ldy point_idx
    sta y_add,y
    jmp b2
  b4:
    // x add = -1.0
    lda #-$10
    ldy point_idx
    sta x_add,y
    jmp b5
  abs16s2_b1:
    sec
    lda y_diff
    eor #$ff
    adc #0
    sta abs16s2_return
    lda y_diff+1
    eor #$ff
    adc #0
    sta abs16s2_return+1
    jmp b6
  abs16s1_b1:
    sec
    lda x_diff
    eor #$ff
    adc #0
    sta abs16s1_return
    lda x_diff+1
    eor #$ff
    adc #0
    sta abs16s1_return+1
    jmp abs16s2
}
// Perform division on two signed 16-bit numbers with an initial remainder.
// Returns dividend/divisor. The remainder will be set into the global variable rem16s.
// Implemented using simple binary division
// Follows the C99 standard by truncating toward zero on negative results.
// See http://www.open-std.org/jtc1/sc22/wg14/www/docs/n1124.pdf section 6.5.5
// divr16s(signed word zeropage(9) divisor, signed word zeropage(7) rem)
divr16s: {
    .label remu = 7
    .label divisoru = 9
    .label resultu = 3
    .label return = 3
    .label divisor = 9
    .label rem = 7
    lda rem+1
    bmi b1
    ldy #0
  b2:
    lda divisor+1
    bmi b3
  b4:
    jsr divr16u
    cpy #0
    beq breturn
    sec
    lda return
    eor #$ff
    adc #0
    sta return
    lda return+1
    eor #$ff
    adc #0
    sta return+1
  breturn:
    rts
  b3:
    sec
    lda divisoru
    eor #$ff
    adc #0
    sta divisoru
    lda divisoru+1
    eor #$ff
    adc #0
    sta divisoru+1
    tya
    eor #1
    tay
    jmp b4
  b1:
    sec
    lda remu
    eor #$ff
    adc #0
    sta remu
    lda remu+1
    eor #$ff
    adc #0
    sta remu+1
    ldy #1
    jmp b2
}
// Performs division on two 16 bit unsigned words and an initial remainder
// Returns the quotient dividend/divisor.
// The final remainder will be set into the global variable rem16u
// Implemented using simple binary division
// divr16u(word zeropage(5) dividend, word zeropage(9) divisor, word zeropage(7) rem)
divr16u: {
    .label rem = 7
    .label dividend = 5
    .label quotient = 3
    .label return = 3
    .label divisor = 9
    ldx #0
    txa
    sta quotient
    sta quotient+1
    sta dividend
    sta dividend+1
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
    cmp divisor+1
    bcc b3
    bne !+
    lda rem
    cmp divisor
    bcc b3
  !:
    inc quotient
    bne !+
    inc quotient+1
  !:
    lda rem
    sec
    sbc divisor
    sta rem
    lda rem+1
    sbc divisor+1
    sta rem+1
  b3:
    inx
    cpx #$10
    bne b1
    rts
}
// Fill the screen with a specific char
// screen_fill(byte* zeropage(3) screen)
screen_fill: {
    .const ch = $10
    .label screen = 3
    .label y = 2
    lda #0
    sta y
    lda #<SCREEN
    sta screen
    lda #>SCREEN
    sta screen+1
  b1:
    ldx #0
  b2:
    lda #ch
    ldy #0
    sta (screen),y
    inc screen
    bne !+
    inc screen+1
  !:
    inx
    cpx #$28
    bne b2
    inc y
    lda #$19
    cmp y
    bne b1
    rts
}
// Clear all graphics on the bitmap
bitmap_clear: {
    .label bitmap = 3
    .label y = 2
    lda bitmap_plot_ylo
    sta bitmap
    lda bitmap_plot_yhi
    sta bitmap+1
    lda #0
    sta y
  b1:
    ldx #0
  b2:
    lda #0
    tay
    sta (bitmap),y
    inc bitmap
    bne !+
    inc bitmap+1
  !:
    inx
    cpx #$c8
    bne b2
    inc y
    lda #$28
    cmp y
    bne b1
    rts
}
bitmap_init: {
    .label _7 = 2
    .label yoffs = 3
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
