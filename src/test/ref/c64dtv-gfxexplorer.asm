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
  .const PROCPORT_RAM_IO = 5
  // RAM in $A000, $E000 CHAR ROM in $D000
  .const PROCPORT_RAM_CHARROM = 1
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
  // Any shift is pressed
  .const KEY_MODIFIER_SHIFT = KEY_MODIFIER_LSHIFT|KEY_MODIFIER_RSHIFT
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
  // The number of frames to use for a full blink cycle
  .const FORM_CURSOR_BLINK = $28
  // Number of form fields
  .const form_fields_cnt = $24
  .label print_char_cursor = $a
  .label print_line_cursor = $d
  // Keyboard event buffer size. The number of events currently in the event buffer
  .label keyboard_events_size = $1e
  // Counts down to blink for form cursor (it is inversed in the lower half)
  // Always blink cursor in new field
  .label form_cursor_count = $f
  // Current selected field in the form
  .label form_field_idx = 8
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
    sta.z form_field_idx
    sta.z keyboard_events_size
    lda #FORM_CURSOR_BLINK/2
    sta.z form_cursor_count
  __b2:
    jsr form_mode
    jsr gfx_mode
    jmp __b2
}
// Change graphics mode to show the selected graphics mode
gfx_mode: {
    .label __20 = 2
    .label __24 = $19
    .label __26 = $1b
    .label __34 = 2
    .label __38 = $11
    .label __40 = $17
    .label __47 = 6
    .label __48 = 6
    .label __49 = 6
    .label __50 = $1d
    .label __52 = $d
    .label __53 = $d
    .label plane_a = 2
    .label plane_b = 2
    .label vic_colors = 6
    .label col = $a
    .label cy = 9
    lda form_ctrl_line
    cmp #0
    beq b1
    ldx #DTV_LINEAR
    jmp __b1
  b1:
    ldx #0
  __b1:
    lda form_ctrl_borof
    cmp #0
    beq __b2
    txa
    ora #DTV_BORDER_OFF
    tax
  __b2:
    lda form_ctrl_hicol
    cmp #0
    beq __b3
    txa
    ora #DTV_HIGHCOLOR
    tax
  __b3:
    lda form_ctrl_overs
    cmp #0
    beq __b4
    txa
    ora #DTV_OVERSCAN
    tax
  __b4:
    lda form_ctrl_colof
    cmp #0
    beq __b5
    txa
    ora #DTV_COLORRAM_OFF
    tax
  __b5:
    lda form_ctrl_chunk
    cmp #0
    beq __b6
    txa
    ora #DTV_CHUNKY
    tax
  __b6:
    stx DTV_CONTROL
    lda form_ctrl_ecm
    cmp #0
    beq b2
    ldx #VIC_DEN|VIC_RSEL|3|VIC_ECM
    jmp __b7
  b2:
    ldx #VIC_DEN|VIC_RSEL|3
  __b7:
    lda form_ctrl_bmm
    cmp #0
    beq __b8
    txa
    ora #VIC_BMM
    tax
  __b8:
    stx VIC_CONTROL
    lda form_ctrl_mcm
    cmp #0
    beq b3
    lda #VIC_CSEL|VIC_MCM
    jmp __b9
  b3:
    lda #VIC_CSEL
  __b9:
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
    adc.z plane_a
    sta.z plane_a
    lda.z plane_a+1
    adc #0
    sta.z plane_a+1
    lda.z plane_a+2
    adc #0
    sta.z plane_a+2
    lda.z plane_a+3
    adc #0
    sta.z plane_a+3
    lda.z plane_a
    sta.z __24
    lda.z plane_a+1
    sta.z __24+1
    lda.z __24
    sta DTV_PLANEA_START_LO
    lda.z __24+1
    sta DTV_PLANEA_START_MI
    lda.z plane_a+2
    sta.z __26
    lda.z plane_a+3
    sta.z __26+1
    lda.z __26
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
    adc.z plane_b
    sta.z plane_b
    lda.z plane_b+1
    adc #0
    sta.z plane_b+1
    lda.z plane_b+2
    adc #0
    sta.z plane_b+2
    lda.z plane_b+3
    adc #0
    sta.z plane_b+3
    lda.z plane_b
    sta.z __38
    lda.z plane_b+1
    sta.z __38+1
    lda.z __38
    sta DTV_PLANEB_START_LO
    lda.z __38+1
    sta DTV_PLANEB_START_MI
    lda.z plane_b+2
    sta.z __40
    lda.z plane_b+3
    sta.z __40+1
    lda.z __40
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
    lda.z __48
    and #<$3fff
    sta.z __48
    lda.z __48+1
    and #>$3fff
    sta.z __48+1
    ldy #6
  !:
    lsr.z __49+1
    ror.z __49
    dey
    bne !-
    lda.z __49
    sta.z __50
    lda form_vic_gfx
    jsr get_vic_charset
    lda.z __53
    and #<$3fff
    sta.z __53
    lda.z __53+1
    and #>$3fff
    sta.z __53+1
    lsr
    lsr
    ora.z __50
    // Set VIC Bank
    // VIC memory
    sta VIC_MEMORY
    lda form_vic_cols
    jsr get_vic_screen
    lda #0
    sta.z cy
    lda #<COLS
    sta.z col
    lda #>COLS
    sta.z col+1
  __b19:
    ldx #0
  __b20:
    ldy #0
    lda (vic_colors),y
    sta (col),y
    inc.z col
    bne !+
    inc.z col+1
  !:
    inc.z vic_colors
    bne !+
    inc.z vic_colors+1
  !:
    inx
    cpx #$28
    bne __b20
    inc.z cy
    lda #$19
    cmp.z cy
    bne __b19
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
    beq b4
    ldx #0
  // DTV Palette - Grey Tones
  __b23:
    txa
    sta DTV_PALETTE,x
    inx
    cpx #$10
    bne __b23
  __b25:
    lda #$ff
    cmp RASTER
    bne __b25
    jsr keyboard_event_scan
    jsr keyboard_event_get
    cmp #KEY_SPACE
    beq __breturn
    jmp __b25
  __breturn:
    rts
  // DTV Palette - default
  b4:
    ldx #0
  __b24:
    lda DTV_PALETTE_DEFAULT,x
    sta DTV_PALETTE,x
    inx
    cpx #$10
    bne __b24
    jmp __b25
}
// Get the next event from the keyboard event buffer.
// Returns $ff if there is no event waiting. As all events are <$7f it is enough to examine bit 7 when determining if there is any event to process.
// The buffer is filled by keyboard_event_scan()
keyboard_event_get: {
    lda.z keyboard_events_size
    cmp #0
    beq b1
    dec.z keyboard_events_size
    ldy.z keyboard_events_size
    lda keyboard_events,y
    rts
  b1:
    lda #$ff
    rts
}
// Scans the entire matrix to determine which keys have been pressed/depressed.
// Generates keyboard events into the event buffer. Events can be read using keyboard_event_get().
// Handles debounce and only generates events when the status of a key changes.
// Also stores current status of modifiers in keyboard_modifiers.
keyboard_event_scan: {
    .label row_scan = $1d
    .label keycode = $c
    .label row = 9
    lda #0
    sta.z keycode
    sta.z row
  __b7:
    ldx.z row
    jsr keyboard_matrix_read
    sta.z row_scan
    ldy.z row
    cmp keyboard_scan_values,y
    bne b3
    lax.z keycode
    axs #-[8]
    stx.z keycode
  __b8:
    inc.z row
    lda #8
    cmp.z row
    bne __b7
    lda #KEY_LSHIFT
    sta.z keyboard_event_pressed.keycode
    jsr keyboard_event_pressed
    cmp #0
    beq b1
    ldx #KEY_MODIFIER_LSHIFT
    jmp __b1
  b1:
    ldx #0
  __b1:
    lda #KEY_RSHIFT
    sta.z keyboard_event_pressed.keycode
    jsr keyboard_event_pressed
    cmp #0
    beq __b2
    txa
    ora #KEY_MODIFIER_RSHIFT
    tax
  __b2:
    lda #KEY_CTRL
    sta.z keyboard_event_pressed.keycode
    jsr keyboard_event_pressed
    cmp #0
    beq __b3
    txa
    ora #KEY_MODIFIER_CTRL
    tax
  __b3:
    lda #KEY_COMMODORE
    sta.z keyboard_event_pressed.keycode
    jsr keyboard_event_pressed
    cmp #0
    beq __breturn
    txa
    ora #KEY_MODIFIER_COMMODORE
    tax
  __breturn:
    rts
  // Something has changed on the keyboard row - check each column
  b3:
    ldx #0
  __b9:
    lda.z row_scan
    ldy.z row
    eor keyboard_scan_values,y
    and keyboard_matrix_col_bitmask,x
    cmp #0
    beq __b10
    lda #8
    cmp.z keyboard_events_size
    beq __b10
    lda keyboard_matrix_col_bitmask,x
    and.z row_scan
    cmp #0
    beq __b11
    // Key pressed
    lda.z keycode
    ldy.z keyboard_events_size
    sta keyboard_events,y
    inc.z keyboard_events_size
  __b10:
    inc.z keycode
    inx
    cpx #8
    bne __b9
    // Store the current keyboard status for the row to debounce
    lda.z row_scan
    ldy.z row
    sta keyboard_scan_values,y
    jmp __b8
  __b11:
    lda #$40
    ora.z keycode
    // Key released
    ldy.z keyboard_events_size
    sta keyboard_events,y
    inc.z keyboard_events_size
    jmp __b10
}
// Determine if a specific key is currently pressed based on the last keyboard_event_scan()
// Returns 0 is not pressed and non-0 if pressed
// keyboard_event_pressed(byte zp($c) keycode)
keyboard_event_pressed: {
    .label row_bits = $1d
    .label keycode = $c
    lda.z keycode
    lsr
    lsr
    lsr
    tay
    lda keyboard_scan_values,y
    sta.z row_bits
    lda #7
    and.z keycode
    tay
    lda keyboard_matrix_col_bitmask,y
    and.z row_bits
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
    .label return = 6
    cmp #0
    beq __b1
    cmp #1
    beq b1
    cmp #2
    beq b2
    cmp #3
    beq b3
    cmp #4
    bne __b1
    lda #<VIC_SCREEN4
    sta.z return
    lda #>VIC_SCREEN4
    sta.z return+1
    rts
  __b1:
    lda #<VIC_SCREEN0
    sta.z return
    lda #>VIC_SCREEN0
    sta.z return+1
    rts
  b1:
    lda #<VIC_SCREEN1
    sta.z return
    lda #>VIC_SCREEN1
    sta.z return+1
    rts
  b2:
    lda #<VIC_SCREEN2
    sta.z return
    lda #>VIC_SCREEN2
    sta.z return+1
    rts
  b3:
    lda #<VIC_SCREEN3
    sta.z return
    lda #>VIC_SCREEN3
    sta.z return+1
    rts
}
// Get the VIC charset/bitmap address from the index
// get_vic_charset(byte register(A) idx)
get_vic_charset: {
    .label return = $d
    cmp #0
    beq __b1
    cmp #1
    bne __b1
    lda #<VIC_BITMAP
    sta.z return
    lda #>VIC_BITMAP
    sta.z return+1
    rts
  __b1:
    lda #<VIC_CHARSET_ROM
    sta.z return
    lda #>VIC_CHARSET_ROM
    sta.z return+1
    rts
}
// Get plane address from a plane index (from the form)
// get_plane(byte register(A) idx)
get_plane: {
    .label return = 2
    cmp #0
    beq b1
    cmp #1
    bne !b6+
    jmp b6
  !b6:
    cmp #2
    bne !b7+
    jmp b7
  !b7:
    cmp #3
    bne !b8+
    jmp b8
  !b8:
    cmp #4
    bne !b9+
    jmp b9
  !b9:
    cmp #5
    bne !b10+
    jmp b10
  !b10:
    cmp #6
    bne !b11+
    jmp b11
  !b11:
    cmp #7
    bne !b12+
    jmp b12
  !b12:
    cmp #8
    bne !b13+
    jmp b13
  !b13:
    cmp #9
    beq b2
    cmp #$a
    beq b3
    cmp #$b
    beq b4
    cmp #$c
    beq b5
    cmp #$d
    bne __b1
    lda #<PLANE_FULL
    sta.z return
    lda #>PLANE_FULL
    sta.z return+1
    lda #<PLANE_FULL>>$10
    sta.z return+2
    lda #>PLANE_FULL>>$10
    sta.z return+3
    rts
  __b1:
    lda #<VIC_SCREEN0
    sta.z return
    lda #>VIC_SCREEN0
    sta.z return+1
    lda #<VIC_SCREEN0>>$10
    sta.z return+2
    lda #>VIC_SCREEN0>>$10
    sta.z return+3
    rts
  b1:
    lda #<VIC_SCREEN0
    sta.z return
    lda #>VIC_SCREEN0
    sta.z return+1
    lda #<VIC_SCREEN0>>$10
    sta.z return+2
    lda #>VIC_SCREEN0>>$10
    sta.z return+3
    rts
  b2:
    lda #<PLANE_HORISONTAL2
    sta.z return
    lda #>PLANE_HORISONTAL2
    sta.z return+1
    lda #<PLANE_HORISONTAL2>>$10
    sta.z return+2
    lda #>PLANE_HORISONTAL2>>$10
    sta.z return+3
    rts
  b3:
    lda #<PLANE_VERTICAL2
    sta.z return
    lda #>PLANE_VERTICAL2
    sta.z return+1
    lda #<PLANE_VERTICAL2>>$10
    sta.z return+2
    lda #>PLANE_VERTICAL2>>$10
    sta.z return+3
    rts
  b4:
    lda #<PLANE_CHARSET8
    sta.z return
    lda #>PLANE_CHARSET8
    sta.z return+1
    lda #<PLANE_CHARSET8>>$10
    sta.z return+2
    lda #>PLANE_CHARSET8>>$10
    sta.z return+3
    rts
  b5:
    lda #<PLANE_BLANK
    sta.z return
    lda #>PLANE_BLANK
    sta.z return+1
    lda #<PLANE_BLANK>>$10
    sta.z return+2
    lda #>PLANE_BLANK>>$10
    sta.z return+3
    rts
  b6:
    lda #<VIC_SCREEN1
    sta.z return
    lda #>VIC_SCREEN1
    sta.z return+1
    lda #<VIC_SCREEN1>>$10
    sta.z return+2
    lda #>VIC_SCREEN1>>$10
    sta.z return+3
    rts
  b7:
    lda #<VIC_SCREEN2
    sta.z return
    lda #>VIC_SCREEN2
    sta.z return+1
    lda #<VIC_SCREEN2>>$10
    sta.z return+2
    lda #>VIC_SCREEN2>>$10
    sta.z return+3
    rts
  b8:
    lda #<VIC_SCREEN3
    sta.z return
    lda #>VIC_SCREEN3
    sta.z return+1
    lda #<VIC_SCREEN3>>$10
    sta.z return+2
    lda #>VIC_SCREEN3>>$10
    sta.z return+3
    rts
  b9:
    lda #<VIC_BITMAP
    sta.z return
    lda #>VIC_BITMAP
    sta.z return+1
    lda #<VIC_BITMAP>>$10
    sta.z return+2
    lda #>VIC_BITMAP>>$10
    sta.z return+3
    rts
  b10:
    lda #<VIC_CHARSET_ROM
    sta.z return
    lda #>VIC_CHARSET_ROM
    sta.z return+1
    lda #<VIC_CHARSET_ROM>>$10
    sta.z return+2
    lda #>VIC_CHARSET_ROM>>$10
    sta.z return+3
    rts
  b11:
    lda #<PLANE_8BPP_CHUNKY
    sta.z return
    lda #>PLANE_8BPP_CHUNKY
    sta.z return+1
    lda #<PLANE_8BPP_CHUNKY>>$10
    sta.z return+2
    lda #>PLANE_8BPP_CHUNKY>>$10
    sta.z return+3
    rts
  b12:
    lda #<PLANE_HORISONTAL
    sta.z return
    lda #>PLANE_HORISONTAL
    sta.z return+1
    lda #<PLANE_HORISONTAL>>$10
    sta.z return+2
    lda #>PLANE_HORISONTAL>>$10
    sta.z return+3
    rts
  b13:
    lda #<PLANE_VERTICAL
    sta.z return
    lda #>PLANE_VERTICAL
    sta.z return+1
    lda #<PLANE_VERTICAL>>$10
    sta.z return+2
    lda #>PLANE_VERTICAL>>$10
    sta.z return+3
    rts
}
// Show the form - and let the user change values
form_mode: {
    .label preset_current = $10
    lda #<COLS
    sta.z print_set_screen.screen
    lda #>COLS
    sta.z print_set_screen.screen+1
    jsr print_set_screen
    jsr print_cls
    lda #<FORM_COLS
    sta.z print_str_lines.str
    lda #>FORM_COLS
    sta.z print_str_lines.str+1
    jsr print_str_lines
    lda #<FORM_SCREEN
    sta.z print_set_screen.screen
    lda #>FORM_SCREEN
    sta.z print_set_screen.screen+1
    jsr print_set_screen
    jsr print_cls
    lda #<FORM_TEXT
    sta.z print_str_lines.str
    lda #>FORM_TEXT
    sta.z print_str_lines.str+1
    jsr print_str_lines
    jsr form_set_screen
    jsr form_render_values
    lda form_fields_val
    jsr render_preset_name
    // DTV Graphics Bank
    lda #0
    sta DTV_GRAPHICS_VIC_BANK
    // DTV Color Bank
    lda #<DTV_COLOR_BANK_DEFAULT/$400
    sta DTV_COLOR_BANK_LO
    lda #0
    sta DTV_COLOR_BANK_HI
    // VIC Graphics Bank
    lda #3
    sta CIA2_PORT_A_DDR
    // Set VIC Bank bits to output - all others to input
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
    lda #0
    sta DTV_PLANEA_START_LO
    lda #>FORM_SCREEN
    sta DTV_PLANEA_START_MI
    lda #0
    sta DTV_PLANEA_START_HI
    tax
  // DTV Palette - default
  __b1:
    lda DTV_PALETTE_DEFAULT,x
    sta DTV_PALETTE,x
    inx
    cpx #$10
    bne __b1
    // Screen colors
    lda #0
    sta BGCOL
    sta BORDERCOL
    lda form_fields_val
    sta.z preset_current
  b1:
  // Let the user change values in the form
  __b4:
    lda #$ff
    cmp RASTER
    bne __b4
    jsr form_control
    txa
    cmp #0
    beq __b6
    rts
  __b6:
    lda form_fields_val
    cmp.z preset_current
    beq b1
    jsr apply_preset
    lda form_fields_val
    sta.z preset_current
    jsr form_render_values
    lda form_fields_val
    jsr render_preset_name
    jmp b1
}
// Render form preset name in the form
// idx is the ID of the preset
// render_preset_name(byte register(A) idx)
render_preset_name: {
    .label name = 6
    cmp #0
    beq b1
    cmp #1
    beq b4
    cmp #2
    beq b5
    cmp #3
    beq b6
    cmp #4
    beq b7
    cmp #5
    beq b8
    cmp #6
    beq b9
    cmp #7
    beq b10
    cmp #8
    beq b2
    cmp #9
    beq b3
    cmp #$a
    beq __b1
  b1:
    lda #<name_1
    sta.z name
    lda #>name_1
    sta.z name+1
    jmp __b2
  __b1:
    lda #<name_11
    sta.z name
    lda #>name_11
    sta.z name+1
    jmp __b2
  b2:
    lda #<name_9
    sta.z name
    lda #>name_9
    sta.z name+1
    jmp __b2
  b3:
    lda #<name_10
    sta.z name
    lda #>name_10
    sta.z name+1
    jmp __b2
  b4:
    lda #<name_2
    sta.z name
    lda #>name_2
    sta.z name+1
    jmp __b2
  b5:
    lda #<name_3
    sta.z name
    lda #>name_3
    sta.z name+1
    jmp __b2
  b6:
    lda #<name_4
    sta.z name
    lda #>name_4
    sta.z name+1
    jmp __b2
  b7:
    lda #<name_5
    sta.z name
    lda #>name_5
    sta.z name+1
    jmp __b2
  b8:
    lda #<name_6
    sta.z name
    lda #>name_6
    sta.z name+1
    jmp __b2
  b9:
    lda #<name_7
    sta.z name
    lda #>name_7
    sta.z name+1
    jmp __b2
  b10:
    lda #<name_8
    sta.z name
    lda #>name_8
    sta.z name+1
  __b2:
    jsr print_str_at
    rts
    name_1: .text "Standard Charset              "
    .byte 0
    name_2: .text "Extended Color Charset        "
    .byte 0
    name_3: .text "Standard Bitmap               "
    .byte 0
    name_4: .text "Multicolor Bitmap             "
    .byte 0
    name_5: .text "Hicolor Charset               "
    .byte 0
    name_6: .text "Hicolor Extended Color Charset"
    .byte 0
    name_7: .text "Twoplane Bitmap               "
    .byte 0
    name_8: .text "Chunky 8bpp                   "
    .byte 0
    name_9: .text "Sixs Fred                     "
    .byte 0
    name_10: .text "Sixs Fred 2                   "
    .byte 0
    name_11: .text "8bpp Pixel Cell               "
    .byte 0
}
// Print a string at a specific screen position
// print_str_at(byte* zp(6) str, byte* zp($a) at)
print_str_at: {
    .label at = $a
    .label str = 6
    lda #<FORM_SCREEN+$28*2+$a
    sta.z at
    lda #>FORM_SCREEN+$28*2+$a
    sta.z at+1
  __b1:
    ldy #0
    lda (str),y
    cmp #0
    bne __b2
    rts
  __b2:
    ldy #0
    lda (str),y
    sta (at),y
    inc.z at
    bne !+
    inc.z at+1
  !:
    inc.z str
    bne !+
    inc.z str+1
  !:
    jmp __b1
}
// Render all form values from the form_fields_val array
form_render_values: {
    ldx #0
  __b1:
    cpx #form_fields_cnt
    bcc __b2
    rts
  __b2:
    jsr form_field_ptr
    ldy form_fields_val,x
    lda print_hextab,y
    ldy.z form_field_ptr.x
    sta (form_field_ptr.line),y
    inx
    jmp __b1
}
// Get the screen address of a form field
// field_idx is the index of the field to get the screen address for
// form_field_ptr(byte register(X) field_idx)
form_field_ptr: {
    .label line = $19
    .label x = $1d
    .label return = $1b
    ldy form_fields_y,x
    lda form_line_hi,y
    sta.z line+1
    lda form_line_lo,y
    sta.z line
    lda form_fields_x,x
    sta.z x
    clc
    adc.z line
    sta.z return
    lda #0
    adc.z line+1
    sta.z return+1
    rts
}
// Apply a form value preset to the form values
// idx is the ID of the preset
// apply_preset(byte register(A) idx)
apply_preset: {
    .label preset = $d
    cmp #0
    beq b1
    cmp #1
    beq b4
    cmp #2
    beq b5
    cmp #3
    beq b6
    cmp #4
    beq b7
    cmp #5
    beq b8
    cmp #6
    beq b9
    cmp #7
    beq b10
    cmp #8
    beq b2
    cmp #9
    beq b3
    cmp #$a
    beq __b1
  b1:
    lda #<preset_stdchar
    sta.z preset
    lda #>preset_stdchar
    sta.z preset+1
    jmp __b2
  __b1:
    lda #<preset_8bpppixelcell
    sta.z preset
    lda #>preset_8bpppixelcell
    sta.z preset+1
    jmp __b2
  b2:
    lda #<preset_sixsfred
    sta.z preset
    lda #>preset_sixsfred
    sta.z preset+1
    jmp __b2
  b3:
    lda #<preset_sixsfred2
    sta.z preset
    lda #>preset_sixsfred2
    sta.z preset+1
    jmp __b2
  b4:
    lda #<preset_ecmchar
    sta.z preset
    lda #>preset_ecmchar
    sta.z preset+1
    jmp __b2
  b5:
    lda #<preset_stdbm
    sta.z preset
    lda #>preset_stdbm
    sta.z preset+1
    jmp __b2
  b6:
    lda #<preset_mcbm
    sta.z preset
    lda #>preset_mcbm
    sta.z preset+1
    jmp __b2
  b7:
    lda #<preset_hi_stdchar
    sta.z preset
    lda #>preset_hi_stdchar
    sta.z preset+1
    jmp __b2
  b8:
    lda #<preset_hi_ecmchar
    sta.z preset
    lda #>preset_hi_ecmchar
    sta.z preset+1
    jmp __b2
  b9:
    lda #<preset_twoplane
    sta.z preset
    lda #>preset_twoplane
    sta.z preset+1
    jmp __b2
  b10:
    lda #<preset_chunky
    sta.z preset
    lda #>preset_chunky
    sta.z preset+1
  __b2:
    ldy #0
  // Copy preset values into the fields
  __b13:
    cpy #form_fields_cnt
    bne __b14
    rts
  __b14:
    lda (preset),y
    sta form_fields_val,y
    iny
    jmp __b13
}
// Reads keyboard and allows the user to navigate and change the fields of the form
// Returns 0 if space is not pressed, non-0 if space is pressed
form_control: {
    .label field = $1b
    ldx.z form_field_idx
    jsr form_field_ptr
    dec.z form_cursor_count
    lda.z form_cursor_count
    cmp #0
    bpl __b1
    lda #FORM_CURSOR_BLINK
    sta.z form_cursor_count
  __b1:
    lda.z form_cursor_count
    sec
    sbc #FORM_CURSOR_BLINK/2
    bvc !+
    eor #$80
  !:
    bpl !__b2+
    jmp __b2
  !__b2:
    lda #$7f
    ldy #0
    and (field),y
    sta (field),y
  __b3:
    jsr keyboard_event_scan
    jsr keyboard_event_get
    cmp #KEY_CRSR_DOWN
    bne __b4
    lda #$7f
    ldy #0
    and (field),y
    // Unblink the cursor
    sta (field),y
    txa
    and #KEY_MODIFIER_SHIFT
    cmp #0
    beq __b13
    dec.z form_field_idx
    lda #$ff
    cmp.z form_field_idx
    bne __b14
    lda #form_fields_cnt-1
    sta.z form_field_idx
  __b14:
    lda #FORM_CURSOR_BLINK/2
    sta.z form_cursor_count
    ldx #0
    rts
  __b13:
    inc.z form_field_idx
    lda #form_fields_cnt
    cmp.z form_field_idx
    bne __b14
    lda #0
    sta.z form_field_idx
    jmp __b14
  __b4:
    cmp #KEY_CRSR_RIGHT
    bne __b5
    txa
    and #KEY_MODIFIER_SHIFT
    cmp #0
    beq __b15
    ldx.z form_field_idx
    dec form_fields_val,x
    lda #$ff
    ldy.z form_field_idx
    cmp form_fields_val,y
    bne __b16
    lda form_fields_max,y
    sta form_fields_val,y
  __b16:
    // Render field value
    ldx.z form_field_idx
    ldy form_fields_val,x
    lda print_hextab,y
    ldy #0
    sta (field),y
  b1:
    ldx #0
    rts
  __b15:
    ldx.z form_field_idx
    inc form_fields_val,x
    ldy.z form_field_idx
    lda form_fields_max,y
    cmp form_fields_val,y
    bcs __b16
    lda #0
    sta form_fields_val,y
    jmp __b16
  __b5:
    cmp #KEY_SPACE
    bne b1
    ldx #$ff
    rts
  __b2:
    lda #$80
    ldy #0
    ora (field),y
    sta (field),y
    jmp __b3
}
// Set the screen to use for the form.
// screen is the start address of the screen to use
form_set_screen: {
    .label line = 6
    ldx #0
    lda #<FORM_SCREEN
    sta.z line
    lda #>FORM_SCREEN
    sta.z line+1
  __b1:
    lda.z line
    sta form_line_lo,x
    lda.z line+1
    sta form_line_hi,x
    lda #$28
    clc
    adc.z line
    sta.z line
    bcc !+
    inc.z line+1
  !:
    inx
    cpx #$19
    bne __b1
    rts
}
// Print a number of zero-terminated strings, each followed by a newline.
// The sequence of lines is terminated by another zero.
// print_str_lines(byte* zp(6) str)
print_str_lines: {
    .label str = 6
    lda.z print_set_screen.screen
    sta.z print_char_cursor
    lda.z print_set_screen.screen+1
    sta.z print_char_cursor+1
  __b1:
    ldy #0
    lda (str),y
    cmp #0
    bne __b2
    rts
  __b2:
    ldy #0
    lda (str),y
    inc.z str
    bne !+
    inc.z str+1
  !:
    cmp #0
    beq __b3
    ldy #0
    sta (print_char_cursor),y
    inc.z print_char_cursor
    bne !+
    inc.z print_char_cursor+1
  !:
  __b3:
    cmp #0
    bne __b2
    jsr print_ln
    lda.z print_line_cursor
    sta.z print_char_cursor
    lda.z print_line_cursor+1
    sta.z print_char_cursor+1
    jmp __b1
}
// Print a newline
print_ln: {
  __b1:
    lda #$28
    clc
    adc.z print_line_cursor
    sta.z print_line_cursor
    bcc !+
    inc.z print_line_cursor+1
  !:
    lda.z print_line_cursor+1
    cmp.z print_char_cursor+1
    bcc __b1
    bne !+
    lda.z print_line_cursor
    cmp.z print_char_cursor
    bcc __b1
  !:
    rts
}
// Clear the screen. Also resets current line/char cursor.
print_cls: {
    lda.z print_set_screen.screen
    sta.z memset.str
    lda.z print_set_screen.screen+1
    sta.z memset.str+1
    jsr memset
    rts
}
// Copies the character c (an unsigned char) to the first num characters of the object pointed to by the argument str.
// memset(void* zp($a) str)
memset: {
    .const c = ' '
    .const num = $3e8
    .label end = $11
    .label dst = $a
    .label str = $a
    lda.z str
    clc
    adc #<num
    sta.z end
    lda.z str+1
    adc #>num
    sta.z end+1
  __b2:
    lda.z dst+1
    cmp.z end+1
    bne __b3
    lda.z dst
    cmp.z end
    bne __b3
    rts
  __b3:
    lda #c
    ldy #0
    sta (dst),y
    inc.z dst
    bne !+
    inc.z dst+1
  !:
    jmp __b2
}
// Set the screen to print on. Also resets current line/char cursor.
// print_set_screen(byte* zp($d) screen)
print_set_screen: {
    .label screen = $d
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
    sta.z gfx_init_plane_fill.fill
    lda #<PLANE_FULL
    sta.z gfx_init_plane_fill.plane_addr
    lda #>PLANE_FULL
    sta.z gfx_init_plane_fill.plane_addr+1
    lda #<PLANE_FULL>>$10
    sta.z gfx_init_plane_fill.plane_addr+2
    lda #>PLANE_FULL>>$10
    sta.z gfx_init_plane_fill.plane_addr+3
    jsr gfx_init_plane_fill
    rts
}
// Initialize 320*200 1bpp pixel ($2000) plane with identical bytes
// gfx_init_plane_fill(dword zp(2) plane_addr, byte zp($1e) fill)
gfx_init_plane_fill: {
    .label __0 = $13
    .label __1 = $17
    .label __4 = $d
    .label __5 = $d
    .label gfxb = $d
    .label by = $f
    .label plane_addr = 2
    .label fill = $1e
    lda.z plane_addr
    asl
    sta.z __0
    lda.z plane_addr+1
    rol
    sta.z __0+1
    lda.z plane_addr+2
    rol
    sta.z __0+2
    lda.z plane_addr+3
    rol
    sta.z __0+3
    asl.z __0
    rol.z __0+1
    rol.z __0+2
    rol.z __0+3
    lda.z __0+2
    sta.z __1
    lda.z __0+3
    sta.z __1+1
    lda.z __1
    jsr dtvSetCpuBankSegment1
    lda.z plane_addr
    sta.z __4
    lda.z plane_addr+1
    sta.z __4+1
    lda.z __5
    and #<$3fff
    sta.z __5
    lda.z __5+1
    and #>$3fff
    sta.z __5+1
    clc
    lda.z gfxb
    adc #<$4000
    sta.z gfxb
    lda.z gfxb+1
    adc #>$4000
    sta.z gfxb+1
    lda #0
    sta.z by
  __b1:
    ldx #0
  __b2:
    lda.z fill
    ldy #0
    sta (gfxb),y
    inc.z gfxb
    bne !+
    inc.z gfxb+1
  !:
    inx
    cpx #$28
    bne __b2
    inc.z by
    lda #$c8
    cmp.z by
    bne __b1
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
    lda.z $ff
    .byte $32, $00
    rts
}
// Initialize Plane with blank pixels
gfx_init_plane_blank: {
    lda #0
    sta.z gfx_init_plane_fill.fill
    lda #<PLANE_BLANK
    sta.z gfx_init_plane_fill.plane_addr
    lda #>PLANE_BLANK
    sta.z gfx_init_plane_fill.plane_addr+1
    lda #<PLANE_BLANK>>$10
    sta.z gfx_init_plane_fill.plane_addr+2
    lda #>PLANE_BLANK>>$10
    sta.z gfx_init_plane_fill.plane_addr+3
    jsr gfx_init_plane_fill
    rts
}
// Initialize Plane with Vertical Stripes every 2 pixels
gfx_init_plane_vertical2: {
    lda #$1b
    sta.z gfx_init_plane_fill.fill
    lda #<PLANE_VERTICAL2
    sta.z gfx_init_plane_fill.plane_addr
    lda #>PLANE_VERTICAL2
    sta.z gfx_init_plane_fill.plane_addr+1
    lda #<PLANE_VERTICAL2>>$10
    sta.z gfx_init_plane_fill.plane_addr+2
    lda #>PLANE_VERTICAL2>>$10
    sta.z gfx_init_plane_fill.plane_addr+3
    jsr gfx_init_plane_fill
    rts
}
// Initialize Plane with Horizontal Stripes every 2 pixels
gfx_init_plane_horisontal2: {
    .const gfxbCpuBank = PLANE_HORISONTAL2/$4000
    .label gfxa = 6
    .label ay = 8
    lda #gfxbCpuBank
    jsr dtvSetCpuBankSegment1
    lda #<$4000
    sta.z gfxa
    lda #>$4000
    sta.z gfxa+1
    lda #0
    sta.z ay
  __b1:
    ldx #0
  __b2:
    lda.z ay
    lsr
    and #3
    tay
    lda row_bitmask,y
    ldy #0
    sta (gfxa),y
    inc.z gfxa
    bne !+
    inc.z gfxa+1
  !:
    inx
    cpx #$28
    bne __b2
    inc.z ay
    lda #$c8
    cmp.z ay
    bne __b1
    lda #$4000/$4000
    jsr dtvSetCpuBankSegment1
    rts
    row_bitmask: .byte 0, $55, $aa, $ff
}
// Initialize Plane with Vertical Stripes
gfx_init_plane_vertical: {
    .const gfxbCpuBank = PLANE_VERTICAL/$4000
    .label gfxb = 6
    .label by = $10
    lda #gfxbCpuBank
    jsr dtvSetCpuBankSegment1
    lda #0
    sta.z by
    lda #<$4000+(PLANE_VERTICAL&$3fff)
    sta.z gfxb
    lda #>$4000+(PLANE_VERTICAL&$3fff)
    sta.z gfxb+1
  __b1:
    ldx #0
  __b2:
    lda #$f
    ldy #0
    sta (gfxb),y
    inc.z gfxb
    bne !+
    inc.z gfxb+1
  !:
    inx
    cpx #$28
    bne __b2
    inc.z by
    lda #$c8
    cmp.z by
    bne __b1
    lda #$4000/$4000
    jsr dtvSetCpuBankSegment1
    rts
}
// Initialize Plane with Horizontal Stripes
gfx_init_plane_horisontal: {
    .const gfxbCpuBank = PLANE_HORISONTAL/$4000
    .label gfxa = 6
    .label ay = 9
    lda #gfxbCpuBank
    jsr dtvSetCpuBankSegment1
    lda #<$4000
    sta.z gfxa
    lda #>$4000
    sta.z gfxa+1
    lda #0
    sta.z ay
  __b1:
    ldx #0
  __b2:
    lda #4
    and.z ay
    cmp #0
    beq __b3
    lda #$ff
    ldy #0
    sta (gfxa),y
    inc.z gfxa
    bne !+
    inc.z gfxa+1
  !:
  __b4:
    inx
    cpx #$28
    bne __b2
    inc.z ay
    lda #$c8
    cmp.z ay
    bne __b1
    lda #$4000/$4000
    jsr dtvSetCpuBankSegment1
    rts
  __b3:
    lda #0
    tay
    sta (gfxa),y
    inc.z gfxa
    bne !+
    inc.z gfxa+1
  !:
    jmp __b4
}
// Initialize Plane with 8bpp charset
gfx_init_plane_charset8: {
    // 8bpp cells for Plane B (charset) - ROM charset with 256 colors
    .const gfxbCpuBank = PLANE_CHARSET8/$4000
    .label bits = $1e
    .label chargen = 6
    .label gfxa = $a
    .label col = $f
    .label cr = $c
    .label ch = 9
    lda #gfxbCpuBank
    jsr dtvSetCpuBankSegment1
    lda #PROCPORT_RAM_CHARROM
    sta PROCPORT
    lda #0
    sta.z ch
    sta.z col
    lda #<$4000
    sta.z gfxa
    lda #>$4000
    sta.z gfxa+1
    lda #<CHARGEN
    sta.z chargen
    lda #>CHARGEN
    sta.z chargen+1
  __b1:
    lda #0
    sta.z cr
  __b2:
    ldy #0
    lda (chargen),y
    sta.z bits
    inc.z chargen
    bne !+
    inc.z chargen+1
  !:
    ldx #0
  __b3:
    lda #$80
    and.z bits
    cmp #0
    beq b1
    lda.z col
    jmp __b4
  b1:
    lda #0
  __b4:
    ldy #0
    sta (gfxa),y
    inc.z gfxa
    bne !+
    inc.z gfxa+1
  !:
    asl.z bits
    inc.z col
    inx
    cpx #8
    bne __b3
    inc.z cr
    lda #8
    cmp.z cr
    bne __b2
    inc.z ch
    lda.z ch
    cmp #0
    bne __b1
    lda #PROCPORT_RAM_IO
    sta PROCPORT
    lda #$4000/$4000
    jsr dtvSetCpuBankSegment1
    rts
}
// Initialize 8BPP Chunky Bitmap (contains 8bpp pixels)
gfx_init_plane_8bppchunky: {
    .label __5 = $19
    .label gfxb = $d
    .label x = $a
    .label y = $c
    lda #PLANE_8BPP_CHUNKY/$4000
    jsr dtvSetCpuBankSegment1
    ldx #PLANE_8BPP_CHUNKY/$4000+1
    lda #0
    sta.z y
    lda #<$4000
    sta.z gfxb
    lda #>$4000
    sta.z gfxb+1
  __b1:
    lda #<0
    sta.z x
    sta.z x+1
  __b2:
    lda.z gfxb+1
    cmp #>$8000
    bne __b3
    lda.z gfxb
    cmp #<$8000
    bne __b3
    txa
    jsr dtvSetCpuBankSegment1
    inx
    lda #<$4000
    sta.z gfxb
    lda #>$4000
    sta.z gfxb+1
  __b3:
    lda.z y
    clc
    adc.z x
    sta.z __5
    lda #0
    adc.z x+1
    sta.z __5+1
    lda.z __5
    ldy #0
    sta (gfxb),y
    inc.z gfxb
    bne !+
    inc.z gfxb+1
  !:
    inc.z x
    bne !+
    inc.z x+1
  !:
    lda.z x+1
    cmp #>$140
    bne __b2
    lda.z x
    cmp #<$140
    bne __b2
    inc.z y
    lda #$c8
    cmp.z y
    bne __b1
    lda #$4000/$4000
    jsr dtvSetCpuBankSegment1
    rts
}
// Initialize VIC bitmap
gfx_init_vic_bitmap: {
    .const lines_cnt = 9
    .label l = $1e
    jsr bitmap_init
    jsr bitmap_clear
    lda #0
    sta.z l
  __b1:
    lda.z l
    cmp #lines_cnt
    bcc __b2
    rts
  __b2:
    ldy.z l
    lda lines_x,y
    sta.z bitmap_line.x0
    ldx lines_x+1,y
    lda lines_y,y
    sta.z bitmap_line.y0
    lda lines_y+1,y
    sta.z bitmap_line.y1
    jsr bitmap_line
    inc.z l
    jmp __b1
    lines_x: .byte 0, $ff, $ff, 0, 0, $80, $ff, $80, 0, $80
    lines_y: .byte 0, 0, $c7, $c7, 0, 0, $64, $c7, $64, 0
}
// Draw a line on the bitmap
// bitmap_line(byte zp(8) x0, byte register(X) x1, byte zp($c) y0, byte zp($10) y1)
bitmap_line: {
    .label xd = $1d
    .label x0 = 8
    .label y0 = $c
    .label y1 = $10
    txa
    cmp.z x0
    beq !+
    bcs __b1
  !:
    txa
    eor #$ff
    sec
    adc.z x0
    sta.z xd
    lda.z y0
    cmp.z y1
    bcc __b7
    sec
    sbc.z y1
    tay
    cpy.z xd
    bcc __b8
    lda.z y1
    sta.z bitmap_line_ydxi.y
    lda.z y0
    sta.z bitmap_line_ydxi.y1
    sty.z bitmap_line_ydxi.yd
    jsr bitmap_line_ydxi
    rts
  __b8:
    stx.z bitmap_line_xdyi.x
    lda.z y1
    sta.z bitmap_line_xdyi.y
    sty.z bitmap_line_xdyi.yd
    jsr bitmap_line_xdyi
    rts
  __b7:
    lda.z y1
    sec
    sbc.z y0
    tay
    cpy.z xd
    bcc __b9
    lda.z y0
    sta.z bitmap_line_ydxd.y
    ldx.z x0
    lda.z y1
    sta.z bitmap_line_ydxd.y1
    sty.z bitmap_line_ydxd.yd
    jsr bitmap_line_ydxd
    rts
  __b9:
    stx.z bitmap_line_xdyd.x
    lda.z y1
    sta.z bitmap_line_xdyd.y
    sty.z bitmap_line_xdyd.yd
    jsr bitmap_line_xdyd
    rts
  __b1:
    txa
    sec
    sbc.z x0
    sta.z xd
    lda.z y0
    cmp.z y1
    bcc __b11
    sec
    sbc.z y1
    tay
    cpy.z xd
    bcc __b12
    lda.z y1
    sta.z bitmap_line_ydxd.y
    sty.z bitmap_line_ydxd.yd
    jsr bitmap_line_ydxd
    rts
  __b12:
    lda.z x0
    sta.z bitmap_line_xdyd.x
    stx.z bitmap_line_xdyd.x1
    sty.z bitmap_line_xdyd.yd
    jsr bitmap_line_xdyd
    rts
  __b11:
    lda.z y1
    sec
    sbc.z y0
    tay
    cpy.z xd
    bcc __b13
    lda.z y0
    sta.z bitmap_line_ydxi.y
    ldx.z x0
    sty.z bitmap_line_ydxi.yd
    jsr bitmap_line_ydxi
    rts
  __b13:
    lda.z x0
    sta.z bitmap_line_xdyi.x
    stx.z bitmap_line_xdyi.x1
    sty.z bitmap_line_xdyi.yd
    jsr bitmap_line_xdyi
    rts
}
// bitmap_line_xdyi(byte zp(9) x, byte zp($c) y, byte zp(8) x1, byte zp($1d) xd, byte zp($f) yd)
bitmap_line_xdyi: {
    .label x = 9
    .label y = $c
    .label x1 = 8
    .label xd = $1d
    .label yd = $f
    .label e = $10
    lda.z yd
    lsr
    sta.z e
  __b1:
    ldx.z x
    ldy.z y
    jsr bitmap_plot
    inc.z x
    lda.z e
    clc
    adc.z yd
    sta.z e
    lda.z xd
    cmp.z e
    bcs __b2
    inc.z y
    lda.z e
    sec
    sbc.z xd
    sta.z e
  __b2:
    ldx.z x1
    inx
    cpx.z x
    bne __b1
    rts
}
// bitmap_plot(byte register(X) x, byte register(Y) y)
bitmap_plot: {
    .label plotter_x = $19
    .label plotter_y = $1b
    .label plotter = $19
    lda bitmap_plot_xhi,x
    sta.z plotter_x+1
    lda bitmap_plot_xlo,x
    sta.z plotter_x
    lda bitmap_plot_yhi,y
    sta.z plotter_y+1
    lda bitmap_plot_ylo,y
    sta.z plotter_y
    lda.z plotter
    clc
    adc.z plotter_y
    sta.z plotter
    lda.z plotter+1
    adc.z plotter_y+1
    sta.z plotter+1
    lda bitmap_plot_bit,x
    ldy #0
    ora (plotter),y
    sta (plotter),y
    rts
}
// bitmap_line_ydxi(byte zp(9) y, byte register(X) x, byte zp($10) y1, byte zp(8) yd, byte zp($1d) xd)
bitmap_line_ydxi: {
    .label y = 9
    .label y1 = $10
    .label yd = 8
    .label xd = $1d
    .label e = $c
    lda.z xd
    lsr
    sta.z e
  __b1:
    ldy.z y
    jsr bitmap_plot
    inc.z y
    lda.z e
    clc
    adc.z xd
    sta.z e
    lda.z yd
    cmp.z e
    bcs __b2
    inx
    lda.z e
    sec
    sbc.z yd
    sta.z e
  __b2:
    lda.z y1
    clc
    adc #1
    cmp.z y
    bne __b1
    rts
}
// bitmap_line_xdyd(byte zp($f) x, byte zp($c) y, byte zp(8) x1, byte zp($1d) xd, byte zp(9) yd)
bitmap_line_xdyd: {
    .label x = $f
    .label y = $c
    .label x1 = 8
    .label xd = $1d
    .label yd = 9
    .label e = $10
    lda.z yd
    lsr
    sta.z e
  __b1:
    ldx.z x
    ldy.z y
    jsr bitmap_plot
    inc.z x
    lda.z e
    clc
    adc.z yd
    sta.z e
    lda.z xd
    cmp.z e
    bcs __b2
    dec.z y
    lda.z e
    sec
    sbc.z xd
    sta.z e
  __b2:
    ldx.z x1
    inx
    cpx.z x
    bne __b1
    rts
}
// bitmap_line_ydxd(byte zp($f) y, byte register(X) x, byte zp($c) y1, byte zp(9) yd, byte zp($1d) xd)
bitmap_line_ydxd: {
    .label y = $f
    .label y1 = $c
    .label yd = 9
    .label xd = $1d
    .label e = $10
    lda.z xd
    lsr
    sta.z e
  __b1:
    ldy.z y
    jsr bitmap_plot
    inc.z y
    lda.z e
    clc
    adc.z xd
    sta.z e
    lda.z yd
    cmp.z e
    bcs __b2
    dex
    lda.z e
    sec
    sbc.z yd
    sta.z e
  __b2:
    lda.z y1
    clc
    adc #1
    cmp.z y
    bne __b1
    rts
}
// Clear all graphics on the bitmap
bitmap_clear: {
    .label bitmap = $d
    .label y = $1d
    lda bitmap_plot_xlo
    sta.z bitmap
    lda bitmap_plot_xhi
    sta.z bitmap+1
    lda #0
    sta.z y
  __b1:
    ldx #0
  __b2:
    lda #0
    tay
    sta (bitmap),y
    inc.z bitmap
    bne !+
    inc.z bitmap+1
  !:
    inx
    cpx #$c8
    bne __b2
    inc.z y
    lda #$28
    cmp.z y
    bne __b1
    rts
}
// Initialize the bitmap plotter tables for a specific bitmap
bitmap_init: {
    .label __10 = $1d
    .label yoffs = $a
    ldy #$80
    ldx #0
  __b1:
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
    bne __b2
    ldy #$80
  __b2:
    inx
    cpx #0
    bne __b1
    lda #<0
    sta.z yoffs
    sta.z yoffs+1
    tax
  __b3:
    lda #7
    sax.z __10
    lda.z yoffs
    ora.z __10
    sta bitmap_plot_ylo,x
    lda.z yoffs+1
    sta bitmap_plot_yhi,x
    lda #7
    cmp.z __10
    bne __b4
    clc
    lda.z yoffs
    adc #<$28*8
    sta.z yoffs
    lda.z yoffs+1
    adc #>$28*8
    sta.z yoffs+1
  __b4:
    inx
    cpx #0
    bne __b3
    rts
}
gfx_init_charset: {
    .label charset = $d
    .label chargen = $a
    .label c = $c
    lda #$32
    sta PROCPORT
    lda #0
    sta.z c
    lda #<VIC_CHARSET_ROM
    sta.z charset
    lda #>VIC_CHARSET_ROM
    sta.z charset+1
    lda #<CHARGEN
    sta.z chargen
    lda #>CHARGEN
    sta.z chargen+1
  __b1:
    ldx #0
  __b2:
    ldy #0
    lda (chargen),y
    sta (charset),y
    inc.z charset
    bne !+
    inc.z charset+1
  !:
    inc.z chargen
    bne !+
    inc.z chargen+1
  !:
    inx
    cpx #8
    bne __b2
    inc.z c
    lda.z c
    cmp #0
    bne __b1
    lda #$37
    sta PROCPORT
    rts
}
// Initialize VIC screen 4 - all chars are 00
gfx_init_screen4: {
    .label ch = $d
    .label cy = $c
    lda #0
    sta.z cy
    lda #<VIC_SCREEN4
    sta.z ch
    lda #>VIC_SCREEN4
    sta.z ch+1
  __b1:
    ldx #0
  __b2:
    lda #0
    tay
    sta (ch),y
    inc.z ch
    bne !+
    inc.z ch+1
  !:
    inx
    cpx #$28
    bne __b2
    inc.z cy
    lda #$19
    cmp.z cy
    bne __b1
    rts
}
// Initialize VIC screen 3 ( value is %00xx00yy where xx is xpos and yy is ypos
gfx_init_screen3: {
    .label __1 = $1d
    .label ch = $11
    .label cy = $f
    lda #<VIC_SCREEN3
    sta.z ch
    lda #>VIC_SCREEN3
    sta.z ch+1
    lda #0
    sta.z cy
  __b1:
    ldx #0
  __b2:
    txa
    and #3
    asl
    asl
    asl
    asl
    sta.z __1
    lda #3
    and.z cy
    ora.z __1
    ldy #0
    sta (ch),y
    inc.z ch
    bne !+
    inc.z ch+1
  !:
    inx
    cpx #$28
    bne __b2
    inc.z cy
    lda #$19
    cmp.z cy
    bne __b1
    rts
}
// Initialize VIC screen 2 ( value is %ccccrrrr where cccc is (x+y mod $f) and rrrr is %1111-%cccc)
gfx_init_screen2: {
    .label col2 = $1e
    .label ch = $11
    .label cy = $f
    lda #<VIC_SCREEN2
    sta.z ch
    lda #>VIC_SCREEN2
    sta.z ch+1
    lda #0
    sta.z cy
  __b1:
    ldx #0
  __b2:
    txa
    clc
    adc.z cy
    and #$f
    tay
    tya
    eor #$ff
    clc
    adc #$f+1
    sta.z col2
    tya
    asl
    asl
    asl
    asl
    ora.z col2
    ldy #0
    sta (ch),y
    inc.z ch
    bne !+
    inc.z ch+1
  !:
    inx
    cpx #$28
    bne __b2
    inc.z cy
    lda #$19
    cmp.z cy
    bne __b1
    rts
}
// Initialize VIC screen 1 ( value is %0000cccc where cccc is (x+y mod $f))
gfx_init_screen1: {
    .label ch = $11
    .label cy = $10
    lda #<VIC_SCREEN1
    sta.z ch
    lda #>VIC_SCREEN1
    sta.z ch+1
    lda #0
    sta.z cy
  __b1:
    ldx #0
  __b2:
    txa
    clc
    adc.z cy
    and #$f
    ldy #0
    sta (ch),y
    inc.z ch
    bne !+
    inc.z ch+1
  !:
    inx
    cpx #$28
    bne __b2
    inc.z cy
    lda #$19
    cmp.z cy
    bne __b1
    rts
}
// Initialize VIC screen 0 ( value is %yyyyxxxx where yyyy is ypos and xxxx is xpos)
gfx_init_screen0: {
    .label __1 = $1e
    .label ch = $11
    .label cy = $10
    lda #<VIC_SCREEN0
    sta.z ch
    lda #>VIC_SCREEN0
    sta.z ch+1
    lda #0
    sta.z cy
  __b1:
    ldx #0
  __b2:
    lda #$f
    and.z cy
    asl
    asl
    asl
    asl
    sta.z __1
    txa
    and #$f
    ora.z __1
    ldy #0
    sta (ch),y
    inc.z ch
    bne !+
    inc.z ch+1
  !:
    inx
    cpx #$28
    bne __b2
    inc.z cy
    lda #$19
    cmp.z cy
    bne __b1
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
  // Charset ROM
  FORM_TEXT: .text " C64 DTV Graphics Mode Explorer         @                                        @ PRESET 0 Standard Charset              @                                        @ CONTROL        PLANE  A     VIC II     @ bmm        0   pattern p0   screen s0  @ mcm        0   start   00   gfx    g0  @ ecm        0   step    00   colors c0  @ hicolor    0   modulo  00              @ linear     0                COLORS     @ color off  0   PLANE  B     palet   0  @ chunky     0   pattern p0   bgcol0 00  @ border off 0   start   00   bgcol1 00  @ overscan   0   step    00   bgcol2 00  @                modulo  00   bgcol3 00  @"
  .byte 0
  FORM_COLS: .text "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa@                                        @aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa@                                        @ nnnnnnnnnnnn   mmmmmmmmmm   ooooooooo  @ nnnnnnnnnnnn   mmmmmmmmmm   ooooooooo  @ nnnnnnnnnnnn   mmmmmmmmmm   ooooooooo  @ nnnnnnnnnnnn   mmmmmmmmmm   ooooooooo  @ nnnnnnnnnnnn   mmmmmmmmmm              @ nnnnnnnnnnnn                jjjjjjjjj  @ nnnnnnnnnnnn   mmmmmmmmmm   jjjjjjjjj  @ nnnnnnnnnnnn   mmmmmmmmmm   jjjjjjjjj  @ nnnnnnnnnnnn   mmmmmmmmmm   jjjjjjjjj  @ nnnnnnnnnnnn   mmmmmmmmmm   jjjjjjjjj  @ nnnnnnnnnnnn   mmmmmmmmmm   jjjjjjjjj  @ nnnnnnnnnnnn   mmmmmmmmmm   jjjjjjjjj  @"
  .byte 0
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
