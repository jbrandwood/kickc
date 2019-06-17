// Clears start screen throwing around the letters (by turning them into sprites)
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .const OFFSET_STRUCT_PROCESSINGSPRITE_Y = 2
  .const OFFSET_STRUCT_PROCESSINGSPRITE_VX = 4
  .const OFFSET_STRUCT_PROCESSINGSPRITE_VY = 6
  .const OFFSET_STRUCT_PROCESSINGSPRITE_ID = 8
  .const OFFSET_STRUCT_PROCESSINGSPRITE_PTR = 9
  .const OFFSET_STRUCT_PROCESSINGSPRITE_COL = $a
  .const OFFSET_STRUCT_PROCESSINGSPRITE_STATUS = $b
  .const OFFSET_STRUCT_PROCESSINGSPRITE_SCREENPTR = $c
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
  // Values added to VX
  .label VXSIN = $2200
  // Values added to VY
  .label VYSIN = $2280
  // Max number of chars processed at once
  .const NUM_PROCESSING = 8
  // Distance value meaning not found
  .const NOT_FOUND = $ffff
  // Values for ProcessingSprite.status
  .const STATUS_FREE = 0
  .const STATUS_NEW = 1
  .const STATUS_PROCESSING = 2
  .const RASTER_IRQ_TOP = $30
  .const RASTER_IRQ_MIDDLE = $ff
  .const XPOS_RIGHTMOST = BORDER_XPOS_RIGHT<<4
  .const YPOS_BOTTOMMOST = BORDER_YPOS_BOTTOM<<4
  .const XPOS_LEFTMOST = BORDER_XPOS_LEFT-8<<4
  .const YPOS_TOPMOST = BORDER_YPOS_TOP-8<<4
main: {
    .label src = 2
    .label dst = 4
    .label i = 6
    .label center_dist = $14
    jsr initSquareTables
    lda #<SCREEN_COPY
    sta dst
    lda #>SCREEN_COPY
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
    ldx getCharToProcess.return_x
    ldy getCharToProcess.return_y
    lda center_dist+1
    cmp #>NOT_FOUND
    bne b5
    lda center_dist
    cmp #<NOT_FOUND
    bne b5
    lda #'.'
    sta SCREEN+$3e7
  b7:
    inc COLS+$3e7
    jmp b7
  b5:
    stx startProcessing.center_x
    sty startProcessing.center_y
    jsr startProcessing
    jmp b3
}
// Start processing a char - by inserting it into the PROCESSING array
// startProcessing(byte zeropage($20) center_x, byte zeropage($21) center_y)
startProcessing: {
    .label _0 = $22
    .label _1 = $22
    .label _5 = $a
    .label _6 = $a
    .label _8 = 8
    .label _9 = 8
    .label _11 = $29
    .label _12 = $29
    .label _13 = $29
    .label _15 = $2b
    .label _16 = $2b
    .label _17 = $2b
    .label _23 = $2e
    .label center_x = $20
    .label center_y = $21
    .label i = 7
    .label offset = $22
    .label colPtr = $26
    .label spriteCol = $28
    .label screenPtr = $22
    .label spriteData = $a
    .label chargenData = 8
    .label spriteX = $29
    .label spriteY = $2b
    .label spritePtr = $2d
    .label freeIdx = 7
    .label _47 = $24
    .label _48 = $22
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
    .label _9 = $30
    .label _10 = $30
    .label _11 = $30
    .label return_dist = $14
    .label x = $f
    .label dist = $14
    .label screen_line = $c
    .label y = $e
    .label return_x = $12
    .label return_y = $13
    .label closest_dist = $10
    .label closest_x = $12
    .label closest_y = $13
    .label _15 = $32
    .label _16 = $30
    lda #0
    sta closest_y
    sta closest_x
    lda #<NOT_FOUND
    sta closest_dist
    lda #>NOT_FOUND
    sta closest_dist+1
    lda #0
    sta y
    lda #<SCREEN_COPY
    sta screen_line
    lda #>SCREEN_COPY
    sta screen_line+1
  b1:
    lda #0
    sta x
  b2:
    ldy x
    lda (screen_line),y
    cmp #' '
    bne !b11+
    jmp b11
  !b11:
    tya
    asl
    tax
    lda y
    asl
    tay
    lda SQUARES_X,x
    clc
    adc SQUARES_Y,y
    sta dist
    lda SQUARES_X+1,x
    adc SQUARES_Y+1,y
    sta dist+1
    lda closest_dist+1
    cmp dist+1
    bne !+
    lda closest_dist
    cmp dist
    bne !b12+
    jmp b12
  !b12:
  !:
    bcs !b12+
    jmp b12
  !b12:
    lda x
    sta return_x
    lda y
    sta return_y
  b3:
    inc x
    lda #$28
    cmp x
    bne b10
    clc
    adc screen_line
    sta screen_line
    bcc !+
    inc screen_line+1
  !:
    inc y
    lda #$19
    cmp y
    bne b9
    lda return_dist
    cmp #<NOT_FOUND
    bne !+
    lda return_dist+1
    cmp #>NOT_FOUND
    beq breturn
  !:
    lda return_y
    sta _9
    lda #0
    sta _9+1
    lda _9
    asl
    sta _15
    lda _9+1
    rol
    sta _15+1
    asl _15
    rol _15+1
    lda _16
    clc
    adc _15
    sta _16
    lda _16+1
    adc _15+1
    sta _16+1
    asl _10
    rol _10+1
    asl _10
    rol _10+1
    asl _10
    rol _10+1
    clc
    lda _11
    adc #<SCREEN_COPY
    sta _11
    lda _11+1
    adc #>SCREEN_COPY
    sta _11+1
    // clear the found char on the screen copy
    lda #' '
    ldy return_x
    sta (_11),y
  breturn:
    rts
  b9:
    lda return_dist
    sta closest_dist
    lda return_dist+1
    sta closest_dist+1
    jmp b1
  b10:
    lda return_dist
    sta closest_dist
    lda return_dist+1
    sta closest_dist+1
    jmp b2
  b12:
    lda closest_dist
    sta return_dist
    lda closest_dist+1
    sta return_dist+1
    jmp b3
  b11:
    lda closest_dist
    sta return_dist
    lda closest_dist+1
    sta return_dist+1
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
    .label sp = $16
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
// initialize SQUARES table
initSquareTables: {
    .label _6 = $1a
    .label _14 = $1a
    .label x = $18
    .label y = $19
    lda #0
    sta x
  b1:
    lda x
    cmp #$14
    bcc b2
    sec
    sbc #$14
  b4:
    tax
    sta mul8u.mb
    lda #0
    sta mul8u.mb+1
    jsr mul8u
    lda x
    asl
    tay
    lda _6
    sta SQUARES_X,y
    lda _6+1
    sta SQUARES_X+1,y
    inc x
    lda #$28
    cmp x
    bne b1
    lda #0
    sta y
  b5:
    lda y
    cmp #$c
    bcc b6
    sec
    sbc #$c
  b8:
    tax
    sta mul8u.mb
    lda #0
    sta mul8u.mb+1
    jsr mul8u
    lda y
    asl
    tay
    lda _14
    sta SQUARES_Y,y
    lda _14+1
    sta SQUARES_Y+1,y
    inc y
    lda #$19
    cmp y
    bne b5
    rts
  b6:
    lda #$c
    sec
    sbc y
    jmp b8
  b2:
    lda #$14
    sec
    sbc x
    jmp b4
}
// Perform binary multiplication of two unsigned 8-bit bytes into a 16-bit unsigned word
// mul8u(byte register(X) a, byte register(A) b)
mul8u: {
    .label mb = $1c
    .label res = $1a
    .label return = $1a
    lda #0
    sta res
    sta res+1
  b1:
    cpx #0
    bne b2
    rts
  b2:
    txa
    and #1
    cmp #0
    beq b3
    lda res
    clc
    adc mb
    sta res
    lda res+1
    adc mb+1
    sta res+1
  b3:
    txa
    lsr
    tax
    asl mb
    rol mb+1
    jmp b1
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
    .label _15 = $39
    .label _25 = $37
    .label processing = $34
    .label bitmask = $36
    .label i = $1e
    .label xpos = $37
    .label ypos = $3b
    .label numActive = $1f
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
  // Copy of the screen used for finding chars to process
  SCREEN_COPY: .fill $3e8, 0
  // SQUARES_X[i] = (i-20)*(i-20)
  SQUARES_X: .fill 2*$28, 0
  // SQUARES_Y[i] = (i-12)*(i-12)
  SQUARES_Y: .fill 2*$19, 0
  // Sprites currently being processed in the interrupt
  PROCESSING: .fill $e*NUM_PROCESSING, 0
.pc = VXSIN "VXSIN"
  .for(var i=0; i<40; i++) {
      .word -sin(toRadians([i*360]/40))*4
    }

.pc = VYSIN "VYSIN"
  .for(var i=0; i<25; i++) {
      .word -sin(toRadians([i*360]/25))*4
    }

