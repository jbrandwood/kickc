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
  .const NUM_PROCESSING = $10
  .const RASTER_IRQ_TOP = $30
  .const RASTER_IRQ_MIDDLE = $ff
main: {
    .label src = 2
    .label dst = 4
    .label center_dist = $f
    ldy #0
  // Init processing array
  b1:
    tya
    asl
    asl
    tax
    lda #0
    sta PROCESSING,x
    sta PROCESSING+OFFSET_STRUCT_PROCESSINGCHAR_Y,x
    lda #<NOT_FOUND
    sta PROCESSING+OFFSET_STRUCT_PROCESSINGCHAR_DIST,x
    lda #>NOT_FOUND
    sta PROCESSING+OFFSET_STRUCT_PROCESSINGCHAR_DIST+1,x
    iny
    cpy #NUM_PROCESSING-1+1
    bne b1
    jsr setupRasterIrq
    lda #<SCREEN_COPY
    sta dst
    lda #>SCREEN_COPY
    sta dst+1
    lda #<SCREEN
    sta src
    lda #>SCREEN
    sta src+1
  // Copy screen to screen copy
  b3:
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
    bne b3
    lda src
    cmp #<SCREEN+$3e8
    bne b3
    jsr initSquareTables
  b2:
  // Main loop
    jsr getCharToProcess
    ldy getCharToProcess.return_x
    ldx getCharToProcess.return_y
    lda center_dist+1
    cmp #>NOT_FOUND
    bne b6
    lda center_dist
    cmp #<NOT_FOUND
    bne b6
  b7:
    inc SCREEN+$3e7
    jmp b7
  b6:
    sty startProcessing.center_x
    stx startProcessing.center_y
    jsr startProcessing
    jmp b2
}
// Start processing a char - by inserting it into the PROCESSING array
// startProcessing(byte zeropage($17) center_x, byte zeropage($18) center_y, word zeropage($f) center_dist)
startProcessing: {
    .label center_x = $17
    .label center_y = $18
    .label center_dist = $f
    .label freeIdx = 6
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
    cpx #NUM_PROCESSING-1+1
    bne b2
    ldx freeIdx
    jmp b4
}
// Find the non-space char closest to the center of the screen
// If no non-space char is found the distance will be 0xffff
getCharToProcess: {
    .label _9 = $19
    .label _10 = $19
    .label _11 = $19
    .label return_dist = $f
    .label x = $a
    .label dist = $f
    .label screen_line = 7
    .label y = 9
    .label return_x = $d
    .label return_y = $e
    .label closest_dist = $b
    .label closest_x = $d
    .label closest_y = $e
    .label _15 = $1b
    .label _16 = $19
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
    .label _6 = $13
    .label _14 = $13
    .label x = $11
    .label y = $12
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
    .label mb = $15
    .label res = $13
    .label return = $13
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
    .label _3 = $1f
    .label _4 = $1f
    .label _5 = $1f
    .label _7 = $23
    .label _8 = $23
    .label _9 = $23
    .label processing_x = $1d
    .label processing_y = $1e
    .label _22 = $21
    .label _23 = $1f
    .label _25 = $25
    .label _26 = $23
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
    sta _3
    lda #0
    sta _3+1
    lda _3
    asl
    sta _22
    lda _3+1
    rol
    sta _22+1
    asl _22
    rol _22+1
    lda _23
    clc
    adc _22
    sta _23
    lda _23+1
    adc _22+1
    sta _23+1
    asl _4
    rol _4+1
    asl _4
    rol _4+1
    asl _4
    rol _4+1
    clc
    lda _5
    adc #<COLS
    sta _5
    lda _5+1
    adc #>COLS
    sta _5+1
    lda #WHITE
    ldy processing_x
    sta (_5),y
    lda processing_y
    sta _7
    lda #0
    sta _7+1
    lda _7
    asl
    sta _25
    lda _7+1
    rol
    sta _25+1
    asl _25
    rol _25+1
    lda _26
    clc
    adc _25
    sta _26
    lda _26+1
    adc _25+1
    sta _26+1
    asl _8
    rol _8+1
    asl _8
    rol _8+1
    asl _8
    rol _8+1
    clc
    lda _9
    adc #<SCREEN
    sta _9
    lda _9+1
    adc #>SCREEN
    sta _9+1
    lda (_9),y
    cmp #' '
    beq b3
    lda (_9),y
    cmp #' '
    beq !+
    bcs b4
  !:
    ldy processing_x
    lda (_9),y
    clc
    adc #1
    sta (_9),y
  b2:
    inx
    cpx #NUM_PROCESSING-1+1
    beq !b1+
    jmp b1
  !b1:
    rts
  b4:
    ldy processing_x
    lda (_9),y
    sec
    sbc #1
    sta (_9),y
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
  // SQUARES_X[i] = (i-20)*(i-20)
  SQUARES_X: .fill 2*$28, 0
  // SQUARES_Y[i] = (i-12)*(i-12)
  SQUARES_Y: .fill 2*$19, 0
  // Chars currently being processed in the interrupt
  PROCESSING: .fill 4*NUM_PROCESSING, 0
