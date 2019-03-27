.pc = $801 "Basic"
:BasicUpstart(bbegin)
.pc = $80d "Program"
  // Processor port data direction register
  .label PROCPORT_DDR = 0
  // Mask for PROCESSOR_PORT_DDR which allows only memory configuration to be written
  .const PROCPORT_DDR_MEMORY_MASK = 7
  // Processor Port Register controlling RAM/ROM configuration and the datasette
  .label PROCPORT = 1
  // RAM in $A000, $E000 I/O in $D000
  .const PROCPORT_RAM_IO = $35
  // The offset of the sprite pointers from the screen start address
  .const SPRITE_PTRS = $3f8
  .label SPRITES_XPOS = $d000
  .label SPRITES_YPOS = $d001
  .label RASTER = $d012
  .label SPRITES_ENABLE = $d015
  .label SPRITES_EXPAND_Y = $d017
  .label SPRITES_MC = $d01c
  .label SPRITES_EXPAND_X = $d01d
  .label SPRITES_COLS = $d027
  .label VIC_CONTROL = $d011
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
  // CIA#2 Port A: Serial bus, RS-232, VIC memory bank
  .label CIA2_PORT_A = $dd00
  // CIA #2 Port A data direction register.
  .label CIA2_PORT_A_DDR = $dd02
  // The vector used when the HARDWARE serves IRQ interrupts
  .label HARDWARE_IRQ = $fffe
  // The colors of the C64
  .const BLACK = 0
  // Address of the first screen
  .label PLAYFIELD_SCREEN_1 = $400
  // Address of the second screen
  .label PLAYFIELD_SCREEN_2 = $2c00
  // Address of the sprites covering the playfield
  .label PLAYFIELD_SPRITES = $2000
  // Address of the charset
  .label PLAYFIELD_CHARSET = $2800
  // The size of the playfield
  .const PLAYFIELD_LINES = $16
  .const PLAYFIELD_COLS = $a
  // The Y-position of the first sprite row
  .const SPRITES_FIRST_YPOS = $31
  .label SIN = $1400
  .label SIN_SPRITE = $2800
  // Screen Sprite pointers on screen 1
  .label PLAYFIELD_SPRITE_PTRS_1 = PLAYFIELD_SCREEN_1+SPRITE_PTRS
  // Screen Sprite pointers on screen 2
  .label PLAYFIELD_SPRITE_PTRS_2 = PLAYFIELD_SCREEN_2+SPRITE_PTRS
  // The line of the first IRQ
  .const IRQ_RASTER_FIRST = SPRITES_FIRST_YPOS+$13
  .const toSpritePtr1_return = PLAYFIELD_SPRITES>>6
  .label render_screen_showing = 5
  .label irq_raster_next = 4
  .label irq_sprite_ypos = 6
  .label irq_sprite_ptr = 7
  .label irq_cnt = 8
  .label sin_idx = 2
bbegin:
  // The screen currently being showed to the user. $00 for screen 1 / $40 for screen 2.
  lda #0
  sta render_screen_showing
  // The raster line of the next IRQ
  lda #IRQ_RASTER_FIRST
  sta irq_raster_next
  // Y-pos of the sprites on the next IRQ
  lda #SPRITES_FIRST_YPOS+$15
  sta irq_sprite_ypos
  // Index of the sprites to show on the next IRQ
  lda #toSpritePtr1_return+3
  sta irq_sprite_ptr
  // Counting the 10 IRQs
  lda #0
  sta irq_cnt
  jsr main
main: {
    .const toSpritePtr2_return = SIN_SPRITE>>6
    .const vicSelectGfxBank1_toDd001_return = 3^(>PLAYFIELD_SCREEN_1)>>6
    .const toD0181_return = (>(PLAYFIELD_SCREEN_1&$3fff)<<2)|(>PLAYFIELD_CHARSET)>>2&$f
    .label xpos = 2
    .label ypos = 3
    lda #3
    sta CIA2_PORT_A_DDR
    lda #vicSelectGfxBank1_toDd001_return
    sta CIA2_PORT_A
    lda #toD0181_return
    sta D018
    jsr sprites_init
    lda #$ff
    sta SPRITES_ENABLE
    lda #$32
    sta ypos
    lda #$18
    sta xpos
    ldy #4
  b1:
    tya
    asl
    tax
    lda xpos
    sta SPRITES_XPOS,x
    lda ypos
    sta SPRITES_YPOS,x
    tya
    sec
    sbc #3
    sta SPRITES_COLS,y
    lda #toSpritePtr2_return
    sta PLAYFIELD_SPRITE_PTRS_1,y
    lax xpos
    axs #-[$18]
    stx xpos
    lax ypos
    axs #-[$18]
    stx ypos
    iny
    cpy #8
    bne b1
    jsr sprites_irq_init
    jsr loop
    rts
}
loop: {
    .label s = 3
    lda #0
    sta sin_idx
  b4:
    lda #$ff
    cmp RASTER
    bne b4
    ldx sin_idx
    lda #4
    sta s
  b5:
    lda s
    asl
    tay
    lda SIN,x
    sta SPRITES_YPOS,y
    txa
    axs #-[$a]
    inc s
    lda #8
    cmp s
    bne b5
    inc sin_idx
    jmp b4
}
// Setup the IRQ
sprites_irq_init: {
    sei
    // Acknowledge any IRQ and setup the next one
    lda #IRQ_RASTER
    sta IRQ_STATUS
    lda CIA1_INTERRUPT
    // Disable kernal & basic
    lda #PROCPORT_DDR_MEMORY_MASK
    sta PROCPORT_DDR
    lda #PROCPORT_RAM_IO
    sta PROCPORT
    // Disable CIA 1 Timer IRQ
    lda #CIA_INTERRUPT_CLEAR
    sta CIA1_INTERRUPT
    // Set raster line
    lda #$7f
    and VIC_CONTROL
    sta VIC_CONTROL
    lda #IRQ_RASTER_FIRST
    sta RASTER
    // Enable Raster Interrupt
    lda #IRQ_RASTER
    sta IRQ_ENABLE
    // Set the IRQ routine
    lda #<sprites_irq
    sta HARDWARE_IRQ
    lda #>sprites_irq
    sta HARDWARE_IRQ+1
    cli
    rts
}
// Setup the sprites
sprites_init: {
    .label xpos = 2
    lda #$f
    sta SPRITES_ENABLE
    lda #0
    sta SPRITES_MC
    sta SPRITES_EXPAND_Y
    sta SPRITES_EXPAND_X
    lda #$18+$f*8
    sta xpos
    ldy #0
  b1:
    tya
    asl
    tax
    lda xpos
    sta SPRITES_XPOS,x
    lda #BLACK
    sta SPRITES_COLS,y
    lax xpos
    axs #-[$18]
    stx xpos
    iny
    cpy #4
    bne b1
    rts
}
// Raster Interrupt Routine - sets up the sprites covering the playfield
// Repeats 10 timers every 2 lines from line IRQ_RASTER_FIRST
// Utilizes duplicated gfx in the sprites to allow for some leeway in updating the sprite pointers
sprites_irq: {
    .const toSpritePtr2_return = PLAYFIELD_SPRITES>>6
    .label raster_sprite_gfx_modify = 9
    sta rega+1
    stx regx+1
    //(*BGCOL)++;
    // Clear decimal flag (because it is used by the score algorithm)
    cld
    // Place the sprites
    lda irq_sprite_ypos
    sta SPRITES_YPOS
    sta SPRITES_YPOS+2
    sta SPRITES_YPOS+4
    sta SPRITES_YPOS+6
    ldx irq_raster_next
    inx
    // Wait for the y-position before changing sprite pointers
    stx raster_sprite_gfx_modify
  b1:
    lda RASTER
    cmp raster_sprite_gfx_modify
    bcc b1
    ldx irq_sprite_ptr
    lda render_screen_showing
    cmp #0
    beq b2
    stx PLAYFIELD_SPRITE_PTRS_2
    inx
    txa
    sta PLAYFIELD_SPRITE_PTRS_2+1
    sta PLAYFIELD_SPRITE_PTRS_2+2
    clc
    adc #1
    sta PLAYFIELD_SPRITE_PTRS_2+3
  b3:
    inc irq_cnt
    lda #9
    cmp irq_cnt
    beq b4
    lda #$a
    cmp irq_cnt
    beq b5
    lax irq_raster_next
    axs #-[$14]
    stx irq_raster_next
    lax irq_sprite_ypos
    axs #-[$15]
    stx irq_sprite_ypos
    lax irq_sprite_ptr
    axs #-[3]
    stx irq_sprite_ptr
  b7:
    // Setup next interrupt
    lda irq_raster_next
    sta RASTER
    // Acknowledge the IRQ and setup the next one
    lda #IRQ_RASTER
    sta IRQ_STATUS
  rega:
    lda #00
  regx:
    ldx #00
    rti
  b5:
    lda #0
    sta irq_cnt
    lda #IRQ_RASTER_FIRST
    sta irq_raster_next
    lax irq_sprite_ypos
    axs #-[$15]
    stx irq_sprite_ypos
    lax irq_sprite_ptr
    axs #-[3]
    stx irq_sprite_ptr
    jmp b7
  b4:
    lax irq_raster_next
    axs #-[$15]
    stx irq_raster_next
    lda #SPRITES_FIRST_YPOS
    sta irq_sprite_ypos
    lda #toSpritePtr2_return
    sta irq_sprite_ptr
    jmp b7
  b2:
    stx PLAYFIELD_SPRITE_PTRS_1
    inx
    stx PLAYFIELD_SPRITE_PTRS_1+1
    stx PLAYFIELD_SPRITE_PTRS_1+2
    inx
    txa
    sta PLAYFIELD_SPRITE_PTRS_1+3
    jmp b3
}
.pc = PLAYFIELD_SPRITES "PLAYFIELD_SPRITES"
  .var sprites = LoadPicture("playfield-sprites.png", List().add($010101, $000000))
	// Put the sprites into memory 
	.for(var sy=0;sy<10;sy++) {
	    .var sprite_gfx_y = sy*20
		.for(var sx=0;sx<3;sx++) {
	    	.for (var y=0;y<21; y++) {
	    	    .var gfx_y =  sprite_gfx_y + mod(2100+y-sprite_gfx_y,21)
		    	.for (var c=0; c<3; c++) {
	            	.byte sprites.getSinglecolorByte(sx*3+c,gfx_y)
	            }
	        }
	    	.byte 0
	  	}
	}

.pc = SIN "SIN"
  .var AMPL = 200-21
    .for(var i=0; i<256; i++) {
  	  .byte 51+AMPL/2+sin(toRadians([i*360]/256))*AMPL/2
    }

.pc = SIN_SPRITE "SIN_SPRITE"
  .fill $40, $ff

