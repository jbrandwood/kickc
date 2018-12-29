.pc = $801 "Basic"
:BasicUpstart(bbegin)
.pc = $80d "Program"
  .label PROCPORT_DDR = 0
  .const PROCPORT_DDR_MEMORY_MASK = 7
  .label PROCPORT = 1
  .const PROCPORT_RAM_IO = $35
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
  .label IRQ_STATUS = $d019
  .label IRQ_ENABLE = $d01a
  .const IRQ_RASTER = 1
  .label CIA1_INTERRUPT = $dc0d
  .const CIA_INTERRUPT_CLEAR = $7f
  .label CIA2_PORT_A = $dd00
  .label CIA2_PORT_A_DDR = $dd02
  .label HARDWARE_IRQ = $fffe
  .const BLACK = 0
  .label PLAYFIELD_SCREEN_1 = $400
  .label PLAYFIELD_SCREEN_2 = $2c00
  .label PLAYFIELD_SPRITES = $2000
  .label PLAYFIELD_CHARSET = $2800
  .const PLAYFIELD_LINES = $16
  .const PLAYFIELD_COLS = $a
  .const IRQ_RASTER_FIRST = $31
  .label PLAYFIELD_SPRITE_PTRS_1 = PLAYFIELD_SCREEN_1+SPRITE_PTRS
  .label PLAYFIELD_SPRITE_PTRS_2 = PLAYFIELD_SCREEN_2+SPRITE_PTRS
  .const toSpritePtr1_return = PLAYFIELD_SPRITES>>6
  .label render_screen_showing = 4
  .label irq_raster_next = 3
  .label irq_sprite_ypos = 5
  .label irq_sprite_ptr = 6
  .label irq_cnt = 7
bbegin:
  lda #0
  sta render_screen_showing
  lda #IRQ_RASTER_FIRST
  sta irq_raster_next
  lda #$32
  sta irq_sprite_ypos
  lda #toSpritePtr1_return
  sta irq_sprite_ptr
  lda #0
  sta irq_cnt
  jsr main
main: {
    .const vicSelectGfxBank1_toDd001_return = 3^(>PLAYFIELD_SCREEN_1)>>6
    .const toD0181_return = (>(PLAYFIELD_SCREEN_1&$3fff)<<2)|(>PLAYFIELD_CHARSET)>>2&$f
    lda #3
    sta CIA2_PORT_A_DDR
    lda #vicSelectGfxBank1_toDd001_return
    sta CIA2_PORT_A
    lda #toD0181_return
    sta D018
    jsr sprites_init
    jsr sprites_irq_init
  b2:
    inc PLAYFIELD_SCREEN_1
    jmp b2
}
sprites_irq_init: {
    sei
    lda #IRQ_RASTER
    sta IRQ_STATUS
    lda CIA1_INTERRUPT
    lda #PROCPORT_DDR_MEMORY_MASK
    sta PROCPORT_DDR
    lda #PROCPORT_RAM_IO
    sta PROCPORT
    lda #CIA_INTERRUPT_CLEAR
    sta CIA1_INTERRUPT
    lda VIC_CONTROL
    and #$7f
    sta VIC_CONTROL
    lda #IRQ_RASTER_FIRST
    sta RASTER
    lda #IRQ_RASTER
    sta IRQ_ENABLE
    lda #<sprites_irq
    sta HARDWARE_IRQ
    lda #>sprites_irq
    sta HARDWARE_IRQ+1
    cli
    rts
}
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
    ldx #0
  b1:
    txa
    asl
    tay
    lda xpos
    sta SPRITES_XPOS,y
    lda #BLACK
    sta SPRITES_COLS,x
    lda #$18
    clc
    adc xpos
    sta xpos
    inx
    cpx #4
    bne b1
    rts
}
sprites_irq: {
    .const toSpritePtr2_return = PLAYFIELD_SPRITES>>6
    sta rega+1
    stx regx+1
    lda irq_sprite_ypos
    sta SPRITES_YPOS
    sta SPRITES_YPOS+2
    sta SPRITES_YPOS+4
    sta SPRITES_YPOS+6
  b1:
    lda RASTER
    cmp irq_sprite_ypos
    bcc b1
    ldx irq_sprite_ptr
    lda render_screen_showing
    cmp #0
    beq b2
    stx PLAYFIELD_SPRITE_PTRS_2
    inx
    stx PLAYFIELD_SPRITE_PTRS_2+1
    stx PLAYFIELD_SPRITE_PTRS_2+2
    inx
    stx PLAYFIELD_SPRITE_PTRS_2+3
  b3:
    inc irq_cnt
    lda irq_cnt
    cmp #$a
    beq b4
    lda #$15
    clc
    adc irq_raster_next
    sta irq_raster_next
    lda #$15
    clc
    adc irq_sprite_ypos
    sta irq_sprite_ypos
    lda #3
    clc
    adc irq_sprite_ptr
    sta irq_sprite_ptr
  b5:
    ldx irq_raster_next
    txa
    and #7
    cmp #3
    bne b6
    dex
  b6:
    stx RASTER
    lda #IRQ_RASTER
    sta IRQ_STATUS
  rega:
    lda #00
  regx:
    ldx #00
    rti
  b4:
    lda #0
    sta irq_cnt
    lda #IRQ_RASTER_FIRST
    sta irq_raster_next
    lda #$32
    sta irq_sprite_ypos
    lda #toSpritePtr2_return
    sta irq_sprite_ptr
    jmp b5
  b2:
    stx PLAYFIELD_SPRITE_PTRS_1
    txa
    clc
    adc #1
    sta PLAYFIELD_SPRITE_PTRS_1+1
    sta PLAYFIELD_SPRITE_PTRS_1+2
    clc
    adc #1
    sta PLAYFIELD_SPRITE_PTRS_1+3
    jmp b3
}
.pc = PLAYFIELD_SPRITES "PLAYFIELD_SPRITES"
  .var sprites = LoadPicture("playfield-sprites.png", List().add($010101, $000000))
	.for(var sy=0;sy<10;sy++) {
		.for(var sx=0;sx<3;sx++) {
	    	.for (var y=0;y<21; y++) {
		    	.for (var c=0; c<3; c++) {
	            	.byte sprites.getSinglecolorByte(sx*3+c,sy*21+y)
	            }
	        }
	    	.byte 0
	  	}
	}

