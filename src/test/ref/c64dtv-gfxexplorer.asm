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
  // The CIA#1: keyboard matrix, joystick #1/#2
  .label CIA1 = $dc00
  // The CIA#2: Serial bus, RS-232, VIC memory bank
  .label CIA2 = $dd00
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
  .const OFFSET_STRUCT_MOS6526_CIA_PORT_A_DDR = 2
  .const OFFSET_STRUCT_MOS6526_CIA_PORT_B_DDR = 3
  .const OFFSET_STRUCT_MOS6526_CIA_PORT_B = 1
  // Number of form fields
  .const form_fields_cnt = $24
  .label print_line_cursor = 7
  // Keyboard event buffer size. The number of events currently in the event buffer
  .label keyboard_events_size = 2
  // Counts down to blink for form cursor (it is inversed in the lower half)
  // Always blink cursor in new field
  .label form_cursor_count = 3
  // Current selected field in the form
  .label form_field_idx = 4
  .label print_char_cursor = 5
main: {
    // asm
    sei
    // *PROCPORT_DDR = PROCPORT_DDR_MEMORY_MASK
    // Disable normal interrupt (prevent keyboard reading glitches and allows to hide basic/kernal)
    // Disable kernal & basic
    lda #PROCPORT_DDR_MEMORY_MASK
    sta PROCPORT_DDR
    // *PROCPORT = PROCPORT_RAM_IO
    lda #PROCPORT_RAM_IO
    sta PROCPORT
    // *DTV_FEATURE = DTV_FEATURE_ENABLE
    // Enable DTV extended modes
    lda #DTV_FEATURE_ENABLE
    sta DTV_FEATURE
    // keyboard_init()
    jsr keyboard_init
    // gfx_init()
    jsr gfx_init
    lda #0
    sta.z form_field_idx
    sta.z keyboard_events_size
    lda #FORM_CURSOR_BLINK/2
    sta.z form_cursor_count
  __b2:
    // form_mode()
  // Let the user change the GFX configuration
    jsr form_mode
    // gfx_mode()
    // Show the GFX configuration
    jsr gfx_mode
    jmp __b2
}
// Change graphics mode to show the selected graphics mode
gfx_mode: {
    .label __20 = 9
    .label __24 = $14
    .label __26 = $1d
    .label __34 = 9
    .label __38 = $1f
    .label __40 = $1b
    .label __47 = $10
    .label __48 = $10
    .label __50 = 7
    .label __52 = $13
    .label __82 = $10
    .label __83 = 7
    .label plane_a = 9
    .label plane_b = 9
    .label vic_colors = $10
    .label col = 5
    .label cy = $d
    // if(*form_ctrl_line!=0)
    lda form_ctrl_line
    cmp #0
    beq __b10
    ldx #DTV_LINEAR
    jmp __b1
  __b10:
    ldx #0
  __b1:
    // if(*form_ctrl_borof!=0)
    lda form_ctrl_borof
    cmp #0
    beq __b2
    // dtv_control = dtv_control | DTV_BORDER_OFF
    txa
    ora #DTV_BORDER_OFF
    tax
  __b2:
    // if(*form_ctrl_hicol!=0)
    lda form_ctrl_hicol
    cmp #0
    beq __b3
    // dtv_control = dtv_control | DTV_HIGHCOLOR
    txa
    ora #DTV_HIGHCOLOR
    tax
  __b3:
    // if(*form_ctrl_overs!=0)
    lda form_ctrl_overs
    cmp #0
    beq __b4
    // dtv_control = dtv_control | DTV_OVERSCAN
    txa
    ora #DTV_OVERSCAN
    tax
  __b4:
    // if(*form_ctrl_colof!=0)
    lda form_ctrl_colof
    cmp #0
    beq __b5
    // dtv_control = dtv_control | DTV_COLORRAM_OFF
    txa
    ora #DTV_COLORRAM_OFF
    tax
  __b5:
    // if(*form_ctrl_chunk!=0)
    lda form_ctrl_chunk
    cmp #0
    beq __b6
    // dtv_control = dtv_control | DTV_CHUNKY
    txa
    ora #DTV_CHUNKY
    tax
  __b6:
    // *DTV_CONTROL = dtv_control
    stx DTV_CONTROL
    // if(*form_ctrl_ecm!=0)
    lda form_ctrl_ecm
    cmp #0
    beq __b11
    ldx #VIC_DEN|VIC_RSEL|3|VIC_ECM
    jmp __b7
  __b11:
    ldx #VIC_DEN|VIC_RSEL|3
  __b7:
    // if(*form_ctrl_bmm!=0)
    lda form_ctrl_bmm
    cmp #0
    beq __b8
    // vic_control = vic_control | VIC_BMM
    txa
    ora #VIC_BMM
    tax
  __b8:
    // *VIC_CONTROL = vic_control
    stx VIC_CONTROL
    // if(*form_ctrl_mcm!=0)
    lda form_ctrl_mcm
    cmp #0
    beq __b12
    lda #VIC_CSEL|VIC_MCM
    jmp __b9
  __b12:
    lda #VIC_CSEL
  __b9:
    // *VIC_CONTROL2 = vic_control2
    sta VIC_CONTROL2
    // *form_a_start_hi*$10
    lda form_a_start_hi
    asl
    asl
    asl
    asl
    // plane_a_offs = *form_a_start_hi*$10|*form_a_start_lo
    ora form_a_start_lo
    tax
    // get_plane(*form_a_pattern)
    lda form_a_pattern
    jsr get_plane
    // get_plane(*form_a_pattern)
    // plane_a = get_plane(*form_a_pattern) + plane_a_offs
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
    // < plane_a
    lda.z plane_a
    sta.z __24
    lda.z plane_a+1
    sta.z __24+1
    // < < plane_a
    lda.z __24
    // *DTV_PLANEA_START_LO = < < plane_a
    sta DTV_PLANEA_START_LO
    // > < plane_a
    lda.z __24+1
    // *DTV_PLANEA_START_MI = > < plane_a
    sta DTV_PLANEA_START_MI
    // > plane_a
    lda.z plane_a+2
    sta.z __26
    lda.z plane_a+3
    sta.z __26+1
    // < > plane_a
    lda.z __26
    // *DTV_PLANEA_START_HI = < > plane_a
    sta DTV_PLANEA_START_HI
    // *form_a_step_hi*$10
    lda form_a_step_hi
    asl
    asl
    asl
    asl
    // *form_a_step_hi*$10|*form_a_step_lo
    ora form_a_step_lo
    // *DTV_PLANEA_STEP = *form_a_step_hi*$10|*form_a_step_lo
    sta DTV_PLANEA_STEP
    // *form_a_mod_hi*$10
    lda form_a_mod_hi
    asl
    asl
    asl
    asl
    // *form_a_mod_hi*$10|*form_a_mod_lo
    ora form_a_mod_lo
    // *DTV_PLANEA_MODULO_LO = *form_a_mod_hi*$10|*form_a_mod_lo
    sta DTV_PLANEA_MODULO_LO
    // *DTV_PLANEA_MODULO_HI = 0
    lda #0
    sta DTV_PLANEA_MODULO_HI
    // *form_b_start_hi*$10
    lda form_b_start_hi
    asl
    asl
    asl
    asl
    // plane_b_offs = *form_b_start_hi*$10|*form_b_start_lo
    ora form_b_start_lo
    tax
    // get_plane(*form_b_pattern)
    lda form_b_pattern
    jsr get_plane
    // get_plane(*form_b_pattern)
    // plane_b = get_plane(*form_b_pattern) + plane_b_offs
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
    // < plane_b
    lda.z plane_b
    sta.z __38
    lda.z plane_b+1
    sta.z __38+1
    // < < plane_b
    lda.z __38
    // *DTV_PLANEB_START_LO = < < plane_b
    sta DTV_PLANEB_START_LO
    // > < plane_b
    lda.z __38+1
    // *DTV_PLANEB_START_MI = > < plane_b
    sta DTV_PLANEB_START_MI
    // > plane_b
    lda.z plane_b+2
    sta.z __40
    lda.z plane_b+3
    sta.z __40+1
    // < > plane_b
    lda.z __40
    // *DTV_PLANEB_START_HI = < > plane_b
    sta DTV_PLANEB_START_HI
    // *form_b_step_hi*$10
    lda form_b_step_hi
    asl
    asl
    asl
    asl
    // *form_b_step_hi*$10|*form_b_step_lo
    ora form_b_step_lo
    // *DTV_PLANEB_STEP = *form_b_step_hi*$10|*form_b_step_lo
    sta DTV_PLANEB_STEP
    // *form_b_mod_hi*$10
    lda form_b_mod_hi
    asl
    asl
    asl
    asl
    // *form_b_mod_hi*$10|*form_b_mod_lo
    ora form_b_mod_lo
    // *DTV_PLANEB_MODULO_LO = *form_b_mod_hi*$10|*form_b_mod_lo
    sta DTV_PLANEB_MODULO_LO
    // *DTV_PLANEB_MODULO_HI = 0
    lda #0
    sta DTV_PLANEB_MODULO_HI
    // CIA2->PORT_A_DDR = %00000011
    // VIC Graphics Bank
    lda #3
    sta CIA2+OFFSET_STRUCT_MOS6526_CIA_PORT_A_DDR
    // CIA2->PORT_A = %00000011 ^ (byte)((word)VIC_SCREEN0/$4000)
    // Set VIC Bank bits to output - all others to input
    lda #3^VIC_SCREEN0/$4000
    sta CIA2
    // get_vic_screen(*form_vic_screen)
    lda form_vic_screen
    jsr get_vic_screen
    // get_vic_screen(*form_vic_screen)
    // (word)get_vic_screen(*form_vic_screen)&$3fff
    lda.z __47
    and #<$3fff
    sta.z __47
    lda.z __47+1
    and #>$3fff
    sta.z __47+1
    // ((word)get_vic_screen(*form_vic_screen)&$3fff)/$40
    ldy #6
  !:
    lsr.z __48+1
    ror.z __48
    dey
    bne !-
    // get_vic_charset(*form_vic_gfx)
    lda form_vic_gfx
    jsr get_vic_charset
    // (word)get_vic_charset(*form_vic_gfx)&$3fff
    lda.z __50
    and #<$3fff
    sta.z __50
    lda.z __50+1
    and #>$3fff
    sta.z __50+1
    // >((word)get_vic_charset(*form_vic_gfx)&$3fff)
    // (>((word)get_vic_charset(*form_vic_gfx)&$3fff))/4
    lsr
    lsr
    sta.z __52
    // (byte)(((word)get_vic_screen(*form_vic_screen)&$3fff)/$40)  |   ((>((word)get_vic_charset(*form_vic_gfx)&$3fff))/4)
    lda.z __48
    ora.z __52
    // *VIC_MEMORY = (byte)(((word)get_vic_screen(*form_vic_screen)&$3fff)/$40)  |   ((>((word)get_vic_charset(*form_vic_gfx)&$3fff))/4)
    // Set VIC Bank
    // VIC memory
    sta VIC_MEMORY
    // get_vic_screen(*form_vic_cols)
    lda form_vic_cols
    jsr get_vic_screen
    // get_vic_screen(*form_vic_cols)
    // vic_colors = get_vic_screen(*form_vic_cols)
    lda #0
    sta.z cy
    lda #<COLS
    sta.z col
    lda #>COLS
    sta.z col+1
  __b19:
    ldx #0
  __b20:
    // *col++ = *vic_colors++
    ldy #0
    lda (vic_colors),y
    sta (col),y
    // *col++ = *vic_colors++;
    inc.z col
    bne !+
    inc.z col+1
  !:
    inc.z vic_colors
    bne !+
    inc.z vic_colors+1
  !:
    // for(byte cx: 0..39)
    inx
    cpx #$28
    bne __b20
    // for(byte cy: 0..24 )
    inc.z cy
    lda #$19
    cmp.z cy
    bne __b19
    // *BORDERCOL = 0
    // Background colors
    lda #0
    sta BORDERCOL
    // *form_vic_bg0_hi*$10
    lda form_vic_bg0_hi
    asl
    asl
    asl
    asl
    // *form_vic_bg0_hi*$10|*form_vic_bg0_lo
    ora form_vic_bg0_lo
    // *BGCOL1 = *form_vic_bg0_hi*$10|*form_vic_bg0_lo
    sta BGCOL1
    // *form_vic_bg1_hi*$10
    lda form_vic_bg1_hi
    asl
    asl
    asl
    asl
    // *form_vic_bg1_hi*$10|*form_vic_bg1_lo
    ora form_vic_bg1_lo
    // *BGCOL2 = *form_vic_bg1_hi*$10|*form_vic_bg1_lo
    sta BGCOL2
    // *form_vic_bg2_hi*$10
    lda form_vic_bg2_hi
    asl
    asl
    asl
    asl
    // *form_vic_bg2_hi*$10|*form_vic_bg2_lo
    ora form_vic_bg2_lo
    // *BGCOL3 = *form_vic_bg2_hi*$10|*form_vic_bg2_lo
    sta BGCOL3
    // *form_vic_bg3_hi*$10
    lda form_vic_bg3_hi
    asl
    asl
    asl
    asl
    // *form_vic_bg3_hi*$10|*form_vic_bg3_lo
    ora form_vic_bg3_lo
    // *BGCOL4 = *form_vic_bg3_hi*$10|*form_vic_bg3_lo
    sta BGCOL4
    // if(*form_dtv_palet==0)
    // DTV Palette
    lda form_dtv_palet
    cmp #0
    beq __b13
    ldx #0
  // DTV Palette - Grey Tones
  __b23:
    // DTV_PALETTE[j] = j
    txa
    sta DTV_PALETTE,x
    // for(byte j : 0..$f)
    inx
    cpx #$10
    bne __b23
  __b25:
    // while(*RASTER!=$ff)
    lda #$ff
    cmp RASTER
    bne __b25
    // keyboard_event_scan()
    jsr keyboard_event_scan
    // keyboard_event_get()
    jsr keyboard_event_get
    // keyboard_event = keyboard_event_get()
    // if(keyboard_event==KEY_SPACE)
    cmp #KEY_SPACE
    beq __breturn
    jmp __b25
  __breturn:
    // }
    rts
  // DTV Palette - default
  __b13:
    ldx #0
  __b24:
    // DTV_PALETTE[i] = DTV_PALETTE_DEFAULT[i]
    lda DTV_PALETTE_DEFAULT,x
    sta DTV_PALETTE,x
    // for(byte i : 0..$f)
    inx
    cpx #$10
    bne __b24
    jmp __b25
}
// Get the next event from the keyboard event buffer.
// Returns $ff if there is no event waiting. As all events are <$7f it is enough to examine bit 7 when determining if there is any event to process.
// The buffer is filled by keyboard_event_scan()
keyboard_event_get: {
    // if(keyboard_events_size==0)
    lda.z keyboard_events_size
    cmp #0
    beq __b1
    // return keyboard_events[--keyboard_events_size];
    dec.z keyboard_events_size
    ldy.z keyboard_events_size
    lda keyboard_events,y
    rts
  __b1:
    lda #$ff
    // }
    rts
}
// Scans the entire matrix to determine which keys have been pressed/depressed.
// Generates keyboard events into the event buffer. Events can be read using keyboard_event_get().
// Handles debounce and only generates events when the status of a key changes.
// Also stores current status of modifiers in keyboard_modifiers.
keyboard_event_scan: {
    .label row_scan = $16
    .label keycode = $22
    .label row = $e
    lda #0
    sta.z keycode
    sta.z row
  __b7:
    // keyboard_matrix_read(row)
    ldx.z row
    jsr keyboard_matrix_read
    // row_scan = keyboard_matrix_read(row)
    sta.z row_scan
    // if(row_scan!=keyboard_scan_values[row])
    ldy.z row
    cmp keyboard_scan_values,y
    bne __b6
    // keycode = keycode + 8
    lax.z keycode
    axs #-[8]
    stx.z keycode
  __b8:
    // for(char row : 0..7)
    inc.z row
    lda #8
    cmp.z row
    bne __b7
    // keyboard_event_pressed(KEY_LSHIFT)
    lda #KEY_LSHIFT
    sta.z keyboard_event_pressed.keycode
    jsr keyboard_event_pressed
    // keyboard_event_pressed(KEY_LSHIFT)
    // if(keyboard_event_pressed(KEY_LSHIFT)!= 0)
    cmp #0
    beq __b4
    ldx #KEY_MODIFIER_LSHIFT
    jmp __b1
  __b4:
    ldx #0
  __b1:
    // keyboard_event_pressed(KEY_RSHIFT)
    lda #KEY_RSHIFT
    sta.z keyboard_event_pressed.keycode
    jsr keyboard_event_pressed
    // keyboard_event_pressed(KEY_RSHIFT)
    // if(keyboard_event_pressed(KEY_RSHIFT)!= 0)
    cmp #0
    beq __b2
    // keyboard_modifiers = keyboard_modifiers | KEY_MODIFIER_RSHIFT
    txa
    ora #KEY_MODIFIER_RSHIFT
    tax
  __b2:
    // keyboard_event_pressed(KEY_CTRL)
    lda #KEY_CTRL
    sta.z keyboard_event_pressed.keycode
    jsr keyboard_event_pressed
    // keyboard_event_pressed(KEY_CTRL)
    // if(keyboard_event_pressed(KEY_CTRL)!= 0)
    cmp #0
    beq __b3
    // keyboard_modifiers = keyboard_modifiers | KEY_MODIFIER_CTRL
    txa
    ora #KEY_MODIFIER_CTRL
    tax
  __b3:
    // keyboard_event_pressed(KEY_COMMODORE)
    lda #KEY_COMMODORE
    sta.z keyboard_event_pressed.keycode
    jsr keyboard_event_pressed
    // keyboard_event_pressed(KEY_COMMODORE)
    // if(keyboard_event_pressed(KEY_COMMODORE)!= 0)
    cmp #0
    beq __breturn
    // keyboard_modifiers = keyboard_modifiers | KEY_MODIFIER_COMMODORE
    txa
    ora #KEY_MODIFIER_COMMODORE
    tax
  __breturn:
    // }
    rts
  // Something has changed on the keyboard row - check each column
  __b6:
    ldx #0
  __b9:
    // row_scan^keyboard_scan_values[row]
    lda.z row_scan
    ldy.z row
    eor keyboard_scan_values,y
    // (row_scan^keyboard_scan_values[row])&keyboard_matrix_col_bitmask[col]
    and keyboard_matrix_col_bitmask,x
    // if(((row_scan^keyboard_scan_values[row])&keyboard_matrix_col_bitmask[col])!=0)
    cmp #0
    beq __b10
    // if(keyboard_events_size!=8)
    lda #8
    cmp.z keyboard_events_size
    beq __b10
    // event_type = row_scan&keyboard_matrix_col_bitmask[col]
    lda keyboard_matrix_col_bitmask,x
    and.z row_scan
    // if(event_type==0)
    cmp #0
    beq __b11
    // keyboard_events[keyboard_events_size++] = keycode
    // Key pressed
    lda.z keycode
    ldy.z keyboard_events_size
    sta keyboard_events,y
    // keyboard_events[keyboard_events_size++] = keycode;
    inc.z keyboard_events_size
  __b10:
    // keycode++;
    inc.z keycode
    // for(char col : 0..7)
    inx
    cpx #8
    bne __b9
    // keyboard_scan_values[row] = row_scan
    // Store the current keyboard status for the row to debounce
    lda.z row_scan
    ldy.z row
    sta keyboard_scan_values,y
    jmp __b8
  __b11:
    // keycode|$40
    lda #$40
    ora.z keycode
    // keyboard_events[keyboard_events_size++] = keycode|$40
    // Key released
    ldy.z keyboard_events_size
    sta keyboard_events,y
    // keyboard_events[keyboard_events_size++] = keycode|$40;
    inc.z keyboard_events_size
    jmp __b10
}
// Determine if a specific key is currently pressed based on the last keyboard_event_scan()
// Returns 0 is not pressed and non-0 if pressed
// keyboard_event_pressed(byte zp($f) keycode)
keyboard_event_pressed: {
    .label row_bits = $21
    .label keycode = $f
    // keycode>>3
    lda.z keycode
    lsr
    lsr
    lsr
    // row_bits = keyboard_scan_values[keycode>>3]
    tay
    lda keyboard_scan_values,y
    sta.z row_bits
    // keycode&7
    lda #7
    and.z keycode
    // row_bits & keyboard_matrix_col_bitmask[keycode&7]
    tay
    lda keyboard_matrix_col_bitmask,y
    and.z row_bits
    // }
    rts
}
// Read a single row of the keyboard matrix
// The row ID (0-7) of the keyboard matrix row to read. See the C64 key matrix for row IDs.
// Returns the keys pressed on the row as bits according to the C64 key matrix.
// Notice: If the C64 normal interrupt is still running it will occasionally interrupt right between the read & write
// leading to erroneous readings. You must disable kill the normal interrupt or sei/cli around calls to the keyboard matrix reader.
// keyboard_matrix_read(byte register(X) rowid)
keyboard_matrix_read: {
    // CIA1->PORT_A = keyboard_matrix_row_bitmask[rowid]
    lda keyboard_matrix_row_bitmask,x
    sta CIA1
    // ~CIA1->PORT_B
    lda CIA1+OFFSET_STRUCT_MOS6526_CIA_PORT_B
    eor #$ff
    // }
    rts
}
// Get the VIC screen address from the screen index
// get_vic_screen(byte register(A) idx)
get_vic_screen: {
    .label return = $10
    // if(idx==0)
    cmp #0
    beq __b1
    // if(idx==1)
    cmp #1
    beq __b2
    // if(idx==2)
    cmp #2
    beq __b3
    // if(idx==3)
    cmp #3
    beq __b4
    // if(idx==4)
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
  __b2:
    lda #<VIC_SCREEN1
    sta.z return
    lda #>VIC_SCREEN1
    sta.z return+1
    rts
  __b3:
    lda #<VIC_SCREEN2
    sta.z return
    lda #>VIC_SCREEN2
    sta.z return+1
    rts
  __b4:
    lda #<VIC_SCREEN3
    sta.z return
    lda #>VIC_SCREEN3
    sta.z return+1
    // }
    rts
}
// Get the VIC charset/bitmap address from the index
// get_vic_charset(byte register(A) idx)
get_vic_charset: {
    .label return = 7
    // if(idx==0)
    cmp #0
    beq __b1
    // if(idx==1)
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
    // }
    rts
}
// Get plane address from a plane index (from the form)
// get_plane(byte register(A) idx)
get_plane: {
    .label return = 9
    // if(idx==0)
    cmp #0
    beq __b2
    // if(idx==1)
    cmp #1
    bne !__b7+
    jmp __b7
  !__b7:
    // if(idx==2)
    cmp #2
    bne !__b8+
    jmp __b8
  !__b8:
    // if(idx==3)
    cmp #3
    bne !__b9+
    jmp __b9
  !__b9:
    // if(idx==4)
    cmp #4
    bne !__b10+
    jmp __b10
  !__b10:
    // if(idx==5)
    cmp #5
    bne !__b11+
    jmp __b11
  !__b11:
    // if(idx==6)
    cmp #6
    bne !__b12+
    jmp __b12
  !__b12:
    // if(idx==7)
    cmp #7
    bne !__b13+
    jmp __b13
  !__b13:
    // if(idx==8)
    cmp #8
    bne !__b14+
    jmp __b14
  !__b14:
    // if(idx==9)
    cmp #9
    beq __b3
    // if(idx==10)
    cmp #$a
    beq __b4
    // if(idx==11)
    cmp #$b
    beq __b5
    // if(idx==12)
    cmp #$c
    beq __b6
    // if(idx==13)
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
  __b2:
    lda #<VIC_SCREEN0
    sta.z return
    lda #>VIC_SCREEN0
    sta.z return+1
    lda #<VIC_SCREEN0>>$10
    sta.z return+2
    lda #>VIC_SCREEN0>>$10
    sta.z return+3
    rts
  __b3:
    lda #<PLANE_HORISONTAL2
    sta.z return
    lda #>PLANE_HORISONTAL2
    sta.z return+1
    lda #<PLANE_HORISONTAL2>>$10
    sta.z return+2
    lda #>PLANE_HORISONTAL2>>$10
    sta.z return+3
    rts
  __b4:
    lda #<PLANE_VERTICAL2
    sta.z return
    lda #>PLANE_VERTICAL2
    sta.z return+1
    lda #<PLANE_VERTICAL2>>$10
    sta.z return+2
    lda #>PLANE_VERTICAL2>>$10
    sta.z return+3
    rts
  __b5:
    lda #<PLANE_CHARSET8
    sta.z return
    lda #>PLANE_CHARSET8
    sta.z return+1
    lda #<PLANE_CHARSET8>>$10
    sta.z return+2
    lda #>PLANE_CHARSET8>>$10
    sta.z return+3
    rts
  __b6:
    lda #<PLANE_BLANK
    sta.z return
    lda #>PLANE_BLANK
    sta.z return+1
    lda #<PLANE_BLANK>>$10
    sta.z return+2
    lda #>PLANE_BLANK>>$10
    sta.z return+3
    rts
  __b7:
    lda #<VIC_SCREEN1
    sta.z return
    lda #>VIC_SCREEN1
    sta.z return+1
    lda #<VIC_SCREEN1>>$10
    sta.z return+2
    lda #>VIC_SCREEN1>>$10
    sta.z return+3
    rts
  __b8:
    lda #<VIC_SCREEN2
    sta.z return
    lda #>VIC_SCREEN2
    sta.z return+1
    lda #<VIC_SCREEN2>>$10
    sta.z return+2
    lda #>VIC_SCREEN2>>$10
    sta.z return+3
    rts
  __b9:
    lda #<VIC_SCREEN3
    sta.z return
    lda #>VIC_SCREEN3
    sta.z return+1
    lda #<VIC_SCREEN3>>$10
    sta.z return+2
    lda #>VIC_SCREEN3>>$10
    sta.z return+3
    rts
  __b10:
    lda #<VIC_BITMAP
    sta.z return
    lda #>VIC_BITMAP
    sta.z return+1
    lda #<VIC_BITMAP>>$10
    sta.z return+2
    lda #>VIC_BITMAP>>$10
    sta.z return+3
    rts
  __b11:
    lda #<VIC_CHARSET_ROM
    sta.z return
    lda #>VIC_CHARSET_ROM
    sta.z return+1
    lda #<VIC_CHARSET_ROM>>$10
    sta.z return+2
    lda #>VIC_CHARSET_ROM>>$10
    sta.z return+3
    rts
  __b12:
    lda #<PLANE_8BPP_CHUNKY
    sta.z return
    lda #>PLANE_8BPP_CHUNKY
    sta.z return+1
    lda #<PLANE_8BPP_CHUNKY>>$10
    sta.z return+2
    lda #>PLANE_8BPP_CHUNKY>>$10
    sta.z return+3
    rts
  __b13:
    lda #<PLANE_HORISONTAL
    sta.z return
    lda #>PLANE_HORISONTAL
    sta.z return+1
    lda #<PLANE_HORISONTAL>>$10
    sta.z return+2
    lda #>PLANE_HORISONTAL>>$10
    sta.z return+3
    rts
  __b14:
    lda #<PLANE_VERTICAL
    sta.z return
    lda #>PLANE_VERTICAL
    sta.z return+1
    lda #<PLANE_VERTICAL>>$10
    sta.z return+2
    lda #>PLANE_VERTICAL>>$10
    sta.z return+3
    // }
    rts
}
// Show the form - and let the user change values
form_mode: {
    .label preset_current = $d
    // print_set_screen(COLS)
  // Form Colors
    lda #<COLS
    sta.z print_set_screen.screen
    lda #>COLS
    sta.z print_set_screen.screen+1
    jsr print_set_screen
    // print_cls()
    jsr print_cls
    // print_str_lines(FORM_COLS)
    lda #<FORM_COLS
    sta.z print_str_lines.str
    lda #>FORM_COLS
    sta.z print_str_lines.str+1
    jsr print_str_lines
    // print_set_screen(FORM_SCREEN)
  // Form Text
    lda #<FORM_SCREEN
    sta.z print_set_screen.screen
    lda #>FORM_SCREEN
    sta.z print_set_screen.screen+1
    jsr print_set_screen
    // print_cls()
    jsr print_cls
    // print_str_lines(FORM_TEXT)
    lda #<FORM_TEXT
    sta.z print_str_lines.str
    lda #>FORM_TEXT
    sta.z print_str_lines.str+1
    jsr print_str_lines
    // form_set_screen(FORM_SCREEN)
  // Form Fields
    jsr form_set_screen
    // form_render_values()
    jsr form_render_values
    // render_preset_name(*form_preset)
    lda form_fields_val
    jsr render_preset_name
    // *DTV_GRAPHICS_VIC_BANK = (byte)((dword)FORM_CHARSET/$10000)
    // DTV Graphics Bank
    lda #0
    sta DTV_GRAPHICS_VIC_BANK
    // *DTV_COLOR_BANK_LO = <((word)(DTV_COLOR_BANK_DEFAULT/$400))
    // DTV Color Bank
    lda #<DTV_COLOR_BANK_DEFAULT/$400
    sta DTV_COLOR_BANK_LO
    // *DTV_COLOR_BANK_HI = >((word)(DTV_COLOR_BANK_DEFAULT/$400))
    lda #0
    sta DTV_COLOR_BANK_HI
    // CIA2->PORT_A_DDR = %00000011
    // VIC Graphics Bank
    lda #3
    sta CIA2+OFFSET_STRUCT_MOS6526_CIA_PORT_A_DDR
    // CIA2->PORT_A = %00000011 ^ (byte)((word)FORM_CHARSET/$4000)
    // Set VIC Bank bits to output - all others to input
    sta CIA2
    // *DTV_CONTROL = 0
    // Set VIC Bank
    // DTV Graphics Mode
    lda #0
    sta DTV_CONTROL
    // *VIC_CONTROL = VIC_DEN|VIC_RSEL|3
    // VIC Graphics Mode
    lda #VIC_DEN|VIC_RSEL|3
    sta VIC_CONTROL
    // *VIC_CONTROL2 = VIC_CSEL
    lda #VIC_CSEL
    sta VIC_CONTROL2
    // *VIC_MEMORY =  (byte)((((word)FORM_SCREEN&$3fff)/$40)|(((word)FORM_CHARSET&$3fff)/$400))
    // VIC Memory Pointers
    lda #(FORM_SCREEN&$3fff)/$40|(FORM_CHARSET&$3fff)/$400
    sta VIC_MEMORY
    // *DTV_PLANEA_START_LO = < FORM_SCREEN
    // DTV Plane A to FORM_SCREEN also
    lda #0
    sta DTV_PLANEA_START_LO
    // *DTV_PLANEA_START_MI = > FORM_SCREEN
    lda #>FORM_SCREEN
    sta DTV_PLANEA_START_MI
    // *DTV_PLANEA_START_HI = 0
    lda #0
    sta DTV_PLANEA_START_HI
    tax
  // DTV Palette - default
  __b1:
    // DTV_PALETTE[i] = DTV_PALETTE_DEFAULT[i]
    lda DTV_PALETTE_DEFAULT,x
    sta DTV_PALETTE,x
    // for(byte i : 0..$f)
    inx
    cpx #$10
    bne __b1
    // *BGCOL = 0
    // Screen colors
    lda #0
    sta BGCOL
    // *BORDERCOL = 0
    sta BORDERCOL
    // preset_current = *form_preset
    lda form_fields_val
    sta.z preset_current
  __b2:
  // Let the user change values in the form
  __b4:
    // while(*RASTER!=$ff)
    lda #$ff
    cmp RASTER
    bne __b4
    // form_control()
    jsr form_control
    txa
    // if(form_control()!=0)
    cmp #0
    beq __b6
    // }
    rts
  __b6:
    // if(preset_current!=*form_preset)
    lda form_fields_val
    cmp.z preset_current
    beq __b2
    // apply_preset(*form_preset)
    // Preset changed - update field values and render
    jsr apply_preset
    // preset_current = *form_preset
    lda form_fields_val
    sta.z preset_current
    // form_render_values()
    jsr form_render_values
    // render_preset_name(*form_preset)
    lda form_fields_val
    jsr render_preset_name
    jmp __b2
}
// Render form preset name in the form
// idx is the ID of the preset
// render_preset_name(byte register(A) idx)
render_preset_name: {
    .label name = $10
    // if(idx==0)
    cmp #0
    beq __b3
    // if(idx==1)
    cmp #1
    beq __b6
    // if(idx==2)
    cmp #2
    beq __b7
    // if(idx==3)
    cmp #3
    beq __b8
    // if(idx==4)
    cmp #4
    beq __b9
    // if(idx==5)
    cmp #5
    beq __b10
    // if(idx==6)
    cmp #6
    beq __b11
    // if(idx==7)
    cmp #7
    beq __b12
    // if(idx==8)
    cmp #8
    beq __b4
    // if(idx==9)
    cmp #9
    beq __b5
    // if(idx==10)
    cmp #$a
    beq __b1
  __b3:
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
  __b4:
    lda #<name_9
    sta.z name
    lda #>name_9
    sta.z name+1
    jmp __b2
  __b5:
    lda #<name_10
    sta.z name
    lda #>name_10
    sta.z name+1
    jmp __b2
  __b6:
    lda #<name_2
    sta.z name
    lda #>name_2
    sta.z name+1
    jmp __b2
  __b7:
    lda #<name_3
    sta.z name
    lda #>name_3
    sta.z name+1
    jmp __b2
  __b8:
    lda #<name_4
    sta.z name
    lda #>name_4
    sta.z name+1
    jmp __b2
  __b9:
    lda #<name_5
    sta.z name
    lda #>name_5
    sta.z name+1
    jmp __b2
  __b10:
    lda #<name_6
    sta.z name
    lda #>name_6
    sta.z name+1
    jmp __b2
  __b11:
    lda #<name_7
    sta.z name
    lda #>name_7
    sta.z name+1
    jmp __b2
  __b12:
    lda #<name_8
    sta.z name
    lda #>name_8
    sta.z name+1
  __b2:
    // print_str_at(name, FORM_SCREEN+40*2+10)
  // Render it
    jsr print_str_at
    // }
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
// print_str_at(byte* zp($10) str, byte* zp(5) at)
print_str_at: {
    .label at = 5
    .label str = $10
    lda #<FORM_SCREEN+$28*2+$a
    sta.z at
    lda #>FORM_SCREEN+$28*2+$a
    sta.z at+1
  __b1:
    // while(*str)
    ldy #0
    lda (str),y
    cmp #0
    bne __b2
    // }
    rts
  __b2:
    // *(at++) = *(str++)
    ldy #0
    lda (str),y
    sta (at),y
    // *(at++) = *(str++);
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
    // for( byte idx=0; idx<form_fields_cnt; idx++)
    cpx #form_fields_cnt
    bcc __b2
    // }
    rts
  __b2:
    // form_field_ptr(idx)
    jsr form_field_ptr
    // *field = print_hextab[form_fields_val[idx]]
    ldy form_fields_val,x
    lda print_hextab,y
    ldy.z form_field_ptr.x
    sta (form_field_ptr.line),y
    // for( byte idx=0; idx<form_fields_cnt; idx++)
    inx
    jmp __b1
}
// Get the screen address of a form field
// field_idx is the index of the field to get the screen address for
// form_field_ptr(byte register(X) field_idx)
form_field_ptr: {
    .label line = $14
    .label x = $16
    .label return = $1d
    // y = form_fields_y[field_idx]
    ldy form_fields_y,x
    // line = (byte*) { form_line_hi[y], form_line_lo[y] }
    lda form_line_hi,y
    sta.z line+1
    lda form_line_lo,y
    sta.z line
    // x = form_fields_x[field_idx]
    lda form_fields_x,x
    sta.z x
    // line+x
    clc
    adc.z line
    sta.z return
    lda #0
    adc.z line+1
    sta.z return+1
    // }
    rts
}
// Apply a form value preset to the form values
// idx is the ID of the preset
// apply_preset(byte register(A) idx)
apply_preset: {
    .label preset = 7
    // if(idx==0)
    cmp #0
    beq __b3
    // if(idx==1)
    cmp #1
    beq __b6
    // if(idx==2)
    cmp #2
    beq __b7
    // if(idx==3)
    cmp #3
    beq __b8
    // if(idx==4)
    cmp #4
    beq __b9
    // if(idx==5)
    cmp #5
    beq __b10
    // if(idx==6)
    cmp #6
    beq __b11
    // if(idx==7)
    cmp #7
    beq __b12
    // if(idx==8)
    cmp #8
    beq __b4
    // if(idx==9)
    cmp #9
    beq __b5
    // if(idx==10)
    cmp #$a
    beq __b1
  __b3:
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
  __b4:
    lda #<preset_sixsfred
    sta.z preset
    lda #>preset_sixsfred
    sta.z preset+1
    jmp __b2
  __b5:
    lda #<preset_sixsfred2
    sta.z preset
    lda #>preset_sixsfred2
    sta.z preset+1
    jmp __b2
  __b6:
    lda #<preset_ecmchar
    sta.z preset
    lda #>preset_ecmchar
    sta.z preset+1
    jmp __b2
  __b7:
    lda #<preset_stdbm
    sta.z preset
    lda #>preset_stdbm
    sta.z preset+1
    jmp __b2
  __b8:
    lda #<preset_mcbm
    sta.z preset
    lda #>preset_mcbm
    sta.z preset+1
    jmp __b2
  __b9:
    lda #<preset_hi_stdchar
    sta.z preset
    lda #>preset_hi_stdchar
    sta.z preset+1
    jmp __b2
  __b10:
    lda #<preset_hi_ecmchar
    sta.z preset
    lda #>preset_hi_ecmchar
    sta.z preset+1
    jmp __b2
  __b11:
    lda #<preset_twoplane
    sta.z preset
    lda #>preset_twoplane
    sta.z preset+1
    jmp __b2
  __b12:
    lda #<preset_chunky
    sta.z preset
    lda #>preset_chunky
    sta.z preset+1
  __b2:
    ldy #0
  // Copy preset values into the fields
  __b13:
    // for( byte i=0; i != form_fields_cnt; i++)
    cpy #form_fields_cnt
    bne __b14
    // }
    rts
  __b14:
    // form_fields_val[i] = preset[i]
    lda (preset),y
    sta form_fields_val,y
    // for( byte i=0; i != form_fields_cnt; i++)
    iny
    jmp __b13
}
// Reads keyboard and allows the user to navigate and change the fields of the form
// Returns 0 if space is not pressed, non-0 if space is pressed
form_control: {
    .label field = $1d
    // form_field_ptr(form_field_idx)
    ldx.z form_field_idx
    jsr form_field_ptr
    // form_field_ptr(form_field_idx)
    // field = form_field_ptr(form_field_idx)
    // if(--form_cursor_count < 0)
    dec.z form_cursor_count
    lda.z form_cursor_count
    cmp #0
    bpl __b1
    lda #FORM_CURSOR_BLINK
    sta.z form_cursor_count
  __b1:
    // if(form_cursor_count<FORM_CURSOR_BLINK/2)
    lda.z form_cursor_count
    sec
    sbc #FORM_CURSOR_BLINK/2
    bvc !+
    eor #$80
  !:
    bpl !__b2+
    jmp __b2
  !__b2:
    // *field & $7f
    lda #$7f
    ldy #0
    and (field),y
    // *field = *field & $7f
    sta (field),y
  __b3:
    // keyboard_event_scan()
  // Scan the keyboard
    jsr keyboard_event_scan
    // keyboard_event_get()
    jsr keyboard_event_get
    // key_event = keyboard_event_get()
    // if(key_event==KEY_CRSR_DOWN)
    cmp #KEY_CRSR_DOWN
    bne __b4
    // *field & $7f
    lda #$7f
    ldy #0
    and (field),y
    // *field = *field & $7f
    // Unblink the cursor
    sta (field),y
    // keyboard_modifiers&KEY_MODIFIER_SHIFT
    txa
    and #KEY_MODIFIER_SHIFT
    // if((keyboard_modifiers&KEY_MODIFIER_SHIFT)==0)
    cmp #0
    beq __b13
    // if(--form_field_idx==$ff)
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
    // }
    rts
  __b13:
    // if(++form_field_idx==form_fields_cnt)
    inc.z form_field_idx
    lda #form_fields_cnt
    cmp.z form_field_idx
    bne __b14
    lda #0
    sta.z form_field_idx
    jmp __b14
  __b4:
    // if(key_event==KEY_CRSR_RIGHT)
    cmp #KEY_CRSR_RIGHT
    bne __b5
    // keyboard_modifiers&KEY_MODIFIER_SHIFT
    txa
    and #KEY_MODIFIER_SHIFT
    // if((keyboard_modifiers&KEY_MODIFIER_SHIFT)==0)
    cmp #0
    beq __b15
    // if(--form_fields_val[form_field_idx]==$ff)
    ldx.z form_field_idx
    dec form_fields_val,x
    lda #$ff
    ldy.z form_field_idx
    cmp form_fields_val,y
    bne __b16
    // form_fields_val[form_field_idx] = form_fields_max[form_field_idx]
    lda form_fields_max,y
    sta form_fields_val,y
  __b16:
    // *field = print_hextab[form_fields_val[form_field_idx]]
    // Render field value
    ldx.z form_field_idx
    ldy form_fields_val,x
    lda print_hextab,y
    ldy #0
    sta (field),y
  __b7:
    ldx #0
    rts
  __b15:
    // if(++form_fields_val[form_field_idx]>form_fields_max[form_field_idx])
    ldx.z form_field_idx
    inc form_fields_val,x
    ldy.z form_field_idx
    lda form_fields_max,y
    cmp form_fields_val,y
    bcs __b16
    // form_fields_val[form_field_idx] = 0
    lda #0
    sta form_fields_val,y
    jmp __b16
  __b5:
    // if(key_event==KEY_SPACE)
    cmp #KEY_SPACE
    bne __b7
    ldx #$ff
    rts
  __b2:
    // *field | $80
    lda #$80
    ldy #0
    ora (field),y
    // *field = *field | $80
    sta (field),y
    jmp __b3
}
// Set the screen to use for the form.
// screen is the start address of the screen to use
form_set_screen: {
    .label line = $10
    ldx #0
    lda #<FORM_SCREEN
    sta.z line
    lda #>FORM_SCREEN
    sta.z line+1
  __b1:
    // <line
    lda.z line
    // form_line_lo[y] = <line
    sta form_line_lo,x
    // >line
    lda.z line+1
    // form_line_hi[y] = >line
    sta form_line_hi,x
    // line = line + 40
    lda #$28
    clc
    adc.z line
    sta.z line
    bcc !+
    inc.z line+1
  !:
    // for(byte y: 0..24)
    inx
    cpx #$19
    bne __b1
    // }
    rts
}
// Print a number of zero-terminated strings, each followed by a newline.
// The sequence of lines is terminated by another zero.
// print_str_lines(byte* zp($10) str)
print_str_lines: {
    .label str = $10
    lda.z print_set_screen.screen
    sta.z print_char_cursor
    lda.z print_set_screen.screen+1
    sta.z print_char_cursor+1
  __b1:
    // while(*str)
    ldy #0
    lda (str),y
    cmp #0
    bne __b2
    // }
    rts
  __b2:
    // ch = *(str++)
    ldy #0
    lda (str),y
    inc.z str
    bne !+
    inc.z str+1
  !:
    // if(ch)
    cmp #0
    beq __b3
    // print_char(ch)
    jsr print_char
  __b3:
    // while (ch)
    cmp #0
    bne __b2
    // print_ln()
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
    // print_line_cursor + $28
    lda #$28
    clc
    adc.z print_line_cursor
    sta.z print_line_cursor
    bcc !+
    inc.z print_line_cursor+1
  !:
    // while (print_line_cursor<print_char_cursor)
    lda.z print_line_cursor+1
    cmp.z print_char_cursor+1
    bcc __b1
    bne !+
    lda.z print_line_cursor
    cmp.z print_char_cursor
    bcc __b1
  !:
    // }
    rts
}
// Print a single char
// print_char(byte register(A) ch)
print_char: {
    // *(print_char_cursor++) = ch
    ldy #0
    sta (print_char_cursor),y
    // *(print_char_cursor++) = ch;
    inc.z print_char_cursor
    bne !+
    inc.z print_char_cursor+1
  !:
    // }
    rts
}
// Clear the screen. Also resets current line/char cursor.
print_cls: {
    // memset(print_screen, ' ', 1000)
    lda.z print_set_screen.screen
    sta.z memset.str
    lda.z print_set_screen.screen+1
    sta.z memset.str+1
    jsr memset
    // }
    rts
}
// Copies the character c (an unsigned char) to the first num characters of the object pointed to by the argument str.
// memset(void* zp($10) str)
memset: {
    .const c = ' '
    .const num = $3e8
    .label end = $1f
    .label dst = $10
    .label str = $10
    // end = (char*)str + num
    lda.z str
    clc
    adc #<num
    sta.z end
    lda.z str+1
    adc #>num
    sta.z end+1
  __b2:
    // for(char* dst = str; dst!=end; dst++)
    lda.z dst+1
    cmp.z end+1
    bne __b3
    lda.z dst
    cmp.z end
    bne __b3
    // }
    rts
  __b3:
    // *dst = c
    lda #c
    ldy #0
    sta (dst),y
    // for(char* dst = str; dst!=end; dst++)
    inc.z dst
    bne !+
    inc.z dst+1
  !:
    jmp __b2
}
// Set the screen to print on. Also resets current line/char cursor.
// print_set_screen(byte* zp(7) screen)
print_set_screen: {
    .label screen = 7
    // }
    rts
}
// Initialize the different graphics in the memory
gfx_init: {
    // gfx_init_screen0()
    jsr gfx_init_screen0
    // gfx_init_screen1()
    jsr gfx_init_screen1
    // gfx_init_screen2()
    jsr gfx_init_screen2
    // gfx_init_screen3()
    jsr gfx_init_screen3
    // gfx_init_screen4()
    jsr gfx_init_screen4
    // gfx_init_charset()
    jsr gfx_init_charset
    // gfx_init_vic_bitmap()
    jsr gfx_init_vic_bitmap
    // gfx_init_plane_8bppchunky()
    jsr gfx_init_plane_8bppchunky
    // gfx_init_plane_charset8()
    jsr gfx_init_plane_charset8
    // gfx_init_plane_horisontal()
    jsr gfx_init_plane_horisontal
    // gfx_init_plane_vertical()
    jsr gfx_init_plane_vertical
    // gfx_init_plane_horisontal2()
    jsr gfx_init_plane_horisontal2
    // gfx_init_plane_vertical2()
    jsr gfx_init_plane_vertical2
    // gfx_init_plane_blank()
    jsr gfx_init_plane_blank
    // gfx_init_plane_full()
    jsr gfx_init_plane_full
    // }
    rts
}
// Initialize Plane with all pixels
gfx_init_plane_full: {
    // gfx_init_plane_fill(PLANE_FULL, $ff)
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
    // }
    rts
}
// Initialize 320*200 1bpp pixel ($2000) plane with identical bytes
// gfx_init_plane_fill(dword zp(9) plane_addr, byte zp($e) fill)
gfx_init_plane_fill: {
    .label __0 = $17
    .label __1 = $1b
    .label __4 = $10
    .label __5 = $10
    .label gfxb = $10
    .label by = $22
    .label plane_addr = 9
    .label fill = $e
    // plane_addr*4
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
    // >(plane_addr*4)
    lda.z __0+2
    sta.z __1
    lda.z __0+3
    sta.z __1+1
    // gfxbCpuBank = < >(plane_addr*4)
    lda.z __1
    // dtvSetCpuBankSegment1(gfxbCpuBank++)
    jsr dtvSetCpuBankSegment1
    // <plane_addr
    lda.z plane_addr
    sta.z __4
    lda.z plane_addr+1
    sta.z __4+1
    // <plane_addr & $3fff
    lda.z __5
    and #<$3fff
    sta.z __5
    lda.z __5+1
    and #>$3fff
    sta.z __5+1
    // $4000 + (<plane_addr & $3fff)
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
    // *gfxb++ = fill
    lda.z fill
    ldy #0
    sta (gfxb),y
    // *gfxb++ = fill;
    inc.z gfxb
    bne !+
    inc.z gfxb+1
  !:
    // for ( byte bx : 0..39)
    inx
    cpx #$28
    bne __b2
    // for(byte by : 0..199)
    inc.z by
    lda #$c8
    cmp.z by
    bne __b1
    // dtvSetCpuBankSegment1((byte)($4000/$4000))
  // Reset CPU BANK segment to $4000
    lda #$4000/$4000
    jsr dtvSetCpuBankSegment1
    // }
    rts
}
// Set the memory pointed to by CPU BANK 1 SEGMENT ($4000-$7fff)
// This sets which actual memory is addressed when the CPU reads/writes to $4000-$7fff
// The actual memory addressed will be $4000*cpuSegmentIdx
// dtvSetCpuBankSegment1(byte register(A) cpuBankIdx)
dtvSetCpuBankSegment1: {
    // Move CPU BANK 1 SEGMENT ($4000-$7fff)
    .label cpuBank = $ff
    // *cpuBank = cpuBankIdx
    sta cpuBank
    // asm
    .byte $32, $dd
    lda.z $ff
    .byte $32, $00
    // }
    rts
}
// Initialize Plane with blank pixels
gfx_init_plane_blank: {
    // gfx_init_plane_fill(PLANE_BLANK, 0)
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
    // }
    rts
}
// Initialize Plane with Vertical Stripes every 2 pixels
gfx_init_plane_vertical2: {
    // gfx_init_plane_fill(PLANE_VERTICAL2, %00011011)
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
    // }
    rts
}
// Initialize Plane with Horizontal Stripes every 2 pixels
gfx_init_plane_horisontal2: {
    .const gfxbCpuBank = PLANE_HORISONTAL2/$4000
    .label gfxa = $10
    .label ay = $f
    // dtvSetCpuBankSegment1(gfxbCpuBank++)
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
    // ay/2
    lda.z ay
    lsr
    // row = (ay/2) & 3
    and #3
    // *gfxa++ = row_bitmask[row]
    tay
    lda row_bitmask,y
    ldy #0
    sta (gfxa),y
    // *gfxa++ = row_bitmask[row];
    inc.z gfxa
    bne !+
    inc.z gfxa+1
  !:
    // for (byte ax : 0..39)
    inx
    cpx #$28
    bne __b2
    // for(byte ay : 0..199)
    inc.z ay
    lda #$c8
    cmp.z ay
    bne __b1
    // dtvSetCpuBankSegment1((byte)($4000/$4000))
  // Reset CPU BANK segment to $4000
    lda #$4000/$4000
    jsr dtvSetCpuBankSegment1
    // }
    rts
    row_bitmask: .byte 0, $55, $aa, $ff
}
// Initialize Plane with Vertical Stripes
gfx_init_plane_vertical: {
    .const gfxbCpuBank = PLANE_VERTICAL/$4000
    .label gfxb = $10
    .label by = $d
    // dtvSetCpuBankSegment1(gfxbCpuBank++)
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
    // *gfxb++ = %00001111
    lda #$f
    ldy #0
    sta (gfxb),y
    // *gfxb++ = %00001111;
    inc.z gfxb
    bne !+
    inc.z gfxb+1
  !:
    // for ( byte bx : 0..39)
    inx
    cpx #$28
    bne __b2
    // for(byte by : 0..199)
    inc.z by
    lda #$c8
    cmp.z by
    bne __b1
    // dtvSetCpuBankSegment1((byte)($4000/$4000))
  // Reset CPU BANK segment to $4000
    lda #$4000/$4000
    jsr dtvSetCpuBankSegment1
    // }
    rts
}
// Initialize Plane with Horizontal Stripes
gfx_init_plane_horisontal: {
    .const gfxbCpuBank = PLANE_HORISONTAL/$4000
    .label gfxa = $10
    .label ay = $d
    // dtvSetCpuBankSegment1(gfxbCpuBank++)
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
    // ay&4
    lda #4
    and.z ay
    // if((ay&4)==0)
    cmp #0
    beq __b3
    // *gfxa++ = %11111111
    lda #$ff
    ldy #0
    sta (gfxa),y
    // *gfxa++ = %11111111;
    inc.z gfxa
    bne !+
    inc.z gfxa+1
  !:
  __b4:
    // for (byte ax : 0..39)
    inx
    cpx #$28
    bne __b2
    // for(byte ay : 0..199)
    inc.z ay
    lda #$c8
    cmp.z ay
    bne __b1
    // dtvSetCpuBankSegment1((byte)($4000/$4000))
  // Reset CPU BANK segment to $4000
    lda #$4000/$4000
    jsr dtvSetCpuBankSegment1
    // }
    rts
  __b3:
    // *gfxa++ = %00000000
    lda #0
    tay
    sta (gfxa),y
    // *gfxa++ = %00000000;
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
    .label bits = $f
    .label chargen = $10
    .label gfxa = $14
    .label col = $12
    .label cr = $22
    .label ch = $e
    // dtvSetCpuBankSegment1(gfxbCpuBank++)
    lda #gfxbCpuBank
    jsr dtvSetCpuBankSegment1
    // *PROCPORT = PROCPORT_RAM_CHARROM
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
    // bits = *chargen++
    ldy #0
    lda (chargen),y
    sta.z bits
    inc.z chargen
    bne !+
    inc.z chargen+1
  !:
    ldx #0
  __b3:
    // bits & $80
    lda #$80
    and.z bits
    // if((bits & $80) != 0)
    cmp #0
    beq __b5
    lda.z col
    jmp __b4
  __b5:
    lda #0
  __b4:
    // *gfxa++ = c
    ldy #0
    sta (gfxa),y
    // *gfxa++ = c;
    inc.z gfxa
    bne !+
    inc.z gfxa+1
  !:
    // bits = bits*2
    asl.z bits
    // col++;
    inc.z col
    // for ( byte cp : 0..7)
    inx
    cpx #8
    bne __b3
    // for ( byte cr : 0..7)
    inc.z cr
    lda #8
    cmp.z cr
    bne __b2
    // for(byte ch : $00..$ff)
    inc.z ch
    lda.z ch
    cmp #0
    bne __b1
    // *PROCPORT = PROCPORT_RAM_IO
    lda #PROCPORT_RAM_IO
    sta PROCPORT
    // dtvSetCpuBankSegment1((byte)($4000/$4000))
  // Reset CPU BANK segment to $4000
    lda #$4000/$4000
    jsr dtvSetCpuBankSegment1
    // }
    rts
}
// Initialize 8BPP Chunky Bitmap (contains 8bpp pixels)
gfx_init_plane_8bppchunky: {
    .label __5 = $1d
    .label gfxb = $10
    .label x = $14
    .label y = $e
    // dtvSetCpuBankSegment1(gfxbCpuBank++)
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
    // if(gfxb==$8000)
    lda.z gfxb+1
    cmp #>$8000
    bne __b3
    lda.z gfxb
    cmp #<$8000
    bne __b3
    // dtvSetCpuBankSegment1(gfxbCpuBank++)
    txa
    jsr dtvSetCpuBankSegment1
    // dtvSetCpuBankSegment1(gfxbCpuBank++);
    inx
    lda #<$4000
    sta.z gfxb
    lda #>$4000
    sta.z gfxb+1
  __b3:
    // x+y
    lda.z y
    clc
    adc.z x
    sta.z __5
    lda #0
    adc.z x+1
    sta.z __5+1
    // c = (byte)(x+y)
    lda.z __5
    // *gfxb++ = c
    ldy #0
    sta (gfxb),y
    // *gfxb++ = c;
    inc.z gfxb
    bne !+
    inc.z gfxb+1
  !:
    // for (word x : 0..319)
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
    // for(byte y : 0..199)
    inc.z y
    lda #$c8
    cmp.z y
    bne __b1
    // dtvSetCpuBankSegment1((byte)($4000/$4000))
  // Reset CPU BANK segment to $4000
    lda #$4000/$4000
    jsr dtvSetCpuBankSegment1
    // }
    rts
}
// Initialize VIC bitmap
gfx_init_vic_bitmap: {
    .const lines_cnt = 9
    .label l = $22
    // bitmap_init(VIC_BITMAP)
  // Draw some lines on the bitmap
    jsr bitmap_init
    // bitmap_clear()
    jsr bitmap_clear
    lda #0
    sta.z l
  __b1:
    // for(byte l=0; l<lines_cnt;l++)
    lda.z l
    cmp #lines_cnt
    bcc __b2
    // }
    rts
  __b2:
    // bitmap_line(lines_x[l], lines_x[l+1], lines_y[l], lines_y[l+1])
    ldy.z l
    lda lines_x,y
    sta.z bitmap_line.x0
    lda lines_x+1,y
    sta.z bitmap_line.x1
    ldx lines_y,y
    lda lines_y+1,y
    sta.z bitmap_line.y1
    jsr bitmap_line
    // for(byte l=0; l<lines_cnt;l++)
    inc.z l
    jmp __b1
    lines_x: .byte 0, $ff, $ff, 0, 0, $80, $ff, $80, 0, $80
    lines_y: .byte 0, 0, $c7, $c7, 0, 0, $64, $c7, $64, 0
}
// Draw a line on the bitmap
// bitmap_line(byte zp($16) x0, byte zp($21) x1, byte register(X) y0, byte zp($13) y1)
bitmap_line: {
    .label xd = $12
    .label x0 = $16
    .label x1 = $21
    .label y1 = $13
    // if(x0<x1)
    lda.z x0
    cmp.z x1
    bcc __b1
    // xd = x0-x1
    sec
    sbc.z x1
    sta.z xd
    // if(y0<y1)
    cpx.z y1
    bcc __b7
    // yd = y0-y1
    txa
    sec
    sbc.z y1
    tay
    // if(yd<xd)
    cpy.z xd
    bcc __b8
    // bitmap_line_ydxi(y1, x1, y0, yd, xd)
    lda.z y1
    sta.z bitmap_line_ydxi.y
    stx.z bitmap_line_ydxi.y1
    sty.z bitmap_line_ydxi.yd
    jsr bitmap_line_ydxi
    // }
    rts
  __b8:
    // bitmap_line_xdyi(x1, y1, x0, xd, yd)
    lda.z x1
    sta.z bitmap_line_xdyi.x
    ldx.z y1
    sty.z bitmap_line_xdyi.yd
    jsr bitmap_line_xdyi
    rts
  __b7:
    // yd = y1-y0
    txa
    eor #$ff
    sec
    adc.z y1
    tay
    // if(yd<xd)
    cpy.z xd
    bcc __b9
    // bitmap_line_ydxd(y0, x0, y1, yd, xd)
    stx.z bitmap_line_ydxd.y
    sty.z bitmap_line_ydxd.yd
    jsr bitmap_line_ydxd
    rts
  __b9:
    // bitmap_line_xdyd(x1, y1, x0, xd, yd)
    lda.z x1
    sta.z bitmap_line_xdyd.x
    ldx.z y1
    sty.z bitmap_line_xdyd.yd
    jsr bitmap_line_xdyd
    rts
  __b1:
    // xd = x1-x0
    lda.z x1
    sec
    sbc.z x0
    sta.z xd
    // if(y0<y1)
    cpx.z y1
    bcc __b11
    // yd = y0-y1
    txa
    sec
    sbc.z y1
    tay
    // if(yd<xd)
    cpy.z xd
    bcc __b12
    // bitmap_line_ydxd(y1, x1, y0, yd, xd)
    lda.z y1
    sta.z bitmap_line_ydxd.y
    lda.z x1
    sta.z bitmap_line_ydxd.x
    stx.z bitmap_line_ydxd.y1
    sty.z bitmap_line_ydxd.yd
    jsr bitmap_line_ydxd
    rts
  __b12:
    // bitmap_line_xdyd(x0, y0, x1, xd, yd)
    lda.z x0
    sta.z bitmap_line_xdyd.x
    lda.z x1
    sta.z bitmap_line_xdyd.x1
    sty.z bitmap_line_xdyd.yd
    jsr bitmap_line_xdyd
    rts
  __b11:
    // yd = y1-y0
    txa
    eor #$ff
    sec
    adc.z y1
    tay
    // if(yd<xd)
    cpy.z xd
    bcc __b13
    // bitmap_line_ydxi(y0, x0, y1, yd, xd)
    stx.z bitmap_line_ydxi.y
    lda.z x0
    sta.z bitmap_line_ydxi.x
    sty.z bitmap_line_ydxi.yd
    jsr bitmap_line_ydxi
    rts
  __b13:
    // bitmap_line_xdyi(x0, y0, x1, xd, yd)
    lda.z x0
    sta.z bitmap_line_xdyi.x
    lda.z x1
    sta.z bitmap_line_xdyi.x1
    sty.z bitmap_line_xdyi.yd
    jsr bitmap_line_xdyi
    rts
}
// bitmap_line_xdyi(byte zp($d) x, byte register(X) y, byte zp($16) x1, byte zp($12) xd, byte zp($f) yd)
bitmap_line_xdyi: {
    .label x = $d
    .label x1 = $16
    .label xd = $12
    .label yd = $f
    .label e = $13
    // e = yd>>1
    lda.z yd
    lsr
    sta.z e
  __b1:
    // bitmap_plot(x,y)
    ldy.z x
    jsr bitmap_plot
    // x++;
    inc.z x
    // e = e+yd
    lda.z e
    clc
    adc.z yd
    sta.z e
    // if(xd<e)
    lda.z xd
    cmp.z e
    bcs __b2
    // y++;
    inx
    // e = e - xd
    lda.z e
    sec
    sbc.z xd
    sta.z e
  __b2:
    // x1+1
    lda.z x1
    clc
    adc #1
    // while (x!=(x1+1))
    cmp.z x
    bne __b1
    // }
    rts
}
// bitmap_plot(byte register(Y) x, byte register(X) y)
bitmap_plot: {
    .label plotter_x = $1d
    .label plotter_y = $1f
    .label plotter = $1d
    // plotter_x = { bitmap_plot_xhi[x], bitmap_plot_xlo[x] }
    lda bitmap_plot_xhi,y
    sta.z plotter_x+1
    lda bitmap_plot_xlo,y
    sta.z plotter_x
    // plotter_y = { bitmap_plot_yhi[y], bitmap_plot_ylo[y] }
    lda bitmap_plot_yhi,x
    sta.z plotter_y+1
    lda bitmap_plot_ylo,x
    sta.z plotter_y
    // plotter_x+plotter_y
    lda.z plotter
    clc
    adc.z plotter_y
    sta.z plotter
    lda.z plotter+1
    adc.z plotter_y+1
    sta.z plotter+1
    // *plotter | bitmap_plot_bit[x]
    lda bitmap_plot_bit,y
    ldy #0
    ora (plotter),y
    // *plotter = *plotter | bitmap_plot_bit[x]
    sta (plotter),y
    // }
    rts
}
// bitmap_line_ydxi(byte zp($e) y, byte zp($21) x, byte zp($13) y1, byte zp($d) yd, byte zp($12) xd)
bitmap_line_ydxi: {
    .label y = $e
    .label x = $21
    .label y1 = $13
    .label yd = $d
    .label xd = $12
    .label e = $f
    // e = xd>>1
    lda.z xd
    lsr
    sta.z e
  __b1:
    // bitmap_plot(x,y)
    ldy.z x
    ldx.z y
    jsr bitmap_plot
    // y++;
    inc.z y
    // e = e+xd
    lda.z e
    clc
    adc.z xd
    sta.z e
    // if(yd<e)
    lda.z yd
    cmp.z e
    bcs __b2
    // x++;
    inc.z x
    // e = e - yd
    lda.z e
    sec
    sbc.z yd
    sta.z e
  __b2:
    // y1+1
    ldx.z y1
    inx
    // while (y!=(y1+1))
    cpx.z y
    bne __b1
    // }
    rts
}
// bitmap_line_xdyd(byte zp($f) x, byte register(X) y, byte zp($16) x1, byte zp($12) xd, byte zp($e) yd)
bitmap_line_xdyd: {
    .label x = $f
    .label x1 = $16
    .label xd = $12
    .label yd = $e
    .label e = $d
    // e = yd>>1
    lda.z yd
    lsr
    sta.z e
  __b1:
    // bitmap_plot(x,y)
    ldy.z x
    jsr bitmap_plot
    // x++;
    inc.z x
    // e = e+yd
    lda.z e
    clc
    adc.z yd
    sta.z e
    // if(xd<e)
    lda.z xd
    cmp.z e
    bcs __b2
    // y--;
    dex
    // e = e - xd
    lda.z e
    sec
    sbc.z xd
    sta.z e
  __b2:
    // x1+1
    lda.z x1
    clc
    adc #1
    // while (x!=(x1+1))
    cmp.z x
    bne __b1
    // }
    rts
}
// bitmap_line_ydxd(byte zp($e) y, byte zp($16) x, byte zp($13) y1, byte zp($d) yd, byte zp($12) xd)
bitmap_line_ydxd: {
    .label y = $e
    .label x = $16
    .label y1 = $13
    .label yd = $d
    .label xd = $12
    .label e = $f
    // e = xd>>1
    lda.z xd
    lsr
    sta.z e
  __b1:
    // bitmap_plot(x,y)
    ldy.z x
    ldx.z y
    jsr bitmap_plot
    // y = y++;
    inc.z y
    // e = e+xd
    lda.z e
    clc
    adc.z xd
    sta.z e
    // if(yd<e)
    lda.z yd
    cmp.z e
    bcs __b2
    // x--;
    dec.z x
    // e = e - yd
    lda.z e
    sec
    sbc.z yd
    sta.z e
  __b2:
    // y1+1
    ldx.z y1
    inx
    // while (y!=(y1+1))
    cpx.z y
    bne __b1
    // }
    rts
}
// Clear all graphics on the bitmap
bitmap_clear: {
    .label bitmap = $10
    .label y = $16
    // bitmap = (char*) { bitmap_plot_xhi[0], bitmap_plot_xlo[0] }
    lda bitmap_plot_xlo
    sta.z bitmap
    lda bitmap_plot_xhi
    sta.z bitmap+1
    lda #0
    sta.z y
  __b1:
    ldx #0
  __b2:
    // *bitmap++ = 0
    lda #0
    tay
    sta (bitmap),y
    // *bitmap++ = 0;
    inc.z bitmap
    bne !+
    inc.z bitmap+1
  !:
    // for( char x: 0..199 )
    inx
    cpx #$c8
    bne __b2
    // for( char y: 0..39 )
    inc.z y
    lda #$28
    cmp.z y
    bne __b1
    // }
    rts
}
// Initialize the bitmap plotter tables for a specific bitmap
bitmap_init: {
    .label __10 = $21
    .label yoffs = $14
    ldy #$80
    ldx #0
  __b1:
    // x&$f8
    txa
    and #$f8
    // bitmap_plot_xlo[x] = x&$f8
    sta bitmap_plot_xlo,x
    // bitmap_plot_xhi[x] = >bitmap
    lda #>VIC_BITMAP
    sta bitmap_plot_xhi,x
    // bitmap_plot_bit[x] = bits
    tya
    sta bitmap_plot_bit,x
    // bits = bits>>1
    tya
    lsr
    tay
    // if(bits==0)
    cpy #0
    bne __b2
    ldy #$80
  __b2:
    // for(char x : 0..255)
    inx
    cpx #0
    bne __b1
    lda #<0
    sta.z yoffs
    sta.z yoffs+1
    tax
  __b3:
    // y&$7
    lda #7
    sax.z __10
    // <yoffs
    lda.z yoffs
    // y&$7 | <yoffs
    ora.z __10
    // bitmap_plot_ylo[y] = y&$7 | <yoffs
    sta bitmap_plot_ylo,x
    // >yoffs
    lda.z yoffs+1
    // bitmap_plot_yhi[y] = >yoffs
    sta bitmap_plot_yhi,x
    // if((y&$7)==7)
    lda #7
    cmp.z __10
    bne __b4
    // yoffs = yoffs + 40*8
    clc
    lda.z yoffs
    adc #<$28*8
    sta.z yoffs
    lda.z yoffs+1
    adc #>$28*8
    sta.z yoffs+1
  __b4:
    // for(char y : 0..255)
    inx
    cpx #0
    bne __b3
    // }
    rts
}
gfx_init_charset: {
    .label charset = $10
    .label chargen = $14
    .label c = $21
    // *PROCPORT = $32
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
    // *charset++ = *chargen++
    ldy #0
    lda (chargen),y
    sta (charset),y
    // *charset++ = *chargen++;
    inc.z charset
    bne !+
    inc.z charset+1
  !:
    inc.z chargen
    bne !+
    inc.z chargen+1
  !:
    // for( byte l: 0..7)
    inx
    cpx #8
    bne __b2
    // for(byte c: 0..$ff)
    inc.z c
    lda.z c
    cmp #0
    bne __b1
    // *PROCPORT = $37
    lda #$37
    sta PROCPORT
    // }
    rts
}
// Initialize VIC screen 4 - all chars are 00
gfx_init_screen4: {
    .label ch = $10
    .label cy = $e
    lda #0
    sta.z cy
    lda #<VIC_SCREEN4
    sta.z ch
    lda #>VIC_SCREEN4
    sta.z ch+1
  __b1:
    ldx #0
  __b2:
    // *ch++ = 0
    lda #0
    tay
    sta (ch),y
    // *ch++ = 0;
    inc.z ch
    bne !+
    inc.z ch+1
  !:
    // for(byte cx: 0..39)
    inx
    cpx #$28
    bne __b2
    // for(byte cy: 0..24 )
    inc.z cy
    lda #$19
    cmp.z cy
    bne __b1
    // }
    rts
}
// Initialize VIC screen 3 ( value is %00xx00yy where xx is xpos and yy is ypos
gfx_init_screen3: {
    .label __1 = $22
    .label ch = $10
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
    // cx&3
    txa
    and #3
    // (cx&3)*$10
    asl
    asl
    asl
    asl
    sta.z __1
    // cy&3
    lda #3
    and.z cy
    // (cx&3)*$10|(cy&3)
    ora.z __1
    // *ch++ = (cx&3)*$10|(cy&3)
    ldy #0
    sta (ch),y
    // *ch++ = (cx&3)*$10|(cy&3);
    inc.z ch
    bne !+
    inc.z ch+1
  !:
    // for(byte cx: 0..39)
    inx
    cpx #$28
    bne __b2
    // for(byte cy: 0..24 )
    inc.z cy
    lda #$19
    cmp.z cy
    bne __b1
    // }
    rts
}
// Initialize VIC screen 2 ( value is %ccccrrrr where cccc is (x+y mod $f) and rrrr is %1111-%cccc)
gfx_init_screen2: {
    .label col2 = $22
    .label ch = $10
    .label cy = $12
    lda #<VIC_SCREEN2
    sta.z ch
    lda #>VIC_SCREEN2
    sta.z ch+1
    lda #0
    sta.z cy
  __b1:
    ldx #0
  __b2:
    // cx+cy
    txa
    clc
    adc.z cy
    // col = (cx+cy)&$f
    and #$f
    tay
    // col2 = ($f-col)
    tya
    eor #$ff
    clc
    adc #$f+1
    sta.z col2
    // col*$10
    tya
    asl
    asl
    asl
    asl
    // col*$10 | col2
    ora.z col2
    // *ch++ = col*$10 | col2
    ldy #0
    sta (ch),y
    // *ch++ = col*$10 | col2;
    inc.z ch
    bne !+
    inc.z ch+1
  !:
    // for(byte cx: 0..39)
    inx
    cpx #$28
    bne __b2
    // for(byte cy: 0..24 )
    inc.z cy
    lda #$19
    cmp.z cy
    bne __b1
    // }
    rts
}
// Initialize VIC screen 1 ( value is %0000cccc where cccc is (x+y mod $f))
gfx_init_screen1: {
    .label ch = $14
    .label cy = $12
    lda #<VIC_SCREEN1
    sta.z ch
    lda #>VIC_SCREEN1
    sta.z ch+1
    lda #0
    sta.z cy
  __b1:
    ldx #0
  __b2:
    // cx+cy
    txa
    clc
    adc.z cy
    // (cx+cy)&$f
    and #$f
    // *ch++ = (cx+cy)&$f
    ldy #0
    sta (ch),y
    // *ch++ = (cx+cy)&$f;
    inc.z ch
    bne !+
    inc.z ch+1
  !:
    // for(byte cx: 0..39)
    inx
    cpx #$28
    bne __b2
    // for(byte cy: 0..24 )
    inc.z cy
    lda #$19
    cmp.z cy
    bne __b1
    // }
    rts
}
// Initialize VIC screen 0 ( value is %yyyyxxxx where yyyy is ypos and xxxx is xpos)
gfx_init_screen0: {
    .label __1 = $22
    .label ch = $14
    .label cy = $13
    lda #<VIC_SCREEN0
    sta.z ch
    lda #>VIC_SCREEN0
    sta.z ch+1
    lda #0
    sta.z cy
  __b1:
    ldx #0
  __b2:
    // cy&$f
    lda #$f
    and.z cy
    // (cy&$f)*$10
    asl
    asl
    asl
    asl
    sta.z __1
    // cx&$f
    txa
    and #$f
    // (cy&$f)*$10|(cx&$f)
    ora.z __1
    // *ch++ = (cy&$f)*$10|(cx&$f)
    ldy #0
    sta (ch),y
    // *ch++ = (cy&$f)*$10|(cx&$f);
    inc.z ch
    bne !+
    inc.z ch+1
  !:
    // for(byte cx: 0..39)
    inx
    cpx #$28
    bne __b2
    // for(byte cy: 0..24 )
    inc.z cy
    lda #$19
    cmp.z cy
    bne __b1
    // }
    rts
}
// Initialize keyboard reading by setting CIA#$ Data Direction Registers
keyboard_init: {
    // CIA1->PORT_A_DDR = $ff
    // Keyboard Matrix Columns Write Mode
    lda #$ff
    sta CIA1+OFFSET_STRUCT_MOS6526_CIA_PORT_A_DDR
    // CIA1->PORT_B_DDR = $00
    // Keyboard Matrix Columns Read Mode
    lda #0
    sta CIA1+OFFSET_STRUCT_MOS6526_CIA_PORT_B_DDR
    // }
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
