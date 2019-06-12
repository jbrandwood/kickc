// Black Hole at the center of the BASIC screen sucking in any letters
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .const OFFSET_STRUCT_PROCESSINGCHAR_Y = 1
  .const OFFSET_STRUCT_PROCESSINGCHAR_DIST = 2
  // Processor port data direction register
  .label PROCPORT_DDR = 0
  // Mask for PROCESSOR_PORT_DDR which allows only memory configuration to be written
  .const PROCPORT_DDR_MEMORY_MASK = 7
  // Processor Port Register controlling RAM/ROM configuration and the datasette
  .label PROCPORT = 1
  // RAM in $A000, $E000 I/O in $D000
  .const PROCPORT_RAM_IO = $35
  .label RASTER = $d012
  .label BORDERCOL = $d020
  .label BGCOL = $d021
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
  .const WHITE = 1
  .const BLUE = 6
  .const LIGHT_BLUE = $e
  .label SCREEN = $400
  // Distance value meaning not found
  .const NOT_FOUND = $ffff
  .const RASTER_IRQ_TOP = $30
  .const RASTER_IRQ_MIDDLE = $ff
main: {
    .label sc = 2
    .label src = 4
    .label dst = 6
    .label center_dist = $11
    ldx #0
  // Init processing array
  b1:
    txa
    asl
    asl
    tay
    lda #0
    sta PROCESSING,y
    sta PROCESSING+OFFSET_STRUCT_PROCESSINGCHAR_Y,y
    lda #<NOT_FOUND
    sta PROCESSING+OFFSET_STRUCT_PROCESSINGCHAR_DIST,y
    lda #>NOT_FOUND
    sta PROCESSING+OFFSET_STRUCT_PROCESSINGCHAR_DIST+1,y
    inx
    cpx #8
    bne b1
    jsr setupRasterIrq
    lda #<SCREEN
    sta sc
    lda #>SCREEN
    sta sc+1
  // Fill screen with some chars
  b3:
    lda sc
    and #$1f
    clc
    adc #'a'
    ldy #0
    sta (sc),y
    inc sc
    bne !+
    inc sc+1
  !:
    lda sc+1
    cmp #>SCREEN+$3e7+1
    bne b3
    lda sc
    cmp #<SCREEN+$3e7+1
    bne b3
    lda #<SCREEN_COPY
    sta dst
    lda #>SCREEN_COPY
    sta dst+1
    lda #<SCREEN
    sta src
    lda #>SCREEN
    sta src+1
  // Copy screen to screen copy
  b4:
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
    cmp #>SCREEN+$3e7
    bne b4
    lda src
    cmp #<SCREEN+$3e7
    bne b4
    jsr initSquareTables
  b2:
  // Main loop
    jsr getCenterChar
    ldx getCenterChar.return_x
    ldy getCenterChar.return_y
    lda center_dist+1
    cmp #>NOT_FOUND
    bne b7
    lda center_dist
    cmp #<NOT_FOUND
    bne b7
  b8:
    inc SCREEN+$3e7
    jmp b8
  b7:
    stx startProcessing.center_x
    sty startProcessing.center_y
    jsr startProcessing
    jmp b2
}
// Start processing a char - by inserting it into the PROCESSING array
// startProcessing(byte zeropage($19) center_x, byte zeropage($1a) center_y, word zeropage($11) center_dist)
startProcessing: {
    .label center_x = $19
    .label center_y = $1a
    .label center_dist = $11
    .label freeIdx = 8
    lda #$ff
    sta freeIdx
  b1:
    ldx #0
  b2:
    txa
    asl
    asl
    tay
    lda PROCESSING+OFFSET_STRUCT_PROCESSINGCHAR_DIST+1,y
    cmp #>NOT_FOUND
    bne b3
    lda PROCESSING+OFFSET_STRUCT_PROCESSINGCHAR_DIST,y
    cmp #<NOT_FOUND
    bne b3
  b4:
    cpx #$ff
    beq b6
    txa
    asl
    asl
    tax
    lda center_x
    sta PROCESSING,x
    lda center_y
    sta PROCESSING+OFFSET_STRUCT_PROCESSINGCHAR_Y,x
    lda center_dist
    sta PROCESSING+OFFSET_STRUCT_PROCESSINGCHAR_DIST,x
    lda center_dist+1
    sta PROCESSING+OFFSET_STRUCT_PROCESSINGCHAR_DIST+1,x
    rts
  b6:
    stx freeIdx
    jmp b1
  b3:
    inx
    cpx #8
    bne b2
    ldx freeIdx
    jmp b4
}
// Find the non-space char closest to the center of the screen
// If no non-space char is found the distance will be 0xffff
getCenterChar: {
    .label _9 = $1b
    .label _10 = $1b
    .label _11 = $1b
    .label return_dist = $11
    .label x = $c
    .label dist = $11
    .label screen_line = 9
    .label y = $b
    .label return_x = $f
    .label return_y = $10
    .label closest_dist = $d
    .label closest_x = $f
    .label closest_y = $10
    .label _15 = $1d
    .label _16 = $1b
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
// initialize SQUARES table
initSquareTables: {
    .label _6 = $15
    .label _14 = $15
    .label x = $13
    .label y = $14
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
    .label mb = $17
    .label res = $15
    .label return = $15
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
// Raster Interrupt at the middle of the screen
irqBottom: {
    sta rega+1
    stx regx+1
    sty regy+1
    ldx #0
  b1:
    inx
    cpx #5
    bne b1
    lda #WHITE
    sta BORDERCOL
    sta BGCOL
    jsr processChars
    lda #LIGHT_BLUE
    sta BORDERCOL
    lda #BLUE
    sta BGCOL
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
    .label _2 = $21
    .label _3 = $21
    .label _4 = $21
    .label _6 = $25
    .label _7 = $25
    .label _8 = $25
    .label processing_x = $1f
    .label processing_y = $20
    .label _21 = $23
    .label _22 = $21
    .label _24 = $27
    .label _25 = $25
    ldx #0
  b1:
    txa
    asl
    asl
    tay
    lda PROCESSING+OFFSET_STRUCT_PROCESSINGCHAR_DIST,y
    cmp #<NOT_FOUND
    bne !+
    lda PROCESSING+OFFSET_STRUCT_PROCESSINGCHAR_DIST+1,y
    cmp #>NOT_FOUND
    bne !b2+
    jmp b2
  !b2:
  !:
    txa
    asl
    asl
    tay
    lda PROCESSING,y
    sta processing_x
    lda PROCESSING+OFFSET_STRUCT_PROCESSINGCHAR_Y,y
    sta processing_y
    sta _2
    lda #0
    sta _2+1
    lda _2
    asl
    sta _21
    lda _2+1
    rol
    sta _21+1
    asl _21
    rol _21+1
    lda _22
    clc
    adc _21
    sta _22
    lda _22+1
    adc _21+1
    sta _22+1
    asl _3
    rol _3+1
    asl _3
    rol _3+1
    asl _3
    rol _3+1
    clc
    lda _4
    adc #<COLS
    sta _4
    lda _4+1
    adc #>COLS
    sta _4+1
    lda #WHITE
    ldy processing_x
    sta (_4),y
    lda processing_y
    sta _6
    lda #0
    sta _6+1
    lda _6
    asl
    sta _24
    lda _6+1
    rol
    sta _24+1
    asl _24
    rol _24+1
    lda _25
    clc
    adc _24
    sta _25
    lda _25+1
    adc _24+1
    sta _25+1
    asl _7
    rol _7+1
    asl _7
    rol _7+1
    asl _7
    rol _7+1
    clc
    lda _8
    adc #<SCREEN
    sta _8
    lda _8+1
    adc #>SCREEN
    sta _8+1
    lda (_8),y
    cmp #' '
    beq b3
    lda (_8),y
    cmp #' '
    beq !+
    bcs b4
  !:
    ldy processing_x
    lda (_8),y
    clc
    adc #1
    sta (_8),y
  b2:
    inx
    cpx #8
    beq !b1+
    jmp b1
  !b1:
    rts
  b4:
    ldy processing_x
    lda (_8),y
    sec
    sbc #1
    sta (_8),y
    jmp b2
  b3:
    txa
    asl
    asl
    tay
    lda #<NOT_FOUND
    sta PROCESSING+OFFSET_STRUCT_PROCESSINGCHAR_DIST,y
    lda #>NOT_FOUND
    sta PROCESSING+OFFSET_STRUCT_PROCESSINGCHAR_DIST+1,y
    jmp b2
}
// Raster Interrupt at the top of the screen
irqTop: {
    sta rega+1
    stx regx+1
    sty regy+1
    ldx #0
  b1:
    inx
    cpx #5
    bne b1
    lda #WHITE
    sta BORDERCOL
    sta BGCOL
    ldx #0
  b3:
    inx
    cpx #8
    bne b3
    lda #LIGHT_BLUE
    sta BORDERCOL
    lda #BLUE
    sta BGCOL
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
  // Chars currently being processed in the interrupt
  PROCESSING: .fill 4*8, 0
  // SQUARES_X[i] = (i-20)*(i-20)
  SQUARES_X: .fill 2*$28, 0
  // SQUARES_Y[i] = (i-12)*(i-12)
  SQUARES_Y: .fill 2*$19, 0
