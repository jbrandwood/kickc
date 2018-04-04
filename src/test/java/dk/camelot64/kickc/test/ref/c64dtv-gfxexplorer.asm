.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
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
  .label COLS = $d800
  .label CIA1_PORT_A = $dc00
  .label CIA1_PORT_B = $dc01
  .label CIA1_PORT_A_DDR = $dc02
  .label CIA1_PORT_B_DDR = $dc03
  .label CIA2_PORT_A = $dd00
  .label CIA2_PORT_A_DDR = $dd02
  .label DTV_FEATURE = $d03f
  .const DTV_FEATURE_ENABLE = 1
  .label DTV_CONTROL = $d03c
  .const DTV_LINEAR = 1
  .const DTV_BORDER_OFF = 2
  .const DTV_HIGHCOLOR = 4
  .const DTV_OVERSCAN = 8
  .const DTV_COLORRAM_OFF = $10
  .const DTV_CHUNKY = $40
  .label DTV_PALETTE = $d200
  .label DTV_PLANEA_START_LO = $d03a
  .label DTV_PLANEA_START_MI = $d03b
  .label DTV_PLANEA_START_HI = $d045
  .label DTV_PLANEA_STEP = $d046
  .label DTV_PLANEA_MODULO_LO = $d038
  .label DTV_PLANEA_MODULO_HI = $d039
  .label DTV_PLANEB_START_LO = $d049
  .label DTV_PLANEB_START_MI = $d04a
  .label DTV_PLANEB_START_HI = $d04b
  .label DTV_PLANEB_STEP = $d04c
  .label DTV_PLANEB_MODULO_LO = $d047
  .label DTV_PLANEB_MODULO_HI = $d048
  .label DTV_COLOR_BANK_LO = $d036
  .label DTV_COLOR_BANK_HI = $d037
  .const DTV_COLOR_BANK_DEFAULT = $1d800
  .label DTV_GRAPHICS_VIC_BANK = $d03d
  .const KEY_CRSR_RIGHT = 2
  .const KEY_CRSR_DOWN = 7
  .const KEY_LSHIFT = $f
  .const KEY_RSHIFT = $34
  .const KEY_CTRL = $3a
  .const KEY_COMMODORE = $3d
  .const KEY_MODIFIER_LSHIFT = 1
  .const KEY_MODIFIER_RSHIFT = 2
  .const KEY_MODIFIER_CTRL = 4
  .const KEY_MODIFIER_COMMODORE = 8
  .const PLANE_8BPP_CHUNKY = $20000
  .label FORM_SCREEN = $8000
  .label FORM_CHARSET = $9800
  .const FORM_OFFSET = $10*$28
  .const form_fields_cnt = $23
  .const FORM_CURSOR_BLINK = $28
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
  .label form_a_start_hi = form_fields_val+$b
  .label form_a_start_lo = form_fields_val+$c
  .label form_a_step_hi = form_fields_val+$d
  .label form_a_step_lo = form_fields_val+$e
  .label form_a_mod_hi = form_fields_val+$f
  .label form_a_mod_lo = form_fields_val+$10
  .label form_b_start_hi = form_fields_val+$12
  .label form_b_start_lo = form_fields_val+$13
  .label form_b_step_hi = form_fields_val+$14
  .label form_b_step_lo = form_fields_val+$15
  .label form_b_mod_hi = form_fields_val+$16
  .label form_b_mod_lo = form_fields_val+$17
  .label form_vic_bg0_hi = form_fields_val+$1b
  .label form_vic_bg0_lo = form_fields_val+$1c
  .label form_vic_bg1_hi = form_fields_val+$1d
  .label form_vic_bg1_lo = form_fields_val+$1e
  .label form_vic_bg2_hi = form_fields_val+$1f
  .label form_vic_bg2_lo = form_fields_val+$20
  .label form_vic_bg3_hi = form_fields_val+$21
  .label form_vic_bg3_lo = form_fields_val+$22
  .label print_char_cursor = 9
  .label keyboard_events_size = 6
  .label form_cursor_count = 2
  .label form_field_idx = 3
  .label print_line_cursor = $b
  jsr main
main: {
    sei
    lda #DTV_FEATURE_ENABLE
    sta DTV_FEATURE
    jsr keyboard_init
    jsr gfx_init
    jsr form_init
    lda #0
    sta form_field_idx
    sta keyboard_events_size
    lda #FORM_CURSOR_BLINK/2
    sta form_cursor_count
  b4:
    lda RASTER
    cmp #$30+8*$10
    bne b4
    jsr form_mode
  b7:
    lda RASTER
    cmp #$ff
    bne b7
    jsr form_control
    jsr gfx_mode
    jmp b4
}
gfx_mode: {
    .label _33 = 7
    .label _35 = 7
    .label _37 = 7
    .label _46 = 7
    .label _48 = 7
    .label _50 = 7
    .label plane_a = $d
    .label plane_b = $d
    lda form_ctrl_line
    cmp #0
    beq b11
    ldx #0|DTV_LINEAR
    jmp b1
  b11:
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
    beq b12
    ldx #VIC_DEN|VIC_RSEL|3|VIC_ECM
    jmp b7
  b12:
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
    beq b13
    lda #VIC_CSEL|VIC_MCM
    jmp b9
  b13:
    lda #VIC_CSEL
  b9:
    sta VIC_CONTROL2
    lda form_a_start_hi
    asl
    asl
    asl
    asl
    ora form_a_start_lo
    clc
    adc #<$ffffffff&FORM_SCREEN
    sta plane_a
    lda #0
    adc #>$ffffffff&FORM_SCREEN
    sta plane_a+1
    lda #0
    adc #0
    sta plane_a+2
    lda #0
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
    clc
    adc #<PLANE_8BPP_CHUNKY
    sta plane_b
    lda #>PLANE_8BPP_CHUNKY
    adc #0
    sta plane_b+1
    lda #<PLANE_8BPP_CHUNKY>>$10
    adc #0
    sta plane_b+2
    lda #>PLANE_8BPP_CHUNKY>>$10
    adc #0
    sta plane_b+3
    lda plane_b
    sta _46
    lda plane_b+1
    sta _46+1
    lda _46
    sta DTV_PLANEB_START_LO
    lda plane_b
    sta _48
    lda plane_b+1
    sta _48+1
    sta DTV_PLANEB_START_MI
    lda plane_b+2
    sta _50
    lda plane_b+3
    sta _50+1
    lda _50
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
    ldx #0
  b10:
    txa
    sta DTV_PALETTE,x
    inx
    cpx #$10
    bne b10
    rts
}
form_control: {
    .label field = 7
    ldx form_field_idx
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
    bmi !b2+
    jmp b2
  !b2:
    lda #$80
    ldy #0
    ora (field),y
    sta (field),y
  b3:
    jsr keyboard_event_scan
    jsr keyboard_event_get
    cmp #KEY_CRSR_DOWN
    bne b4
    lda #$7f
    ldy #0
    and (field),y
    sta (field),y
    txa
    and #KEY_MODIFIER_SHIFT
    cmp #0
    bne b5
    inc form_field_idx
    lda form_field_idx
    cmp #form_fields_cnt
    bne b7
    tya
    sta form_field_idx
  b7:
    lda #FORM_CURSOR_BLINK/2
    sta form_cursor_count
  breturn:
    rts
  b5:
    dec form_field_idx
    lda form_field_idx
    cmp #$ff
    bne b7
    lda #form_fields_cnt-1
    sta form_field_idx
    jmp b7
  b4:
    cmp #KEY_CRSR_RIGHT
    bne breturn
    txa
    and #KEY_MODIFIER_SHIFT
    cmp #0
    bne b10
    ldx form_field_idx
    inc form_fields_val,x
    ldy form_field_idx
    lda form_fields_val,y
    cmp form_fields_max,y
    bcc b12
    beq b12
    lda #0
    sta form_fields_val,y
  b12:
    ldy form_field_idx
    lda form_fields_val,y
    tay
    lda print_hextab,y
    ldy #0
    sta (field),y
    jmp breturn
  b10:
    ldx form_field_idx
    lda form_fields_val,x
    sec
    sbc #1
    sta form_fields_val,x
    ldy form_field_idx
    lda form_fields_val,y
    cmp #$ff
    bne b12
    lda form_fields_max,y
    sta form_fields_val,y
    jmp b12
  b2:
    lda #$7f
    ldy #0
    and (field),y
    sta (field),y
    jmp b3
}
keyboard_event_get: {
    lda keyboard_events_size
    bne b1
    lda #$ff
  breturn:
    rts
  b1:
    dec keyboard_events_size
    ldy keyboard_events_size
    lda keyboard_events,y
    jmp breturn
}
keyboard_event_scan: {
    .label row_scan = $11
    .label keycode = 5
    .label row = 4
    lda #0
    sta keycode
    sta row
  b1:
    ldx row
    jsr keyboard_matrix_read
    sta row_scan
    ldy row
    lda keyboard_scan_values,y
    cmp row_scan
    bne !b2+
    jmp b2
  !b2:
    ldx #0
  b3:
    lda row_scan
    ldy row
    eor keyboard_scan_values,y
    and keyboard_matrix_col_bitmask,x
    cmp #0
    beq b4
    lda keyboard_events_size
    cmp #8
    beq b4
    lda keyboard_matrix_col_bitmask,x
    and row_scan
    cmp #0
    bne b6
    lda #$40
    ora keycode
    ldy keyboard_events_size
    sta keyboard_events,y
    inc keyboard_events_size
  b4:
    inc keycode
    inx
    cpx #8
    bne b3
    lda row_scan
    ldy row
    sta keyboard_scan_values,y
  b8:
    inc row
    lda row
    cmp #8
    bne b1
    lda #KEY_LSHIFT
    sta keyboard_event_pressed.keycode
    jsr keyboard_event_pressed
    cmp #0
    beq b5
    ldx #0|KEY_MODIFIER_LSHIFT
    jmp b9
  b5:
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
  b6:
    lda keycode
    ldy keyboard_events_size
    sta keyboard_events,y
    inc keyboard_events_size
    jmp b4
  b2:
    lda #8
    clc
    adc keycode
    sta keycode
    jmp b8
}
keyboard_event_pressed: {
    .label row_bits = 5
    .label keycode = 4
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
keyboard_matrix_read: {
    lda keyboard_matrix_row_bitmask,x
    sta CIA1_PORT_A
    lda CIA1_PORT_B
    eor #$ff
    rts
}
form_field_ptr: {
    .label return = 7
    .label _2 = 7
    ldy form_fields_y,x
    lda form_line_hi,y
    sta _2+1
    lda form_line_lo,y
    sta _2
    lda form_fields_x,x
    clc
    adc return
    sta return
    lda #0
    adc return+1
    sta return+1
    rts
}
form_mode: {
    lda #($ffffffff&FORM_CHARSET)/$10000
    sta DTV_GRAPHICS_VIC_BANK
    lda #DTV_COLOR_BANK_DEFAULT/$400
    sta DTV_COLOR_BANK_LO
    lda #0
    sta DTV_COLOR_BANK_HI
    lda #3
    sta CIA2_PORT_A_DDR
    lda #3^FORM_CHARSET/$4000
    sta CIA2_PORT_A
    lda #0
    sta DTV_CONTROL
    lda #VIC_DEN|VIC_RSEL|3
    sta VIC_CONTROL
    lda #VIC_CSEL
    sta VIC_CONTROL2
    lda #(FORM_SCREEN&$3fff)/$40|(FORM_CHARSET&$3fff)/$400
    sta VIC_MEMORY
    ldx #0
  b1:
    lda DTV_PALETTE_DEFAULT,x
    sta DTV_PALETTE,x
    inx
    cpx #$10
    bne b1
    lda #0
    sta BORDERCOL
    sta BGCOL
    rts
}
form_init: {
    lda #<COLS+FORM_OFFSET
    sta print_set_screen.screen
    lda #>COLS+FORM_OFFSET
    sta print_set_screen.screen+1
    jsr print_set_screen
    lda #<FORM_COLS
    sta print_str_lines.str
    lda #>FORM_COLS
    sta print_str_lines.str+1
    jsr print_str_lines
    lda #<FORM_SCREEN+FORM_OFFSET
    sta print_set_screen.screen
    lda #>FORM_SCREEN+FORM_OFFSET
    sta print_set_screen.screen+1
    jsr print_set_screen
    lda #<FORM_TEXT
    sta print_str_lines.str
    lda #>FORM_TEXT
    sta print_str_lines.str+1
    jsr print_str_lines
    jsr form_set_screen
    jsr form_render_values
    rts
}
form_render_values: {
    .label field = 7
    ldx #0
  b1:
    jsr form_field_ptr
    lda form_fields_val,x
    tay
    lda print_hextab,y
    ldy #0
    sta (field),y
    inx
    cpx #form_fields_cnt
    bcc b1
    rts
}
form_set_screen: {
    .label screen = FORM_SCREEN+FORM_OFFSET
    .label line = 7
    ldx #0
    lda #<screen
    sta line
    lda #>screen
    sta line+1
  b1:
    lda line
    sta form_line_lo,x
    lda line+1
    sta form_line_hi,x
    lda line
    clc
    adc #$28
    sta line
    bcc !+
    inc line+1
  !:
    inx
    cpx #$19
    bne b1
    rts
}
print_str_lines: {
    .label str = 7
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
print_ln: {
  b1:
    lda print_line_cursor
    clc
    adc #$28
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
print_set_screen: {
    .label screen = $b
    rts
}
gfx_init: {
    jsr gfx_init_plane_8bppchunky
    rts
}
gfx_init_plane_8bppchunky: {
    .label _6 = $b
    .label gfxb = 9
    .label x = 7
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
    lda #<0
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
dtvSetCpuBankSegment1: {
    .label cpuBank = $ff
    sta cpuBank
    .byte $32, $dd
    lda $ff
    .byte $32, $00
    rts
}
keyboard_init: {
    lda #$ff
    sta CIA1_PORT_A_DDR
    lda #0
    sta CIA1_PORT_B_DDR
    rts
}
  DTV_PALETTE_DEFAULT: .byte 0, $f, $36, $be, $58, $db, $86, $ff, $29, $26, $3b, 5, 7, $df, $9a, $a
  print_hextab: .text "0123456789abcdef"
  keyboard_matrix_row_bitmask: .byte $fe, $fd, $fb, $f7, $ef, $df, $bf, $7f
  keyboard_matrix_col_bitmask: .byte 1, 2, 4, 8, $10, $20, $40, $80
  keyboard_events: .fill 8, 0
  keyboard_scan_values: .fill 8, 0
  form_fields_x: .byte $16, 7, 7, 7, 7, 7, 7, 7, $11, $11, $11, $10, $11, $10, $11, $10, $11, $1b, $1a, $1b, $1a, $1b, $1a, $1b, $26, $26, $26, $25, $26, $25, $26, $25, $26, $25, $26
  form_fields_y: .byte 0, 2, 3, 4, 5, 6, 7, 8, 7, 8, 2, 3, 3, 4, 4, 5, 5, 2, 3, 3, 4, 4, 5, 5, 2, 3, 4, 5, 5, 6, 6, 7, 7, 8, 8
  form_fields_max: .byte $d, 1, 1, 1, 1, 1, 1, 1, 1, 1, $f, $f, $f, $f, $f, $f, $f, $f, $f, $f, $f, $f, $f, $f, $f, $f, $f, $f, $f, $f, $f, $f, $f, $f, $f
  form_fields_val: .byte 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
  form_line_lo: .fill $19, 0
  form_line_hi: .fill $19, 0
  FORM_COLS: .text "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa@"+" nnnnnnn  mmmmmmmm  mmmmmmmm  ooooooooo @"+" nnnnnnn  mmmmmmmm  mmmmmmmm  ooooooooo @"+" nnnnnnn  mmmmmmmm  mmmmmmmm  ooooooooo @"+" nnnnnnn  mmmmmmmm  mmmmmmmm  ooooooooo @"+" nnnnnnn  mmmmmmmm  mmmmmmmm  ooooooooo @"+" nnnnnnn                      ooooooooo @"+" nnnnnnn  nnnnnnnn            ooooooooo @"+" nnnnnnn  nnnnnnnn            ooooooooo @"+"@"
  FORM_TEXT: .text " DTV GfxExplorer MODE 0 8bpp pixel cell @"+" CONTROL  PLANE  A  PLANE  B  VIC II    @"+" bmm   0  patt  p0  patt  p0  screen s0 @"+" mcm   0  start 00  start 00  gfx    g0 @"+" ecm   0  step  00  step  00  colors c0 @"+" hicol 0  mod   00  mod   00  bgcol0 00 @"+" line  0                      bgcol1 00 @"+" colof 0  borof  0            bgcol2 00 @"+" chunk 0  overs  0            bgcol3 00 @"+"@"
