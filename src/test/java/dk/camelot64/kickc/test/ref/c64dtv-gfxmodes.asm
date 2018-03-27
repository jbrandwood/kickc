.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label PROCPORT = 1
  .label BORDERCOL = $d020
  .label BGCOL = $d021
  .label BGCOL1 = $d021
  .label BGCOL2 = $d022
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
  .label CIA2_PORT_A = $dd00
  .label CIA2_PORT_A_DDR = $dd02
  .const LIGHT_GREEN = $d
  .label DTV_FEATURE = $d03f
  .const DTV_FEATURE_ENABLE = 1
  .label DTV_CONTROL = $d03c
  .const DTV_CONTROL_LINEAR_ADDRESSING_ON = 1
  .const DTV_CONTROL_HIGHCOLOR_ON = 4
  .const DTV_CONTROL_CHUNKY_ON = $40
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
  .label DTV_GRAPHICS_VIC_BANK = $d03d
  .const KEY_D = $12
  .const KEY_C = $14
  .const KEY_B = $1c
  .const KEY_SPACE = $3c
  .label MENU_SCREEN = $8000
  .label MENU_CHARSET = $9800
  .const DTV_COLOR_BANK_DEFAULT = $1d800
  .label TWOPLANE_PLANEA = $4000
  .label TWOPLANE_PLANEB = $6000
  .label TWOPLANE_COLORS = $8000
  .label SIXSFRED_PLANEA = $4000
  .label SIXSFRED_PLANEB = $6000
  .label SIXSFRED_COLORS = $8000
  .label PIXELCELL8BPP_PLANEA = $3c00
  .label PIXELCELL8BPP_PLANEB = $4000
  .label print_char_cursor = 7
  .label print_line_cursor = $a
  jsr main
main: {
    sei
    lda #DTV_FEATURE_ENABLE
    sta DTV_FEATURE
  b2:
    jsr menu
    jmp b2
}
menu: {
    .label c = 2
    lda #($ffffffff&MENU_CHARSET)/$10000
    sta DTV_GRAPHICS_VIC_BANK
    lda #DTV_COLOR_BANK_DEFAULT/$400
    sta DTV_COLOR_BANK_LO
    lda #0
    sta DTV_COLOR_BANK_HI
    sta DTV_CONTROL
    lda #3
    sta CIA2_PORT_A_DDR
    lda #3^MENU_CHARSET/$4000
    sta CIA2_PORT_A
    lda #VIC_DEN|VIC_RSEL|3
    sta VIC_CONTROL
    lda #VIC_CSEL
    sta VIC_CONTROL2
    lda #(MENU_SCREEN&$3fff)/$40|(MENU_CHARSET&$3fff)/$400
    sta VIC_MEMORY
    ldx #0
  b1:
    lda DTV_PALETTE_DEFAULT,x
    sta DTV_PALETTE,x
    inx
    cpx #$10
    bne b1
    lda #<COLS
    sta c
    lda #>COLS
    sta c+1
  b2:
    lda #LIGHT_GREEN
    ldy #0
    sta (c),y
    inc c
    bne !+
    inc c+1
  !:
    lda c+1
    cmp #>COLS+$3e8
    bne b2
    lda c
    cmp #<COLS+$3e8
    bne b2
    lda #0
    sta BGCOL
    sta BORDERCOL
    jsr print_set_screen
    jsr print_cls
    jsr print_str_lines
    jmp b4
  breturn:
    rts
  b4:
    ldx #KEY_B
    jsr keyboard_key_pressed
    cmp #0
    beq b6
    jsr mode_twoplanebitmap
    jmp breturn
  b6:
    ldx #KEY_C
    jsr keyboard_key_pressed
    cmp #0
    beq b7
    jsr mode_sixsfred
    jmp breturn
  b7:
    ldx #KEY_D
    jsr keyboard_key_pressed
    cmp #0
    beq b4
    jsr mode_8bpppixelcell
    jmp breturn
}
mode_8bpppixelcell: {
    .label _12 = 5
    .label gfxa = 2
    .label ay = 4
    .label bits = 6
    .label chargen = 2
    .label gfxb = 7
    .label col = 9
    .label cr = 5
    .label ch = 4
    lda #DTV_CONTROL_HIGHCOLOR_ON|DTV_CONTROL_LINEAR_ADDRESSING_ON|DTV_CONTROL_CHUNKY_ON
    sta DTV_CONTROL
    lda #VIC_ECM|VIC_DEN|VIC_RSEL|3
    sta VIC_CONTROL
    lda #VIC_MCM|VIC_CSEL
    sta VIC_CONTROL2
    lda #<PIXELCELL8BPP_PLANEA
    sta DTV_PLANEA_START_LO
    lda #>PIXELCELL8BPP_PLANEA
    sta DTV_PLANEA_START_MI
    lda #0
    sta DTV_PLANEA_START_HI
    lda #1
    sta DTV_PLANEA_STEP
    lda #0
    sta DTV_PLANEA_MODULO_LO
    sta DTV_PLANEA_MODULO_HI
    lda #<PIXELCELL8BPP_PLANEB
    sta DTV_PLANEB_START_LO
    lda #>PIXELCELL8BPP_PLANEB
    sta DTV_PLANEB_START_MI
    lda #0
    sta DTV_PLANEB_START_HI
    sta DTV_PLANEB_STEP
    sta DTV_PLANEB_MODULO_LO
    sta DTV_PLANEB_MODULO_HI
    sta BORDERCOL
    tax
  b1:
    txa
    sta DTV_PALETTE,x
    inx
    cpx #$10
    bne b1
    lda #<PIXELCELL8BPP_PLANEA
    sta gfxa
    lda #>PIXELCELL8BPP_PLANEA
    sta gfxa+1
    lda #0
    sta ay
  b2:
    ldx #0
  b3:
    lda #$f
    and ay
    asl
    asl
    asl
    asl
    sta _12
    txa
    and #$f
    ora _12
    ldy #0
    sta (gfxa),y
    inc gfxa
    bne !+
    inc gfxa+1
  !:
    inx
    cpx #$28
    bne b3
    inc ay
    lda ay
    cmp #$19
    bne b2
    lda #$32
    sta PROCPORT
    lda #0
    sta ch
    sta col
    lda #<PIXELCELL8BPP_PLANEB
    sta gfxb
    lda #>PIXELCELL8BPP_PLANEB
    sta gfxb+1
    lda #<$d000
    sta chargen
    lda #>$d000
    sta chargen+1
  b4:
    lda #0
    sta cr
  b5:
    ldy #0
    lda (chargen),y
    sta bits
    inc chargen
    bne !+
    inc chargen+1
  !:
    ldx #0
  b6:
    lda #$80
    and bits
    cmp #0
    beq b10
    lda col
    jmp b7
  b10:
    lda #0
  b7:
    ldy #0
    sta (gfxb),y
    inc gfxb
    bne !+
    inc gfxb+1
  !:
    asl bits
    inc col
    inx
    cpx #8
    bne b6
    inc cr
    lda cr
    cmp #8
    bne b5
    inc ch
    lda ch
    bne b4
    lda #$37
    sta PROCPORT
    jmp b9
  breturn:
    rts
  b9:
    ldx #KEY_SPACE
    jsr keyboard_key_pressed
    cmp #0
    beq b9
    jmp breturn
}
keyboard_key_pressed: {
    txa
    and #7
    tay
    txa
    lsr
    lsr
    lsr
    tax
    jsr keyboard_matrix_read
    and keyboard_matrix_col_bitmask,y
    rts
}
keyboard_matrix_read: {
    lda keyboard_matrix_row_bitmask,x
    sta CIA1_PORT_A
    lda CIA1_PORT_B
    eor #$ff
    rts
}
mode_sixsfred: {
    .label col = 2
    .label cy = 4
    .label gfxa = 2
    .label ay = 4
    .label gfxb = 2
    .label by = 4
    lda #DTV_CONTROL_HIGHCOLOR_ON|DTV_CONTROL_LINEAR_ADDRESSING_ON
    sta DTV_CONTROL
    lda #VIC_ECM|VIC_BMM|VIC_DEN|VIC_RSEL|3
    sta VIC_CONTROL
    lda #VIC_MCM|VIC_CSEL
    sta VIC_CONTROL2
    lda #<SIXSFRED_PLANEA
    sta DTV_PLANEA_START_LO
    lda #>SIXSFRED_PLANEA
    sta DTV_PLANEA_START_MI
    lda #0
    sta DTV_PLANEA_START_HI
    lda #1
    sta DTV_PLANEA_STEP
    lda #0
    sta DTV_PLANEA_MODULO_LO
    sta DTV_PLANEA_MODULO_HI
    lda #<SIXSFRED_PLANEB
    sta DTV_PLANEB_START_LO
    lda #>SIXSFRED_PLANEB
    sta DTV_PLANEB_START_MI
    lda #0
    sta DTV_PLANEB_START_HI
    lda #1
    sta DTV_PLANEB_STEP
    lda #0
    sta DTV_PLANEB_MODULO_LO
    sta DTV_PLANEB_MODULO_HI
    lda #<SIXSFRED_COLORS/$400
    sta DTV_COLOR_BANK_LO
    lda #>SIXSFRED_COLORS/$400
    sta DTV_COLOR_BANK_HI
    ldx #0
  b1:
    txa
    sta DTV_PALETTE,x
    inx
    cpx #$10
    bne b1
    lda #0
    sta BORDERCOL
    lda #<TWOPLANE_COLORS
    sta col
    lda #>TWOPLANE_COLORS
    sta col+1
    lda #0
    sta cy
  b2:
    ldx #0
  b3:
    txa
    clc
    adc cy
    and #$f
    ldy #0
    sta (col),y
    inc col
    bne !+
    inc col+1
  !:
    inx
    cpx #$28
    bne b3
    inc cy
    lda cy
    cmp #$19
    bne b2
    lda #<SIXSFRED_PLANEA
    sta gfxa
    lda #>SIXSFRED_PLANEA
    sta gfxa+1
    lda #0
    sta ay
  b4:
    ldx #0
  b5:
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
    bne b5
    inc ay
    lda ay
    cmp #$c8
    bne b4
    lda #0
    sta by
    lda #<SIXSFRED_PLANEB
    sta gfxb
    lda #>SIXSFRED_PLANEB
    sta gfxb+1
  b6:
    ldx #0
  b7:
    lda #$1b
    ldy #0
    sta (gfxb),y
    inc gfxb
    bne !+
    inc gfxb+1
  !:
    inx
    cpx #$28
    bne b7
    inc by
    lda by
    cmp #$c8
    bne b6
    jmp b9
  breturn:
    rts
  b9:
    ldx #KEY_SPACE
    jsr keyboard_key_pressed
    cmp #0
    beq b9
    jmp breturn
    row_bitmask: .byte 0, $55, $aa, $ff
}
mode_twoplanebitmap: {
    .label _15 = 5
    .label col = 2
    .label cy = 4
    .label gfxa = 2
    .label ay = 4
    .label gfxb = 2
    .label by = 4
    lda #DTV_CONTROL_HIGHCOLOR_ON|DTV_CONTROL_LINEAR_ADDRESSING_ON
    sta DTV_CONTROL
    lda #VIC_ECM|VIC_BMM|VIC_DEN|VIC_RSEL|3
    sta VIC_CONTROL
    lda #VIC_CSEL
    sta VIC_CONTROL2
    lda #<TWOPLANE_PLANEA
    sta DTV_PLANEA_START_LO
    lda #>TWOPLANE_PLANEA
    sta DTV_PLANEA_START_MI
    lda #0
    sta DTV_PLANEA_START_HI
    lda #1
    sta DTV_PLANEA_STEP
    lda #0
    sta DTV_PLANEA_MODULO_LO
    sta DTV_PLANEA_MODULO_HI
    lda #<TWOPLANE_PLANEB
    sta DTV_PLANEB_START_LO
    lda #>TWOPLANE_PLANEB
    sta DTV_PLANEB_START_MI
    lda #0
    sta DTV_PLANEB_START_HI
    lda #1
    sta DTV_PLANEB_STEP
    lda #0
    sta DTV_PLANEB_MODULO_LO
    sta DTV_PLANEB_MODULO_HI
    lda #<TWOPLANE_COLORS/$400
    sta DTV_COLOR_BANK_LO
    lda #>TWOPLANE_COLORS/$400
    sta DTV_COLOR_BANK_HI
    lda #0
  b1:
    tax
    sta DTV_PALETTE,x
    clc
    adc #1
    cmp #$10
    bne b1
    lda #0
    sta BORDERCOL
    lda #$70
    sta BGCOL1
    lda #$d4
    sta BGCOL2
    lda #<TWOPLANE_COLORS
    sta col
    lda #>TWOPLANE_COLORS
    sta col+1
    lda #0
    sta cy
  b2:
    ldx #0
  b3:
    lda #$f
    and cy
    asl
    asl
    asl
    asl
    sta _15
    txa
    and #$f
    ora _15
    ldy #0
    sta (col),y
    inc col
    bne !+
    inc col+1
  !:
    inx
    cpx #$28
    bne b3
    inc cy
    lda cy
    cmp #$19
    bne b2
    lda #<TWOPLANE_PLANEA
    sta gfxa
    lda #>TWOPLANE_PLANEA
    sta gfxa+1
    lda #0
    sta ay
  b4:
    ldx #0
  b5:
    lda #4
    and ay
    cmp #0
    bne b6
    lda #0
    tay
    sta (gfxa),y
    inc gfxa
    bne !+
    inc gfxa+1
  !:
  b7:
    inx
    cpx #$28
    bne b5
    inc ay
    lda ay
    cmp #$c8
    bne b4
    lda #0
    sta by
    lda #<TWOPLANE_PLANEB
    sta gfxb
    lda #>TWOPLANE_PLANEB
    sta gfxb+1
  b8:
    ldx #0
  b9:
    lda #$f
    ldy #0
    sta (gfxb),y
    inc gfxb
    bne !+
    inc gfxb+1
  !:
    inx
    cpx #$28
    bne b9
    inc by
    lda by
    cmp #$c8
    bne b8
    jmp b11
  breturn:
    rts
  b11:
    ldx #KEY_SPACE
    jsr keyboard_key_pressed
    cmp #0
    beq b11
    jmp breturn
  b6:
    lda #$ff
    ldy #0
    sta (gfxa),y
    inc gfxa
    bne !+
    inc gfxa+1
  !:
    jmp b7
}
print_str_lines: {
    .label str = 2
    lda #<MENU_SCREEN
    sta print_line_cursor
    lda #>MENU_SCREEN
    sta print_line_cursor+1
    lda #<MENU_SCREEN
    sta print_char_cursor
    lda #>MENU_SCREEN
    sta print_char_cursor+1
    lda #<MENU_TEXT
    sta str
    lda #>MENU_TEXT
    sta str+1
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
    .label sc = 2
    lda #<MENU_SCREEN
    sta sc
    lda #>MENU_SCREEN
    sta sc+1
  b1:
    lda #' '
    ldy #0
    sta (sc),y
    inc sc
    bne !+
    inc sc+1
  !:
    lda sc+1
    cmp #>MENU_SCREEN+$3e8
    bne b1
    lda sc
    cmp #<MENU_SCREEN+$3e8
    bne b1
    rts
}
print_set_screen: {
    rts
}
  DTV_PALETTE_DEFAULT: .byte 0, $f, $36, $be, $58, $db, $86, $ff, $29, $26, $3b, 5, 7, $df, $9a, $a
  keyboard_matrix_row_bitmask: .byte $fe, $fd, $fb, $f7, $ef, $df, $bf, $7f
  keyboard_matrix_col_bitmask: .byte 1, 2, 4, 8, $10, $20, $40, $80
  MENU_TEXT: .text "C64DTV Graphics Modes            CCLHBME@"+"                                 OHIIMCC@"+"                                 LUNCMMM@"+"----------------------------------------@"+"1. Standard Char             (V) 0000000@"+"2. Extended Color Char       (V) 0000001@"+"3. Multicolor Char           (V) 0000010@"+"4. Standard Bitmap           (V) 0000100@"+"5. Multicolor Bitmap         (V) 0000110@"+"6. High Color Standard Char  (H) 0001000@"+"7. High Extended Color Char  (H) 0001001@"+"8. High Multicolor Char      (H) 0001010@"+"9. High Multicolor Bitmap    (H) 0001110@"+"a. Sixs Fred 2               (D) 0010111@"+"b. Two Plane Bitmap          (D) 0011101@"+"c. Sixs Fred (2 Plane MC BM) (D) 0011111@"+"d. 8bpp Pixel Cell           (D) 0111011@"+"e. Chunky 8bpp Bitmap        (D) 1111011@"+"----------------------------------------@"+"    (V) vicII (H) vicII+hicol (D) c64dtv@"+"@"
