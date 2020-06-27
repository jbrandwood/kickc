// Tetris Game for the Commodore 64
// A sprite multiplexer covering the playfield with a black layer to allow for 3 single-pixel colors
// Commodore 64 Registers and Constants
// The MOS 6526 Complex Interface Adapter (CIA)
// http://archive.6502.org/datasheets/mos_6526_cia_recreated.pdf
.pc = $801 "Basic"
:BasicUpstart(__start)
.pc = $80d "Program"
  // Value that disables all CIA interrupts when stored to the CIA Interrupt registers
  .const CIA_INTERRUPT_CLEAR = $7f
  // The offset of the sprite pointers from the screen start address
  .const SPRITE_PTRS = $3f8
  // Bits for the VICII IRQ Status/Enable Registers
  .const IRQ_RASTER = 1
  // Mask for PROCESSOR_PORT_DDR which allows only memory configuration to be written
  .const PROCPORT_DDR_MEMORY_MASK = 7
  // RAM in 0xA000, 0xE000 I/O in 0xD000
  .const PROCPORT_RAM_IO = 5
  // The colors of the C64
  .const BLACK = 0
  // The Y-position of the first sprite row
  .const SPRITES_FIRST_YPOS = $31
  // The line of the first IRQ
  .const IRQ_RASTER_FIRST = SPRITES_FIRST_YPOS+$13
  .const OFFSET_STRUCT_MOS6526_CIA_PORT_A_DDR = 2
  .const OFFSET_STRUCT_MOS6526_CIA_INTERRUPT = $d
  .label SPRITES_XPOS = $d000
  .label SPRITES_YPOS = $d001
  .label SPRITES_COLOR = $d027
  .label SPRITES_ENABLE = $d015
  .label SPRITES_EXPAND_Y = $d017
  .label SPRITES_MC = $d01c
  .label SPRITES_EXPAND_X = $d01d
  .label RASTER = $d012
  .label VIC_CONTROL = $d011
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
  // The CIA#2: Serial bus, RS-232, VIC memory bank
  .label CIA2 = $dd00
  // CIA#1 Interrupt for reading in ASM
  .label CIA1_INTERRUPT = $dc0d
  // The vector used when the HARDWARE serves IRQ interrupts
  .label HARDWARE_IRQ = $fffe
  // Address of the first screen
  .label PLAYFIELD_SCREEN_1 = $400
  // Address of the second screen
  .label PLAYFIELD_SCREEN_2 = $2c00
  // Screen Sprite pointers on screen 1
  .label PLAYFIELD_SPRITE_PTRS_1 = PLAYFIELD_SCREEN_1+SPRITE_PTRS
  // Screen Sprite pointers on screen 2
  .label PLAYFIELD_SPRITE_PTRS_2 = PLAYFIELD_SCREEN_2+SPRITE_PTRS
  // The screen currently being showed to the user. 0x00 for screen 1 / 0x20 for screen 2.
  .label render_screen_showing = 6
  // The raster line of the next IRQ
  .label irq_raster_next = 7
  // Y-pos of the sprites on the next IRQ
  .label irq_sprite_ypos = 8
  // Index of the sprites to show on the next IRQ
  .label irq_sprite_ptr = 9
  // Counting the 10 IRQs
  .label irq_cnt = $a
  .label sin_idx = 4
__start: {
    .const __init1_toSpritePtr1_return = $ff&PLAYFIELD_SPRITES/$40
    // render_screen_showing = 0
    lda #0
    sta.z render_screen_showing
    // irq_raster_next = IRQ_RASTER_FIRST
    lda #IRQ_RASTER_FIRST
    sta.z irq_raster_next
    // irq_sprite_ypos = SPRITES_FIRST_YPOS + 21
    lda #SPRITES_FIRST_YPOS+$15
    sta.z irq_sprite_ypos
    // irq_sprite_ptr = toSpritePtr(PLAYFIELD_SPRITES) + 3
    lda #__init1_toSpritePtr1_return+3
    sta.z irq_sprite_ptr
    // irq_cnt = 0
    lda #0
    sta.z irq_cnt
    jsr main
    rts
}
// Raster Interrupt Routine - sets up the sprites covering the playfield
// Repeats 10 timers every 2 lines from line IRQ_RASTER_FIRST
// Utilizes duplicated gfx in the sprites to allow for some leeway in updating the sprite pointers
sprites_irq: {
    .const toSpritePtr1_return = $ff&PLAYFIELD_SPRITES/$40
    .label raster_sprite_gfx_modify = $b
    sta rega+1
    stx regx+1
    // asm
    //(*BG_COLOR)++;
    // Clear decimal flag (because it is used by the score algorithm)
    cld
    // ypos = irq_sprite_ypos
    // Place the sprites
    lda.z irq_sprite_ypos
    // SPRITES_YPOS[0] = ypos
    sta SPRITES_YPOS
    // SPRITES_YPOS[2] = ypos
    sta SPRITES_YPOS+2
    // SPRITES_YPOS[4] = ypos
    sta SPRITES_YPOS+4
    // SPRITES_YPOS[6] = ypos
    sta SPRITES_YPOS+6
    // irq_raster_next+1
    ldx.z irq_raster_next
    inx
    // raster_sprite_gfx_modify = irq_raster_next+1
    // Wait for the y-position before changing sprite pointers
    stx.z raster_sprite_gfx_modify
  __b8:
    // while(*RASTER<raster_sprite_gfx_modify)
    lda RASTER
    cmp.z raster_sprite_gfx_modify
    bcc __b8
    // ptr = irq_sprite_ptr
    ldx.z irq_sprite_ptr
    // if(render_screen_showing==0)
    lda.z render_screen_showing
    cmp #0
    beq __b1
    // PLAYFIELD_SPRITE_PTRS_2[0] = ptr++
    stx PLAYFIELD_SPRITE_PTRS_2
    // PLAYFIELD_SPRITE_PTRS_2[0] = ptr++;
    inx
    txa
    // PLAYFIELD_SPRITE_PTRS_2[1] = ptr
    sta PLAYFIELD_SPRITE_PTRS_2+1
    // PLAYFIELD_SPRITE_PTRS_2[2] = ptr++
    sta PLAYFIELD_SPRITE_PTRS_2+2
    // PLAYFIELD_SPRITE_PTRS_2[2] = ptr++;
    clc
    adc #1
    // PLAYFIELD_SPRITE_PTRS_2[3] = ptr
    sta PLAYFIELD_SPRITE_PTRS_2+3
  __b2:
    // ++irq_cnt;
    inc.z irq_cnt
    // if(irq_cnt==9)
    lda #9
    cmp.z irq_cnt
    beq __b3
    // if(irq_cnt==10)
    lda #$a
    cmp.z irq_cnt
    beq __b4
    // irq_raster_next += 20
    lax.z irq_raster_next
    axs #-[$14]
    stx.z irq_raster_next
    // irq_sprite_ypos += 21
    lax.z irq_sprite_ypos
    axs #-[$15]
    stx.z irq_sprite_ypos
    // irq_sprite_ptr += 3
    lax.z irq_sprite_ptr
    axs #-[3]
    stx.z irq_sprite_ptr
  __b5:
    // *RASTER = irq_raster_next
    // Setup next interrupt
    lda.z irq_raster_next
    sta RASTER
    // *IRQ_STATUS = IRQ_RASTER
    // Acknowledge the IRQ and setup the next one
    lda #IRQ_RASTER
    sta IRQ_STATUS
    // }
  rega:
    lda #00
  regx:
    ldx #00
    rti
  __b4:
    // irq_cnt = 0
    lda #0
    sta.z irq_cnt
    // irq_raster_next = IRQ_RASTER_FIRST
    lda #IRQ_RASTER_FIRST
    sta.z irq_raster_next
    // irq_sprite_ypos += 21
    lax.z irq_sprite_ypos
    axs #-[$15]
    stx.z irq_sprite_ypos
    // irq_sprite_ptr += 3
    lax.z irq_sprite_ptr
    axs #-[3]
    stx.z irq_sprite_ptr
    jmp __b5
  __b3:
    // irq_raster_next += 21
    lax.z irq_raster_next
    axs #-[$15]
    stx.z irq_raster_next
    // irq_sprite_ypos = SPRITES_FIRST_YPOS
    lda #SPRITES_FIRST_YPOS
    sta.z irq_sprite_ypos
    // irq_sprite_ptr = toSpritePtr(PLAYFIELD_SPRITES)
    lda #toSpritePtr1_return
    sta.z irq_sprite_ptr
    jmp __b5
  __b1:
    // PLAYFIELD_SPRITE_PTRS_1[0] = ptr++
    stx PLAYFIELD_SPRITE_PTRS_1
    // PLAYFIELD_SPRITE_PTRS_1[0] = ptr++;
    inx
    // PLAYFIELD_SPRITE_PTRS_1[1] = ptr
    stx PLAYFIELD_SPRITE_PTRS_1+1
    // PLAYFIELD_SPRITE_PTRS_1[2] = ptr++
    stx PLAYFIELD_SPRITE_PTRS_1+2
    // PLAYFIELD_SPRITE_PTRS_1[2] = ptr++;
    inx
    txa
    // PLAYFIELD_SPRITE_PTRS_1[3] = ptr
    sta PLAYFIELD_SPRITE_PTRS_1+3
    jmp __b2
}
main: {
    .const toSpritePtr1_return = $ff&SIN_SPRITE/$40
    .const vicSelectGfxBank1_toDd001_return = 3
    .const toD0181_return = (>(PLAYFIELD_SCREEN_1&$3fff)*4)|(>PLAYFIELD_CHARSET)/4&$f
    .label xpos = 2
    .label ypos = 3
    // CIA2->PORT_A_DDR = %00000011
    lda #3
    sta CIA2+OFFSET_STRUCT_MOS6526_CIA_PORT_A_DDR
    // CIA2->PORT_A = toDd00(gfx)
    lda #vicSelectGfxBank1_toDd001_return
    sta CIA2
    // *D018 = toD018(PLAYFIELD_SCREEN_1, PLAYFIELD_CHARSET)
    lda #toD0181_return
    sta D018
    // sprites_init()
    jsr sprites_init
    // *SPRITES_ENABLE = 0xff
    lda #$ff
    sta SPRITES_ENABLE
    lda #$32
    sta.z ypos
    lda #$18
    sta.z xpos
    ldy #4
  __b1:
    // s2 = s*2
    tya
    asl
    tax
    // SPRITES_XPOS[s2] = xpos
    lda.z xpos
    sta SPRITES_XPOS,x
    // SPRITES_YPOS[s2] = ypos
    lda.z ypos
    sta SPRITES_YPOS,x
    // s-3
    tya
    sec
    sbc #3
    // SPRITES_COLOR[s] = s-3
    sta SPRITES_COLOR,y
    // PLAYFIELD_SPRITE_PTRS_1[s] = toSpritePtr(SIN_SPRITE)
    lda #toSpritePtr1_return
    sta PLAYFIELD_SPRITE_PTRS_1,y
    // xpos +=  24
    lax.z xpos
    axs #-[$18]
    stx.z xpos
    // ypos +=  24
    lax.z ypos
    axs #-[$18]
    stx.z ypos
    // for(char s:4..7)
    iny
    cpy #8
    bne __b1
    // sprites_irq_init()
    jsr sprites_irq_init
    // loop()
    jsr loop
    // }
    rts
}
// Setup the sprites
sprites_init: {
    .label xpos = 5
    // *SPRITES_ENABLE = %00001111
    lda #$f
    sta SPRITES_ENABLE
    // *SPRITES_MC = 0
    lda #0
    sta SPRITES_MC
    // *SPRITES_EXPAND_Y = *SPRITES_MC = 0
    sta SPRITES_EXPAND_Y
    // *SPRITES_EXPAND_X = *SPRITES_EXPAND_Y = *SPRITES_MC = 0
    sta SPRITES_EXPAND_X
    lda #$18+$f*8
    sta.z xpos
    ldy #0
  __b1:
    // s2 = s*2
    tya
    asl
    tax
    // SPRITES_XPOS[s2] = xpos
    lda.z xpos
    sta SPRITES_XPOS,x
    // SPRITES_COLOR[s] = BLACK
    lda #BLACK
    sta SPRITES_COLOR,y
    // xpos = xpos+24
    lax.z xpos
    axs #-[$18]
    stx.z xpos
    // for(char s:0..3)
    iny
    cpy #4
    bne __b1
    // }
    rts
}
// Setup the IRQ
sprites_irq_init: {
    // asm
    sei
    // *IRQ_STATUS = IRQ_RASTER
    // Acknowledge any IRQ and setup the next one
    lda #IRQ_RASTER
    sta IRQ_STATUS
    // asm
    lda CIA1_INTERRUPT
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
    // *VIC_CONTROL &=0x7f
    // Set raster line
    lda #$7f
    and VIC_CONTROL
    sta VIC_CONTROL
    // *RASTER = IRQ_RASTER_FIRST
    lda #IRQ_RASTER_FIRST
    sta RASTER
    // *IRQ_ENABLE = IRQ_RASTER
    // Enable Raster Interrupt
    lda #IRQ_RASTER
    sta IRQ_ENABLE
    // *HARDWARE_IRQ = &sprites_irq
    // Set the IRQ routine
    lda #<sprites_irq
    sta HARDWARE_IRQ
    lda #>sprites_irq
    sta HARDWARE_IRQ+1
    // asm
    cli
    // }
    rts
}
loop: {
    .label s = 5
    lda #0
    sta.z sin_idx
  __b2:
    // while (*RASTER!=0xff)
    lda #$ff
    cmp RASTER
    bne __b2
    // idx = sin_idx
    ldx.z sin_idx
    lda #4
    sta.z s
  __b4:
    // s*2
    lda.z s
    asl
    // SPRITES_YPOS[s*2] = SIN[idx]
    tay
    lda SIN,x
    sta SPRITES_YPOS,y
    // idx += 10
    txa
    axs #-[$a]
    // for(char s:4..7)
    inc.z s
    lda #8
    cmp.z s
    bne __b4
    // sin_idx++;
    inc.z sin_idx
    jmp __b2
}
SIN:
.var AMPL = 200-21
    .for(var i=0; i<256; i++) {
  	  .byte 51+AMPL/2+sin(toRadians([i*360]/256))*AMPL/2
    }

.pc = $3000 "PLAYFIELD_SPRITES"
// Sprites covering the playfield
PLAYFIELD_SPRITES:
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

.pc = $2800 "PLAYFIELD_CHARSET"
// Address of the charset
PLAYFIELD_CHARSET:
.fill 8,$00 // Place a filled char at the start of the charset
    .import binary "playfield-screen.imap"

.pc = $3800 "SIN_SPRITE"
SIN_SPRITE:
.fill $40, $ff

