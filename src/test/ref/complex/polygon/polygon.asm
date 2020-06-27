// Filling a simple 16x16 2D polygon using EOR-filling
// - Clearing canvas
// - Trivial 2D rotation using sine tables
// - Line-drawing polygon edges (fill-ready lines)
// - Up-to-down EOR filling 
// - Double buffering
.pc = $801 "Basic"
:BasicUpstart(_start)
.pc = $80d "Program"
  // Value that disables all CIA interrupts when stored to the CIA Interrupt registers
  .const CIA_INTERRUPT_CLEAR = $7f
  // Timer Control - Start/stop timer (0:stop, 1: start)
  .const CIA_TIMER_CONTROL_START = 1
  // Timer B Control - Timer counts (00:system cycles, 01: CNT pulses, 10: timer A underflow, 11: time A underflow while CNT is high)
  .const CIA_TIMER_CONTROL_B_COUNT_UNDERFLOW_A = $40
  .const BORDER_YPOS_BOTTOM = $fa
  // Bits for the VICII IRQ Status/Enable Registers
  .const IRQ_RASTER = 1
  // The colors of the C64
  .const BLACK = 0
  .const WHITE = 1
  .const RED = 2
  .const DARK_GREY = $b
  .const OFFSET_STRUCT_MOS6526_CIA_TIMER_A_CONTROL = $e
  .const OFFSET_STRUCT_MOS6526_CIA_TIMER_B_CONTROL = $f
  .const OFFSET_STRUCT_MOS6569_VICII_BORDER_COLOR = $20
  .const OFFSET_STRUCT_MOS6569_VICII_BG_COLOR = $21
  .const OFFSET_STRUCT_MOS6526_CIA_INTERRUPT = $d
  .const OFFSET_STRUCT_MOS6569_VICII_CONTROL1 = $11
  .const OFFSET_STRUCT_MOS6569_VICII_RASTER = $12
  .const OFFSET_STRUCT_MOS6569_VICII_IRQ_ENABLE = $1a
  .const OFFSET_STRUCT_MOS6569_VICII_MEMORY = $18
  .const OFFSET_STRUCT_MOS6569_VICII_IRQ_STATUS = $19
  // The VIC-II MOS 6567/6569
  .label VICII = $d000
  // Color Ram
  .label COLS = $d800
  // The CIA#1: keyboard matrix, joystick #1/#2
  .label CIA1 = $dc00
  // The CIA#2: Serial bus, RS-232, VIC memory bank
  .label CIA2 = $dd00
  // CIA#2 timer A&B as one single 32-bit value
  .label CIA2_TIMER_AB = $dd04
  // The vector used when the KERNAL serves IRQ interrupts
  .label KERNEL_IRQ = $314
  // The line buffer
  .label LINE_BUFFER = $2000
  // The two charsets used as screen buffers
  .label CANVAS1 = $3000
  .label CANVAS2 = $3800
  // The screen matrix
  .label SCREEN = $2c00
  // The screen console
  .label CONSOLE = $400
  // The default charset address
  .label PETSCII = $1000
  .label COSTAB = SINTAB+$40
  // The current canvas being rendered to the screen - in D018 format.
  .label canvas_show_memory = $11
  // Flag signalling that the canvas on screen needs to be updated.
  // Set to 1 by the renderer when a new canvas is ready for showing, and to 0 by the raster when the canvas is shown on screen.
  .label canvas_show_flag = $12
_start: {
    .const _init1_toD0181_return = (>(SCREEN&$3fff)*4)|(>CANVAS2)/4&$f
    // canvas_show_memory = toD018(SCREEN, CANVAS2)
    lda #_init1_toD0181_return
    sta.z canvas_show_memory
    // canvas_show_flag = 0
    lda #0
    sta.z canvas_show_flag
    jsr main
    rts
}
main: {
    .const toD0181_return = (>(SCREEN&$3fff)*4)|(>CANVAS1)/4&$f
    .const toD0182_return = (>(SCREEN&$3fff)*4)|(>CANVAS2)/4&$f
    .label cols = 3
    // Setup 16x16 canvas for rendering
    // Setup 16x16 canvas for rendering
    .label screen = 5
    .label y = 2
    // Plot in line buffer
    .label x0 = $13
    .label y0 = $14
    .label x1 = $c
    .label y1 = $15
    .label x2 = $c
    .label y2 = $16
    .label p0_idx = 7
    .label p1_idx = 8
    .label p2_idx = 9
    // The current canvas being rendered to
    // The current canvas being rendered to
    .label canvas = $a
    // memset(CONSOLE, ' ', 40*25)
  // Clear the console
    ldx #' '
    lda #<CONSOLE
    sta.z memset.str
    lda #>CONSOLE
    sta.z memset.str+1
    lda #<$28*$19
    sta.z memset.num
    lda #>$28*$19
    sta.z memset.num+1
    jsr memset
    // memset(SCREEN, 0, 40*25)
  // Clear the screen
    ldx #0
    lda #<SCREEN
    sta.z memset.str
    lda #>SCREEN
    sta.z memset.str+1
    lda #<$28*$19
    sta.z memset.num
    lda #>$28*$19
    sta.z memset.num+1
    jsr memset
    // memset(COLS, BLACK, 40*25)
    ldx #BLACK
    lda #<COLS
    sta.z memset.str
    lda #>COLS
    sta.z memset.str+1
    lda #<$28*$19
    sta.z memset.num
    lda #>$28*$19
    sta.z memset.num+1
    jsr memset
    lda #<SCREEN+$c
    sta.z screen
    lda #>SCREEN+$c
    sta.z screen+1
    lda #<COLS+$c
    sta.z cols
    lda #>COLS+$c
    sta.z cols+1
    lda #0
    sta.z y
  __b1:
    // for(char y=0;y<16;y++)
    lda.z y
    cmp #$10
    bcs !__b2+
    jmp __b2
  !__b2:
    // VICII->BORDER_COLOR = BLACK
    lda #BLACK
    sta VICII+OFFSET_STRUCT_MOS6569_VICII_BORDER_COLOR
    // VICII->BG_COLOR = BLACK
    sta VICII+OFFSET_STRUCT_MOS6569_VICII_BG_COLOR
    // setup_irq()
    // Set-up the raster IRQ
    jsr setup_irq
    lda #<CANVAS1
    sta.z canvas
    lda #>CANVAS1
    sta.z canvas+1
    lda #$b5+$aa
    sta.z p2_idx
    lda #$b5+$f
    sta.z p1_idx
    lda #$b5
    sta.z p0_idx
  __b8:
    // clock_start()
    jsr clock_start
    // memset(LINE_BUFFER, 0, 0x0800)
  // Clear line buffer
    ldx #0
    lda #<LINE_BUFFER
    sta.z memset.str
    lda #>LINE_BUFFER
    sta.z memset.str+1
    lda #<$800
    sta.z memset.num
    lda #>$800
    sta.z memset.num+1
    jsr memset
    // x0 = COSTAB[p0_idx]
    // Plot in line buffer
    ldy.z p0_idx
    lda COSTAB,y
    sta.z x0
    // y0 = SINTAB[p0_idx]
    lda SINTAB,y
    sta.z y0
    // x1 = COSTAB[p1_idx]
    ldy.z p1_idx
    lda COSTAB,y
    sta.z x1
    // y1 = SINTAB[p1_idx]
    lda SINTAB,y
    sta.z y1
    // line(LINE_BUFFER, x0, y0, x1, y1)
    lda.z x0
    sta.z line.x1
    lda.z y0
    sta.z line.y1
    lda.z y1
    sta.z line.y2
    jsr line
    // x2 = COSTAB[p2_idx]
    ldy.z p2_idx
    lda COSTAB,y
    sta.z x2
    // y2 = SINTAB[p2_idx]
    lda SINTAB,y
    sta.z y2
    // line(LINE_BUFFER, x1, y1, x2, y2)
    lda.z x1
    sta.z line.x1
    lda.z y1
    sta.z line.y1
    lda.z y2
    sta.z line.y2
    jsr line
    // line(LINE_BUFFER, x2, y2, x0, y0)
    lda.z x2
    sta.z line.x1
    lda.z y2
    sta.z line.y1
    lda.z x0
    sta.z line.x2
    lda.z y0
    sta.z line.y2
    jsr line
    // p0_idx++;
    inc.z p0_idx
    // p1_idx++;
    inc.z p1_idx
    // p2_idx++;
    inc.z p2_idx
    // VICII->BORDER_COLOR = RED
    // Wait until the canvas on screen has been switched before starting work on the next frame
    lda #RED
    sta VICII+OFFSET_STRUCT_MOS6569_VICII_BORDER_COLOR
  __b9:
    // while(canvas_show_flag)
    lda #0
    cmp.z canvas_show_flag
    bne __b9
    // VICII->BORDER_COLOR = BLACK
    lda #BLACK
    sta VICII+OFFSET_STRUCT_MOS6569_VICII_BORDER_COLOR
    // eorfill(LINE_BUFFER, canvas)
    lda.z canvas
    sta.z eorfill.canvas
    lda.z canvas+1
    sta.z eorfill.canvas+1
  // Fill canvas
    jsr eorfill
    // canvas ^= (CANVAS1^CANVAS2)
    // swap canvas being rendered to (using XOR)
    lda #<CANVAS1^CANVAS2
    eor.z canvas
    sta.z canvas
    lda #>CANVAS1^CANVAS2
    eor.z canvas+1
    sta.z canvas+1
    // canvas_show_memory ^= toD018(SCREEN,CANVAS1)^toD018(SCREEN,CANVAS2)
    // Swap canvas to show on screen (using XOR)
    lda #toD0181_return^toD0182_return
    eor.z canvas_show_memory
    sta.z canvas_show_memory
    // canvas_show_flag = 1
    // Set flag used to signal when the canvas has been shown
    lda #1
    sta.z canvas_show_flag
    jmp __b8
  __b2:
    ldx.z y
    ldy #0
  __b4:
    // for(char x=0;x<16;x++)
    cpy #$10
    bcc __b5
    // cols += 40
    lda #$28
    clc
    adc.z cols
    sta.z cols
    bcc !+
    inc.z cols+1
  !:
    // screen += 40
    lda #$28
    clc
    adc.z screen
    sta.z screen
    bcc !+
    inc.z screen+1
  !:
    // for(char y=0;y<16;y++)
    inc.z y
    jmp __b1
  __b5:
    // cols[x] = WHITE
    lda #WHITE
    sta (cols),y
    // screen[x] = c
    txa
    sta (screen),y
    // c+=0x10
    txa
    axs #-[$10]
    // for(char x=0;x<16;x++)
    iny
    jmp __b4
}
// EOR fill from the line buffer onto the canvas
// eorfill(byte* zp($1f) canvas)
eorfill: {
    .label canvas = $1f
    .label line_column = $1c
    .label fill_column = $1f
    lda #<LINE_BUFFER
    sta.z line_column
    lda #>LINE_BUFFER
    sta.z line_column+1
    ldx #0
  __b1:
    // for(char x=0;x<16;x++)
    cpx #$10
    bcc __b2
    // }
    rts
  __b2:
    // eor = line_column[0]
    ldy #0
    lda (line_column),y
    // fill_column[0] = eor
    sta (fill_column),y
    ldy #1
  __b3:
    // for(char y=1;y<16*8;y++)
    cpy #$10*8
    bcc __b4
    // line_column += 16*8
    lda #$10*8
    clc
    adc.z line_column
    sta.z line_column
    bcc !+
    inc.z line_column+1
  !:
    // fill_column += 16*8
    lda #$10*8
    clc
    adc.z fill_column
    sta.z fill_column
    bcc !+
    inc.z fill_column+1
  !:
    // for(char x=0;x<16;x++)
    inx
    jmp __b1
  __b4:
    // eor ^= line_column[y]
    eor (line_column),y
    // fill_column[y] = eor
    sta (fill_column),y
    // for(char y=1;y<16*8;y++)
    iny
    jmp __b3
}
// Draw a EOR friendly line between two points
// Uses bresenham line drawing routine
// line(byte zp($f) x1, byte zp($10) y1, byte zp($c) x2, byte zp($d) y2)
line: {
    .label plot2___1 = $1e
    .label plot5___1 = $27
    .label x1 = $f
    .label y1 = $10
    .label x2 = $c
    .label y2 = $d
    .label x = $f
    .label y = $10
    .label dx = $17
    .label dy = $18
    .label sx = $19
    .label sy = $1a
    // Find the canvas column
    .label plot1_column = $21
    .label plot2_y = $1b
    // Find the canvas column
    .label plot2_column = $1c
    // Find the canvas column
    .label plot3_column = $1f
    .label e1 = $e
    // Find the canvas column
    .label plot4_column = $23
    // Find the canvas column
    .label plot5_column = $25
    // Find the canvas column
    .label plot6_column = $28
    // abs_u8(x2-x1)
    lda.z x2
    sec
    sbc.z x
    jsr abs_u8
    // abs_u8(x2-x1)
    // dx = abs_u8(x2-x1)
    sta.z dx
    // abs_u8(y2-y1)
    lda.z y2
    sec
    sbc.z y
    jsr abs_u8
    // abs_u8(y2-y1)
    // dy = abs_u8(y2-y1)
    sta.z dy
    // sgn_u8(x2-x1)
    lda.z x2
    sec
    sbc.z x
    jsr sgn_u8
    // sgn_u8(x2-x1)
    // sx = sgn_u8(x2-x1)
    sta.z sx
    // sgn_u8(y2-y1)
    lda.z y2
    sec
    sbc.z y
    jsr sgn_u8
    // sgn_u8(y2-y1)
    // sy = sgn_u8(y2-y1)
    sta.z sy
    // if(sx==0xff)
    lda #$ff
    cmp.z sx
    bne __b1
    // y++;
    inc.z y
    // y2++;
    inc.z y2
  __b1:
    // if(dx > dy)
    lda.z dy
    cmp.z dx
    bcs !__b2+
    jmp __b2
  !__b2:
    // if(sx==sy)
    // Steep slope - Y is the driver - only plot one plot per X
    lda.z sx
    cmp.z sy
    beq plot1
    // e = dy/2
    lda.z dy
    lsr
    tax
  __b6:
    // y += sy
    lda.z y
    clc
    adc.z sy
    sta.z y
    // e += dx
    txa
    clc
    adc.z dx
    tax
    // if(e>dy)
    lda.z dy
    stx.z $ff
    cmp.z $ff
    bcs __b7
    // plot(x, y-sy)
    lda.z y
    sec
    sbc.z sy
    sta.z plot2_y
    // x/8
    lda.z x
    lsr
    lsr
    lsr
    // column = plot_column[x/8]
    asl
    tay
    lda plot_column,y
    sta.z plot2_column
    lda plot_column+1,y
    sta.z plot2_column+1
    // x&7
    lda #7
    and.z x
    sta.z plot2___1
    // column[y] |= plot_bit[x&7]
    ldy.z plot2_y
    lda (plot2_column),y
    ldy.z plot2___1
    ora plot_bit,y
    ldy.z plot2_y
    sta (plot2_column),y
    // x += sx
    lda.z x
    clc
    adc.z sx
    sta.z x
    // e -= dy
    txa
    sec
    sbc.z dy
    tax
  __b7:
    // while (y != y2)
    lda.z y
    cmp.z y2
    bne __b6
    // x/8
    lda.z x
    lsr
    lsr
    lsr
    // column = plot_column[x/8]
    asl
    tay
    lda plot_column,y
    sta.z plot3_column
    lda plot_column+1,y
    sta.z plot3_column+1
    // x&7
    lda #7
    and.z x
    // column[y] |= plot_bit[x&7]
    ldy.z y
    tax
    lda (plot3_column),y
    ora plot_bit,x
    sta (plot3_column),y
    // }
    rts
  plot1:
    // x/8
    lda.z x
    lsr
    lsr
    lsr
    // column = plot_column[x/8]
    asl
    tay
    lda plot_column,y
    sta.z plot1_column
    lda plot_column+1,y
    sta.z plot1_column+1
    // x&7
    lda #7
    and.z x
    // column[y] |= plot_bit[x&7]
    ldy.z y
    tax
    lda (plot1_column),y
    ora plot_bit,x
    sta (plot1_column),y
    // if(dx==0)
    lda.z dx
    cmp #0
    bne __b9
    rts
  __b9:
    // e = dy/2
    lda.z dy
    lsr
    sta.z e1
  __b10:
    // y += sy
    lda.z y
    clc
    adc.z sy
    sta.z y
    // e += dx
    lda.z e1
    clc
    adc.z dx
    sta.z e1
    // while(e<=dy)
    lda.z dy
    cmp.z e1
    bcs __b10
    // x += sx
    lda.z x
    clc
    adc.z sx
    sta.z x
    // e -= dy
    lda.z e1
    sec
    sbc.z dy
    sta.z e1
    // x/8
    lda.z x
    lsr
    lsr
    lsr
    // column = plot_column[x/8]
    asl
    tay
    lda plot_column,y
    sta.z plot4_column
    lda plot_column+1,y
    sta.z plot4_column+1
    // x&7
    lda #7
    and.z x
    // column[y] |= plot_bit[x&7]
    ldy.z y
    tax
    lda (plot4_column),y
    ora plot_bit,x
    sta (plot4_column),y
    // while (x != x2)
    lda.z x
    cmp.z x2
    bne __b10
    rts
  __b2:
    // e = dx/2
    lda.z dx
    lsr
    tax
  plot5:
    // x/8
    lda.z x
    lsr
    lsr
    lsr
    // column = plot_column[x/8]
    asl
    tay
    lda plot_column,y
    sta.z plot5_column
    lda plot_column+1,y
    sta.z plot5_column+1
    // x&7
    lda #7
    and.z x
    sta.z plot5___1
    // column[y] |= plot_bit[x&7]
    ldy.z y
    lda (plot5_column),y
    ldy.z plot5___1
    ora plot_bit,y
    ldy.z y
    sta (plot5_column),y
    // x += sx
    lda.z x
    clc
    adc.z sx
    sta.z x
    // e += dy
    txa
    clc
    adc.z dy
    tax
    // if(e>dx)
    lda.z dx
    stx.z $ff
    cmp.z $ff
    bcs __b13
    // y += sy
    tya
    clc
    adc.z sy
    sta.z y
    // e -= dx
    txa
    sec
    sbc.z dx
    tax
  __b13:
    // while (x != x2)
    lda.z x
    cmp.z x2
    bne plot5
    // x/8
    lsr
    lsr
    lsr
    // column = plot_column[x/8]
    asl
    tay
    lda plot_column,y
    sta.z plot6_column
    lda plot_column+1,y
    sta.z plot6_column+1
    // x&7
    lda #7
    and.z x
    // column[y] |= plot_bit[x&7]
    ldy.z y
    tax
    lda (plot6_column),y
    ora plot_bit,x
    sta (plot6_column),y
    rts
}
// Get the sign of a 8-bit unsigned number treated as a signed number.
// Returns unsigned -1 if the number is negative
// sgn_u8(byte register(A) u)
sgn_u8: {
    // u & 0x80
    and #$80
    // if(u & 0x80)
    cmp #0
    bne __b1
    lda #1
    rts
  __b1:
    lda #-1
    // }
    rts
}
// Get the absolute value of a u-bit unsigned number treated as a signed number.
// abs_u8(byte register(A) u)
abs_u8: {
    // u & 0x80
    ldx #$80
    axs #0
    // if(u & 0x80)
    cpx #0
    bne __b1
    rts
  __b1:
    // return -u;
    eor #$ff
    clc
    adc #1
    // }
    rts
}
// Copies the character c (an unsigned char) to the first num characters of the object pointed to by the argument str.
// memset(void* zp($1f) str, byte register(X) c, word zp($1c) num)
memset: {
    .label end = $1c
    .label dst = $1f
    .label num = $1c
    .label str = $1f
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
// Reset & start the processor clock time. The value can be read using clock().
// This uses CIA #2 Timer A+B on the C64
clock_start: {
    // CIA2->TIMER_A_CONTROL = CIA_TIMER_CONTROL_STOP | CIA_TIMER_CONTROL_CONTINUOUS | CIA_TIMER_CONTROL_A_COUNT_CYCLES
    // Setup CIA#2 timer A to count (down) CPU cycles
    lda #0
    sta CIA2+OFFSET_STRUCT_MOS6526_CIA_TIMER_A_CONTROL
    // CIA2->TIMER_B_CONTROL = CIA_TIMER_CONTROL_STOP | CIA_TIMER_CONTROL_CONTINUOUS | CIA_TIMER_CONTROL_B_COUNT_UNDERFLOW_A
    lda #CIA_TIMER_CONTROL_B_COUNT_UNDERFLOW_A
    sta CIA2+OFFSET_STRUCT_MOS6526_CIA_TIMER_B_CONTROL
    // *CIA2_TIMER_AB = 0xffffffff
    lda #<$ffffffff
    sta CIA2_TIMER_AB
    lda #>$ffffffff
    sta CIA2_TIMER_AB+1
    lda #<$ffffffff>>$10
    sta CIA2_TIMER_AB+2
    lda #>$ffffffff>>$10
    sta CIA2_TIMER_AB+3
    // CIA2->TIMER_B_CONTROL = CIA_TIMER_CONTROL_START | CIA_TIMER_CONTROL_CONTINUOUS | CIA_TIMER_CONTROL_B_COUNT_UNDERFLOW_A
    lda #CIA_TIMER_CONTROL_START|CIA_TIMER_CONTROL_B_COUNT_UNDERFLOW_A
    sta CIA2+OFFSET_STRUCT_MOS6526_CIA_TIMER_B_CONTROL
    // CIA2->TIMER_A_CONTROL = CIA_TIMER_CONTROL_START | CIA_TIMER_CONTROL_CONTINUOUS | CIA_TIMER_CONTROL_A_COUNT_CYCLES
    lda #CIA_TIMER_CONTROL_START
    sta CIA2+OFFSET_STRUCT_MOS6526_CIA_TIMER_A_CONTROL
    // }
    rts
}
// Setup raster IRQ to change charset at different lines
setup_irq: {
    // asm
    sei
    // CIA1->INTERRUPT = CIA_INTERRUPT_CLEAR
    // Disable CIA 1 Timer IRQ
    lda #CIA_INTERRUPT_CLEAR
    sta CIA1+OFFSET_STRUCT_MOS6526_CIA_INTERRUPT
    // VICII->CONTROL1 &= 0x7f
    // Set raster line to 8 pixels before the border
    lda #$7f
    and VICII+OFFSET_STRUCT_MOS6569_VICII_CONTROL1
    sta VICII+OFFSET_STRUCT_MOS6569_VICII_CONTROL1
    // VICII->RASTER = BORDER_YPOS_BOTTOM-8
    lda #BORDER_YPOS_BOTTOM-8
    sta VICII+OFFSET_STRUCT_MOS6569_VICII_RASTER
    // VICII->IRQ_ENABLE = IRQ_RASTER
    // Enable Raster Interrupt
    lda #IRQ_RASTER
    sta VICII+OFFSET_STRUCT_MOS6569_VICII_IRQ_ENABLE
    // *KERNEL_IRQ = &irq_bottom_1
    // Set the IRQ routine
    lda #<irq_bottom_1
    sta KERNEL_IRQ
    lda #>irq_bottom_1
    sta KERNEL_IRQ+1
    // asm
    cli
    // }
    rts
}
// Interrupt Routine 2
irq_bottom_2: {
    .const toD0181_return = (>(SCREEN&$3fff)*4)|(>LINE_BUFFER)/4&$f
    // VICII->BORDER_COLOR = BLACK
    // Change border color
    lda #BLACK
    sta VICII+OFFSET_STRUCT_MOS6569_VICII_BORDER_COLOR
    // kbhit()
    jsr kbhit
    // if(!kbhit())
    // Show the current canvas (unless a key is being pressed)
    cmp #0
    beq __b1
    // VICII->MEMORY = toD018(SCREEN, LINE_BUFFER)
    lda #toD0181_return
    sta VICII+OFFSET_STRUCT_MOS6569_VICII_MEMORY
  __b2:
    // canvas_show_flag = 0
    lda #0
    sta.z canvas_show_flag
    // VICII->IRQ_STATUS = IRQ_RASTER
    // Acknowledge the IRQ
    lda #IRQ_RASTER
    sta VICII+OFFSET_STRUCT_MOS6569_VICII_IRQ_STATUS
    // VICII->RASTER = BORDER_YPOS_BOTTOM-8
    // Trigger IRQ 1 at 8 pixels before the border
    lda #BORDER_YPOS_BOTTOM-8
    sta VICII+OFFSET_STRUCT_MOS6569_VICII_RASTER
    // *KERNEL_IRQ = &irq_bottom_1
    lda #<irq_bottom_1
    sta KERNEL_IRQ
    lda #>irq_bottom_1
    sta KERNEL_IRQ+1
    // }
    jmp $ea31
  __b1:
    // VICII->MEMORY = canvas_show_memory
    lda.z canvas_show_memory
    sta VICII+OFFSET_STRUCT_MOS6569_VICII_MEMORY
    jmp __b2
}
// Return true if there's a key waiting, return false if not
kbhit: {
    // CIA#1 Port A: keyboard matrix columns and joystick #2
    .label CIA1_PORT_A = $dc00
    // CIA#1 Port B: keyboard matrix rows and joystick #1.
    .label CIA1_PORT_B = $dc01
    // *CIA1_PORT_A = 0
    lda #0
    sta CIA1_PORT_A
    // ~*CIA1_PORT_B
    lda CIA1_PORT_B
    eor #$ff
    // }
    rts
}
// Interrupt Routine 1: Just above last text line.
irq_bottom_1: {
    .const toD0181_return = (>(CONSOLE&$3fff)*4)|(>PETSCII)/4&$f
    // VICII->BORDER_COLOR = DARK_GREY
    // Change border color
    lda #DARK_GREY
    sta VICII+OFFSET_STRUCT_MOS6569_VICII_BORDER_COLOR
    // VICII->MEMORY = toD018(CONSOLE, PETSCII)
    // Show the cycle counter
    lda #toD0181_return
    sta VICII+OFFSET_STRUCT_MOS6569_VICII_MEMORY
    // VICII->IRQ_STATUS = IRQ_RASTER
    // Acknowledge the IRQ
    lda #IRQ_RASTER
    sta VICII+OFFSET_STRUCT_MOS6569_VICII_IRQ_STATUS
    // VICII->RASTER = BORDER_YPOS_BOTTOM
    // Trigger IRQ 2 at bottom of text-line
    lda #BORDER_YPOS_BOTTOM
    sta VICII+OFFSET_STRUCT_MOS6569_VICII_RASTER
    // *KERNEL_IRQ = &irq_bottom_2
    lda #<irq_bottom_2
    sta KERNEL_IRQ
    lda #>irq_bottom_2
    sta KERNEL_IRQ+1
    // }
    jmp $ea81
}
  // SIN/COS tables
  .align $100
SINTAB:
.fill $200, round(63 + 63*sin(i*2*PI/$100))

  // Column offsets
  plot_column: .word LINE_BUFFER, LINE_BUFFER+1*$80, LINE_BUFFER+2*$80, LINE_BUFFER+3*$80, LINE_BUFFER+4*$80, LINE_BUFFER+5*$80, LINE_BUFFER+6*$80, LINE_BUFFER+7*$80, LINE_BUFFER+8*$80, LINE_BUFFER+9*$80, LINE_BUFFER+$a*$80, LINE_BUFFER+$b*$80, LINE_BUFFER+$c*$80, LINE_BUFFER+$d*$80, LINE_BUFFER+$e*$80, LINE_BUFFER+$f*$80
  // The bits used for plotting a pixel
  plot_bit: .byte $80, $40, $20, $10, 8, 4, 2, 1
