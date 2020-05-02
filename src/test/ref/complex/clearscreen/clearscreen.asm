// Clears start screen throwing around the letters (by turning them into sprites)
.pc = $801 "Basic"
:BasicUpstart(__bbegin)
.pc = $80d "Program"
  // The number of iterations performed during 16-bit CORDIC atan2 calculation
  .const CORDIC_ITERATIONS_16 = $f
  // Value that disables all CIA interrupts when stored to the CIA Interrupt registers
  .const CIA_INTERRUPT_CLEAR = $7f
  // Positions of the border (in sprite positions)
  .const BORDER_XPOS_LEFT = $18
  .const BORDER_XPOS_RIGHT = $158
  .const BORDER_YPOS_TOP = $32
  .const BORDER_YPOS_BOTTOM = $fa
  // The offset of the sprite pointers from the screen start address
  .const SPRITE_PTRS = $3f8
  // Bits for the VICII IRQ Status/Enable Registers
  .const IRQ_RASTER = 1
  // Mask for PROCESSOR_PORT_DDR which allows only memory configuration to be written
  .const PROCPORT_DDR_MEMORY_MASK = 7
  // RAM in 0xA000, 0xE000 I/O in 0xD000
  .const PROCPORT_RAM_IO = 5
  // RAM in 0xA000, 0xE000 CHAR ROM in 0xD000
  .const PROCPORT_RAM_CHARROM = 1
  .const LIGHT_BLUE = $e
  // Max number of chars processed at once
  .const NUM_PROCESSING = 8
  // Distance value meaning not found
  .const NOT_FOUND = $ff
  .const STATUS_FREE = 0
  .const STATUS_NEW = 1
  .const STATUS_PROCESSING = 2
  .const XPOS_LEFTMOST = BORDER_XPOS_LEFT-8<<4
  .const XPOS_RIGHTMOST = BORDER_XPOS_RIGHT<<4
  .const YPOS_TOPMOST = BORDER_YPOS_TOP-8<<4
  .const YPOS_BOTTOMMOST = BORDER_YPOS_BOTTOM<<4
  .const RASTER_IRQ_TOP = $30
  .const RASTER_IRQ_MIDDLE = $ff
  .const SIZEOF_STRUCT_PROCESSINGSPRITE = $e
  .const OFFSET_STRUCT_PROCESSINGSPRITE_Y = 2
  .const OFFSET_STRUCT_PROCESSINGSPRITE_VX = 4
  .const OFFSET_STRUCT_PROCESSINGSPRITE_VY = 6
  .const OFFSET_STRUCT_PROCESSINGSPRITE_ID = 8
  .const OFFSET_STRUCT_PROCESSINGSPRITE_PTR = 9
  .const OFFSET_STRUCT_PROCESSINGSPRITE_COL = $a
  .const OFFSET_STRUCT_PROCESSINGSPRITE_STATUS = $b
  .const OFFSET_STRUCT_PROCESSINGSPRITE_SCREENPTR = $c
  .const OFFSET_STRUCT_MOS6526_CIA_INTERRUPT = $d
  .label SPRITES_XPOS = $d000
  .label SPRITES_YPOS = $d001
  .label SPRITES_XMSB = $d010
  .label SPRITES_COLOR = $d027
  .label SPRITES_ENABLE = $d015
  .label SPRITES_EXPAND_Y = $d017
  .label SPRITES_MC = $d01c
  .label SPRITES_EXPAND_X = $d01d
  .label RASTER = $d012
  .label VIC_CONTROL = $d011
  // VIC II IRQ Status Register
  .label IRQ_STATUS = $d019
  // VIC II IRQ Enable Register
  .label IRQ_ENABLE = $d01a
  // Processor port data direction register
  .label PROCPORT_DDR = 0
  // Processor Port Register controlling RAM/ROM configuration and the datasette
  .label PROCPORT = 1
  // The address of the CHARGEN character set
  .label CHARGEN = $d000
  // Color Ram
  .label COLS = $d800
  // The CIA#1: keyboard matrix, joystick #1/#2
  .label CIA1 = $dc00
  // The vector used when the HARDWARE serves IRQ interrupts
  .label HARDWARE_IRQ = $fffe
  // Address of the screen
  .label SCREEN = $400
  // Sprite data for the animating sprites
  .label SPRITE_DATA = $2000
  // Top of the heap used by malloc()
  .label HEAP_TOP = $a000
  // Head of the heap. Moved backward each malloc()
  .label heap_head = 8
  .label SCREEN_COPY = $c
  .label SCREEN_DIST = $e
__bbegin:
  // malloc(1000)
  lda #<HEAP_TOP
  sta.z heap_head
  lda #>HEAP_TOP
  sta.z heap_head+1
  jsr malloc
  // malloc(1000)
  lda.z malloc.mem
  sta.z SCREEN_COPY
  lda.z malloc.mem+1
  sta.z SCREEN_COPY+1
  jsr malloc
  // malloc(1000)
  jsr main
  rts
main: {
    .label dst = 2
    .label src = 8
    .label i = 4
    .label center_y = $10
    // init_angle_screen(SCREEN_DIST)
    lda.z SCREEN_DIST
    sta.z init_angle_screen.screen
    lda.z SCREEN_DIST+1
    sta.z init_angle_screen.screen+1
    // Initialize the screen containing distance to the center
    jsr init_angle_screen
    // dst=SCREEN_COPY
    lda.z SCREEN_COPY
    sta.z dst
    lda.z SCREEN_COPY+1
    sta.z dst+1
    lda #<SCREEN
    sta.z src
    lda #>SCREEN
    sta.z src+1
  // Copy screen to screen copy
  __b1:
    // for( char *src=SCREEN, *dst=SCREEN_COPY; src!=SCREEN+1000; src++, dst++)
    lda.z src+1
    cmp #>SCREEN+$3e8
    bne __b2
    lda.z src
    cmp #<SCREEN+$3e8
    bne __b2
    lda #0
    sta.z i
  // Init processing array
  __b3:
    // PROCESSING[i] = { 0, 0, 0, 0, 0, 0, 0, STATUS_FREE, 0}
    lda.z i
    asl
    clc
    adc.z i
    asl
    clc
    adc.z i
    asl
    tax
    ldy #0
  !:
    lda __2,y
    sta PROCESSING,x
    inx
    iny
    cpy #SIZEOF_STRUCT_PROCESSINGSPRITE
    bne !-
    // for( char i: 0..NUM_PROCESSING-1 )
    inc.z i
    lda #NUM_PROCESSING-1+1
    cmp.z i
    bne __b3
    // initSprites()
  // Init sprites
    jsr initSprites
    // setupRasterIrq(RASTER_IRQ_TOP, &irqTop)
    // Set-up raster interrupts
    jsr setupRasterIrq
  __b4:
  // Main loop
    // getCharToProcess()
    jsr getCharToProcess
    ldy.z getCharToProcess.return_x
    lda.z getCharToProcess.return_y
    // center = getCharToProcess()
    sta.z center_y
    txa
    // if(center.dist==NOT_FOUND)
    cmp #NOT_FOUND
    bne __b6
    // (*(SCREEN+999)) = '.'
    lda #'.'
    sta SCREEN+$3e7
  __b8:
    // (*(COLS+999))++;
    inc COLS+$3e7
    jmp __b8
  __b6:
    // startProcessing(center)
    sty.z startProcessing.center_x
    jsr startProcessing
    jmp __b4
  __b2:
    // *dst = *src
    ldy #0
    lda (src),y
    sta (dst),y
    // for( char *src=SCREEN, *dst=SCREEN_COPY; src!=SCREEN+1000; src++, dst++)
    inc.z src
    bne !+
    inc.z src+1
  !:
    inc.z dst
    bne !+
    inc.z dst+1
  !:
    jmp __b1
}
// Start processing a char - by inserting it into the PROCESSING array
// startProcessing(byte zp($23) center_x, byte zp($10) center_y)
startProcessing: {
    .label __0 = $11
    .label __4 = 8
    .label __6 = 6
    .label __8 = $18
    .label __9 = $18
    .label __11 = $1a
    .label __12 = $1a
    .label __23 = $11
    .label __24 = 8
    .label __25 = 6
    .label __26 = $18
    .label __27 = $1a
    .label center_x = $23
    .label center_y = $10
    .label i = 5
    .label offset = $11
    .label colPtr = $15
    .label spriteCol = $17
    .label screenPtr = $11
    .label spriteData = 8
    .label chargenData = 6
    .label spriteX = $18
    .label spriteY = $1a
    .label spritePtr = $1c
    // Busy-wait while finding an empty slot in the PROCESSING array
    .label freeIdx = 5
    .label __33 = $13
    .label __34 = $11
    ldx #$ff
  __b1:
    lda #0
    sta.z i
  __b2:
    // PROCESSING[i].status==STATUS_FREE
    lda.z i
    asl
    clc
    adc.z i
    asl
    clc
    adc.z i
    asl
    // if(PROCESSING[i].status==STATUS_FREE)
    tay
    lda #STATUS_FREE
    cmp PROCESSING+OFFSET_STRUCT_PROCESSINGSPRITE_STATUS,y
    beq !__b3+
    jmp __b3
  !__b3:
  __b4:
    // while (freeIdx==0xff)
    lda #$ff
    cmp.z freeIdx
    bne !__b8+
    jmp __b8
  !__b8:
    // (unsigned int)center.y*40
    lda.z center_y
    sta.z __23
    lda #0
    sta.z __23+1
    lda.z __23
    asl
    sta.z __33
    lda.z __23+1
    rol
    sta.z __33+1
    asl.z __33
    rol.z __33+1
    lda.z __34
    clc
    adc.z __33
    sta.z __34
    lda.z __34+1
    adc.z __33+1
    sta.z __34+1
    asl.z __0
    rol.z __0+1
    asl.z __0
    rol.z __0+1
    asl.z __0
    rol.z __0+1
    // offset = (unsigned int)center.y*40+center.x
    lda.z center_x
    clc
    adc.z offset
    sta.z offset
    bcc !+
    inc.z offset+1
  !:
    // colPtr = COLS+offset
    lda.z offset
    clc
    adc #<COLS
    sta.z colPtr
    lda.z offset+1
    adc #>COLS
    sta.z colPtr+1
    // spriteCol = *colPtr
    ldy #0
    lda (colPtr),y
    sta.z spriteCol
    // screenPtr = SCREEN+offset
    clc
    lda.z screenPtr
    adc #<SCREEN
    sta.z screenPtr
    lda.z screenPtr+1
    adc #>SCREEN
    sta.z screenPtr+1
    // (unsigned int)spriteIdx*64
    lda.z freeIdx
    sta.z __24
    tya
    sta.z __24+1
    asl.z __4
    rol.z __4+1
    asl.z __4
    rol.z __4+1
    asl.z __4
    rol.z __4+1
    asl.z __4
    rol.z __4+1
    asl.z __4
    rol.z __4+1
    asl.z __4
    rol.z __4+1
    // spriteData = SPRITE_DATA+(unsigned int)spriteIdx*64
    clc
    lda.z spriteData
    adc #<SPRITE_DATA
    sta.z spriteData
    lda.z spriteData+1
    adc #>SPRITE_DATA
    sta.z spriteData+1
    // ch = (*screenPtr)
    lda (screenPtr),y
    // (unsigned int)ch*8
    sta.z __25
    tya
    sta.z __25+1
    asl.z __6
    rol.z __6+1
    asl.z __6
    rol.z __6+1
    asl.z __6
    rol.z __6+1
    // chargenData = CHARGEN+(unsigned int)ch*8
    clc
    lda.z chargenData
    adc #<CHARGEN
    sta.z chargenData
    lda.z chargenData+1
    adc #>CHARGEN
    sta.z chargenData+1
    // asm
    sei
    // *PROCPORT = PROCPORT_RAM_CHARROM
    lda #PROCPORT_RAM_CHARROM
    sta PROCPORT
    ldx #0
  __b6:
    // *spriteData = *chargenData
    ldy #0
    lda (chargenData),y
    sta (spriteData),y
    // spriteData += 3
    lda #3
    clc
    adc.z spriteData
    sta.z spriteData
    bcc !+
    inc.z spriteData+1
  !:
    // chargenData++;
    inc.z chargenData
    bne !+
    inc.z chargenData+1
  !:
    // for( char i: 0..7)
    inx
    cpx #8
    bne __b6
    // *PROCPORT = PROCPORT_RAM_IO
    lda #PROCPORT_RAM_IO
    sta PROCPORT
    // asm
    cli
    // (unsigned int)center.x*8
    lda.z center_x
    sta.z __26
    lda #0
    sta.z __26+1
    asl.z __8
    rol.z __8+1
    asl.z __8
    rol.z __8+1
    asl.z __8
    rol.z __8+1
    // BORDER_XPOS_LEFT + (unsigned int)center.x*8
    lda #BORDER_XPOS_LEFT
    clc
    adc.z __9
    sta.z __9
    bcc !+
    inc.z __9+1
  !:
    // spriteX = (BORDER_XPOS_LEFT + (unsigned int)center.x*8) << 4
    asl.z spriteX
    rol.z spriteX+1
    asl.z spriteX
    rol.z spriteX+1
    asl.z spriteX
    rol.z spriteX+1
    asl.z spriteX
    rol.z spriteX+1
    // (unsigned int)center.y*8
    lda.z center_y
    sta.z __27
    lda #0
    sta.z __27+1
    asl.z __11
    rol.z __11+1
    asl.z __11
    rol.z __11+1
    asl.z __11
    rol.z __11+1
    // BORDER_YPOS_TOP + (unsigned int)center.y*8
    lda #BORDER_YPOS_TOP
    clc
    adc.z __12
    sta.z __12
    bcc !+
    inc.z __12+1
  !:
    // spriteY = (BORDER_YPOS_TOP + (unsigned int)center.y*8) << 4
    asl.z spriteY
    rol.z spriteY+1
    asl.z spriteY
    rol.z spriteY+1
    asl.z spriteY
    rol.z spriteY+1
    asl.z spriteY
    rol.z spriteY+1
    // spritePtr = (char)(SPRITE_DATA/64)+spriteIdx
    lax.z freeIdx
    axs #-[SPRITE_DATA/$40]
    stx.z spritePtr
    // spriteIdx*8
    lda.z freeIdx
    asl
    asl
    asl
    tay
    // PROCESSING[spriteIdx] = { spriteX, spriteY, (unsigned int)(spriteIdx*8), 60, spriteIdx, spritePtr, spriteCol, STATUS_NEW, screenPtr }
    lda.z freeIdx
    asl
    clc
    adc.z freeIdx
    asl
    clc
    adc.z freeIdx
    asl
    tax
    lda.z spriteX
    sta PROCESSING,x
    lda.z spriteX+1
    sta PROCESSING+1,x
    lda.z spriteY
    sta PROCESSING+OFFSET_STRUCT_PROCESSINGSPRITE_Y,x
    lda.z spriteY+1
    sta PROCESSING+OFFSET_STRUCT_PROCESSINGSPRITE_Y+1,x
    tya
    sta PROCESSING+OFFSET_STRUCT_PROCESSINGSPRITE_VX,x
    lda #0
    sta PROCESSING+OFFSET_STRUCT_PROCESSINGSPRITE_VX+1,x
    lda #<$3c
    sta PROCESSING+OFFSET_STRUCT_PROCESSINGSPRITE_VY,x
    lda #>$3c
    sta PROCESSING+OFFSET_STRUCT_PROCESSINGSPRITE_VY+1,x
    lda.z freeIdx
    sta PROCESSING+OFFSET_STRUCT_PROCESSINGSPRITE_ID,x
    lda.z spritePtr
    sta PROCESSING+OFFSET_STRUCT_PROCESSINGSPRITE_PTR,x
    lda.z spriteCol
    sta PROCESSING+OFFSET_STRUCT_PROCESSINGSPRITE_COL,x
    lda #STATUS_NEW
    sta PROCESSING+OFFSET_STRUCT_PROCESSINGSPRITE_STATUS,x
    lda.z screenPtr
    sta PROCESSING+OFFSET_STRUCT_PROCESSINGSPRITE_SCREENPTR,x
    lda.z screenPtr+1
    sta PROCESSING+OFFSET_STRUCT_PROCESSINGSPRITE_SCREENPTR+1,x
    // }
    rts
  __b8:
    ldx.z freeIdx
    jmp __b1
  __b3:
    // for( char i: 0..NUM_PROCESSING-1 )
    inc.z i
    lda #NUM_PROCESSING-1+1
    cmp.z i
    beq !__b2+
    jmp __b2
  !__b2:
    stx.z freeIdx
    jmp __b4
}
// Find the non-space char closest to the center of the screen
// If no non-space char is found the distance will be 0xffff
getCharToProcess: {
    .label __8 = $1d
    .label __9 = $1d
    .label __11 = $1d
    .label screen_line = 6
    .label dist_line = 8
    .label y = 5
    .label return_x = $17
    .label return_y = $1c
    .label closest_dist = $10
    .label closest_x = $17
    .label closest_y = $1c
    .label __12 = $1f
    .label __13 = $1d
    // screen_line = SCREEN_COPY
    lda.z SCREEN_COPY
    sta.z screen_line
    lda.z SCREEN_COPY+1
    sta.z screen_line+1
    // dist_line = SCREEN_DIST
    lda.z SCREEN_DIST
    sta.z dist_line
    lda.z SCREEN_DIST+1
    sta.z dist_line+1
    lda #0
    sta.z closest_y
    sta.z closest_x
    sta.z y
    lda #NOT_FOUND
    sta.z closest_dist
  __b1:
    ldy #0
  __b2:
    // if(screen_line[x]!=' ')
    lda #' '
    cmp (screen_line),y
    bne !__b11+
    jmp __b11
  !__b11:
    // dist = dist_line[x]
    lda (dist_line),y
    tax
    // if(dist<closest.dist)
    cpx.z closest_dist
    bcs __b12
    sty.z return_x
    lda.z y
    sta.z return_y
  __b3:
    // for( char x: 0..39)
    iny
    cpy #$28
    bne __b10
    // screen_line += 40
    lda #$28
    clc
    adc.z screen_line
    sta.z screen_line
    bcc !+
    inc.z screen_line+1
  !:
    // dist_line += 40
    lda #$28
    clc
    adc.z dist_line
    sta.z dist_line
    bcc !+
    inc.z dist_line+1
  !:
    // for( char y: 0..24)
    inc.z y
    lda #$19
    cmp.z y
    bne __b9
    // if(closest.dist != NOT_FOUND)
    cpx #NOT_FOUND
    beq __breturn
    // (unsigned int)closest.y*40
    lda.z return_y
    sta.z __11
    lda #0
    sta.z __11+1
    lda.z __11
    asl
    sta.z __12
    lda.z __11+1
    rol
    sta.z __12+1
    asl.z __12
    rol.z __12+1
    lda.z __13
    clc
    adc.z __12
    sta.z __13
    lda.z __13+1
    adc.z __12+1
    sta.z __13+1
    asl.z __8
    rol.z __8+1
    asl.z __8
    rol.z __8+1
    asl.z __8
    rol.z __8+1
    // SCREEN_COPY+(unsigned int)closest.y*40
    lda.z __9
    clc
    adc.z SCREEN_COPY
    sta.z __9
    lda.z __9+1
    adc.z SCREEN_COPY+1
    sta.z __9+1
    // *(SCREEN_COPY+(unsigned int)closest.y*40+closest.x) = ' '
    // clear the found char on the screen copy
    lda #' '
    ldy.z return_x
    sta (__9),y
  __breturn:
    // }
    rts
  __b9:
    stx.z closest_dist
    jmp __b1
  __b10:
    stx.z closest_dist
    jmp __b2
  __b12:
    ldx.z closest_dist
    jmp __b3
  __b11:
    ldx.z closest_dist
    jmp __b3
}
// Setup Raster IRQ
setupRasterIrq: {
    .label irqRoutine = irqTop
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
    // *VIC_CONTROL &=0x7f
    lda #$7f
    and VIC_CONTROL
    sta VIC_CONTROL
    // *RASTER = <raster
    lda #RASTER_IRQ_TOP
    sta RASTER
    // *IRQ_ENABLE = IRQ_RASTER
    // Enable Raster Interrupt
    lda #IRQ_RASTER
    sta IRQ_ENABLE
    // *HARDWARE_IRQ = irqRoutine
    // Set the IRQ routine
    lda #<irqRoutine
    sta HARDWARE_IRQ
    lda #>irqRoutine
    sta HARDWARE_IRQ+1
    // asm
    cli
    // }
    rts
}
// Initialize sprites
initSprites: {
    .label sp = 6
    lda #<SPRITE_DATA
    sta.z sp
    lda #>SPRITE_DATA
    sta.z sp+1
  // Clear sprite data
  __b1:
    // for( char* sp = SPRITE_DATA; sp<SPRITE_DATA+NUM_PROCESSING*64; sp++)
    lda.z sp+1
    cmp #>SPRITE_DATA+NUM_PROCESSING*$40
    bcc __b2
    bne !+
    lda.z sp
    cmp #<SPRITE_DATA+NUM_PROCESSING*$40
    bcc __b2
  !:
    ldx #0
  // Initialize sprite registers
  __b3:
    // SPRITES_COLOR[i] = LIGHT_BLUE
    lda #LIGHT_BLUE
    sta SPRITES_COLOR,x
    // for( char i: 0..7)
    inx
    cpx #8
    bne __b3
    // *SPRITES_MC = 0
    lda #0
    sta SPRITES_MC
    // *SPRITES_EXPAND_X = 0
    sta SPRITES_EXPAND_X
    // *SPRITES_EXPAND_Y = 0
    sta SPRITES_EXPAND_Y
    // }
    rts
  __b2:
    // *sp = 0
    lda #0
    tay
    sta (sp),y
    // for( char* sp = SPRITE_DATA; sp<SPRITE_DATA+NUM_PROCESSING*64; sp++)
    inc.z sp
    bne !+
    inc.z sp+1
  !:
    jmp __b1
}
// Populates 1000 chars (a screen) with values representing the angle to the center.
// Utilizes symmetry around the  center
// init_angle_screen(byte* zp($11) screen)
init_angle_screen: {
    .label __7 = $18
    .label screen = $11
    .label screen_topline = 6
    .label screen_bottomline = $11
    .label xw = $1f
    .label yw = $21
    .label angle_w = $18
    .label ang_w = $23
    .label x = $17
    .label xb = $1c
    .label y = $10
    // screen_topline = screen+40*12
    lda.z screen
    clc
    adc #<$28*$c
    sta.z screen_topline
    lda.z screen+1
    adc #>$28*$c
    sta.z screen_topline+1
    // screen_bottomline = screen+40*12
    clc
    lda.z screen_bottomline
    adc #<$28*$c
    sta.z screen_bottomline
    lda.z screen_bottomline+1
    adc #>$28*$c
    sta.z screen_bottomline+1
    lda #0
    sta.z y
  __b1:
    lda #$27
    sta.z xb
    lda #0
    sta.z x
  __b2:
    // for( char x=0,xb=39; x<=19; x++, xb--)
    lda.z x
    cmp #$13+1
    bcc __b3
    // screen_topline -= 40
    lda.z screen_topline
    sec
    sbc #<$28
    sta.z screen_topline
    lda.z screen_topline+1
    sbc #>$28
    sta.z screen_topline+1
    // screen_bottomline += 40
    lda #$28
    clc
    adc.z screen_bottomline
    sta.z screen_bottomline
    bcc !+
    inc.z screen_bottomline+1
  !:
    // for(char y: 0..12)
    inc.z y
    lda #$d
    cmp.z y
    bne __b1
    // }
    rts
  __b3:
    // x*2
    lda.z x
    asl
    // 39-x*2
    eor #$ff
    clc
    adc #$27+1
    // xw = (signed int)(unsigned int){ 39-x*2, 0 }
    ldy #0
    sta.z xw+1
    sty.z xw
    // y*2
    lda.z y
    asl
    // yw = (signed int)(unsigned int){ y*2, 0 }
    sta.z yw+1
    sty.z yw
    // atan2_16(xw, yw)
    jsr atan2_16
    // angle_w = atan2_16(xw, yw)
    // angle_w+0x0080
    lda #$80
    clc
    adc.z __7
    sta.z __7
    bcc !+
    inc.z __7+1
  !:
    // ang_w = >(angle_w+0x0080)
    lda.z __7+1
    sta.z ang_w
    // screen_bottomline[xb] = ang_w
    ldy.z xb
    sta (screen_bottomline),y
    // -ang_w
    eor #$ff
    clc
    adc #1
    // screen_topline[xb] = -ang_w
    sta (screen_topline),y
    // 0x80+ang_w
    lda #$80
    clc
    adc.z ang_w
    // screen_topline[x] = 0x80+ang_w
    ldy.z x
    sta (screen_topline),y
    // 0x80-ang_w
    lda #$80
    sec
    sbc.z ang_w
    // screen_bottomline[x] = 0x80-ang_w
    sta (screen_bottomline),y
    // for( char x=0,xb=39; x<=19; x++, xb--)
    inc.z x
    dec.z xb
    jmp __b2
}
// Find the atan2(x, y) - which is the angle of the line from (0,0) to (x,y)
// Finding the angle requires a binary search using CORDIC_ITERATIONS_16
// Returns the angle in hex-degrees (0=0, 0x8000=PI, 0x10000=2*PI)
// atan2_16(signed word zp($1f) x, signed word zp($21) y)
atan2_16: {
    .label __2 = $13
    .label __7 = $15
    .label yi = $13
    .label xi = $15
    .label angle = $18
    .label xd = $1d
    .label yd = $1a
    .label return = $18
    .label x = $1f
    .label y = $21
    // (y>=0)?y:-y
    lda.z y+1
    bmi !__b1+
    jmp __b1
  !__b1:
    sec
    lda #0
    sbc.z y
    sta.z __2
    lda #0
    sbc.z y+1
    sta.z __2+1
  __b3:
    // (x>=0)?x:-x
    lda.z x+1
    bmi !__b4+
    jmp __b4
  !__b4:
    sec
    lda #0
    sbc.z x
    sta.z __7
    lda #0
    sbc.z x+1
    sta.z __7+1
  __b6:
    lda #<0
    sta.z angle
    sta.z angle+1
    tax
  __b10:
    // if(yi==0)
    lda.z yi+1
    bne __b11
    lda.z yi
    bne __b11
  __b12:
    // angle /=2
    lsr.z angle+1
    ror.z angle
    // if(x<0)
    lda.z x+1
    bpl __b7
    // angle = 0x8000-angle
    sec
    lda #<$8000
    sbc.z angle
    sta.z angle
    lda #>$8000
    sbc.z angle+1
    sta.z angle+1
  __b7:
    // if(y<0)
    lda.z y+1
    bpl __b8
    // angle = -angle
    sec
    lda #0
    sbc.z angle
    sta.z angle
    lda #0
    sbc.z angle+1
    sta.z angle+1
  __b8:
    // }
    rts
  __b11:
    txa
    tay
    lda.z xi
    sta.z xd
    lda.z xi+1
    sta.z xd+1
    lda.z yi
    sta.z yd
    lda.z yi+1
    sta.z yd+1
  __b13:
    // while(shift>=2)
    cpy #2
    bcs __b14
    // if(shift)
    cpy #0
    beq __b17
    // xd >>= 1
    lda.z xd+1
    cmp #$80
    ror.z xd+1
    ror.z xd
    // yd >>= 1
    lda.z yd+1
    cmp #$80
    ror.z yd+1
    ror.z yd
  __b17:
    // if(yi>=0)
    lda.z yi+1
    bpl __b18
    // xi -= yd
    lda.z xi
    sec
    sbc.z yd
    sta.z xi
    lda.z xi+1
    sbc.z yd+1
    sta.z xi+1
    // yi += xd
    lda.z yi
    clc
    adc.z xd
    sta.z yi
    lda.z yi+1
    adc.z xd+1
    sta.z yi+1
    // angle -= CORDIC_ATAN2_ANGLES_16[i]
    txa
    asl
    tay
    sec
    lda.z angle
    sbc CORDIC_ATAN2_ANGLES_16,y
    sta.z angle
    lda.z angle+1
    sbc CORDIC_ATAN2_ANGLES_16+1,y
    sta.z angle+1
  __b19:
    // for( char i: 0..CORDIC_ITERATIONS_16-1)
    inx
    cpx #CORDIC_ITERATIONS_16-1+1
    bne !__b12+
    jmp __b12
  !__b12:
    jmp __b10
  __b18:
    // xi += yd
    lda.z xi
    clc
    adc.z yd
    sta.z xi
    lda.z xi+1
    adc.z yd+1
    sta.z xi+1
    // yi -= xd
    lda.z yi
    sec
    sbc.z xd
    sta.z yi
    lda.z yi+1
    sbc.z xd+1
    sta.z yi+1
    // angle += CORDIC_ATAN2_ANGLES_16[i]
    txa
    asl
    tay
    clc
    lda.z angle
    adc CORDIC_ATAN2_ANGLES_16,y
    sta.z angle
    lda.z angle+1
    adc CORDIC_ATAN2_ANGLES_16+1,y
    sta.z angle+1
    jmp __b19
  __b14:
    // xd >>= 2
    lda.z xd+1
    cmp #$80
    ror.z xd+1
    ror.z xd
    lda.z xd+1
    cmp #$80
    ror.z xd+1
    ror.z xd
    // yd >>= 2
    lda.z yd+1
    cmp #$80
    ror.z yd+1
    ror.z yd
    lda.z yd+1
    cmp #$80
    ror.z yd+1
    ror.z yd
    // shift -=2
    dey
    dey
    jmp __b13
  __b4:
    // (x>=0)?x:-x
    lda.z x
    sta.z xi
    lda.z x+1
    sta.z xi+1
    jmp __b6
  __b1:
    // (y>=0)?y:-y
    lda.z y
    sta.z yi
    lda.z y+1
    sta.z yi+1
    jmp __b3
}
// Allocates a block of size chars of memory, returning a pointer to the beginning of the block.
// The content of the newly allocated block of memory is not initialized, remaining with indeterminate values.
malloc: {
    .label mem = $e
    // mem = heap_head-size
    lda.z heap_head
    sec
    sbc #<$3e8
    sta.z mem
    lda.z heap_head+1
    sbc #>$3e8
    sta.z mem+1
    // heap_head = mem
    lda.z mem
    sta.z heap_head
    lda.z mem+1
    sta.z heap_head+1
    // }
    rts
}
// Raster Interrupt at the bottom of the screen
irqBottom: {
    sta rega+1
    stx regx+1
    sty regy+1
    // processChars()
    jsr processChars
    // *RASTER = RASTER_IRQ_TOP
    // Trigger IRQ at the top of the screen
    lda #RASTER_IRQ_TOP
    sta RASTER
    // *HARDWARE_IRQ = &irqTop
    lda #<irqTop
    sta HARDWARE_IRQ
    lda #>irqTop
    sta HARDWARE_IRQ+1
    // *IRQ_STATUS = IRQ_RASTER
    // Acknowledge the IRQ
    lda #IRQ_RASTER
    sta IRQ_STATUS
    // }
  rega:
    lda #00
  regx:
    ldx #00
  regy:
    ldy #00
    rti
}
// Process any chars in the PROCESSING array
processChars: {
    .label __12 = $29
    .label __21 = $27
    .label processing = $24
    .label bitmask = $26
    .label i = $a
    .label xpos = $27
    .label ypos = $2b
    .label numActive = $b
    lda #0
    sta.z numActive
    sta.z i
  __b1:
    // PROCESSING+i
    lda.z i
    asl
    clc
    adc.z i
    asl
    clc
    adc.z i
    asl
    // processing = PROCESSING+i
    clc
    adc #<PROCESSING
    sta.z processing
    lda #>PROCESSING
    adc #0
    sta.z processing+1
    // bitmask = 1<<processing->id
    ldy #OFFSET_STRUCT_PROCESSINGSPRITE_ID
    lda (processing),y
    tay
    lda #1
    cpy #0
    beq !e+
  !:
    asl
    dey
    bne !-
  !e:
    sta.z bitmask
    // if(processing->status!=STATUS_FREE)
    lda #STATUS_FREE
    ldy #OFFSET_STRUCT_PROCESSINGSPRITE_STATUS
    cmp (processing),y
    bne !__b2+
    jmp __b2
  !__b2:
    // if(processing->status==STATUS_NEW)
    lda (processing),y
    cmp #STATUS_NEW
    bne __b3
    // *(processing->screenPtr) = ' '
    // Clear the char on the screen
    ldx #' '
    ldy #OFFSET_STRUCT_PROCESSINGSPRITE_SCREENPTR
    lda (processing),y
    sta !+ +1
    iny
    lda (processing),y
    sta !+ +2
  !:
    stx $ffff
    // *SPRITES_ENABLE |= bitmask
    // Enable the sprite
    lda SPRITES_ENABLE
    ora.z bitmask
    sta SPRITES_ENABLE
    // SPRITES_COLOR[processing->id] = processing->col
    // Set the sprite color
    ldy #OFFSET_STRUCT_PROCESSINGSPRITE_COL
    lda (processing),y
    ldy #OFFSET_STRUCT_PROCESSINGSPRITE_ID
    pha
    lda (processing),y
    tay
    pla
    sta SPRITES_COLOR,y
    // *(SCREEN+SPRITE_PTRS+processing->id) = processing->ptr
    // Set sprite pointer
    ldy #OFFSET_STRUCT_PROCESSINGSPRITE_PTR
    lda (processing),y
    ldy #OFFSET_STRUCT_PROCESSINGSPRITE_ID
    pha
    lda (processing),y
    tay
    pla
    sta SCREEN+SPRITE_PTRS,y
    // processing->status = STATUS_PROCESSING
    // Set status
    lda #STATUS_PROCESSING
    ldy #OFFSET_STRUCT_PROCESSINGSPRITE_STATUS
    sta (processing),y
  __b3:
    // xpos = processing->x >> 4
    ldy #0
    lda (processing),y
    sta.z xpos
    iny
    lda (processing),y
    sta.z xpos+1
    lsr.z xpos+1
    ror.z xpos
    lsr.z xpos+1
    ror.z xpos
    lsr.z xpos+1
    ror.z xpos
    lsr.z xpos+1
    ror.z xpos
    // >xpos
    lda.z xpos+1
    // if(>xpos)
    // Set sprite position
    cmp #0
    beq !__b4+
    jmp __b4
  !__b4:
    // 0xff ^ bitmask
    lda #$ff
    eor.z bitmask
    // *SPRITES_XMSB &= 0xff ^ bitmask
    and SPRITES_XMSB
    sta SPRITES_XMSB
  __b5:
    // i*2
    lda.z i
    asl
    tax
    // SPRITES_XPOS[i*2] = (char)xpos
    lda.z xpos
    sta SPRITES_XPOS,x
    // processing->y>>4
    ldy #OFFSET_STRUCT_PROCESSINGSPRITE_Y
    lda (processing),y
    sta.z __12
    iny
    lda (processing),y
    sta.z __12+1
    lsr.z __12+1
    ror.z __12
    lsr.z __12+1
    ror.z __12
    lsr.z __12+1
    ror.z __12
    lsr.z __12+1
    ror.z __12
    // ypos = (char)(processing->y>>4)
    lda.z __12
    sta.z ypos
    // SPRITES_YPOS[i*2] = ypos
    sta SPRITES_YPOS,x
    // if(processing->x < XPOS_LEFTMOST || processing->x > XPOS_RIGHTMOST || processing->y < YPOS_TOPMOST|| processing->y > YPOS_BOTTOMMOST  )
    // Move sprite
    ldy #1
    lda (processing),y
    cmp #>XPOS_LEFTMOST
    bcs !__b6+
    jmp __b6
  !__b6:
    bne !+
    dey
    lda (processing),y
    cmp #<XPOS_LEFTMOST
    bcs !__b6+
    jmp __b6
  !__b6:
  !:
    ldy #1
    lda #>XPOS_RIGHTMOST
    cmp (processing),y
    bcs !__b6+
    jmp __b6
  !__b6:
    bne !+
    dey
    lda #<XPOS_RIGHTMOST
    cmp (processing),y
    bcs !__b6+
    jmp __b6
  !__b6:
  !:
    ldy #OFFSET_STRUCT_PROCESSINGSPRITE_Y
    iny
    lda (processing),y
    cmp #>YPOS_TOPMOST
    bcs !__b6+
    jmp __b6
  !__b6:
    bne !+
    dey
    lda (processing),y
    cmp #<YPOS_TOPMOST
    bcs !__b6+
    jmp __b6
  !__b6:
  !:
    ldy #OFFSET_STRUCT_PROCESSINGSPRITE_Y
    iny
    lda #>YPOS_BOTTOMMOST
    cmp (processing),y
    bcs !__b6+
    jmp __b6
  !__b6:
    bne !+
    dey
    lda #<YPOS_BOTTOMMOST
    cmp (processing),y
    bcc __b6
  !:
    // xpos/8
    lsr.z __21+1
    ror.z __21
    lsr.z __21+1
    ror.z __21
    lsr.z __21+1
    ror.z __21
    // (char)(xpos/8) - BORDER_XPOS_LEFT/8
    lda.z __21
    // xchar = (char)(xpos/8) - BORDER_XPOS_LEFT/8
    sec
    sbc #BORDER_XPOS_LEFT/8
    // processing->vx += VXSIN[xchar]
    asl
    ldy #OFFSET_STRUCT_PROCESSINGSPRITE_VX
    tax
    clc
    lda (processing),y
    adc VXSIN,x
    sta (processing),y
    iny
    lda (processing),y
    adc VXSIN+1,x
    sta (processing),y
    // processing->x += processing->vx
    ldy #OFFSET_STRUCT_PROCESSINGSPRITE_VX
    sty.z $ff
    clc
    lda (processing),y
    ldy #0
    adc (processing),y
    sta (processing),y
    ldy.z $ff
    iny
    lda (processing),y
    ldy #1
    adc (processing),y
    sta (processing),y
    // (char)(ypos/8) - BORDER_YPOS_TOP/8
    lda.z ypos
    lsr
    lsr
    lsr
    // ychar = (char)(ypos/8) - BORDER_YPOS_TOP/8
    sec
    sbc #BORDER_YPOS_TOP/8
    // processing->vy +=   VYSIN[ychar]
    asl
    ldy #OFFSET_STRUCT_PROCESSINGSPRITE_VY
    tax
    clc
    lda (processing),y
    adc VYSIN,x
    sta (processing),y
    iny
    lda (processing),y
    adc VYSIN+1,x
    sta (processing),y
    // processing->y += processing->vy
    ldy #OFFSET_STRUCT_PROCESSINGSPRITE_VY
    clc
    lda (processing),y
    ldy #OFFSET_STRUCT_PROCESSINGSPRITE_Y
    adc (processing),y
    sta (processing),y
    ldy #OFFSET_STRUCT_PROCESSINGSPRITE_VY+1
    lda (processing),y
    ldy #OFFSET_STRUCT_PROCESSINGSPRITE_Y+1
    adc (processing),y
    sta (processing),y
  __b7:
    // numActive++;
    inc.z numActive
  __b2:
    // for( char i: 0..NUM_PROCESSING-1 )
    inc.z i
    lda #NUM_PROCESSING-1+1
    cmp.z i
    beq !__b1+
    jmp __b1
  !__b1:
    // }
    rts
  __b6:
    // processing->status = STATUS_FREE
    // Set status to FREE
    lda #STATUS_FREE
    ldy #OFFSET_STRUCT_PROCESSINGSPRITE_STATUS
    sta (processing),y
    // 0xff ^ bitmask
    lda #$ff
    eor.z bitmask
    // *SPRITES_ENABLE &= 0xff ^ bitmask
    // Disable the sprite
    and SPRITES_ENABLE
    sta SPRITES_ENABLE
    jmp __b7
  __b4:
    // *SPRITES_XMSB |= bitmask
    lda SPRITES_XMSB
    ora.z bitmask
    sta SPRITES_XMSB
    jmp __b5
}
// Raster Interrupt at the top of the screen
irqTop: {
    sta rega+1
    stx regx+1
    sty regy+1
    // *RASTER = RASTER_IRQ_MIDDLE
    // Trigger IRQ at the middle of the screen
    lda #RASTER_IRQ_MIDDLE
    sta RASTER
    // *HARDWARE_IRQ = &irqBottom
    lda #<irqBottom
    sta HARDWARE_IRQ
    lda #>irqBottom
    sta HARDWARE_IRQ+1
    // *IRQ_STATUS = IRQ_RASTER
    // Acknowledge the IRQ
    lda #IRQ_RASTER
    sta IRQ_STATUS
    // }
  rega:
    lda #00
  regx:
    ldx #00
  regy:
    ldy #00
    rti
}
  // Angles representing ATAN(0.5), ATAN(0.25), ATAN(0.125), ...
CORDIC_ATAN2_ANGLES_16:
.for (var i=0; i<CORDIC_ITERATIONS_16; i++)
        .word 256*2*256*atan(1/pow(2,i))/PI/2

  // Values added to VX
VXSIN:
.for(var i=0; i<40; i++) {
      .word -sin(toRadians([i*360]/40))*4
    }

  // Values added to VY
VYSIN:
.for(var i=0; i<25; i++) {
      .word -sin(toRadians([i*360]/25))*4
    }

  // Sprites currently being processed in the interrupt
  PROCESSING: .fill $e*NUM_PROCESSING, 0
  __2: .word 0, 0, 0, 0
  .byte 0, 0, 0, STATUS_FREE
  .word 0
