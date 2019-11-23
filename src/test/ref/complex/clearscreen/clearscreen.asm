// Clears start screen throwing around the letters (by turning them into sprites)
.pc = $801 "Basic"
:BasicUpstart(__b1)
.pc = $80d "Program"
  // The number of iterations performed during 16-bit CORDIC atan2 calculation
  .const CORDIC_ITERATIONS_16 = $f
  // Processor port data direction register
  .label PROCPORT_DDR = 0
  // Mask for PROCESSOR_PORT_DDR which allows only memory configuration to be written
  .const PROCPORT_DDR_MEMORY_MASK = 7
  // Processor Port Register controlling RAM/ROM configuration and the datasette
  .label PROCPORT = 1
  // RAM in $A000, $E000 I/O in $D000
  .const PROCPORT_RAM_IO = 5
  // RAM in $A000, $E000 CHAR ROM in $D000
  .const PROCPORT_RAM_CHARROM = 1
  // The address of the CHARGEN character set
  .label CHARGEN = $d000
  // Positions of the border (in sprite positions)
  .const BORDER_XPOS_LEFT = $18
  .const BORDER_XPOS_RIGHT = $158
  .const BORDER_YPOS_TOP = $32
  .const BORDER_YPOS_BOTTOM = $fa
  // The offset of the sprite pointers from the screen start address
  .const SPRITE_PTRS = $3f8
  .label SPRITES_XPOS = $d000
  .label SPRITES_YPOS = $d001
  .label SPRITES_XMSB = $d010
  .label RASTER = $d012
  .label SPRITES_ENABLE = $d015
  .label SPRITES_EXPAND_Y = $d017
  .label SPRITES_MC = $d01c
  .label SPRITES_EXPAND_X = $d01d
  .label SPRITES_COLS = $d027
  .label VIC_CONTROL = $d011
  // VIC II IRQ Status Register
  .label IRQ_STATUS = $d019
  // VIC II IRQ Enable Register
  .label IRQ_ENABLE = $d01a
  // Bits for the IRQ Status/Enable Registers
  .const IRQ_RASTER = 1
  // Color Ram
  .label COLS = $d800
  // CIA#1 Interrupt Status & Control Register
  .label CIA1_INTERRUPT = $dc0d
  // Value that disables all CIA interrupts when stored to the CIA Interrupt registers
  .const CIA_INTERRUPT_CLEAR = $7f
  // The vector used when the HARDWARE serves IRQ interrupts
  .label HARDWARE_IRQ = $fffe
  .const LIGHT_BLUE = $e
  // Address of the screen
  .label SCREEN = $400
  // Sprite data for the animating sprites
  .label SPRITE_DATA = $2000
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
  .const OFFSET_STRUCT_PROCESSINGSPRITE_Y = 2
  .const OFFSET_STRUCT_PROCESSINGSPRITE_VX = 4
  .const OFFSET_STRUCT_PROCESSINGSPRITE_VY = 6
  .const OFFSET_STRUCT_PROCESSINGSPRITE_ID = 8
  .const OFFSET_STRUCT_PROCESSINGSPRITE_PTR = 9
  .const OFFSET_STRUCT_PROCESSINGSPRITE_COL = $a
  .const OFFSET_STRUCT_PROCESSINGSPRITE_STATUS = $b
  .const OFFSET_STRUCT_PROCESSINGSPRITE_SCREENPTR = $c
  // Top of the heap used by malloc()
  .label HEAP_TOP = $a000
  // Head of the heap. Moved backward each malloc()
  .label heap_head = $18
  .label SCREEN_COPY = 7
  .label SCREEN_DIST = 9
__b1:
  lda #<HEAP_TOP
  sta.z heap_head
  lda #>HEAP_TOP
  sta.z heap_head+1
  jsr malloc
  lda.z malloc.mem
  sta.z SCREEN_COPY
  lda.z malloc.mem+1
  sta.z SCREEN_COPY+1
  jsr malloc
  jsr main
  rts
main: {
    .label dst = 3
    .label src = $1c
    .label i = 2
    .label center_y = $b
    lda.z SCREEN_DIST
    sta.z init_angle_screen.screen
    lda.z SCREEN_DIST+1
    sta.z init_angle_screen.screen+1
    jsr init_angle_screen
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
    lda.z i
    asl
    clc
    adc.z i
    asl
    clc
    adc.z i
    asl
    tax
    lda #0
    sta PROCESSING,x
    sta PROCESSING+1,x
    sta PROCESSING+OFFSET_STRUCT_PROCESSINGSPRITE_Y,x
    sta PROCESSING+OFFSET_STRUCT_PROCESSINGSPRITE_Y+1,x
    sta PROCESSING+OFFSET_STRUCT_PROCESSINGSPRITE_VX,x
    sta PROCESSING+OFFSET_STRUCT_PROCESSINGSPRITE_VX+1,x
    sta PROCESSING+OFFSET_STRUCT_PROCESSINGSPRITE_VY,x
    sta PROCESSING+OFFSET_STRUCT_PROCESSINGSPRITE_VY+1,x
    sta PROCESSING+OFFSET_STRUCT_PROCESSINGSPRITE_ID,x
    sta PROCESSING+OFFSET_STRUCT_PROCESSINGSPRITE_PTR,x
    sta PROCESSING+OFFSET_STRUCT_PROCESSINGSPRITE_COL,x
    lda #STATUS_FREE
    sta PROCESSING+OFFSET_STRUCT_PROCESSINGSPRITE_STATUS,x
    lda #<0
    sta PROCESSING+OFFSET_STRUCT_PROCESSINGSPRITE_SCREENPTR,x
    sta PROCESSING+OFFSET_STRUCT_PROCESSINGSPRITE_SCREENPTR+1,x
    inc.z i
    lda #NUM_PROCESSING-1+1
    cmp.z i
    bne __b3
    jsr initSprites
    jsr setupRasterIrq
  b1:
  // Main loop
    jsr getCharToProcess
    ldy.z getCharToProcess.return_x
    lda.z getCharToProcess.return_y
    sta.z center_y
    txa
    cmp #NOT_FOUND
    bne __b6
    lda #'.'
    sta SCREEN+$3e7
  __b8:
    inc COLS+$3e7
    jmp __b8
  __b6:
    sty.z startProcessing.center_x
    jsr startProcessing
    jmp b1
  __b2:
    ldy #0
    lda (src),y
    sta (dst),y
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
// startProcessing(byte zeropage($1e) center_x, byte zeropage($b) center_y)
startProcessing: {
    .label __0 = $c
    .label __1 = $c
    .label __5 = 3
    .label __6 = 3
    .label __8 = $1c
    .label __9 = $1c
    .label __11 = $13
    .label __12 = $13
    .label __13 = $13
    .label __15 = $15
    .label __16 = $15
    .label __17 = $15
    .label __21 = $18
    .label center_x = $1e
    .label center_y = $b
    .label i = 2
    .label offset = $c
    .label colPtr = $10
    .label spriteCol = $12
    .label screenPtr = $c
    .label spriteData = 3
    .label chargenData = $1c
    .label spriteX = $13
    .label spriteY = $15
    .label spritePtr = $17
    // Busy-wait while finding an empty slot in the PROCESSING array
    .label freeIdx = 2
    .label __44 = $e
    .label __45 = $c
    ldx #$ff
  __b1:
    lda #0
    sta.z i
  __b2:
    lda.z i
    asl
    clc
    adc.z i
    asl
    clc
    adc.z i
    asl
    tay
    lda #STATUS_FREE
    cmp PROCESSING+OFFSET_STRUCT_PROCESSINGSPRITE_STATUS,y
    beq !__b3+
    jmp __b3
  !__b3:
  __b4:
    lda #$ff
    cmp.z freeIdx
    bne !__b8+
    jmp __b8
  !__b8:
    lda.z center_y
    sta.z __0
    lda #0
    sta.z __0+1
    lda.z __0
    asl
    sta.z __44
    lda.z __0+1
    rol
    sta.z __44+1
    asl.z __44
    rol.z __44+1
    lda.z __45
    clc
    adc.z __44
    sta.z __45
    lda.z __45+1
    adc.z __44+1
    sta.z __45+1
    asl.z __1
    rol.z __1+1
    asl.z __1
    rol.z __1+1
    asl.z __1
    rol.z __1+1
    lda.z center_x
    clc
    adc.z offset
    sta.z offset
    bcc !+
    inc.z offset+1
  !:
    lda.z offset
    clc
    adc #<COLS
    sta.z colPtr
    lda.z offset+1
    adc #>COLS
    sta.z colPtr+1
    ldy #0
    lda (colPtr),y
    sta.z spriteCol
    clc
    lda.z screenPtr
    adc #<SCREEN
    sta.z screenPtr
    lda.z screenPtr+1
    adc #>SCREEN
    sta.z screenPtr+1
    lda.z freeIdx
    sta.z __5
    tya
    sta.z __5+1
    asl.z __6
    rol.z __6+1
    asl.z __6
    rol.z __6+1
    asl.z __6
    rol.z __6+1
    asl.z __6
    rol.z __6+1
    asl.z __6
    rol.z __6+1
    asl.z __6
    rol.z __6+1
    clc
    lda.z spriteData
    adc #<SPRITE_DATA
    sta.z spriteData
    lda.z spriteData+1
    adc #>SPRITE_DATA
    sta.z spriteData+1
    lda (screenPtr),y
    sta.z __8
    tya
    sta.z __8+1
    asl.z __9
    rol.z __9+1
    asl.z __9
    rol.z __9+1
    asl.z __9
    rol.z __9+1
    clc
    lda.z chargenData
    adc #<CHARGEN
    sta.z chargenData
    lda.z chargenData+1
    adc #>CHARGEN
    sta.z chargenData+1
    sei
    lda #PROCPORT_RAM_CHARROM
    sta PROCPORT
    ldx #0
  __b6:
    ldy #0
    lda (chargenData),y
    sta (spriteData),y
    lda #3
    clc
    adc.z spriteData
    sta.z spriteData
    bcc !+
    inc.z spriteData+1
  !:
    inc.z chargenData
    bne !+
    inc.z chargenData+1
  !:
    inx
    cpx #8
    bne __b6
    lda #PROCPORT_RAM_IO
    sta PROCPORT
    cli
    lda.z center_x
    sta.z __11
    lda #0
    sta.z __11+1
    asl.z __12
    rol.z __12+1
    asl.z __12
    rol.z __12+1
    asl.z __12
    rol.z __12+1
    lda #BORDER_XPOS_LEFT
    clc
    adc.z __13
    sta.z __13
    bcc !+
    inc.z __13+1
  !:
    asl.z spriteX
    rol.z spriteX+1
    asl.z spriteX
    rol.z spriteX+1
    asl.z spriteX
    rol.z spriteX+1
    asl.z spriteX
    rol.z spriteX+1
    lda.z center_y
    sta.z __15
    lda #0
    sta.z __15+1
    asl.z __16
    rol.z __16+1
    asl.z __16
    rol.z __16+1
    asl.z __16
    rol.z __16+1
    lda #BORDER_YPOS_TOP
    clc
    adc.z __17
    sta.z __17
    bcc !+
    inc.z __17+1
  !:
    asl.z spriteY
    rol.z spriteY+1
    asl.z spriteY
    rol.z spriteY+1
    asl.z spriteY
    rol.z spriteY+1
    asl.z spriteY
    rol.z spriteY+1
    lax.z freeIdx
    axs #-[SPRITE_DATA/$40]
    stx.z spritePtr
    lda.z freeIdx
    asl
    asl
    asl
    sta.z __21
    lda #0
    sta.z __21+1
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
    lda.z __21
    sta PROCESSING+OFFSET_STRUCT_PROCESSINGSPRITE_VX,x
    lda.z __21+1
    sta PROCESSING+OFFSET_STRUCT_PROCESSINGSPRITE_VX+1,x
    lda #$3c
    sta PROCESSING+OFFSET_STRUCT_PROCESSINGSPRITE_VY,x
    lda #0
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
    rts
  __b8:
    ldx.z freeIdx
    jmp __b1
  __b3:
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
    .label __8 = $18
    .label __9 = $18
    .label __10 = $18
    .label screen_line = $1c
    .label dist_line = 3
    .label y = 2
    .label return_x = $17
    .label return_y = $b
    .label closest_dist = $12
    .label closest_x = $17
    .label closest_y = $b
    .label __12 = $1a
    .label __13 = $18
    lda.z SCREEN_COPY
    sta.z screen_line
    lda.z SCREEN_COPY+1
    sta.z screen_line+1
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
    lda (screen_line),y
    cmp #' '
    bne !__b11+
    jmp __b11
  !__b11:
    lda (dist_line),y
    tax
    cpx.z closest_dist
    bcs __b12
    sty.z return_x
    lda.z y
    sta.z return_y
  __b3:
    iny
    cpy #$28
    bne __b10
    lda #$28
    clc
    adc.z screen_line
    sta.z screen_line
    bcc !+
    inc.z screen_line+1
  !:
    lda #$28
    clc
    adc.z dist_line
    sta.z dist_line
    bcc !+
    inc.z dist_line+1
  !:
    inc.z y
    lda #$19
    cmp.z y
    bne __b9
    cpx #NOT_FOUND
    beq __breturn
    lda.z return_y
    sta.z __8
    lda #0
    sta.z __8+1
    lda.z __8
    asl
    sta.z __12
    lda.z __8+1
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
    asl.z __9
    rol.z __9+1
    asl.z __9
    rol.z __9+1
    asl.z __9
    rol.z __9+1
    lda.z __10
    clc
    adc.z SCREEN_COPY
    sta.z __10
    lda.z __10+1
    adc.z SCREEN_COPY+1
    sta.z __10+1
    // clear the found char on the screen copy
    lda #' '
    ldy.z return_x
    sta (__10),y
  __breturn:
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
    sei
    // Disable kernal & basic
    lda #PROCPORT_DDR_MEMORY_MASK
    sta PROCPORT_DDR
    lda #PROCPORT_RAM_IO
    sta PROCPORT
    // Disable CIA 1 Timer IRQ
    lda #CIA_INTERRUPT_CLEAR
    sta CIA1_INTERRUPT
    lda #$7f
    and VIC_CONTROL
    sta VIC_CONTROL
    lda #RASTER_IRQ_TOP
    sta RASTER
    // Enable Raster Interrupt
    lda #IRQ_RASTER
    sta IRQ_ENABLE
    // Set the IRQ routine
    lda #<irqRoutine
    sta HARDWARE_IRQ
    lda #>irqRoutine
    sta HARDWARE_IRQ+1
    cli
    rts
}
// Initialize sprites
initSprites: {
    .label sp = $1c
    lda #<SPRITE_DATA
    sta.z sp
    lda #>SPRITE_DATA
    sta.z sp+1
  // Clear sprite data
  __b1:
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
    lda #LIGHT_BLUE
    sta SPRITES_COLS,x
    inx
    cpx #8
    bne __b3
    lda #0
    sta SPRITES_MC
    sta SPRITES_EXPAND_X
    sta SPRITES_EXPAND_Y
    rts
  __b2:
    lda #0
    tay
    sta (sp),y
    inc.z sp
    bne !+
    inc.z sp+1
  !:
    jmp __b1
}
// Populates 1000 bytes (a screen) with values representing the angle to the center.
// Utilizes symmetry around the  center
// init_angle_screen(byte* zeropage($18) screen)
init_angle_screen: {
    .label __11 = $10
    .label screen = $18
    .label screen_topline = 3
    .label screen_bottomline = $18
    .label xw = $1a
    .label yw = $1c
    .label angle_w = $10
    .label ang_w = $1e
    .label x = $12
    .label xb = $17
    .label y = 2
    lda.z screen
    clc
    adc #<$28*$c
    sta.z screen_topline
    lda.z screen+1
    adc #>$28*$c
    sta.z screen_topline+1
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
    lda.z x
    cmp #$13+1
    bcc __b3
    lda.z screen_topline
    sec
    sbc #<$28
    sta.z screen_topline
    lda.z screen_topline+1
    sbc #>$28
    sta.z screen_topline+1
    lda #$28
    clc
    adc.z screen_bottomline
    sta.z screen_bottomline
    bcc !+
    inc.z screen_bottomline+1
  !:
    inc.z y
    lda #$d
    cmp.z y
    bne __b1
    rts
  __b3:
    lda.z x
    asl
    eor #$ff
    clc
    adc #$27+1
    ldy #0
    sta.z xw+1
    sty.z xw
    lda.z y
    asl
    sta.z yw+1
    sty.z yw
    jsr atan2_16
    lda #$80
    clc
    adc.z __11
    sta.z __11
    bcc !+
    inc.z __11+1
  !:
    lda.z __11+1
    sta.z ang_w
    ldy.z xb
    sta (screen_bottomline),y
    eor #$ff
    clc
    adc #1
    sta (screen_topline),y
    lda #$80
    clc
    adc.z ang_w
    ldy.z x
    sta (screen_topline),y
    lda #$80
    sec
    sbc.z ang_w
    sta (screen_bottomline),y
    inc.z x
    dec.z xb
    jmp __b2
}
// Find the atan2(x, y) - which is the angle of the line from (0,0) to (x,y)
// Finding the angle requires a binary search using CORDIC_ITERATIONS_16
// Returns the angle in hex-degrees (0=0, 0x8000=PI, 0x10000=2*PI)
// atan2_16(signed word zeropage($1a) x, signed word zeropage($1c) y)
atan2_16: {
    .label __2 = $c
    .label __7 = $e
    .label yi = $c
    .label xi = $e
    .label angle = $10
    .label xd = $15
    .label yd = $13
    .label return = $10
    .label x = $1a
    .label y = $1c
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
    lda.z yi+1
    bne __b11
    lda.z yi
    bne __b11
  __b12:
    lsr.z angle+1
    ror.z angle
    lda.z x+1
    bpl __b7
    sec
    lda #<$8000
    sbc.z angle
    sta.z angle
    lda #>$8000
    sbc.z angle+1
    sta.z angle+1
  __b7:
    lda.z y+1
    bpl __b8
    sec
    lda #0
    sbc.z angle
    sta.z angle
    lda #0
    sbc.z angle+1
    sta.z angle+1
  __b8:
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
    cpy #2
    bcs __b14
    cpy #0
    beq __b17
    lda.z xd+1
    cmp #$80
    ror.z xd+1
    ror.z xd
    lda.z yd+1
    cmp #$80
    ror.z yd+1
    ror.z yd
  __b17:
    lda.z yi+1
    bpl __b18
    lda.z xi
    sec
    sbc.z yd
    sta.z xi
    lda.z xi+1
    sbc.z yd+1
    sta.z xi+1
    lda.z yi
    clc
    adc.z xd
    sta.z yi
    lda.z yi+1
    adc.z xd+1
    sta.z yi+1
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
    inx
    cpx #CORDIC_ITERATIONS_16-1+1
    bne !__b12+
    jmp __b12
  !__b12:
    jmp __b10
  __b18:
    lda.z xi
    clc
    adc.z yd
    sta.z xi
    lda.z xi+1
    adc.z yd+1
    sta.z xi+1
    lda.z yi
    sec
    sbc.z xd
    sta.z yi
    lda.z yi+1
    sbc.z xd+1
    sta.z yi+1
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
    lda.z xd+1
    cmp #$80
    ror.z xd+1
    ror.z xd
    lda.z xd+1
    cmp #$80
    ror.z xd+1
    ror.z xd
    lda.z yd+1
    cmp #$80
    ror.z yd+1
    ror.z yd
    lda.z yd+1
    cmp #$80
    ror.z yd+1
    ror.z yd
    dey
    dey
    jmp __b13
  __b4:
    lda.z x
    sta.z xi
    lda.z x+1
    sta.z xi+1
    jmp __b6
  __b1:
    lda.z y
    sta.z yi
    lda.z y+1
    sta.z yi+1
    jmp __b3
}
// Allocates a block of size bytes of memory, returning a pointer to the beginning of the block.
// The content of the newly allocated block of memory is not initialized, remaining with indeterminate values.
malloc: {
    .label mem = 9
    lda.z heap_head
    sec
    sbc #<$3e8
    sta.z mem
    lda.z heap_head+1
    sbc #>$3e8
    sta.z mem+1
    lda.z mem
    sta.z heap_head
    lda.z mem+1
    sta.z heap_head+1
    rts
}
// Raster Interrupt at the bottom of the screen
irqBottom: {
    sta rega+1
    stx regx+1
    sty regy+1
    jsr processChars
    // Trigger IRQ at the top of the screen
    lda #RASTER_IRQ_TOP
    sta RASTER
    lda #<irqTop
    sta HARDWARE_IRQ
    lda #>irqTop
    sta HARDWARE_IRQ+1
    // Acknowledge the IRQ
    lda #IRQ_RASTER
    sta IRQ_STATUS
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
    .label __13 = $24
    .label __23 = $22
    .label processing = $1f
    .label bitmask = $21
    .label i = 5
    .label xpos = $22
    .label ypos = $26
    .label numActive = 6
    lda #0
    sta.z numActive
    sta.z i
  __b1:
    lda.z i
    asl
    clc
    adc.z i
    asl
    clc
    adc.z i
    asl
    clc
    adc #<PROCESSING
    sta.z processing
    lda #>PROCESSING
    adc #0
    sta.z processing+1
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
    ldy #OFFSET_STRUCT_PROCESSINGSPRITE_STATUS
    lda (processing),y
    cmp #STATUS_FREE
    bne !__b2+
    jmp __b2
  !__b2:
    lda (processing),y
    cmp #STATUS_NEW
    bne __b3
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
    // Enable the sprite
    lda SPRITES_ENABLE
    ora.z bitmask
    sta SPRITES_ENABLE
    // Set the sprite color
    ldy #OFFSET_STRUCT_PROCESSINGSPRITE_COL
    lda (processing),y
    ldy #OFFSET_STRUCT_PROCESSINGSPRITE_ID
    pha
    lda (processing),y
    tay
    pla
    sta SPRITES_COLS,y
    // Set sprite pointer
    ldy #OFFSET_STRUCT_PROCESSINGSPRITE_PTR
    lda (processing),y
    ldy #OFFSET_STRUCT_PROCESSINGSPRITE_ID
    pha
    lda (processing),y
    tay
    pla
    sta SCREEN+SPRITE_PTRS,y
    // Set status
    lda #STATUS_PROCESSING
    ldy #OFFSET_STRUCT_PROCESSINGSPRITE_STATUS
    sta (processing),y
  __b3:
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
    lda.z xpos+1
    // Set sprite position
    cmp #0
    beq !__b4+
    jmp __b4
  !__b4:
    lda #$ff
    eor.z bitmask
    and SPRITES_XMSB
    sta SPRITES_XMSB
  __b5:
    lda.z i
    asl
    tax
    lda.z xpos
    sta SPRITES_XPOS,x
    ldy #OFFSET_STRUCT_PROCESSINGSPRITE_Y
    lda (processing),y
    sta.z __13
    iny
    lda (processing),y
    sta.z __13+1
    lsr.z __13+1
    ror.z __13
    lsr.z __13+1
    ror.z __13
    lsr.z __13+1
    ror.z __13
    lsr.z __13+1
    ror.z __13
    lda.z __13
    sta.z ypos
    sta SPRITES_YPOS,x
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
    lsr.z __23+1
    ror.z __23
    lsr.z __23+1
    ror.z __23
    lsr.z __23+1
    ror.z __23
    lda.z __23
    sec
    sbc #BORDER_XPOS_LEFT/8
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
    lda.z ypos
    lsr
    lsr
    lsr
    sec
    sbc #BORDER_YPOS_TOP/8
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
    inc.z numActive
  __b2:
    inc.z i
    lda #NUM_PROCESSING-1+1
    cmp.z i
    beq !__b1+
    jmp __b1
  !__b1:
    rts
  __b6:
    // Set status to FREE
    lda #STATUS_FREE
    ldy #OFFSET_STRUCT_PROCESSINGSPRITE_STATUS
    sta (processing),y
    lda #$ff
    eor.z bitmask
    // Disable the sprite
    and SPRITES_ENABLE
    sta SPRITES_ENABLE
    jmp __b7
  __b4:
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
    // Trigger IRQ at the middle of the screen
    lda #RASTER_IRQ_MIDDLE
    sta RASTER
    lda #<irqBottom
    sta HARDWARE_IRQ
    lda #>irqBottom
    sta HARDWARE_IRQ+1
    // Acknowledge the IRQ
    lda #IRQ_RASTER
    sta IRQ_STATUS
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
