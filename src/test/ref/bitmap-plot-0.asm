// Tests the simple bitmap plotter - and counts plots per frame in an IRQ
// Plots simple plots
// Commodore 64 Registers and Constants
// The MOS 6526 Complex Interface Adapter (CIA)
// http://archive.6502.org/datasheets/mos_6526_cia_recreated.pdf
.pc = $801 "Basic"
:BasicUpstart(__start)
.pc = $80d "Program"
  // Value that disables all CIA interrupts when stored to the CIA Interrupt registers
  .const CIA_INTERRUPT_CLEAR = $7f
  .const VIC_BMM = $20
  .const VIC_DEN = $10
  .const VIC_RSEL = 8
  // Bits for the VICII IRQ Status/Enable Registers
  .const IRQ_RASTER = 1
  // Mask for PROCESSOR_PORT_DDR which allows only memory configuration to be written
  .const PROCPORT_DDR_MEMORY_MASK = 7
  // RAM in 0xA000, 0xE000 I/O in 0xD000
  .const PROCPORT_RAM_IO = 5
  // The colors of the C64
  .const BLACK = 0
  .const WHITE = 1
  .const OFFSET_STRUCT_MOS6526_CIA_INTERRUPT = $d
  .label RASTER = $d012
  .label BG_COLOR = $d021
  .label VIC_CONTROL = $d011
  .label D011 = $d011
  .label D018 = $d018
  // VIC II IRQ Status Register
  .label IRQ_STATUS = $d019
  // VIC II IRQ Enable Register
  .label IRQ_ENABLE = $d01a
  // Processor port data direction register
  .label PROCPORT_DDR = 0
  // Processor Port Register controlling RAM/ROM configuration and the datasette
  .label PROCPORT = 1
  // The CIA#1: keyboard matrix, joystick #1/#2
  .label CIA1 = $dc00
  // The vector used when the HARDWARE serves IRQ interrupts
  .label HARDWARE_IRQ = $fffe
  .label BITMAP = $2000
  .label SCREEN = $400
  // Counts frames - updated by the IRQ
  .label frame_cnt = 8
__start: {
    // frame_cnt = 1
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
    lda #0
    cmp.z frame_cnt
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
    lda #00
    rti
}
main: {
    .const toD0181_return = (>(SCREEN&$3fff)*4)|(>BITMAP)/4&$f
    .label x = 2
    .label y = 4
    .label vx = 5
    .label vy = 7
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
    lda #1
    sta.z vy
    sta.z vx
    lda #>1
    sta.z vx+1
    sta.z y
    sta.z x
    sta.z x+1
  __b2:
    // bitmap_plot(x, y)
    ldx.z y
    jsr bitmap_plot
    // x += vx
    lda.z x
    clc
    adc.z vx
    sta.z x
    lda.z x+1
    adc.z vx+1
    sta.z x+1
    // y += vy
    lda.z y
    clc
    adc.z vy
    sta.z y
    // if(x==319 || x==0)
    lda.z x
    cmp #<$13f
    bne !+
    lda.z x+1
    cmp #>$13f
    beq __b5
  !:
    lda.z x
    ora.z x+1
    bne __b3
  __b5:
    // vx = -vx
    sec
    lda #0
    sbc.z vx
    sta.z vx
    lda #0
    sbc.z vx+1
    sta.z vx+1
  __b3:
    // if(y==199 || y==0)
    lda #$c7
    cmp.z y
    beq __b6
    lda.z y
    cmp #0
    bne __b4
  __b6:
    // vy = -vy
    lda.z vy
    eor #$ff
    clc
    adc #1
    sta.z vy
  __b4:
    // plots_per_frame[frame_cnt]++;
    ldx.z frame_cnt
    inc plots_per_frame,x
    jmp __b2
}
// Initialize bitmap plotting tables
bitmap_init: {
    .label __7 = 9
    .label yoffs = $c
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
// Plot a single dot in the bitmap
// bitmap_plot(word zp(2) x, byte register(X) y)
bitmap_plot: {
    .label __0 = $c
    .label plotter = $a
    .label x = 2
    // plotter = (char*) { bitmap_plot_yhi[y], bitmap_plot_ylo[y] }
    lda bitmap_plot_yhi,x
    sta.z plotter+1
    lda bitmap_plot_ylo,x
    sta.z plotter
    // x & $fff8
    lda.z x
    and #<$fff8
    sta.z __0
    lda.z x+1
    and #>$fff8
    sta.z __0+1
    // plotter += ( x & $fff8 )
    lda.z plotter
    clc
    adc.z __0
    sta.z plotter
    lda.z plotter+1
    adc.z __0+1
    sta.z plotter+1
    // <x
    ldx.z x
    // *plotter |= bitmap_plot_bit[<x]
    lda bitmap_plot_bit,x
    ldy #0
    ora (plotter),y
    sta (plotter),y
    // }
    rts
}
// Copies the character c (an unsigned char) to the first num characters of the object pointed to by the argument str.
// memset(void* zp($a) str, byte register(X) c, word zp($c) num)
memset: {
    .label end = $c
    .label dst = $a
    .label num = $c
    .label str = $a
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
  // Tables for the plotter - initialized by calling bitmap_init();
  bitmap_plot_ylo: .fill $100, 0
  bitmap_plot_yhi: .fill $100, 0
  bitmap_plot_bit: .fill $100, 0
  plots_per_frame: .fill $100, 0
