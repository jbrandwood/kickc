// Clears start screen throwing around the letters (by turning them into sprites)
.pc = $801 "Basic"
:BasicUpstart(bbegin)
.pc = $80d "Program"
  .const STATUS_FREE = 0
  .const STATUS_NEW = 1
  .const STATUS_PROCESSING = 2
  .const OFFSET_STRUCT_PROCESSINGSPRITE_Y = 2
  .const OFFSET_STRUCT_PROCESSINGSPRITE_VX = 4
  .const OFFSET_STRUCT_PROCESSINGSPRITE_VY = 6
  .const OFFSET_STRUCT_PROCESSINGSPRITE_ID = 8
  .const OFFSET_STRUCT_PROCESSINGSPRITE_PTR = 9
  .const OFFSET_STRUCT_PROCESSINGSPRITE_COL = $a
  .const OFFSET_STRUCT_PROCESSINGSPRITE_STATUS = $b
  .const OFFSET_STRUCT_PROCESSINGSPRITE_SCREENPTR = $c
  // Start of the heap used by malloc()
  .label HEAP_START = $c000
  // The number of iterations performed during 16-bit CORDIC atan2 calculation
  .const CORDIC_ITERATIONS_16 = $f
  // Processor port data direction register
  .label PROCPORT_DDR = 0
  // Mask for PROCESSOR_PORT_DDR which allows only memory configuration to be written
  .const PROCPORT_DDR_MEMORY_MASK = 7
  // Processor Port Register controlling RAM/ROM configuration and the datasette
  .label PROCPORT = 1
  // RAM in $A000, $E000 I/O in $D000
  .const PROCPORT_RAM_IO = $35
  // RAM in $A000, $E000 CHAR ROM in $D000
  .const PROCPORT_RAM_CHARROM = $31
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
  .const RASTER_IRQ_TOP = $30
  .const RASTER_IRQ_MIDDLE = $ff
  .const XPOS_RIGHTMOST = BORDER_XPOS_RIGHT<<4
  .const YPOS_BOTTOMMOST = BORDER_YPOS_BOTTOM<<4
  .const XPOS_LEFTMOST = BORDER_XPOS_LEFT-8<<4
  .const YPOS_TOPMOST = BORDER_YPOS_TOP-8<<4
  .label heap_head = $27
  .label SCREEN_COPY = $2b
  .label SCREEN_DIST = $2d
bbegin:
  lda #<HEAP_START
  sta heap_head
  lda #>HEAP_START
  sta heap_head+1
  jsr malloc
  lda malloc.mem
  sta SCREEN_COPY
  lda malloc.mem+1
  sta SCREEN_COPY+1
  jsr malloc
  jsr main
  rts
main: {
    .label dst = 4
    .label src = 2
    .label i = 6
    .label center_y = $2f
    lda SCREEN_DIST
    sta init_angle_screen.screen
    lda SCREEN_DIST+1
    sta init_angle_screen.screen+1
    jsr init_angle_screen
    lda SCREEN_COPY
    sta dst
    lda SCREEN_COPY+1
    sta dst+1
    lda #<SCREEN
    sta src
    lda #>SCREEN
    sta src+1
  // Copy screen to screen copy
  b1:
    ldy #0
    lda (src),y
    sta (dst),y
    inc src
    bne !+
    inc src+1
  !:
    inc dst
    bne !+
    inc dst+1
  !:
    lda src+1
    cmp #>SCREEN+$3e8
    bne b1
    lda src
    cmp #<SCREEN+$3e8
    bne b1
    lda #0
    sta i
  // Init processing array
  b2:
    lda i
    asl
    clc
    adc i
    asl
    clc
    adc i
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
    inc i
    lda #NUM_PROCESSING-1+1
    cmp i
    bne b2
    jsr initSprites
    jsr setupRasterIrq
  b3:
  // Main loop
    jsr getCharToProcess
    ldy getCharToProcess.return_x
    lda getCharToProcess.return_y
    sta center_y
    txa
    cmp #NOT_FOUND
    bne b5
    lda #'.'
    sta SCREEN+$3e7
  b7:
    inc COLS+$3e7
    jmp b7
  b5:
    sty startProcessing.center_x
    jsr startProcessing
    jmp b3
}
// Start processing a char - by inserting it into the PROCESSING array
// startProcessing(byte zeropage($30) center_x, byte zeropage($2f) center_y)
startProcessing: {
    .label _0 = $31
    .label _1 = $31
    .label _5 = $a
    .label _6 = $a
    .label _8 = 8
    .label _9 = 8
    .label _11 = $38
    .label _12 = $38
    .label _13 = $38
    .label _15 = $3a
    .label _16 = $3a
    .label _17 = $3a
    .label _23 = $3d
    .label center_x = $30
    .label center_y = $2f
    .label i = 7
    .label offset = $31
    .label colPtr = $35
    .label spriteCol = $37
    .label screenPtr = $31
    .label spriteData = $a
    .label chargenData = 8
    .label spriteX = $38
    .label spriteY = $3a
    .label spritePtr = $3c
    .label freeIdx = 7
    .label _47 = $33
    .label _48 = $31
    ldx #$ff
  b1:
    lda #0
    sta i
  b2:
    lda i
    asl
    clc
    adc i
    asl
    clc
    adc i
    asl
    tay
    lda #STATUS_FREE
    cmp PROCESSING+OFFSET_STRUCT_PROCESSINGSPRITE_STATUS,y
    beq !b3+
    jmp b3
  !b3:
  b4:
    lda #$ff
    cmp freeIdx
    bne !b8+
    jmp b8
  !b8:
    lda center_y
    sta _0
    lda #0
    sta _0+1
    lda _0
    asl
    sta _47
    lda _0+1
    rol
    sta _47+1
    asl _47
    rol _47+1
    lda _48
    clc
    adc _47
    sta _48
    lda _48+1
    adc _47+1
    sta _48+1
    asl _1
    rol _1+1
    asl _1
    rol _1+1
    asl _1
    rol _1+1
    lda center_x
    clc
    adc offset
    sta offset
    bcc !+
    inc offset+1
  !:
    lda offset
    clc
    adc #<COLS
    sta colPtr
    lda offset+1
    adc #>COLS
    sta colPtr+1
    ldy #0
    lda (colPtr),y
    sta spriteCol
    clc
    lda screenPtr
    adc #<SCREEN
    sta screenPtr
    lda screenPtr+1
    adc #>SCREEN
    sta screenPtr+1
    lda freeIdx
    sta _5
    tya
    sta _5+1
    asl _6
    rol _6+1
    asl _6
    rol _6+1
    asl _6
    rol _6+1
    asl _6
    rol _6+1
    asl _6
    rol _6+1
    asl _6
    rol _6+1
    clc
    lda spriteData
    adc #<SPRITE_DATA
    sta spriteData
    lda spriteData+1
    adc #>SPRITE_DATA
    sta spriteData+1
    lda (screenPtr),y
    sta _8
    tya
    sta _8+1
    asl _9
    rol _9+1
    asl _9
    rol _9+1
    asl _9
    rol _9+1
    clc
    lda chargenData
    adc #<CHARGEN
    sta chargenData
    lda chargenData+1
    adc #>CHARGEN
    sta chargenData+1
    sei
    lda #PROCPORT_RAM_CHARROM
    sta PROCPORT
    ldx #0
  b6:
    ldy #0
    lda (chargenData),y
    sta (spriteData),y
    lda #3
    clc
    adc spriteData
    sta spriteData
    bcc !+
    inc spriteData+1
  !:
    inc chargenData
    bne !+
    inc chargenData+1
  !:
    inx
    cpx #8
    bne b6
    lda #PROCPORT_RAM_IO
    sta PROCPORT
    cli
    lda center_x
    sta _11
    lda #0
    sta _11+1
    asl _12
    rol _12+1
    asl _12
    rol _12+1
    asl _12
    rol _12+1
    lda #BORDER_XPOS_LEFT
    clc
    adc _13
    sta _13
    bcc !+
    inc _13+1
  !:
    asl spriteX
    rol spriteX+1
    asl spriteX
    rol spriteX+1
    asl spriteX
    rol spriteX+1
    asl spriteX
    rol spriteX+1
    lda center_y
    sta _15
    lda #0
    sta _15+1
    asl _16
    rol _16+1
    asl _16
    rol _16+1
    asl _16
    rol _16+1
    lda #BORDER_YPOS_TOP
    clc
    adc _17
    sta _17
    bcc !+
    inc _17+1
  !:
    asl spriteY
    rol spriteY+1
    asl spriteY
    rol spriteY+1
    asl spriteY
    rol spriteY+1
    asl spriteY
    rol spriteY+1
    lax freeIdx
    axs #-[SPRITE_DATA/$40]
    stx spritePtr
    lda freeIdx
    asl
    asl
    asl
    sta _23
    lda #0
    sta _23+1
    lda freeIdx
    asl
    clc
    adc freeIdx
    asl
    clc
    adc freeIdx
    asl
    tax
    lda spriteX
    sta PROCESSING,x
    lda spriteX+1
    sta PROCESSING+1,x
    lda spriteY
    sta PROCESSING+OFFSET_STRUCT_PROCESSINGSPRITE_Y,x
    lda spriteY+1
    sta PROCESSING+OFFSET_STRUCT_PROCESSINGSPRITE_Y+1,x
    lda _23
    sta PROCESSING+OFFSET_STRUCT_PROCESSINGSPRITE_VX,x
    lda _23+1
    sta PROCESSING+OFFSET_STRUCT_PROCESSINGSPRITE_VX+1,x
    lda #$3c
    sta PROCESSING+OFFSET_STRUCT_PROCESSINGSPRITE_VY,x
    lda #0
    sta PROCESSING+OFFSET_STRUCT_PROCESSINGSPRITE_VY+1,x
    lda freeIdx
    sta PROCESSING+OFFSET_STRUCT_PROCESSINGSPRITE_ID,x
    lda spritePtr
    sta PROCESSING+OFFSET_STRUCT_PROCESSINGSPRITE_PTR,x
    lda spriteCol
    sta PROCESSING+OFFSET_STRUCT_PROCESSINGSPRITE_COL,x
    lda #STATUS_NEW
    sta PROCESSING+OFFSET_STRUCT_PROCESSINGSPRITE_STATUS,x
    lda screenPtr
    sta PROCESSING+OFFSET_STRUCT_PROCESSINGSPRITE_SCREENPTR,x
    lda screenPtr+1
    sta PROCESSING+OFFSET_STRUCT_PROCESSINGSPRITE_SCREENPTR+1,x
    rts
  b8:
    ldx freeIdx
    jmp b1
  b3:
    inc i
    lda #NUM_PROCESSING-1+1
    cmp i
    beq !b2+
    jmp b2
  !b2:
    stx freeIdx
    jmp b4
}
// Find the non-space char closest to the center of the screen
// If no non-space char is found the distance will be 0xffff
getCharToProcess: {
    .label _8 = $3f
    .label _9 = $3f
    .label _10 = $3f
    .label screen_line = $c
    .label dist_line = $e
    .label y = $10
    .label return_x = $12
    .label return_y = $13
    .label closest_dist = $11
    .label closest_x = $12
    .label closest_y = $13
    .label _12 = $41
    .label _13 = $3f
    lda SCREEN_COPY
    sta screen_line
    lda SCREEN_COPY+1
    sta screen_line+1
    lda SCREEN_DIST
    sta dist_line
    lda SCREEN_DIST+1
    sta dist_line+1
    lda #0
    sta closest_y
    sta closest_x
    sta y
    lda #NOT_FOUND
    sta closest_dist
  b1:
    ldy #0
  b2:
    lda (screen_line),y
    cmp #' '
    bne !b11+
    jmp b11
  !b11:
    lda (dist_line),y
    tax
    cpx closest_dist
    bcs b12
    sty return_x
    lda y
    sta return_y
  b3:
    iny
    cpy #$28
    bne b10
    lda #$28
    clc
    adc screen_line
    sta screen_line
    bcc !+
    inc screen_line+1
  !:
    lda #$28
    clc
    adc dist_line
    sta dist_line
    bcc !+
    inc dist_line+1
  !:
    inc y
    lda #$19
    cmp y
    bne b9
    cpx #NOT_FOUND
    beq breturn
    lda return_y
    sta _8
    lda #0
    sta _8+1
    lda _8
    asl
    sta _12
    lda _8+1
    rol
    sta _12+1
    asl _12
    rol _12+1
    lda _13
    clc
    adc _12
    sta _13
    lda _13+1
    adc _12+1
    sta _13+1
    asl _9
    rol _9+1
    asl _9
    rol _9+1
    asl _9
    rol _9+1
    lda _10
    clc
    adc SCREEN_COPY
    sta _10
    lda _10+1
    adc SCREEN_COPY+1
    sta _10+1
    // clear the found char on the screen copy
    lda #' '
    ldy return_x
    sta (_10),y
  breturn:
    rts
  b9:
    stx closest_dist
    jmp b1
  b10:
    stx closest_dist
    jmp b2
  b12:
    ldx closest_dist
    jmp b3
  b11:
    ldx closest_dist
    jmp b3
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
    .label sp = $14
    lda #<SPRITE_DATA
    sta sp
    lda #>SPRITE_DATA
    sta sp+1
  // Clear sprite data
  b1:
    lda #0
    tay
    sta (sp),y
    inc sp
    bne !+
    inc sp+1
  !:
    lda sp+1
    cmp #>SPRITE_DATA+NUM_PROCESSING*$40
    bcc b1
    bne !+
    lda sp
    cmp #<SPRITE_DATA+NUM_PROCESSING*$40
    bcc b1
  !:
    ldx #0
  // Initialize sprite registers
  b2:
    lda #LIGHT_BLUE
    sta SPRITES_COLS,x
    inx
    cpx #8
    bne b2
    lda #0
    sta SPRITES_MC
    sta SPRITES_EXPAND_X
    sta SPRITES_EXPAND_Y
    rts
}
// Populates 1000 bytes (a screen) with values representing the angle to the center.
// Utilizes symmetry around the  center
// init_angle_screen(byte* zeropage($17) screen)
init_angle_screen: {
    .label _10 = $21
    .label screen = $17
    .label screen_topline = $19
    .label screen_bottomline = $17
    .label xw = $43
    .label yw = $45
    .label angle_w = $21
    .label ang_w = $47
    .label x = $1b
    .label xb = $1c
    .label y = $16
    lda screen
    clc
    adc #<$28*$c
    sta screen_topline
    lda screen+1
    adc #>$28*$c
    sta screen_topline+1
    clc
    lda screen_bottomline
    adc #<$28*$c
    sta screen_bottomline
    lda screen_bottomline+1
    adc #>$28*$c
    sta screen_bottomline+1
    lda #0
    sta y
  b1:
    lda #$27
    sta xb
    lda #0
    sta x
  b2:
    lda x
    asl
    eor #$ff
    clc
    adc #$27+1
    ldy #0
    sta xw+1
    sty xw
    lda y
    asl
    sta yw+1
    sty yw
    jsr atan2_16
    lda #$80
    clc
    adc _10
    sta _10
    bcc !+
    inc _10+1
  !:
    lda _10+1
    sta ang_w
    ldy xb
    sta (screen_bottomline),y
    eor #$ff
    clc
    adc #1
    sta (screen_topline),y
    lda #$80
    clc
    adc ang_w
    ldy x
    sta (screen_topline),y
    lda #$80
    sec
    sbc ang_w
    sta (screen_bottomline),y
    inc x
    dec xb
    lda x
    cmp #$13+1
    bcc b2
    lda screen_topline
    sec
    sbc #<$28
    sta screen_topline
    lda screen_topline+1
    sbc #>$28
    sta screen_topline+1
    lda #$28
    clc
    adc screen_bottomline
    sta screen_bottomline
    bcc !+
    inc screen_bottomline+1
  !:
    inc y
    lda #$d
    cmp y
    bne b1
    rts
}
// Find the atan2(x, y) - which is the angle of the line from (0,0) to (x,y)
// Finding the angle requires a binary search using CORDIC_ITERATIONS_16
// Returns the angle in hex-degrees (0=0, 0x8000=PI, 0x10000=2*PI)
// atan2_16(signed word zeropage($43) x, signed word zeropage($45) y)
atan2_16: {
    .label _2 = $1d
    .label _7 = $1f
    .label yi = $1d
    .label xi = $1f
    .label angle = $21
    .label xd = $25
    .label yd = $23
    .label return = $21
    .label x = $43
    .label y = $45
    lda y+1
    bmi !b1+
    jmp b1
  !b1:
    sec
    lda #0
    sbc y
    sta _2
    lda #0
    sbc y+1
    sta _2+1
  b3:
    lda x+1
    bmi !b4+
    jmp b4
  !b4:
    sec
    lda #0
    sbc x
    sta _7
    lda #0
    sbc x+1
    sta _7+1
  b6:
    lda #0
    sta angle
    sta angle+1
    tax
  b10:
    lda yi+1
    bne b11
    lda yi
    bne b11
  b12:
    lsr angle+1
    ror angle
    lda x+1
    bpl b7
    sec
    lda #<$8000
    sbc angle
    sta angle
    lda #>$8000
    sbc angle+1
    sta angle+1
  b7:
    lda y+1
    bpl b8
    sec
    lda #0
    sbc angle
    sta angle
    lda #0
    sbc angle+1
    sta angle+1
  b8:
    rts
  b11:
    txa
    tay
    lda xi
    sta xd
    lda xi+1
    sta xd+1
    lda yi
    sta yd
    lda yi+1
    sta yd+1
  b13:
    cpy #2
    bcs b14
    cpy #0
    beq b17
    lda xd+1
    cmp #$80
    ror xd+1
    ror xd
    lda yd+1
    cmp #$80
    ror yd+1
    ror yd
  b17:
    lda yi+1
    bpl b18
    lda xi
    sec
    sbc yd
    sta xi
    lda xi+1
    sbc yd+1
    sta xi+1
    lda yi
    clc
    adc xd
    sta yi
    lda yi+1
    adc xd+1
    sta yi+1
    txa
    asl
    tay
    sec
    lda angle
    sbc CORDIC_ATAN2_ANGLES_16,y
    sta angle
    lda angle+1
    sbc CORDIC_ATAN2_ANGLES_16+1,y
    sta angle+1
  b19:
    inx
    cpx #CORDIC_ITERATIONS_16-1+1
    bne !b12+
    jmp b12
  !b12:
    jmp b10
  b18:
    lda xi
    clc
    adc yd
    sta xi
    lda xi+1
    adc yd+1
    sta xi+1
    lda yi
    sec
    sbc xd
    sta yi
    lda yi+1
    sbc xd+1
    sta yi+1
    txa
    asl
    tay
    clc
    lda angle
    adc CORDIC_ATAN2_ANGLES_16,y
    sta angle
    lda angle+1
    adc CORDIC_ATAN2_ANGLES_16+1,y
    sta angle+1
    jmp b19
  b14:
    lda xd+1
    cmp #$80
    ror xd+1
    ror xd
    lda xd+1
    cmp #$80
    ror xd+1
    ror xd
    lda yd+1
    cmp #$80
    ror yd+1
    ror yd
    lda yd+1
    cmp #$80
    ror yd+1
    ror yd
    dey
    dey
    jmp b13
  b4:
    lda x
    sta xi
    lda x+1
    sta xi+1
    jmp b6
  b1:
    lda y
    sta yi
    lda y+1
    sta yi+1
    jmp b3
}
// Allocates a block of size bytes of memory, returning a pointer to the beginning of the block.
// The content of the newly allocated block of memory is not initialized, remaining with indeterminate values.
malloc: {
    .label mem = $2d
    lda heap_head
    sta mem
    lda heap_head+1
    sta mem+1
    clc
    lda heap_head
    adc #<$3e8
    sta heap_head
    lda heap_head+1
    adc #>$3e8
    sta heap_head+1
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
    .label _15 = $4d
    .label _25 = $4b
    .label processing = $48
    .label bitmask = $4a
    .label i = $29
    .label xpos = $4b
    .label ypos = $4f
    .label numActive = $2a
    lda #0
    sta numActive
    sta i
  b1:
    lda i
    asl
    clc
    adc i
    asl
    clc
    adc i
    asl
    clc
    adc #<PROCESSING
    sta processing
    lda #>PROCESSING
    adc #0
    sta processing+1
    ldy #OFFSET_STRUCT_PROCESSINGSPRITE_ID
    lda (processing),y
    tax
    lda #1
    cpx #0
    beq !e+
  !:
    asl
    dex
    bne !-
  !e:
    sta bitmask
    ldy #OFFSET_STRUCT_PROCESSINGSPRITE_STATUS
    lda (processing),y
    cmp #STATUS_FREE
    bne !b2+
    jmp b2
  !b2:
    lda (processing),y
    cmp #STATUS_NEW
    bne b3
    // Clear the char on the screen
    ldx #' '
    ldy #OFFSET_STRUCT_PROCESSINGSPRITE_SCREENPTR
    lda (processing),y
    sta !++1
    iny
    lda (processing),y
    sta !++2
    txa
  !:
    sta $ffff
    // Enable the sprite
    lda SPRITES_ENABLE
    ora bitmask
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
  b3:
    ldy #0
    lda (processing),y
    sta xpos
    iny
    lda (processing),y
    sta xpos+1
    lsr xpos+1
    ror xpos
    lsr xpos+1
    ror xpos
    lsr xpos+1
    ror xpos
    lsr xpos+1
    ror xpos
    lda xpos+1
    // Set sprite position
    cmp #0
    beq !b4+
    jmp b4
  !b4:
    lda #$ff
    eor bitmask
    and SPRITES_XMSB
    sta SPRITES_XMSB
  b5:
    lda i
    asl
    tax
    lda xpos
    sta SPRITES_XPOS,x
    ldy #OFFSET_STRUCT_PROCESSINGSPRITE_Y
    lda (processing),y
    sta _15
    iny
    lda (processing),y
    sta _15+1
    lsr _15+1
    ror _15
    lsr _15+1
    ror _15
    lsr _15+1
    ror _15
    lsr _15+1
    ror _15
    lda _15
    sta ypos
    sta SPRITES_YPOS,x
    // Move sprite
    ldy #1
    lda (processing),y
    cmp #>XPOS_LEFTMOST
    bcs !b6+
    jmp b6
  !b6:
    bne !+
    dey
    lda (processing),y
    cmp #<XPOS_LEFTMOST
    bcs !b6+
    jmp b6
  !b6:
  !:
    ldy #1
    lda #>XPOS_RIGHTMOST
    cmp (processing),y
    bcs !b6+
    jmp b6
  !b6:
    bne !+
    dey
    lda #<XPOS_RIGHTMOST
    cmp (processing),y
    bcs !b6+
    jmp b6
  !b6:
  !:
    ldy #OFFSET_STRUCT_PROCESSINGSPRITE_Y
    iny
    lda (processing),y
    cmp #>YPOS_TOPMOST
    bcs !b6+
    jmp b6
  !b6:
    bne !+
    dey
    lda (processing),y
    cmp #<YPOS_TOPMOST
    bcs !b6+
    jmp b6
  !b6:
  !:
    ldy #OFFSET_STRUCT_PROCESSINGSPRITE_Y
    iny
    lda #>YPOS_BOTTOMMOST
    cmp (processing),y
    bcs !b6+
    jmp b6
  !b6:
    bne !+
    dey
    lda #<YPOS_BOTTOMMOST
    cmp (processing),y
    bcc b6
  !:
    lsr _25+1
    ror _25
    lsr _25+1
    ror _25
    lsr _25+1
    ror _25
    lda _25
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
    sty $ff
    clc
    lda (processing),y
    ldy #0
    adc (processing),y
    sta (processing),y
    ldy $ff
    iny
    lda (processing),y
    ldy #1
    adc (processing),y
    sta (processing),y
    lda ypos
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
  b7:
    inc numActive
  b2:
    inc i
    lda #NUM_PROCESSING-1+1
    cmp i
    beq !b1+
    jmp b1
  !b1:
    rts
  b6:
    // Set status to FREE
    lda #STATUS_FREE
    ldy #OFFSET_STRUCT_PROCESSINGSPRITE_STATUS
    sta (processing),y
    lda #$ff
    eor bitmask
    // Disable the sprite
    and SPRITES_ENABLE
    sta SPRITES_ENABLE
    jmp b7
  b4:
    lda SPRITES_XMSB
    ora bitmask
    sta SPRITES_XMSB
    jmp b5
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
