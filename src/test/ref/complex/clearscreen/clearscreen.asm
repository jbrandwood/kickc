// Clears start screen throwing around the letters (by turning them into sprites)
.pc = $801 "Basic"
:BasicUpstart(bbegin)
.pc = $80d "Program"
  .const SIZEOF_WORD = 2
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
  .const NOT_FOUND = $ff
  .const NUM_SQUARES = $30
  .const RASTER_IRQ_TOP = $30
  .const RASTER_IRQ_MIDDLE = $ff
  .const XPOS_RIGHTMOST = BORDER_XPOS_RIGHT<<4
  .const YPOS_BOTTOMMOST = BORDER_YPOS_BOTTOM<<4
  .const XPOS_LEFTMOST = BORDER_XPOS_LEFT-8<<4
  .const YPOS_TOPMOST = BORDER_YPOS_TOP-8<<4
  .label heap_head = $23
  .label SQUARES = $49
  .label SCREEN_COPY = $29
  .label SCREEN_DIST = $2b
bbegin:
  lda #<$3e8
  sta malloc.size
  lda #>$3e8
  sta malloc.size+1
  lda #<HEAP_START
  sta heap_head
  lda #>HEAP_START
  sta heap_head+1
  jsr malloc
  lda malloc.mem
  sta SCREEN_COPY
  lda malloc.mem+1
  sta SCREEN_COPY+1
  lda #<$3e8
  sta malloc.size
  lda #>$3e8
  sta malloc.size+1
  jsr malloc
  lda malloc.mem
  sta SCREEN_DIST
  lda malloc.mem+1
  sta SCREEN_DIST+1
  jsr main
  rts
main: {
    .label dst = 4
    .label src = 2
    .label i = 6
    .label center_y = $2d
    lda SCREEN_DIST
    sta init_dist_screen.screen
    lda SCREEN_DIST+1
    sta init_dist_screen.screen+1
    jsr init_dist_screen
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
// startProcessing(byte zeropage($2e) center_x, byte zeropage($2d) center_y)
startProcessing: {
    .label _0 = $2f
    .label _1 = $2f
    .label _5 = $a
    .label _6 = $a
    .label _8 = 8
    .label _9 = 8
    .label _11 = $36
    .label _12 = $36
    .label _13 = $36
    .label _15 = $38
    .label _16 = $38
    .label _17 = $38
    .label _23 = $3b
    .label center_x = $2e
    .label center_y = $2d
    .label i = 7
    .label offset = $2f
    .label colPtr = $33
    .label spriteCol = $35
    .label screenPtr = $2f
    .label spriteData = $a
    .label chargenData = 8
    .label spriteX = $36
    .label spriteY = $38
    .label spritePtr = $3a
    .label freeIdx = 7
    .label _47 = $31
    .label _48 = $2f
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
    .label _8 = $3d
    .label _9 = $3d
    .label _10 = $3d
    .label screen_line = $c
    .label dist_line = $e
    .label y = $10
    .label return_x = $12
    .label return_y = $13
    .label closest_dist = $11
    .label closest_x = $12
    .label closest_y = $13
    .label _12 = $3f
    .label _13 = $3d
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
// Populates 1000 bytes (a screen) with values representing the distance to the center.
// The actual value stored is distance*2 to increase precision
// init_dist_screen(byte* zeropage($17) screen)
init_dist_screen: {
    .label screen = $17
    .label screen_bottomline = $19
    .label yds = $41
    .label xds = $43
    .label ds = $43
    .label x = $1b
    .label xb = $1c
    .label screen_topline = $17
    .label y = $16
    jsr init_squares
    lda screen
    clc
    adc #<$28*$18
    sta screen_bottomline
    lda screen+1
    adc #>$28*$18
    sta screen_bottomline+1
    lda #0
    sta y
  b1:
    lda y
    asl
    cmp #$18
    bcs b2
    eor #$ff
    clc
    adc #$18+1
  b4:
    jsr sqr
    lda sqr.return
    sta sqr.return_2
    lda sqr.return+1
    sta sqr.return_2+1
    lda #$27
    sta xb
    lda #0
    sta x
  b5:
    lda x
    asl
    cmp #$27
    bcs b6
    eor #$ff
    clc
    adc #$27+1
  b8:
    jsr sqr
    lda ds
    clc
    adc yds
    sta ds
    lda ds+1
    adc yds+1
    sta ds+1
    jsr sqrt
    ldy x
    sta (screen_topline),y
    sta (screen_bottomline),y
    ldy xb
    sta (screen_topline),y
    sta (screen_bottomline),y
    inc x
    dec xb
    lda x
    cmp #$13+1
    bcc b5
    lda #$28
    clc
    adc screen_topline
    sta screen_topline
    bcc !+
    inc screen_topline+1
  !:
    lda screen_bottomline
    sec
    sbc #<$28
    sta screen_bottomline
    lda screen_bottomline+1
    sbc #>$28
    sta screen_bottomline+1
    inc y
    lda #$d
    cmp y
    bne b1
    rts
  b6:
    sec
    sbc #$27
    jmp b8
  b2:
    sec
    sbc #$18
    jmp b4
}
// Find the (integer) square root of a word value
// If the square is not an integer then it returns the largest integer N where N*N <= val
// Uses a table of squares that must be initialized by calling init_squares()
// sqrt(word zeropage($43) val)
sqrt: {
    .label _1 = $1d
    .label _3 = $1d
    .label found = $1d
    .label val = $43
    lda SQUARES
    sta bsearch16u.items
    lda SQUARES+1
    sta bsearch16u.items+1
    jsr bsearch16u
    lda _3
    sec
    sbc SQUARES
    sta _3
    lda _3+1
    sbc SQUARES+1
    sta _3+1
    lsr _1+1
    ror _1
    lda _1
    rts
}
// Searches an array of nitems unsigned words, the initial member of which is pointed to by base, for a member that matches the value key.
// - key - The value to look for
// - items - Pointer to the start of the array to search in
// - num - The number of items in the array
// Returns pointer to an entry in the array that matches the search key
// bsearch16u(word zeropage($43) key, word* zeropage($1d) items, byte register(X) num)
bsearch16u: {
    .label _2 = $1d
    .label pivot = $45
    .label result = $47
    .label return = $1d
    .label items = $1d
    .label key = $43
    ldx #NUM_SQUARES
  b3:
    cpx #0
    bne b4
    ldy #1
    lda (items),y
    cmp key+1
    bne !+
    dey
    lda (items),y
    cmp key
    beq b2
  !:
    bcc b2
    lda _2
    sec
    sbc #<1*SIZEOF_WORD
    sta _2
    lda _2+1
    sbc #>1*SIZEOF_WORD
    sta _2+1
  b2:
    rts
  b4:
    txa
    lsr
    asl
    clc
    adc items
    sta pivot
    lda #0
    adc items+1
    sta pivot+1
    sec
    lda key
    ldy #0
    sbc (pivot),y
    sta result
    lda key+1
    iny
    sbc (pivot),y
    sta result+1
    bne b6
    lda result
    bne b6
    lda pivot
    sta return
    lda pivot+1
    sta return+1
    rts
  b6:
    lda result+1
    bmi b7
    bne !+
    lda result
    beq b7
  !:
    lda #1*SIZEOF_WORD
    clc
    adc pivot
    sta items
    lda #0
    adc pivot+1
    sta items+1
    dex
  b7:
    txa
    lsr
    tax
    jmp b3
}
// Find the square of a byte value
// Uses a table of squares that must be initialized by calling init_squares()
// sqr(byte register(A) val)
sqr: {
    .label return = $43
    .label return_2 = $41
    asl
    tay
    lda (SQUARES),y
    sta return
    iny
    lda (SQUARES),y
    sta return+1
    rts
}
// Initialize squares table
// Uses iterative formula (x+1)^2 = x^2 + 2*x + 1
init_squares: {
    .label squares = $21
    .label sqr = $1f
    lda #NUM_SQUARES*SIZEOF_WORD
    sta malloc.size
    lda #0
    sta malloc.size+1
    jsr malloc
    lda SQUARES
    sta squares
    lda SQUARES+1
    sta squares+1
    ldx #0
    txa
    sta sqr
    sta sqr+1
  b1:
    ldy #0
    lda sqr
    sta (squares),y
    iny
    lda sqr+1
    sta (squares),y
    lda #SIZEOF_WORD
    clc
    adc squares
    sta squares
    bcc !+
    inc squares+1
  !:
    txa
    asl
    clc
    adc #1
    clc
    adc sqr
    sta sqr
    bcc !+
    inc sqr+1
  !:
    inx
    cpx #NUM_SQUARES-1+1
    bne b1
    rts
}
// Allocates a block of size bytes of memory, returning a pointer to the beginning of the block.
// The content of the newly allocated block of memory is not initialized, remaining with indeterminate values.
// malloc(word zeropage($25) size)
malloc: {
    .label mem = $49
    .label size = $25
    lda heap_head
    sta mem
    lda heap_head+1
    sta mem+1
    lda heap_head
    clc
    adc size
    sta heap_head
    lda heap_head+1
    adc size+1
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
    .label _15 = $50
    .label _25 = $4e
    .label processing = $4b
    .label bitmask = $4d
    .label i = $27
    .label xpos = $4e
    .label ypos = $52
    .label numActive = $28
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

