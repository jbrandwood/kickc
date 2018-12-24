.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .const SPRITE_PTRS = $3f8
  .label SPRITES_XPOS = $d000
  .label SPRITES_YPOS = $d001
  .label RASTER = $d012
  .label SPRITES_ENABLE = $d015
  .label SPRITES_EXPAND_Y = $d017
  .label SPRITES_MC = $d01c
  .label SPRITES_EXPAND_X = $d01d
  .label BORDERCOL = $d020
  .label BGCOL = $d021
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
  .label KERNEL_IRQ = $314
  .const BLACK = 0
  .const WHITE = 1
  .const BLUE = 6
  .label PLAYFIELD_SPRITES = $2000
  .label PLAYFIELD_CHARSET = $1000
  .label PLAYFIELD_SCREEN = $400
  .const IRQ_RASTER_FIRST = $30
  .label irq_raster_next = 2
  .label irq_cnt = 2
  .label irq_sprite_ypos = 2
  lda #IRQ_RASTER_FIRST
  sta irq_raster_next
  lda #0
  sta irq_cnt
  lda #$32
  sta irq_sprite_ypos
  jsr main
main: {
    jsr init_sprites
    jsr init_irq
    rts
}
init_irq: {
    sei
    lda #CIA_INTERRUPT_CLEAR
    sta CIA1_INTERRUPT
    lda VIC_CONTROL
    and #$7f
    sta VIC_CONTROL
    lda #IRQ_RASTER_FIRST
    sta RASTER
    lda #IRQ_RASTER
    sta IRQ_ENABLE
    lda #<irq
    sta KERNEL_IRQ
    lda #>irq
    sta KERNEL_IRQ+1
    cli
    rts
}
init_sprites: {
    .const ypos = $32
    .label sprites_ptr = PLAYFIELD_SCREEN+SPRITE_PTRS
    .const toSpritePtr1_return = PLAYFIELD_SPRITES>>6
    .const vicSelectGfxBank1_toDd001_return = 3^(>PLAYFIELD_SCREEN)>>6
    .const toD0181_return = (>(PLAYFIELD_SCREEN&$3fff)<<2)|(>PLAYFIELD_CHARSET)>>2&$f
    .label xpos = 2
    .label ptr = 3
    lda #3
    sta CIA2_PORT_A_DDR
    lda #vicSelectGfxBank1_toDd001_return
    sta CIA2_PORT_A
    lda #toD0181_return
    sta D018
    lda #$f
    sta SPRITES_ENABLE
    lda #0
    sta SPRITES_MC
    sta SPRITES_EXPAND_Y
    sta SPRITES_EXPAND_X
    lda #toSpritePtr1_return
    sta ptr
    lda #$18+$e*8
    sta xpos
    ldy #0
  b1:
    tya
    asl
    tax
    lda xpos
    sta SPRITES_XPOS,x
    lda #ypos
    sta SPRITES_YPOS,x
    lda #BLACK
    sta SPRITES_COLS,y
    lda ptr
    sta sprites_ptr,y
    lda #$18
    clc
    adc xpos
    sta xpos
    inc ptr
    iny
    cpy #4
    bne b1
    rts
}
irq: {
    lda #WHITE
    sta BGCOL
    sta BORDERCOL
    lda irq_sprite_ypos
    sta SPRITES_YPOS
    lda irq_sprite_ypos
    sta SPRITES_YPOS+2
    lda irq_sprite_ypos
    sta SPRITES_YPOS+4
    lda irq_sprite_ypos
    sta SPRITES_YPOS+6
    inc irq_cnt
    lda irq_cnt
    cmp #$a
    beq b1
    lda #$15
    clc
    adc irq_raster_next
    sta irq_raster_next
    lda #$15
    clc
    adc irq_sprite_ypos
    sta irq_sprite_ypos
  b2:
    lda irq_raster_next
    sta RASTER
    lda #IRQ_RASTER
    sta IRQ_STATUS
    lda #BLACK
    sta BORDERCOL
    lda #BLUE
    sta BGCOL
    jmp $ea81
  b1:
    lda #0
    sta irq_cnt
    lda #IRQ_RASTER_FIRST
    sta irq_raster_next
    lda #$32
    sta irq_sprite_ypos
    jmp b2
}
.pc = PLAYFIELD_SPRITES "Inline"
  .var sprites = LoadPicture("nes-playfield.png", List().add($010101, $000000))
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

