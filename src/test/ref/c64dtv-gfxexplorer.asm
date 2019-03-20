// Interactive Explorer for C64DTV Screen Modes
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
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
  .label RASTER = $d012
  .label BORDERCOL = $d020
  .label BGCOL = $d021
  .label BGCOL1 = $d021
  .label BGCOL2 = $d022
  .label BGCOL3 = $d023
  .label BGCOL4 = $d024
  .label VIC_CONTROL = $d011
  .const VIC_ECM = $40
  .const VIC_BMM = $20
  .const VIC_DEN = $10
  .const VIC_RSEL = 8
  .label VIC_CONTROL2 = $d016
  .const VIC_MCM = $10
  .const VIC_CSEL = 8
  .label VIC_MEMORY = $d018
  // Color Ram
  .label COLS = $d800
  // CIA#1 Port A: keyboard matrix columns and joystick #2
  .label CIA1_PORT_A = $dc00
  // CIA#1 Port B: keyboard matrix rows and joystick #1.
  .label CIA1_PORT_B = $dc01
  // CIA #1 Port A data direction register.
  .label CIA1_PORT_A_DDR = $dc02
  // CIA #1 Port B data direction register.
  .label CIA1_PORT_B_DDR = $dc03
  // CIA#2 Port A: Serial bus, RS-232, VIC memory bank
  .label CIA2_PORT_A = $dd00
  // CIA #2 Port A data direction register.
  .label CIA2_PORT_A_DDR = $dd02
  // Feature enables or disables the extra C64 DTV features
  .label DTV_FEATURE = $d03f
  .const DTV_FEATURE_ENABLE = 1
  // Controls the graphics modes of the C64 DTV
  .label DTV_CONTROL = $d03c
  .const DTV_LINEAR = 1
  .const DTV_BORDER_OFF = 2
  .const DTV_HIGHCOLOR = 4
  .const DTV_OVERSCAN = 8
  .const DTV_COLORRAM_OFF = $10
  .const DTV_CHUNKY = $40
  // Defines colors for the 16 first colors ($00-$0f)
  .label DTV_PALETTE = $d200
  // Linear Graphics Plane A Counter Control
  .label DTV_PLANEA_START_LO = $d03a
  .label DTV_PLANEA_START_MI = $d03b
  .label DTV_PLANEA_START_HI = $d045
  .label DTV_PLANEA_STEP = $d046
  .label DTV_PLANEA_MODULO_LO = $d038
  .label DTV_PLANEA_MODULO_HI = $d039
  // Linear Graphics Plane B Counter Control
  .label DTV_PLANEB_START_LO = $d049
  .label DTV_PLANEB_START_MI = $d04a
  .label DTV_PLANEB_START_HI = $d04b
  .label DTV_PLANEB_STEP = $d04c
  .label DTV_PLANEB_MODULO_LO = $d047
  .label DTV_PLANEB_MODULO_HI = $d048
  // Select memory bank where color data is fetched from (bits 11:0)
  // Memory address of Color RAM is ColorBank*$400
  .label DTV_COLOR_BANK_LO = $d036
  .label DTV_COLOR_BANK_HI = $d037
  .const DTV_COLOR_BANK_DEFAULT = $1d800
  // Selects memory bank for normal VIC color mode and lower data for high color modes. (bits 5:0)
  // Memory address of VIC Graphics is GraphicsBank*$10000
  .label DTV_GRAPHICS_VIC_BANK = $d03d
  .const KEY_CRSR_RIGHT = 2
  .const KEY_CRSR_DOWN = 7
  .const KEY_LSHIFT = $f
  .const KEY_RSHIFT = $34
  .const KEY_CTRL = $3a
  .const KEY_SPACE = $3c
  .const KEY_COMMODORE = $3d
  // Left shift is pressed
  .const KEY_MODIFIER_LSHIFT = 1
  // Right shift is pressed
  .const KEY_MODIFIER_RSHIFT = 2
  // CTRL is pressed
  .const KEY_MODIFIER_CTRL = 4
  // Commodore is pressed
  .const KEY_MODIFIER_COMMODORE = 8
  // VIC Screens
  .label VIC_SCREEN0 = $4000
  .label VIC_SCREEN1 = $4400
  .label VIC_SCREEN2 = $4800
  .label VIC_SCREEN3 = $4c00
  .label VIC_SCREEN4 = $5000
  // VIC Charset from ROM
  .label VIC_CHARSET_ROM = $5800
  // VIC Bitmap
  .label VIC_BITMAP = $6000
  // 8BPP Chunky Bitmap (contains 8bpp pixels)
  .const PLANE_8BPP_CHUNKY = $20000
  // Plane with horisontal stripes
  .const PLANE_HORISONTAL = $30000
  // Plane with vertical stripes
  .const PLANE_VERTICAL = $32000
  // Plane with horisontal stripes every 2 pixels
  .const PLANE_HORISONTAL2 = $34000
  // Plane with vertical stripes every 2 pixels
  .const PLANE_VERTICAL2 = $36000
  // Plane with blank pixels
  .const PLANE_BLANK = $38000
  // Plane with all pixels
  .const PLANE_FULL = $3a000
  // Plane with all pixels
  .const PLANE_CHARSET8 = $3c000
  // Screen containing the FORM
  .label FORM_SCREEN = $400
  // Charset used for the FORM
  .label FORM_CHARSET = $1800
  // Number of form fields
  .const form_fields_cnt = $24
  // The number of frames to use for a full blink cycle
  .const FORM_CURSOR_BLINK = $28
  // Any shift is pressed
  .const KEY_MODIFIER_SHIFT = KEY_MODIFIER_LSHIFT|KEY_MODIFIER_RSHIFT
  .label form_ctrl_bmm = form_fields_val+1
  .label form_ctrl_mcm = form_fields_val+2
  .label form_ctrl_ecm = form_fields_val+3
  .label form_ctrl_hicol = form_fields_val+4
  .label form_ctrl_line = form_fields_val+5
  .label form_ctrl_colof = form_fields_val+6
  .label form_ctrl_chunk = form_fields_val+7
  .label form_ctrl_borof = form_fields_val+8
  .label form_ctrl_overs = form_fields_val+9
  .label form_a_pattern = form_fields_val+$a
  .label form_a_start_hi = form_fields_val+$b
  .label form_a_start_lo = form_fields_val+$c
  .label form_a_step_hi = form_fields_val+$d
  .label form_a_step_lo = form_fields_val+$e
  .label form_a_mod_hi = form_fields_val+$f
  .label form_a_mod_lo = form_fields_val+$10
  .label form_b_pattern = form_fields_val+$11
  .label form_b_start_hi = form_fields_val+$12
  .label form_b_start_lo = form_fields_val+$13
  .label form_b_step_hi = form_fields_val+$14
  .label form_b_step_lo = form_fields_val+$15
  .label form_b_mod_hi = form_fields_val+$16
  .label form_b_mod_lo = form_fields_val+$17
  .label form_vic_screen = form_fields_val+$18
  .label form_vic_gfx = form_fields_val+$19
  .label form_vic_cols = form_fields_val+$1a
  .label form_dtv_palet = form_fields_val+$1b
  .label form_vic_bg0_hi = form_fields_val+$1c
  .label form_vic_bg0_lo = form_fields_val+$1d
  .label form_vic_bg1_hi = form_fields_val+$1e
  .label form_vic_bg1_lo = form_fields_val+$1f
  .label form_vic_bg2_hi = form_fields_val+$20
  .label form_vic_bg2_lo = form_fields_val+$21
  .label form_vic_bg3_hi = form_fields_val+$22
  .label form_vic_bg3_lo = form_fields_val+$23
  .label print_char_cursor = 5
  .label print_line_cursor = $10
  .label keyboard_events_size = 8
  .label form_cursor_count = $d
  .label form_field_idx = $e
main: {
    sei
    // Disable normal interrupt (prevent keyboard reading glitches and allows to hide basic/kernal)
    // Disable kernal & basic
    lda #PROCPORT_DDR_MEMORY_MASK
    sta PROCPORT_DDR
    lda #PROCPORT_RAM_IO
    sta PROCPORT
    // Enable DTV extended modes
    lda #DTV_FEATURE_ENABLE
    sta DTV_FEATURE
    jsr keyboard_init
    jsr gfx_init
    lda #0
    sta form_field_idx
    sta keyboard_events_size
    lda #FORM_CURSOR_BLINK/2
    sta form_cursor_count
  b2:
    jsr form_mode
    jsr gfx_mode
    jmp b2
}
// Change graphics mode to show the selected graphics mode
gfx_mode: {
    .label _31 = 9
    .label _33 = 3
    .label _35 = 3
    .label _37 = 3
    .label _45 = 9
    .label _47 = 3
    .label _49 = 3
    .label _51 = 3
    .label _61 = 3
    .label _63 = 3
    .label _64 = 3
    .label _65 = 2
    .label _66 = 3
    .label _68 = 3
    .label plane_a = 9
    .label plane_b = 9
    .label vic_colors = 3
    .label col = 5
    .label cy = 2
    lda form_ctrl_line
    cmp #0
    beq b12
    ldx #0|DTV_LINEAR
    jmp b1
  b12:
    ldx #0
  b1:
    lda form_ctrl_borof
    cmp #0
    beq b2
    txa
    ora #DTV_BORDER_OFF
    tax
  b2:
    lda form_ctrl_hicol
    cmp #0
    beq b3
    txa
    ora #DTV_HIGHCOLOR
    tax
  b3:
    lda form_ctrl_overs
    cmp #0
    beq b4
    txa
    ora #DTV_OVERSCAN
    tax
  b4:
    lda form_ctrl_colof
    cmp #0
    beq b5
    txa
    ora #DTV_COLORRAM_OFF
    tax
  b5:
    lda form_ctrl_chunk
    cmp #0
    beq b6
    txa
    ora #DTV_CHUNKY
    tax
  b6:
    stx DTV_CONTROL
    lda form_ctrl_ecm
    cmp #0
    beq b14
    ldx #VIC_DEN|VIC_RSEL|3|VIC_ECM
    jmp b7
  b14:
    ldx #VIC_DEN|VIC_RSEL|3
  b7:
    lda form_ctrl_bmm
    cmp #0
    beq b8
    txa
    ora #VIC_BMM
    tax
  b8:
    stx VIC_CONTROL
    lda form_ctrl_mcm
    cmp #0
    beq b16
    lda #VIC_CSEL|VIC_MCM
    jmp b9
  b16:
    lda #VIC_CSEL
  b9:
    sta VIC_CONTROL2
    lda form_a_start_hi
    asl
    asl
    asl
    asl
    ora form_a_start_lo
    tax
    lda form_a_pattern
    jsr get_plane
    txa
    clc
    adc plane_a
    sta plane_a
    lda plane_a+1
    adc #0
    sta plane_a+1
    lda plane_a+2
    adc #0
    sta plane_a+2
    lda plane_a+3
    adc #0
    sta plane_a+3
    lda plane_a
    sta _33
    lda plane_a+1
    sta _33+1
    lda _33
    sta DTV_PLANEA_START_LO
    lda plane_a
    sta _35
    lda plane_a+1
    sta _35+1
    sta DTV_PLANEA_START_MI
    lda plane_a+2
    sta _37
    lda plane_a+3
    sta _37+1
    lda _37
    sta DTV_PLANEA_START_HI
    lda form_a_step_hi
    asl
    asl
    asl
    asl
    ora form_a_step_lo
    sta DTV_PLANEA_STEP
    lda form_a_mod_hi
    asl
    asl
    asl
    asl
    ora form_a_mod_lo
    sta DTV_PLANEA_MODULO_LO
    lda #0
    sta DTV_PLANEA_MODULO_HI
    lda form_b_start_hi
    asl
    asl
    asl
    asl
    ora form_b_start_lo
    tax
    lda form_b_pattern
    jsr get_plane
    txa
    clc
    adc plane_b
    sta plane_b
    lda plane_b+1
    adc #0
    sta plane_b+1
    lda plane_b+2
    adc #0
    sta plane_b+2
    lda plane_b+3
    adc #0
    sta plane_b+3
    lda plane_b
    sta _47
    lda plane_b+1
    sta _47+1
    lda _47
    sta DTV_PLANEB_START_LO
    lda plane_b
    sta _49
    lda plane_b+1
    sta _49+1
    sta DTV_PLANEB_START_MI
    lda plane_b+2
    sta _51
    lda plane_b+3
    sta _51+1
    lda _51
    sta DTV_PLANEB_START_HI
    lda form_b_step_hi
    asl
    asl
    asl
    asl
    ora form_b_step_lo
    sta DTV_PLANEB_STEP
    lda form_b_mod_hi
    asl
    asl
    asl
    asl
    ora form_b_mod_lo
    sta DTV_PLANEB_MODULO_LO
    lda #0
    sta DTV_PLANEB_MODULO_HI
    // VIC Graphics Bank
    lda #3
    sta CIA2_PORT_A_DDR
    // Set VIC Bank bits to output - all others to input
    lda #3^VIC_SCREEN0/$4000
    sta CIA2_PORT_A
    lda form_vic_screen
    jsr get_vic_screen
    lda _63
    and #<$3fff
    sta _63
    lda _63+1
    and #>$3fff
    sta _63+1
    ldy #6
  !:
    lsr _64+1
    ror _64
    dey
    bne !-
    lda _64
    sta _65
    lda form_vic_gfx
    jsr get_vic_charset
    lda _68
    and #<$3fff
    sta _68
    lda _68+1
    and #>$3fff
    sta _68+1
    lsr
    lsr
    ora _65
    // Set VIC Bank
    // VIC memory
    sta VIC_MEMORY
    lda form_vic_cols
    jsr get_vic_screen
    lda #0
    sta cy
    lda #<COLS
    sta col
    lda #>COLS
    sta col+1
  b10:
    ldx #0
  b11:
    ldy #0
    lda (vic_colors),y
    sta (col),y
    inc col
    bne !+
    inc col+1
  !:
    inc vic_colors
    bne !+
    inc vic_colors+1
  !:
    inx
    cpx #$28
    bne b11
    inc cy
    lda cy
    cmp #$19
    bne b10
    // Background colors
    lda #0
    sta BORDERCOL
    lda form_vic_bg0_hi
    asl
    asl
    asl
    asl
    ora form_vic_bg0_lo
    sta BGCOL1
    lda form_vic_bg1_hi
    asl
    asl
    asl
    asl
    ora form_vic_bg1_lo
    sta BGCOL2
    lda form_vic_bg2_hi
    asl
    asl
    asl
    asl
    ora form_vic_bg2_lo
    sta BGCOL3
    lda form_vic_bg3_hi
    asl
    asl
    asl
    asl
    ora form_vic_bg3_lo
    sta BGCOL4
    // DTV Palette
    lda form_dtv_palet
    cmp #0
    beq b18
    ldx #0
  // DTV Palette - Grey Tones
  b13:
    txa
    sta DTV_PALETTE,x
    inx
    cpx #$10
    bne b13
  b19:
    lda RASTER
    cmp #$ff
    bne b19
    jsr keyboard_event_scan
    jsr keyboard_event_get
    cmp #KEY_SPACE
    bne b19
    rts
  // DTV Palette - default
  b18:
    ldx #0
  b15:
    lda DTV_PALETTE_DEFAULT,x
    sta DTV_PALETTE,x
    inx
    cpx #$10
    bne b15
    jmp b19
}
// Get the next event from the keyboard event buffer.
// Returns $ff if there is no event waiting. As all events are <$7f it is enough to examine bit 7 when determining if there is any event to process.
// The buffer is filled by keyboard_event_scan()
keyboard_event_get: {
    lda keyboard_events_size
    cmp #0
    beq b1
    dec keyboard_events_size
    ldy keyboard_events_size
    lda keyboard_events,y
    jmp breturn
  b1:
    lda #$ff
  breturn:
    rts
}
// Scans the entire matrix to determine which keys have been pressed/depressed.
// Generates keyboard events into the event buffer. Events can be read using keyboard_event_get().
// Handles debounce and only generates events when the status of a key changes.
// Also stores current status of modifiers in keyboard_modifiers.
keyboard_event_scan: {
    .label row_scan = $12
    .label keycode = 7
    .label row = 2
    lda #0
    sta keycode
    sta row
  b1:
    ldx row
    jsr keyboard_matrix_read
    sta row_scan
    ldy row
    cmp keyboard_scan_values,y
    bne b6
    lda #8
    clc
    adc keycode
    sta keycode
  b3:
    inc row
    lda row
    cmp #8
    bne b1
    lda #KEY_LSHIFT
    sta keyboard_event_pressed.keycode
    jsr keyboard_event_pressed
    cmp #0
    beq b2
    ldx #0|KEY_MODIFIER_LSHIFT
    jmp b9
  b2:
    ldx #0
  b9:
    lda #KEY_RSHIFT
    sta keyboard_event_pressed.keycode
    jsr keyboard_event_pressed
    cmp #0
    beq b10
    txa
    ora #KEY_MODIFIER_RSHIFT
    tax
  b10:
    lda #KEY_CTRL
    sta keyboard_event_pressed.keycode
    jsr keyboard_event_pressed
    cmp #0
    beq b11
    txa
    ora #KEY_MODIFIER_CTRL
    tax
  b11:
    lda #KEY_COMMODORE
    sta keyboard_event_pressed.keycode
    jsr keyboard_event_pressed
    cmp #0
    beq breturn
    txa
    ora #KEY_MODIFIER_COMMODORE
    tax
  breturn:
    rts
  // Something has changed on the keyboard row - check each column
  b6:
    ldx #0
  b4:
    lda row_scan
    ldy row
    eor keyboard_scan_values,y
    and keyboard_matrix_col_bitmask,x
    cmp #0
    beq b5
    lda keyboard_events_size
    cmp #8
    beq b5
    lda keyboard_matrix_col_bitmask,x
    and row_scan
    cmp #0
    beq b7
    // Key pressed
    lda keycode
    ldy keyboard_events_size
    sta keyboard_events,y
    inc keyboard_events_size
  b5:
    inc keycode
    inx
    cpx #8
    bne b4
    // Store the current keyboard status for the row to debounce
    lda row_scan
    ldy row
    sta keyboard_scan_values,y
    jmp b3
  b7:
    lda #$40
    ora keycode
    // Key released
    ldy keyboard_events_size
    sta keyboard_events,y
    inc keyboard_events_size
    jmp b5
}
// Determine if a specific key is currently pressed based on the last keyboard_event_scan()
// Returns 0 is not pressed and non-0 if pressed
// keyboard_event_pressed(byte zeropage(2) keycode)
keyboard_event_pressed: {
    .label row_bits = 7
    .label keycode = 2
    lda keycode
    lsr
    lsr
    lsr
    tay
    lda keyboard_scan_values,y
    sta row_bits
    lda #7
    and keycode
    tay
    lda keyboard_matrix_col_bitmask,y
    and row_bits
    rts
}
// Read a single row of the keyboard matrix
// The row ID (0-7) of the keyboard matrix row to read. See the C64 key matrix for row IDs.
// Returns the keys pressed on the row as bits according to the C64 key matrix.
// Notice: If the C64 normal interrupt is still running it will occasionally interrupt right between the read & write
// leading to erroneous readings. You must disable kill the normal interrupt or sei/cli around calls to the keyboard matrix reader.
// keyboard_matrix_read(byte register(X) rowid)
keyboard_matrix_read: {
    lda keyboard_matrix_row_bitmask,x
    sta CIA1_PORT_A
    lda CIA1_PORT_B
    eor #$ff
    rts
}
// Get the VIC screen address from the screen index
// get_vic_screen(byte register(A) idx)
get_vic_screen: {
    .label return = 3
    cmp #0
    beq b1
    cmp #1
    beq b2
    cmp #2
    beq b3
    cmp #3
    beq b4
    cmp #4
    bne b1
    lda #<VIC_SCREEN4
    sta return
    lda #>VIC_SCREEN4
    sta return+1
    jmp breturn
  b1:
    lda #<VIC_SCREEN0
    sta return
    lda #>VIC_SCREEN0
    sta return+1
    jmp breturn
  b2:
    lda #<VIC_SCREEN1
    sta return
    lda #>VIC_SCREEN1
    sta return+1
    jmp breturn
  b3:
    lda #<VIC_SCREEN2
    sta return
    lda #>VIC_SCREEN2
    sta return+1
    jmp breturn
  b4:
    lda #<VIC_SCREEN3
    sta return
    lda #>VIC_SCREEN3
    sta return+1
  breturn:
    rts
}
// Get the VIC charset/bitmap address from the index
// get_vic_charset(byte register(A) idx)
get_vic_charset: {
    .label return = 3
    cmp #0
    beq b1
    cmp #1
    bne b1
    lda #<VIC_BITMAP
    sta return
    lda #>VIC_BITMAP
    sta return+1
    jmp breturn
  b1:
    lda #<VIC_CHARSET_ROM
    sta return
    lda #>VIC_CHARSET_ROM
    sta return+1
  breturn:
    rts
}
// Get plane address from a plane index (from the form)
// get_plane(byte register(A) idx)
get_plane: {
    .label return = 9
    cmp #0
    beq b1
    cmp #1
    beq b2
    cmp #2
    bne !b3+
    jmp b3
  !b3:
    cmp #3
    bne !b4+
    jmp b4
  !b4:
    cmp #4
    bne !b5+
    jmp b5
  !b5:
    cmp #5
    bne !b6+
    jmp b6
  !b6:
    cmp #6
    bne !b7+
    jmp b7
  !b7:
    cmp #7
    bne !b8+
    jmp b8
  !b8:
    cmp #8
    bne !b9+
    jmp b9
  !b9:
    cmp #9
    bne !b10+
    jmp b10
  !b10:
    cmp #$a
    bne !b11+
    jmp b11
  !b11:
    cmp #$b
    bne !b12+
    jmp b12
  !b12:
    cmp #$c
    bne !b13+
    jmp b13
  !b13:
    cmp #$d
    bne b1
    lda #<PLANE_FULL
    sta return
    lda #>PLANE_FULL
    sta return+1
    lda #<PLANE_FULL>>$10
    sta return+2
    lda #>PLANE_FULL>>$10
    sta return+3
    jmp breturn
  b1:
    lda #<$ffffffff&VIC_SCREEN0
    sta return
    lda #>$ffffffff&VIC_SCREEN0
    sta return+1
    lda #<$ffffffff&VIC_SCREEN0>>$10
    sta return+2
    lda #>$ffffffff&VIC_SCREEN0>>$10
    sta return+3
    jmp breturn
  b2:
    lda #<$ffffffff&VIC_SCREEN1
    sta return
    lda #>$ffffffff&VIC_SCREEN1
    sta return+1
    lda #<$ffffffff&VIC_SCREEN1>>$10
    sta return+2
    lda #>$ffffffff&VIC_SCREEN1>>$10
    sta return+3
    jmp breturn
  b3:
    lda #<$ffffffff&VIC_SCREEN2
    sta return
    lda #>$ffffffff&VIC_SCREEN2
    sta return+1
    lda #<$ffffffff&VIC_SCREEN2>>$10
    sta return+2
    lda #>$ffffffff&VIC_SCREEN2>>$10
    sta return+3
    jmp breturn
  b4:
    lda #<$ffffffff&VIC_SCREEN3
    sta return
    lda #>$ffffffff&VIC_SCREEN3
    sta return+1
    lda #<$ffffffff&VIC_SCREEN3>>$10
    sta return+2
    lda #>$ffffffff&VIC_SCREEN3>>$10
    sta return+3
    jmp breturn
  b5:
    lda #<$ffffffff&VIC_BITMAP
    sta return
    lda #>$ffffffff&VIC_BITMAP
    sta return+1
    lda #<$ffffffff&VIC_BITMAP>>$10
    sta return+2
    lda #>$ffffffff&VIC_BITMAP>>$10
    sta return+3
    jmp breturn
  b6:
    lda #<$ffffffff&VIC_CHARSET_ROM
    sta return
    lda #>$ffffffff&VIC_CHARSET_ROM
    sta return+1
    lda #<$ffffffff&VIC_CHARSET_ROM>>$10
    sta return+2
    lda #>$ffffffff&VIC_CHARSET_ROM>>$10
    sta return+3
    jmp breturn
  b7:
    lda #<PLANE_8BPP_CHUNKY
    sta return
    lda #>PLANE_8BPP_CHUNKY
    sta return+1
    lda #<PLANE_8BPP_CHUNKY>>$10
    sta return+2
    lda #>PLANE_8BPP_CHUNKY>>$10
    sta return+3
    jmp breturn
  b8:
    lda #<PLANE_HORISONTAL
    sta return
    lda #>PLANE_HORISONTAL
    sta return+1
    lda #<PLANE_HORISONTAL>>$10
    sta return+2
    lda #>PLANE_HORISONTAL>>$10
    sta return+3
    jmp breturn
  b9:
    lda #<PLANE_VERTICAL
    sta return
    lda #>PLANE_VERTICAL
    sta return+1
    lda #<PLANE_VERTICAL>>$10
    sta return+2
    lda #>PLANE_VERTICAL>>$10
    sta return+3
    jmp breturn
  b10:
    lda #<PLANE_HORISONTAL2
    sta return
    lda #>PLANE_HORISONTAL2
    sta return+1
    lda #<PLANE_HORISONTAL2>>$10
    sta return+2
    lda #>PLANE_HORISONTAL2>>$10
    sta return+3
    jmp breturn
  b11:
    lda #<PLANE_VERTICAL2
    sta return
    lda #>PLANE_VERTICAL2
    sta return+1
    lda #<PLANE_VERTICAL2>>$10
    sta return+2
    lda #>PLANE_VERTICAL2>>$10
    sta return+3
    jmp breturn
  b12:
    lda #<PLANE_CHARSET8
    sta return
    lda #>PLANE_CHARSET8
    sta return+1
    lda #<PLANE_CHARSET8>>$10
    sta return+2
    lda #>PLANE_CHARSET8>>$10
    sta return+3
    jmp breturn
  b13:
    lda #<PLANE_BLANK
    sta return
    lda #>PLANE_BLANK
    sta return+1
    lda #<PLANE_BLANK>>$10
    sta return+2
    lda #>PLANE_BLANK>>$10
    sta return+3
  breturn:
    rts
}
// Show the form - and let the user change values
form_mode: {
    .label preset_current = $f
    lda #<COLS
    sta print_set_screen.screen
    lda #>COLS
    sta print_set_screen.screen+1
    jsr print_set_screen
    jsr print_cls
    lda #<FORM_COLS
    sta print_str_lines.str
    lda #>FORM_COLS
    sta print_str_lines.str+1
    jsr print_str_lines
    lda #<FORM_SCREEN
    sta print_set_screen.screen
    lda #>FORM_SCREEN
    sta print_set_screen.screen+1
    jsr print_set_screen
    jsr print_cls
    lda #<FORM_TEXT
    sta print_str_lines.str
    lda #>FORM_TEXT
    sta print_str_lines.str+1
    jsr print_str_lines
    jsr form_set_screen
    jsr form_render_values
    lda form_fields_val
    jsr render_preset_name
    // DTV Graphics Bank
    lda #($ffffffff&FORM_CHARSET)/$10000
    sta DTV_GRAPHICS_VIC_BANK
    // DTV Color Bank
    lda #DTV_COLOR_BANK_DEFAULT/$400
    sta DTV_COLOR_BANK_LO
    lda #0
    sta DTV_COLOR_BANK_HI
    // VIC Graphics Bank
    lda #3
    sta CIA2_PORT_A_DDR
    // Set VIC Bank bits to output - all others to input
    lda #3^FORM_CHARSET/$4000
    sta CIA2_PORT_A
    // Set VIC Bank
    // DTV Graphics Mode
    lda #0
    sta DTV_CONTROL
    // VIC Graphics Mode
    lda #VIC_DEN|VIC_RSEL|3
    sta VIC_CONTROL
    lda #VIC_CSEL
    sta VIC_CONTROL2
    // VIC Memory Pointers
    lda #(FORM_SCREEN&$3fff)/$40|(FORM_CHARSET&$3fff)/$400
    sta VIC_MEMORY
    // DTV Plane A to FORM_SCREEN also
    lda #<FORM_SCREEN
    sta DTV_PLANEA_START_LO
    lda #>FORM_SCREEN
    sta DTV_PLANEA_START_MI
    lda #0
    sta DTV_PLANEA_START_HI
    tax
  // DTV Palette - default
  b1:
    lda DTV_PALETTE_DEFAULT,x
    sta DTV_PALETTE,x
    inx
    cpx #$10
    bne b1
    // Screen colors
    lda #0
    sta BGCOL
    sta BORDERCOL
    lda form_fields_val
    sta preset_current
  // Let the user change values in the form
  b5:
    lda RASTER
    cmp #$ff
    bne b5
    jsr form_control
    txa
    cmp #0
    beq b8
    rts
  b8:
    lda form_fields_val
    cmp preset_current
    beq b5
    jsr apply_preset
    lda form_fields_val
    sta preset_current
    jsr form_render_values
    lda form_fields_val
    jsr render_preset_name
    jmp b5
}
// Render form preset name in the form
// idx is the ID of the preset
// render_preset_name(byte register(A) idx)
render_preset_name: {
    .label name = 3
    cmp #0
    beq b33
    cmp #1
    beq b1
    cmp #2
    beq b2
    cmp #3
    beq b3
    cmp #4
    beq b4
    cmp #5
    beq b5
    cmp #6
    beq b6
    cmp #7
    beq b7
    cmp #8
    beq b8
    cmp #9
    beq b9
    cmp #$a
    beq b10
  b33:
    lda #<name_1
    sta name
    lda #>name_1
    sta name+1
    jmp b22
  b1:
    lda #<name_2
    sta name
    lda #>name_2
    sta name+1
    jmp b22
  b2:
    lda #<name_3
    sta name
    lda #>name_3
    sta name+1
    jmp b22
  b3:
    lda #<name_4
    sta name
    lda #>name_4
    sta name+1
    jmp b22
  b4:
    lda #<name_5
    sta name
    lda #>name_5
    sta name+1
    jmp b22
  b5:
    lda #<name_6
    sta name
    lda #>name_6
    sta name+1
    jmp b22
  b6:
    lda #<name_7
    sta name
    lda #>name_7
    sta name+1
    jmp b22
  b7:
    lda #<name_8
    sta name
    lda #>name_8
    sta name+1
    jmp b22
  b8:
    lda #<name_9
    sta name
    lda #>name_9
    sta name+1
    jmp b22
  b9:
    lda #<name_10
    sta name
    lda #>name_10
    sta name+1
    jmp b22
  b10:
    lda #<name_11
    sta name
    lda #>name_11
    sta name+1
  b22:
    jsr print_str_at
    rts
    name_1: .text "Standard Charset              @"
    name_2: .text "Extended Color Charset        @"
    name_3: .text "Standard Bitmap               @"
    name_4: .text "Multicolor Bitmap             @"
    name_5: .text "Hicolor Charset               @"
    name_6: .text "Hicolor Extended Color Charset@"
    name_7: .text "Twoplane Bitmap               @"
    name_8: .text "Chunky 8bpp                   @"
    name_9: .text "Sixs Fred                     @"
    name_10: .text "Sixs Fred 2                   @"
    name_11: .text "8bpp Pixel Cell               @"
}
// Print a string at a specific screen position
// print_str_at(byte* zeropage(3) str, byte* zeropage(5) at)
print_str_at: {
    .label at = 5
    .label str = 3
    lda #<FORM_SCREEN+$28*2+$a
    sta at
    lda #>FORM_SCREEN+$28*2+$a
    sta at+1
  b1:
    ldy #0
    lda (str),y
    cmp #'@'
    bne b2
    rts
  b2:
    ldy #0
    lda (str),y
    sta (at),y
    inc at
    bne !+
    inc at+1
  !:
    inc str
    bne !+
    inc str+1
  !:
    jmp b1
}
// Render all form values from the form_fields_val array
form_render_values: {
    .label field = 3
    .label idx = 2
    lda #0
    sta idx
  b1:
    ldy idx
    jsr form_field_ptr
    ldx idx
    ldy form_fields_val,x
    lda print_hextab,y
    ldy #0
    sta (field),y
    inc idx
    lda idx
    cmp #form_fields_cnt
    bcc b1
    rts
}
// Get the screen address of a form field
// field_idx is the index of the field to get the screen address for
// form_field_ptr(byte register(Y) field_idx)
form_field_ptr: {
    .label return = 3
    .label _2 = 3
    ldx form_fields_y,y
    lda form_line_hi,x
    sta _2+1
    lda form_line_lo,x
    sta _2
    lda form_fields_x,y
    clc
    adc return
    sta return
    bcc !+
    inc return+1
  !:
    rts
}
// Apply a form value preset to the form values
// idx is the ID of the preset
// apply_preset(byte register(A) idx)
apply_preset: {
    .label preset = 3
    cmp #0
    beq b34
    cmp #1
    beq b1
    cmp #2
    beq b2
    cmp #3
    beq b3
    cmp #4
    beq b4
    cmp #5
    beq b5
    cmp #6
    beq b6
    cmp #7
    beq b7
    cmp #8
    beq b8
    cmp #9
    beq b9
    cmp #$a
    beq b10
  b34:
    lda #<preset_stdchar
    sta preset
    lda #>preset_stdchar
    sta preset+1
    jmp b22
  b1:
    lda #<preset_ecmchar
    sta preset
    lda #>preset_ecmchar
    sta preset+1
    jmp b22
  b2:
    lda #<preset_stdbm
    sta preset
    lda #>preset_stdbm
    sta preset+1
    jmp b22
  b3:
    lda #<preset_mcbm
    sta preset
    lda #>preset_mcbm
    sta preset+1
    jmp b22
  b4:
    lda #<preset_hi_stdchar
    sta preset
    lda #>preset_hi_stdchar
    sta preset+1
    jmp b22
  b5:
    lda #<preset_hi_ecmchar
    sta preset
    lda #>preset_hi_ecmchar
    sta preset+1
    jmp b22
  b6:
    lda #<preset_twoplane
    sta preset
    lda #>preset_twoplane
    sta preset+1
    jmp b22
  b7:
    lda #<preset_chunky
    sta preset
    lda #>preset_chunky
    sta preset+1
    jmp b22
  b8:
    lda #<preset_sixsfred
    sta preset
    lda #>preset_sixsfred
    sta preset+1
    jmp b22
  b9:
    lda #<preset_sixsfred2
    sta preset
    lda #>preset_sixsfred2
    sta preset+1
    jmp b22
  b10:
    lda #<preset_8bpppixelcell
    sta preset
    lda #>preset_8bpppixelcell
    sta preset+1
  b22:
    ldy #0
  // Copy preset values into the fields
  b23:
    lda (preset),y
    sta form_fields_val,y
    iny
    cpy #form_fields_cnt
    bne b23
    rts
}
// Reads keyboard and allows the user to navigate and change the fields of the form
// Returns 0 if space is not pressed, non-0 if space is pressed
form_control: {
    .label field = 3
    ldy form_field_idx
    jsr form_field_ptr
    dec form_cursor_count
    lda form_cursor_count
    cmp #0
    bpl b1
    lda #FORM_CURSOR_BLINK
    sta form_cursor_count
  b1:
    lda form_cursor_count
    sec
    sbc #FORM_CURSOR_BLINK/2
    bvc !+
    eor #$80
  !:
    bpl !b2+
    jmp b2
  !b2:
    lda #$7f
    ldy #0
    and (field),y
    sta (field),y
  b3:
    jsr keyboard_event_scan
    jsr keyboard_event_get
    cmp #KEY_CRSR_DOWN
    bne b4
    lda #$7f
    ldy #0
    and (field),y
    // Unblink the cursor
    sta (field),y
    txa
    and #KEY_MODIFIER_SHIFT
    cmp #0
    beq b5
    dec form_field_idx
    lda form_field_idx
    cmp #$ff
    bne b7
    lda #form_fields_cnt-1
    sta form_field_idx
  b7:
    lda #FORM_CURSOR_BLINK/2
    sta form_cursor_count
    ldx #0
  breturn:
    rts
  b5:
    inc form_field_idx
    lda form_field_idx
    cmp #form_fields_cnt
    bne b7
    lda #0
    sta form_field_idx
    jmp b7
  b4:
    cmp #KEY_CRSR_RIGHT
    bne b9
    txa
    and #KEY_MODIFIER_SHIFT
    cmp #0
    beq b10
    ldx form_field_idx
    dec form_fields_val,x
    ldy form_field_idx
    lda form_fields_val,y
    cmp #$ff
    bne b12
    lda form_fields_max,y
    sta form_fields_val,y
  b12:
    // Render field value
    ldx form_field_idx
    ldy form_fields_val,x
    lda print_hextab,y
    ldy #0
    sta (field),y
  b6:
    ldx #0
    jmp breturn
  b10:
    ldx form_field_idx
    inc form_fields_val,x
    ldy form_field_idx
    lda form_fields_val,y
    cmp form_fields_max,y
    bcc b12
    beq b12
    lda #0
    sta form_fields_val,y
    jmp b12
  b9:
    cmp #KEY_SPACE
    bne b6
    ldx #$ff
    jmp breturn
  b2:
    lda #$80
    ldy #0
    ora (field),y
    sta (field),y
    jmp b3
}
// Set the screen to use for the form.
// screen is the start address of the screen to use
form_set_screen: {
    .label line = 3
    ldx #0
    lda #<FORM_SCREEN
    sta line
    lda #>FORM_SCREEN
    sta line+1
  b1:
    lda line
    sta form_line_lo,x
    lda line+1
    sta form_line_hi,x
    lda #$28
    clc
    adc line
    sta line
    bcc !+
    inc line+1
  !:
    inx
    cpx #$19
    bne b1
    rts
}
// Print a number of zero-terminated strings, each followed by a newline.
// The sequence of lines is terminated by another zero.
// print_str_lines(byte* zeropage(3) str)
print_str_lines: {
    .label str = 3
    lda print_set_screen.screen
    sta print_char_cursor
    lda print_set_screen.screen+1
    sta print_char_cursor+1
  b1:
    ldy #0
    lda (str),y
    cmp #'@'
    bne b4
    rts
  b4:
    ldy #0
    lda (str),y
    inc str
    bne !+
    inc str+1
  !:
    cmp #'@'
    beq b5
    ldy #0
    sta (print_char_cursor),y
    inc print_char_cursor
    bne !+
    inc print_char_cursor+1
  !:
  b5:
    cmp #'@'
    bne b4
    jsr print_ln
    lda print_line_cursor
    sta print_char_cursor
    lda print_line_cursor+1
    sta print_char_cursor+1
    jmp b1
}
// Print a newline
print_ln: {
  b1:
    lda #$28
    clc
    adc print_line_cursor
    sta print_line_cursor
    bcc !+
    inc print_line_cursor+1
  !:
    lda print_line_cursor+1
    cmp print_char_cursor+1
    bcc b1
    bne !+
    lda print_line_cursor
    cmp print_char_cursor
    bcc b1
  !:
    rts
}
// Clear the screen. Also resets current line/char cursor.
print_cls: {
    .label _0 = 5
    .label sc = 3
    lda print_set_screen.screen
    sta sc
    lda print_set_screen.screen+1
    sta sc+1
  b1:
    lda #' '
    ldy #0
    sta (sc),y
    inc sc
    bne !+
    inc sc+1
  !:
    lda print_set_screen.screen
    clc
    adc #<$3e8
    sta _0
    lda print_set_screen.screen+1
    adc #>$3e8
    sta _0+1
    lda sc+1
    cmp _0+1
    bne b1
    lda sc
    cmp _0
    bne b1
    rts
}
// Set the screen to print on. Also resets current line/char cursor.
// print_set_screen(byte* zeropage($10) screen)
print_set_screen: {
    .label screen = $10
    rts
}
// Initialize the different graphics in the memory
gfx_init: {
    jsr gfx_init_screen0
    jsr gfx_init_screen1
    jsr gfx_init_screen2
    jsr gfx_init_screen3
    jsr gfx_init_screen4
    jsr gfx_init_charset
    jsr gfx_init_vic_bitmap
    jsr gfx_init_plane_8bppchunky
    jsr gfx_init_plane_charset8
    jsr gfx_init_plane_horisontal
    jsr gfx_init_plane_vertical
    jsr gfx_init_plane_horisontal2
    jsr gfx_init_plane_vertical2
    jsr gfx_init_plane_blank
    jsr gfx_init_plane_full
    rts
}
// Initialize Plane with all pixels
gfx_init_plane_full: {
    lda #$ff
    sta gfx_init_plane_fill.fill
    lda #<PLANE_FULL
    sta gfx_init_plane_fill.plane_addr
    lda #>PLANE_FULL
    sta gfx_init_plane_fill.plane_addr+1
    lda #<PLANE_FULL>>$10
    sta gfx_init_plane_fill.plane_addr+2
    lda #>PLANE_FULL>>$10
    sta gfx_init_plane_fill.plane_addr+3
    jsr gfx_init_plane_fill
    rts
}
// Initialize 320*200 1bpp pixel ($2000) plane with identical bytes
// gfx_init_plane_fill(dword zeropage(9) plane_addr, byte zeropage(2) fill)
gfx_init_plane_fill: {
    .label _0 = $13
    .label _1 = 3
    .label _4 = 3
    .label _5 = 3
    .label _6 = 3
    .label gfxb = 3
    .label by = 7
    .label plane_addr = 9
    .label fill = 2
    lda plane_addr
    sta _0
    lda plane_addr+1
    sta _0+1
    lda plane_addr+2
    sta _0+2
    lda plane_addr+3
    sta _0+3
    asl _0
    rol _0+1
    rol _0+2
    rol _0+3
    asl _0
    rol _0+1
    rol _0+2
    rol _0+3
    lda _0+2
    sta _1
    lda _0+3
    sta _1+1
    lda _1
    tax
    txa
    jsr dtvSetCpuBankSegment1
    inx
    lda plane_addr
    sta _4
    lda plane_addr+1
    sta _4+1
    lda _5
    and #<$3fff
    sta _5
    lda _5+1
    and #>$3fff
    sta _5+1
    clc
    lda _6
    adc #<$4000
    sta _6
    lda _6+1
    adc #>$4000
    sta _6+1
    lda #0
    sta by
  b1:
    ldx #0
  b2:
    lda fill
    ldy #0
    sta (gfxb),y
    inc gfxb
    bne !+
    inc gfxb+1
  !:
    inx
    cpx #$28
    bne b2
    inc by
    lda by
    cmp #$c8
    bne b1
    lda #$4000/$4000
    jsr dtvSetCpuBankSegment1
    rts
}
// Set the memory pointed to by CPU BANK 1 SEGMENT ($4000-$7fff)
// This sets which actual memory is addressed when the CPU reads/writes to $4000-$7fff
// The actual memory addressed will be $4000*cpuSegmentIdx
// dtvSetCpuBankSegment1(byte register(A) cpuBankIdx)
dtvSetCpuBankSegment1: {
    // Move CPU BANK 1 SEGMENT ($4000-$7fff)
    .label cpuBank = $ff
    sta cpuBank
    .byte $32, $dd
    lda $ff
    .byte $32, $00
    rts
}
// Initialize Plane with blank pixels
gfx_init_plane_blank: {
    lda #0
    sta gfx_init_plane_fill.fill
    lda #<PLANE_BLANK
    sta gfx_init_plane_fill.plane_addr
    lda #>PLANE_BLANK
    sta gfx_init_plane_fill.plane_addr+1
    lda #<PLANE_BLANK>>$10
    sta gfx_init_plane_fill.plane_addr+2
    lda #>PLANE_BLANK>>$10
    sta gfx_init_plane_fill.plane_addr+3
    jsr gfx_init_plane_fill
    rts
}
// Initialize Plane with Vertical Stripes every 2 pixels
gfx_init_plane_vertical2: {
    lda #$1b
    sta gfx_init_plane_fill.fill
    lda #<PLANE_VERTICAL2
    sta gfx_init_plane_fill.plane_addr
    lda #>PLANE_VERTICAL2
    sta gfx_init_plane_fill.plane_addr+1
    lda #<PLANE_VERTICAL2>>$10
    sta gfx_init_plane_fill.plane_addr+2
    lda #>PLANE_VERTICAL2>>$10
    sta gfx_init_plane_fill.plane_addr+3
    jsr gfx_init_plane_fill
    rts
}
// Initialize Plane with Horizontal Stripes every 2 pixels
gfx_init_plane_horisontal2: {
    .const gfxbCpuBank = PLANE_HORISONTAL2/$4000
    .label gfxa = 3
    .label ay = 2
    lda #gfxbCpuBank
    jsr dtvSetCpuBankSegment1
    lda #<$4000+(PLANE_HORISONTAL2&$3fff)
    sta gfxa
    lda #>$4000+(PLANE_HORISONTAL2&$3fff)
    sta gfxa+1
    lda #0
    sta ay
  b1:
    ldx #0
  b2:
    lda ay
    lsr
    and #3
    tay
    lda row_bitmask,y
    ldy #0
    sta (gfxa),y
    inc gfxa
    bne !+
    inc gfxa+1
  !:
    inx
    cpx #$28
    bne b2
    inc ay
    lda ay
    cmp #$c8
    bne b1
    lda #$4000/$4000
    jsr dtvSetCpuBankSegment1
    rts
    row_bitmask: .byte 0, $55, $aa, $ff
}
// Initialize Plane with Vertical Stripes
gfx_init_plane_vertical: {
    .const gfxbCpuBank = PLANE_VERTICAL/$4000
    .label gfxb = 3
    .label by = 2
    lda #gfxbCpuBank
    jsr dtvSetCpuBankSegment1
    lda #0
    sta by
    lda #<$4000+(PLANE_VERTICAL&$3fff)
    sta gfxb
    lda #>$4000+(PLANE_VERTICAL&$3fff)
    sta gfxb+1
  b1:
    ldx #0
  b2:
    lda #$f
    ldy #0
    sta (gfxb),y
    inc gfxb
    bne !+
    inc gfxb+1
  !:
    inx
    cpx #$28
    bne b2
    inc by
    lda by
    cmp #$c8
    bne b1
    lda #$4000/$4000
    jsr dtvSetCpuBankSegment1
    rts
}
// Initialize Plane with Horizontal Stripes
gfx_init_plane_horisontal: {
    .const gfxbCpuBank = PLANE_HORISONTAL/$4000
    .label gfxa = 3
    .label ay = 2
    lda #gfxbCpuBank
    jsr dtvSetCpuBankSegment1
    lda #<$4000+(PLANE_HORISONTAL&$3fff)
    sta gfxa
    lda #>$4000+(PLANE_HORISONTAL&$3fff)
    sta gfxa+1
    lda #0
    sta ay
  b1:
    ldx #0
  b2:
    lda #4
    and ay
    cmp #0
    beq b3
    lda #$ff
    ldy #0
    sta (gfxa),y
    inc gfxa
    bne !+
    inc gfxa+1
  !:
  b4:
    inx
    cpx #$28
    bne b2
    inc ay
    lda ay
    cmp #$c8
    bne b1
    lda #$4000/$4000
    jsr dtvSetCpuBankSegment1
    rts
  b3:
    lda #0
    tay
    sta (gfxa),y
    inc gfxa
    bne !+
    inc gfxa+1
  !:
    jmp b4
}
// Initialize Plane with 8bpp charset
gfx_init_plane_charset8: {
    .const gfxbCpuBank = PLANE_CHARSET8/$4000
    .label bits = 8
    .label chargen = 3
    .label gfxa = 5
    .label col = $d
    .label cr = 7
    .label ch = 2
    lda #gfxbCpuBank
    jsr dtvSetCpuBankSegment1
    lda #PROCPORT_RAM_CHARROM
    sta PROCPORT
    lda #0
    sta ch
    sta col
    lda #<$4000+(PLANE_CHARSET8&$3fff)
    sta gfxa
    lda #>$4000+(PLANE_CHARSET8&$3fff)
    sta gfxa+1
    lda #<CHARGEN
    sta chargen
    lda #>CHARGEN
    sta chargen+1
  b1:
    lda #0
    sta cr
  b2:
    ldy #0
    lda (chargen),y
    sta bits
    inc chargen
    bne !+
    inc chargen+1
  !:
    ldx #0
  b3:
    lda #$80
    and bits
    cmp #0
    beq b5
    lda col
    jmp b4
  b5:
    lda #0
  b4:
    ldy #0
    sta (gfxa),y
    inc gfxa
    bne !+
    inc gfxa+1
  !:
    asl bits
    inc col
    inx
    cpx #8
    bne b3
    inc cr
    lda cr
    cmp #8
    bne b2
    inc ch
    lda ch
    cmp #0
    bne b1
    lda #PROCPORT_RAM_IO
    sta PROCPORT
    lda #$4000/$4000
    jsr dtvSetCpuBankSegment1
    rts
}
// Initialize 8BPP Chunky Bitmap (contains 8bpp pixels)
gfx_init_plane_8bppchunky: {
    .label _6 = $10
    .label gfxb = 5
    .label x = 3
    .label y = 2
    lda #PLANE_8BPP_CHUNKY/$4000
    jsr dtvSetCpuBankSegment1
    ldx #PLANE_8BPP_CHUNKY/$4000+1
    lda #0
    sta y
    lda #<$4000
    sta gfxb
    lda #>$4000
    sta gfxb+1
  b1:
    lda #0
    sta x
    sta x+1
  b2:
    lda gfxb+1
    cmp #>$8000
    bne b3
    lda gfxb
    cmp #<$8000
    bne b3
    txa
    jsr dtvSetCpuBankSegment1
    inx
    lda #<$4000
    sta gfxb
    lda #>$4000
    sta gfxb+1
  b3:
    lda y
    clc
    adc x
    sta _6
    lda #0
    adc x+1
    sta _6+1
    lda _6
    ldy #0
    sta (gfxb),y
    inc gfxb
    bne !+
    inc gfxb+1
  !:
    inc x
    bne !+
    inc x+1
  !:
    lda x+1
    cmp #>$140
    bne b2
    lda x
    cmp #<$140
    bne b2
    inc y
    lda y
    cmp #$c8
    bne b1
    lda #$4000/$4000
    jsr dtvSetCpuBankSegment1
    rts
}
// Initialize VIC bitmap
gfx_init_vic_bitmap: {
    .const lines_cnt = 9
    .label l = 2
    jsr bitmap_init
    jsr bitmap_clear
    lda #0
    sta l
  b1:
    ldy l
    lda lines_x,y
    sta bitmap_line.x0
    ldx lines_x+1,y
    lda lines_y,y
    sta bitmap_line.y0
    lda lines_y+1,y
    sta bitmap_line.y1
    jsr bitmap_line
    inc l
    lda l
    cmp #lines_cnt
    bcc b1
    rts
    lines_x: .byte 0, $ff, $ff, 0, 0, $80, $ff, $80, 0, $80
    lines_y: .byte 0, 0, $c7, $c7, 0, 0, $64, $c7, $64, 0
}
// Draw a line on the bitmap
// bitmap_line(byte zeropage($d) x0, byte register(X) x1, byte zeropage($f) y0, byte zeropage($12) y1)
bitmap_line: {
    .label xd = 8
    .label x0 = $d
    .label y0 = $f
    .label y1 = $12
    txa
    cmp x0
    beq !+
    bcs b1
  !:
    txa
    eor #$ff
    sec
    adc x0
    sta xd
    lda y0
    cmp y1
    bcc b2
    sec
    sbc y1
    tay
    cpy xd
    bcc b3
    lda y1
    sta bitmap_line_ydxi.y
    lda y0
    sta bitmap_line_ydxi.y1
    sty bitmap_line_ydxi.yd
    jsr bitmap_line_ydxi
  breturn:
    rts
  b3:
    stx bitmap_line_xdyi.x
    lda y1
    sta bitmap_line_xdyi.y
    sty bitmap_line_xdyi.yd
    jsr bitmap_line_xdyi
    jmp breturn
  b2:
    lda y1
    sec
    sbc y0
    tay
    cpy xd
    bcc b6
    lda y0
    sta bitmap_line_ydxd.y
    ldx x0
    lda y1
    sta bitmap_line_ydxd.y1
    sty bitmap_line_ydxd.yd
    jsr bitmap_line_ydxd
    jmp breturn
  b6:
    stx bitmap_line_xdyd.x
    lda y1
    sta bitmap_line_xdyd.y
    sty bitmap_line_xdyd.yd
    jsr bitmap_line_xdyd
    jmp breturn
  b1:
    txa
    sec
    sbc x0
    sta xd
    lda y0
    cmp y1
    bcc b9
    sec
    sbc y1
    tay
    cpy xd
    bcc b10
    lda y1
    sta bitmap_line_ydxd.y
    sty bitmap_line_ydxd.yd
    jsr bitmap_line_ydxd
    jmp breturn
  b10:
    lda x0
    sta bitmap_line_xdyd.x
    stx bitmap_line_xdyd.x1
    sty bitmap_line_xdyd.yd
    jsr bitmap_line_xdyd
    jmp breturn
  b9:
    lda y1
    sec
    sbc y0
    tay
    cpy xd
    bcc b13
    lda y0
    sta bitmap_line_ydxi.y
    ldx x0
    sty bitmap_line_ydxi.yd
    jsr bitmap_line_ydxi
    jmp breturn
  b13:
    lda x0
    sta bitmap_line_xdyi.x
    stx bitmap_line_xdyi.x1
    sty bitmap_line_xdyi.yd
    jsr bitmap_line_xdyi
    jmp breturn
}
// bitmap_line_xdyi(byte zeropage($e) x, byte zeropage($f) y, byte zeropage($d) x1, byte zeropage(8) xd, byte zeropage(7) yd)
bitmap_line_xdyi: {
    .label x = $e
    .label y = $f
    .label x1 = $d
    .label xd = 8
    .label yd = 7
    .label e = $12
    lda yd
    lsr
    sta e
  b1:
    ldx x
    ldy y
    jsr bitmap_plot
    inc x
    lda e
    clc
    adc yd
    sta e
    lda xd
    cmp e
    bcs b2
    inc y
    lda e
    sec
    sbc xd
    sta e
  b2:
    ldx x1
    inx
    cpx x
    bne b1
    rts
}
// bitmap_plot(byte register(X) x, byte register(Y) y)
bitmap_plot: {
    .label _0 = 3
    .label plotter_x = 3
    .label plotter_y = 5
    lda bitmap_plot_xhi,x
    sta plotter_x+1
    lda bitmap_plot_xlo,x
    sta plotter_x
    lda bitmap_plot_yhi,y
    sta plotter_y+1
    lda bitmap_plot_ylo,y
    sta plotter_y
    lda _0
    clc
    adc plotter_y
    sta _0
    lda _0+1
    adc plotter_y+1
    sta _0+1
    lda bitmap_plot_bit,x
    ldy #0
    ora (_0),y
    sta (_0),y
    rts
}
// bitmap_line_ydxi(byte zeropage($e) y, byte register(X) x, byte zeropage($12) y1, byte zeropage(7) yd, byte zeropage(8) xd)
bitmap_line_ydxi: {
    .label y = $e
    .label y1 = $12
    .label yd = 7
    .label xd = 8
    .label e = $d
    lda xd
    lsr
    sta e
  b1:
    ldy y
    jsr bitmap_plot
    inc y
    lda e
    clc
    adc xd
    sta e
    lda yd
    cmp e
    bcs b2
    inx
    lda e
    sec
    sbc yd
    sta e
  b2:
    lda y1
    clc
    adc #1
    cmp y
    bne b1
    rts
}
// bitmap_line_xdyd(byte zeropage($e) x, byte zeropage($f) y, byte zeropage($d) x1, byte zeropage(8) xd, byte zeropage(7) yd)
bitmap_line_xdyd: {
    .label x = $e
    .label y = $f
    .label x1 = $d
    .label xd = 8
    .label yd = 7
    .label e = $12
    lda yd
    lsr
    sta e
  b1:
    ldx x
    ldy y
    jsr bitmap_plot
    inc x
    lda e
    clc
    adc yd
    sta e
    lda xd
    cmp e
    bcs b2
    dec y
    lda e
    sec
    sbc xd
    sta e
  b2:
    ldx x1
    inx
    cpx x
    bne b1
    rts
}
// bitmap_line_ydxd(byte zeropage($e) y, byte register(X) x, byte zeropage($f) y1, byte zeropage(7) yd, byte zeropage(8) xd)
bitmap_line_ydxd: {
    .label y = $e
    .label y1 = $f
    .label yd = 7
    .label xd = 8
    .label e = $d
    lda xd
    lsr
    sta e
  b1:
    ldy y
    jsr bitmap_plot
    inc y
    lda e
    clc
    adc xd
    sta e
    lda yd
    cmp e
    bcs b2
    dex
    lda e
    sec
    sbc yd
    sta e
  b2:
    lda y1
    clc
    adc #1
    cmp y
    bne b1
    rts
}
// Clear all graphics on the bitmap
bitmap_clear: {
    .label bitmap = 3
    .label y = 2
    .label _3 = 3
    lda bitmap_plot_xlo
    sta _3
    lda bitmap_plot_xhi
    sta _3+1
    lda #0
    sta y
  b1:
    ldx #0
  b2:
    lda #0
    tay
    sta (bitmap),y
    inc bitmap
    bne !+
    inc bitmap+1
  !:
    inx
    cpx #$c8
    bne b2
    inc y
    lda y
    cmp #$28
    bne b1
    rts
}
// Initialize the bitmap plotter tables for a specific bitmap
bitmap_init: {
    .label _6 = 2
    .label yoffs = 3
    ldy #$80
    ldx #0
  b1:
    txa
    and #$f8
    sta bitmap_plot_xlo,x
    lda #>VIC_BITMAP
    sta bitmap_plot_xhi,x
    tya
    sta bitmap_plot_bit,x
    tya
    lsr
    tay
    cpy #0
    bne b2
    ldy #$80
  b2:
    inx
    cpx #0
    bne b1
    lda #<0
    sta yoffs
    sta yoffs+1
    tax
  b3:
    txa
    and #7
    sta _6
    lda yoffs
    ora _6
    sta bitmap_plot_ylo,x
    lda yoffs+1
    sta bitmap_plot_yhi,x
    txa
    and #7
    cmp #7
    bne b4
    clc
    lda yoffs
    adc #<$28*8
    sta yoffs
    lda yoffs+1
    adc #>$28*8
    sta yoffs+1
  b4:
    inx
    cpx #0
    bne b3
    rts
}
gfx_init_charset: {
    .label charset = 5
    .label chargen = 3
    .label c = 2
    lda #$32
    sta PROCPORT
    lda #0
    sta c
    lda #<VIC_CHARSET_ROM
    sta charset
    lda #>VIC_CHARSET_ROM
    sta charset+1
    lda #<CHARGEN
    sta chargen
    lda #>CHARGEN
    sta chargen+1
  b1:
    ldx #0
  b2:
    ldy #0
    lda (chargen),y
    sta (charset),y
    inc charset
    bne !+
    inc charset+1
  !:
    inc chargen
    bne !+
    inc chargen+1
  !:
    inx
    cpx #8
    bne b2
    inc c
    lda c
    cmp #0
    bne b1
    lda #$37
    sta PROCPORT
    rts
}
// Initialize VIC screen 4 - all chars are 00
gfx_init_screen4: {
    .label ch = 3
    .label cy = 2
    lda #0
    sta cy
    lda #<VIC_SCREEN4
    sta ch
    lda #>VIC_SCREEN4
    sta ch+1
  b1:
    ldx #0
  b2:
    lda #0
    tay
    sta (ch),y
    inc ch
    bne !+
    inc ch+1
  !:
    inx
    cpx #$28
    bne b2
    inc cy
    lda cy
    cmp #$19
    bne b1
    rts
}
// Initialize VIC screen 3 ( value is %00xx00yy where xx is xpos and yy is ypos
gfx_init_screen3: {
    .label _1 = 7
    .label ch = 3
    .label cy = 2
    lda #<VIC_SCREEN3
    sta ch
    lda #>VIC_SCREEN3
    sta ch+1
    lda #0
    sta cy
  b1:
    ldx #0
  b2:
    txa
    and #3
    asl
    asl
    asl
    asl
    sta _1
    lda #3
    and cy
    ora _1
    ldy #0
    sta (ch),y
    inc ch
    bne !+
    inc ch+1
  !:
    inx
    cpx #$28
    bne b2
    inc cy
    lda cy
    cmp #$19
    bne b1
    rts
}
// Initialize VIC screen 2 ( value is %ccccrrrr where cccc is (x+y mod $f) and rrrr is %1111-%cccc)
gfx_init_screen2: {
    .label col2 = 7
    .label ch = 3
    .label cy = 2
    lda #<VIC_SCREEN2
    sta ch
    lda #>VIC_SCREEN2
    sta ch+1
    lda #0
    sta cy
  b1:
    ldx #0
  b2:
    txa
    clc
    adc cy
    and #$f
    tay
    tya
    eor #$ff
    clc
    adc #$f+1
    sta col2
    tya
    asl
    asl
    asl
    asl
    ora col2
    ldy #0
    sta (ch),y
    inc ch
    bne !+
    inc ch+1
  !:
    inx
    cpx #$28
    bne b2
    inc cy
    lda cy
    cmp #$19
    bne b1
    rts
}
// Initialize VIC screen 1 ( value is %0000cccc where cccc is (x+y mod $f))
gfx_init_screen1: {
    .label ch = 3
    .label cy = 2
    lda #<VIC_SCREEN1
    sta ch
    lda #>VIC_SCREEN1
    sta ch+1
    lda #0
    sta cy
  b1:
    ldx #0
  b2:
    txa
    clc
    adc cy
    and #$f
    ldy #0
    sta (ch),y
    inc ch
    bne !+
    inc ch+1
  !:
    inx
    cpx #$28
    bne b2
    inc cy
    lda cy
    cmp #$19
    bne b1
    rts
}
// Initialize VIC screen 0 ( value is %yyyyxxxx where yyyy is ypos and xxxx is xpos)
gfx_init_screen0: {
    .label _1 = 7
    .label ch = 3
    .label cy = 2
    lda #<VIC_SCREEN0
    sta ch
    lda #>VIC_SCREEN0
    sta ch+1
    lda #0
    sta cy
  b1:
    ldx #0
  b2:
    lda #$f
    and cy
    asl
    asl
    asl
    asl
    sta _1
    txa
    and #$f
    ora _1
    ldy #0
    sta (ch),y
    inc ch
    bne !+
    inc ch+1
  !:
    inx
    cpx #$28
    bne b2
    inc cy
    lda cy
    cmp #$19
    bne b1
    rts
}
// Initialize keyboard reading by setting CIA#$ Data Direction Registers
keyboard_init: {
    // Keyboard Matrix Columns Write Mode
    lda #$ff
    sta CIA1_PORT_A_DDR
    // Keyboard Matrix Columns Read Mode
    lda #0
    sta CIA1_PORT_B_DDR
    rts
}
  // Default vallues for the palette
  DTV_PALETTE_DEFAULT: .byte 0, $f, $36, $be, $58, $db, $86, $ff, $29, $26, $3b, 5, 7, $df, $9a, $a
  print_hextab: .text "0123456789abcdef"
  // Keyboard row bitmask as expected by CIA#1 Port A when reading a specific keyboard matrix row (rows are numbered 0-7)
  keyboard_matrix_row_bitmask: .byte $fe, $fd, $fb, $f7, $ef, $df, $bf, $7f
  // Keyboard matrix column bitmasks for a specific keybooard matrix column when reading the keyboard. (columns are numbered 0-7)
  keyboard_matrix_col_bitmask: .byte 1, 2, 4, 8, $10, $20, $40, $80
  // Keyboard event buffer. Contains keycodes for key presses/releases. Presses are represented by the keycode. Releases by keycode | $40. The buffer is filled by keyboard_scan()
  keyboard_events: .fill 8, 0
  // The values scanned values for each row. Set by keyboard_scan() and used by keyboard_get_event()
  keyboard_scan_values: .fill 8, 0
  // Tables for the plotter - initialized by calling bitmap_draw_init();
  bitmap_plot_xlo: .fill $100, 0
  bitmap_plot_xhi: .fill $100, 0
  bitmap_plot_ylo: .fill $100, 0
  bitmap_plot_yhi: .fill $100, 0
  bitmap_plot_bit: .fill $100, 0
  // Form fields x/y-positions
  form_fields_x: .byte 8, $c, $c, $c, $c, $c, $c, $c, $c, $c, $19, $18, $19, $18, $19, $18, $19, $19, $18, $19, $18, $19, $18, $19, $25, $25, $25, $25, $24, $25, $24, $25, $24, $25, $24, $25
  form_fields_y: .byte 2, 5, 6, 7, 8, 9, $a, $b, $c, $d, 5, 6, 6, 7, 7, 8, 8, $b, $c, $c, $d, $d, $e, $e, 5, 6, 7, $a, $b, $b, $c, $c, $d, $d, $e, $e
  // Form field max values (all values are in the interval 0..max)
  form_fields_max: .byte $a, 1, 1, 1, 1, 1, 1, 1, 1, 1, $d, $f, $f, $f, $f, $f, $f, $d, $f, $f, $f, $f, $f, $f, 3, 1, 4, 1, $f, $f, $f, $f, $f, $f, $f, $f
  // Form fields values
  form_fields_val: .byte 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
  // Preset: Standard Char Mode
  preset_stdchar: .byte 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0
  // Preset: Extended Color Char Mode
  preset_ecmchar: .byte 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 2, 0, 5, 0, 6
  // Preset: Standard Bitmap
  preset_stdbm: .byte 2, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
  // Preset: MC Bitmap
  preset_mcbm: .byte 3, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 1, 0, 0, 0, 9, 0, 0, 0, 0, 0, 0
  // Preset: Hicolor Standard Char Mode
  preset_hi_stdchar: .byte 4, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0
  // Preset: Hicolor Extended Color Char Mode
  preset_hi_ecmchar: .byte 5, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 3, 4, 6, 8, 9, $c, $c
  // Preset: Two plane mode
  preset_twoplane: .byte 6, 1, 0, 1, 1, 1, 0, 0, 0, 0, 7, 0, 0, 0, 1, 0, 0, 8, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 7, 0, $d, 4, 0, 0, 0, 0
  // Preset: Chunky 8bpp
  preset_chunky: .byte 7, 0, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 6, 0, 0, 0, 8, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0
  // Preset: Sixs FREDs mode
  preset_sixsfred: .byte 8, 1, 1, 1, 1, 1, 0, 0, 0, 0, 9, 0, 0, 0, 1, 0, 0, $a, 0, 0, 0, 1, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0
  // Preset: Sixs FREDs 2 mode
  preset_sixsfred2: .byte 9, 1, 1, 1, 0, 1, 0, 0, 0, 0, 9, 0, 0, 0, 1, 0, 0, $a, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0
  // Preset: 8bpp Pixel Cell
  preset_8bpppixelcell: .byte $a, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, $b, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0
  // Table with addresses of the y-lines of the form. The first line contains the address of the form screen.
  form_line_lo: .fill $19, 0
  form_line_hi: .fill $19, 0
  // Charset ROM
  FORM_TEXT: .text " C64 DTV Graphics Mode Explorer         @"+"                                        @"+" PRESET 0 Standard Charset              @"+"                                        @"+" CONTROL        PLANE  A     VIC II     @"+" bmm        0   pattern p0   screen s0  @"+" mcm        0   start   00   gfx    g0  @"+" ecm        0   step    00   colors c0  @"+" hicolor    0   modulo  00              @"+" linear     0                COLORS     @"+" color off  0   PLANE  B     palet   0  @"+" chunky     0   pattern p0   bgcol0 00  @"+" border off 0   start   00   bgcol1 00  @"+" overscan   0   step    00   bgcol2 00  @"+"                modulo  00   bgcol3 00  @"+"@"
  FORM_COLS: .text "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa@"+"                                        @"+"aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa@"+"                                        @"+" nnnnnnnnnnnn   mmmmmmmmmm   ooooooooo  @"+" nnnnnnnnnnnn   mmmmmmmmmm   ooooooooo  @"+" nnnnnnnnnnnn   mmmmmmmmmm   ooooooooo  @"+" nnnnnnnnnnnn   mmmmmmmmmm   ooooooooo  @"+" nnnnnnnnnnnn   mmmmmmmmmm              @"+" nnnnnnnnnnnn                jjjjjjjjj  @"+" nnnnnnnnnnnn   mmmmmmmmmm   jjjjjjjjj  @"+" nnnnnnnnnnnn   mmmmmmmmmm   jjjjjjjjj  @"+" nnnnnnnnnnnn   mmmmmmmmmm   jjjjjjjjj  @"+" nnnnnnnnnnnn   mmmmmmmmmm   jjjjjjjjj  @"+" nnnnnnnnnnnn   mmmmmmmmmm   jjjjjjjjj  @"+" nnnnnnnnnnnn   mmmmmmmmmm   jjjjjjjjj  @"+"@"
