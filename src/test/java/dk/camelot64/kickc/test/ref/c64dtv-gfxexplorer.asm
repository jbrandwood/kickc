.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label RASTER = $d012
  .label BORDERCOL = $d020
  .label BGCOL = $d021
  .label VIC_CONTROL = $d011
  .const VIC_DEN = $10
  .const VIC_RSEL = 8
  .label VIC_CONTROL2 = $d016
  .const VIC_CSEL = 8
  .label VIC_MEMORY = $d018
  .label COLS = $d800
  .label CIA1_PORT_A = $dc00
  .label CIA1_PORT_B = $dc01
  .label CIA2_PORT_A = $dd00
  .label CIA2_PORT_A_DDR = $dd02
  .label DTV_FEATURE = $d03f
  .const DTV_FEATURE_ENABLE = 1
  .label DTV_CONTROL = $d03c
  .label DTV_PALETTE = $d200
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
  .const form_fields_cnt = $23
  .const FORM_CURSOR_BLINK = $28
  .const KEY_MODIFIER_SHIFT = KEY_MODIFIER_LSHIFT|KEY_MODIFIER_RSHIFT
  .label print_char_cursor = 9
  .label print_line_cursor = $b
  .label keyboard_events_size = 6
  .label keyboard_modifiers = 3
  .label form_cursor_count = 2
  .label form_field_idx = 4
  jsr main
main: {
    sei
    lda #DTV_FEATURE_ENABLE
    sta DTV_FEATURE
    lda #0
    sta form_field_idx
    sta keyboard_modifiers
    sta keyboard_events_size
    lda #FORM_CURSOR_BLINK/2
    sta form_cursor_count
  b2:
    jsr menu
    jmp b2
}
menu: {
    .label SCREEN = $8000
    .label CHARSET = $9800
    lda #($ffffffff&CHARSET)/$10000
    sta DTV_GRAPHICS_VIC_BANK
    lda #DTV_COLOR_BANK_DEFAULT/$400
    sta DTV_COLOR_BANK_LO
    lda #0
    sta DTV_COLOR_BANK_HI
    sta DTV_CONTROL
    lda #3
    sta CIA2_PORT_A_DDR
    lda #3^CHARSET/$4000
    sta CIA2_PORT_A
    lda #VIC_DEN|VIC_RSEL|3
    sta VIC_CONTROL
    lda #VIC_CSEL
    sta VIC_CONTROL2
    lda #(SCREEN&$3fff)/$40|(CHARSET&$3fff)/$400
    sta VIC_MEMORY
    ldx #0
  b1:
    lda DTV_PALETTE_DEFAULT,x
    sta DTV_PALETTE,x
    inx
    cpx #$10
    bne b1
    lda #0
    sta BGCOL
    sta BORDERCOL
    lda #<COLS
    sta print_set_screen.screen
    lda #>COLS
    sta print_set_screen.screen+1
    jsr print_set_screen
    jsr print_cls
    lda #<MENU_COLS
    sta print_str_lines.str
    lda #>MENU_COLS
    sta print_str_lines.str+1
    jsr print_str_lines
    lda #<SCREEN
    sta print_set_screen.screen
    lda #>SCREEN
    sta print_set_screen.screen+1
    jsr print_set_screen
    jsr print_cls
    lda #<MENU_TEXT
    sta print_str_lines.str
    lda #>MENU_TEXT
    sta print_str_lines.str+1
    jsr print_str_lines
    jsr form_set_screen
    jsr form_render_values
  b5:
    lda RASTER
    cmp #$ff
    bne b5
    jsr form_control
    jmp b5
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
    lda #KEY_MODIFIER_SHIFT
    and keyboard_modifiers
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
    lda #KEY_MODIFIER_SHIFT
    and keyboard_modifiers
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
    .label row_scan = $d
    .label keycode = 5
    .label row = 3
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
    lda #0|KEY_MODIFIER_LSHIFT
    sta keyboard_modifiers
    jmp b9
  b5:
    lda #0
    sta keyboard_modifiers
  b9:
    lda #KEY_RSHIFT
    sta keyboard_event_pressed.keycode
    jsr keyboard_event_pressed
    cmp #0
    beq b10
    lda #KEY_MODIFIER_RSHIFT
    ora keyboard_modifiers
    sta keyboard_modifiers
  b10:
    lda #KEY_CTRL
    sta keyboard_event_pressed.keycode
    jsr keyboard_event_pressed
    cmp #0
    beq b11
    lda #KEY_MODIFIER_CTRL
    ora keyboard_modifiers
    sta keyboard_modifiers
  b11:
    lda #KEY_COMMODORE
    sta keyboard_event_pressed.keycode
    jsr keyboard_event_pressed
    cmp #0
    beq breturn
    lda #KEY_MODIFIER_COMMODORE
    ora keyboard_modifiers
    sta keyboard_modifiers
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
    .label keycode = 5
    lda keycode
    lsr
    lsr
    lsr
    tax
    ldy keyboard_scan_values,x
    lda #7
    and keycode
    tax
    tya
    and keyboard_matrix_col_bitmask,x
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
    .label line = 7
    ldx #0
    lda #<menu.SCREEN
    sta line
    lda #>menu.SCREEN
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
print_cls: {
    .label _0 = 9
    .label sc = 7
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
print_set_screen: {
    .label screen = $b
    rts
}
  DTV_PALETTE_DEFAULT: .byte 0, $f, $36, $be, $58, $db, $86, $ff, $29, $26, $3b, 5, 7, $df, $9a, $a
  print_hextab: .text "0123456789abcdef"
  keyboard_matrix_row_bitmask: .byte $fe, $fd, $fb, $f7, $ef, $df, $bf, $7f
  keyboard_matrix_col_bitmask: .byte 1, 2, 4, 8, $10, $20, $40, $80
  keyboard_events: .fill 8, 0
  keyboard_scan_values: .fill 8, 0
  form_line_lo: .fill $19, 0
  form_line_hi: .fill $19, 0
  form_fields_x: .byte $16, 7, 7, 7, 7, 7, 7, 7, $11, $11, $11, $10, $11, $10, $11, $10, $11, $1b, $1a, $1b, $1a, $1b, $1a, $1b, $26, $26, $26, $25, $26, $25, $26, $25, $26, $25, $26
  form_fields_y: .byte 0, 2, 3, 4, 5, 6, 7, 8, 7, 8, 2, 3, 3, 4, 4, 5, 5, 2, 3, 3, 4, 4, 5, 5, 2, 3, 4, 5, 5, 6, 6, 7, 7, 8, 8
  form_fields_max: .byte $d, 1, 1, 1, 1, 1, 2, 1, 1, 1, $f, $f, $f, $f, $f, $f, $f, $f, $f, $f, $f, $f, $f, $f, $f, $f, $f, $f, $f, $f, $f, $f, $f, $f, $f
  form_fields_val: .byte 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
  MENU_COLS: .text "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa@"+" nnnnnnn  mmmmmmmm  mmmmmmmm  ooooooooo @"+" nnnnnnn  mmmmmmmm  mmmmmmmm  ooooooooo @"+" nnnnnnn  mmmmmmmm  mmmmmmmm  ooooooooo @"+" nnnnnnn  mmmmmmmm  mmmmmmmm  ooooooooo @"+" nnnnnnn  mmmmmmmm  mmmmmmmm  ooooooooo @"+" nnnnnnn                      ooooooooo @"+" nnnnnnn  nnnnnnnn            ooooooooo @"+" nnnnnnn  nnnnnnnn            ooooooooo @"+"@"
  MENU_TEXT: .text " DTV GfxExplorer MODE 0 8bpp pixel cell @"+" CONTROL  PLANE  A  PLANE  B  VIC II    @"+" bmm   0  patt  p0  patt  p0  screen s0 @"+" mcm   0  start 00  start 00  gfx    g0 @"+" ecm   0  step  00  step  00  colors c0 @"+" hicol 0  mod   00  mod   00  bgcol0 00 @"+" line  0                      bgcol1 00 @"+" colof 0  borof  0            bgcol2 00 @"+" chunk 0  overs  0            bgcol3 00 @"+"@"
