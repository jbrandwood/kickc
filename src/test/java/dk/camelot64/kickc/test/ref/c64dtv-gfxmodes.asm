.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label BORDERCOL = $d020
  .label BGCOL = $d021
  .label BGCOL1 = $d021
  .label BGCOL2 = $d022
  .label D011 = $d011
  .const VIC_ECM = $40
  .const VIC_BMM = $20
  .const VIC_DEN = $10
  .const VIC_RSEL = 8
  .label D016 = $d016
  .const VIC_CSEL = 8
  .label D018 = $d018
  .label COLS = $d800
  .label CIA1_PORT_A = $dc00
  .label CIA1_PORT_B = $dc01
  .label CIA2_PORT_A = $dd00
  .label CIA2_PORT_A_DDR = $dd02
  .const GREEN = 5
  .const BLUE = 6
  .const LIGHT_GREEN = $d
  .label DTV_FEATURE = $d03f
  .const DTV_FEATURE_ENABLE = 1
  .label DTV_CONTROL = $d03c
  .const DTV_CONTROL_LINEAR_ADDRESSING_ON = 1
  .const DTV_CONTROL_HIGHCOLOR_ON = 4
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
  .label DTV_GRAPHICS_VIC_BANK = $d03d
  .const KEY_C = $14
  .const KEY_SPACE = $3c
  .label MENU_SCREEN = $8000
  .label MENU_CHARSET = $9800
  .label TWOPLANE_PLANEA = $4000
  .label TWOPLANE_PLANEB = $6000
  .label print_char_cursor = 7
  .label print_line_cursor = 5
  .label print_line_cursor_10 = 2
  .label print_char_cursor_13 = 5
  .label print_screen = 2
  .label print_line_cursor_89 = 2
  jsr main
main: {
    lda #DTV_FEATURE_ENABLE
    sta DTV_FEATURE
    lda #<$400
    sta print_char_cursor_13
    lda #>$400
    sta print_char_cursor_13+1
    lda #<$400
    sta print_line_cursor_10
    lda #>$400
    sta print_line_cursor_10+1
    lda #<$400
    sta print_screen
    lda #>$400
    sta print_screen+1
  b2:
    jsr menu
    lda print_line_cursor
    sta print_line_cursor_89
    lda print_line_cursor+1
    sta print_line_cursor_89+1
    lda #<MENU_SCREEN
    sta print_screen
    lda #>MENU_SCREEN
    sta print_screen+1
    jmp b2
}
menu: {
    .label last = MENU_SCREEN+$3e7
    .label c = 2
    lda #($ffffffff&MENU_CHARSET)/$10000
    sta DTV_GRAPHICS_VIC_BANK
    lda #0
    sta DTV_CONTROL
    lda #3
    sta CIA2_PORT_A_DDR
    lda #3^MENU_CHARSET/$4000
    sta CIA2_PORT_A
    lda #VIC_DEN|VIC_RSEL|3
    sta D011
    lda #VIC_CSEL
    sta D016
    lda #(MENU_SCREEN&$3fff)/$40|(MENU_CHARSET&$3fff)/$400
    sta D018
    lda #<COLS
    sta c
    lda #>COLS
    sta c+1
  b1:
    lda #LIGHT_GREEN
    ldy #0
    sta (c),y
    inc c
    bne !+
    inc c+1
  !:
    lda c+1
    cmp #>COLS+$3e8
    bne b1
    lda c
    cmp #<COLS+$3e8
    bne b1
    lda #0
    sta BGCOL
    sta BORDERCOL
    jsr print_set_screen
    jsr print_cls
    lda #<MENU_SCREEN
    sta print_line_cursor
    lda #>MENU_SCREEN
    sta print_line_cursor+1
    lda #<MENU_SCREEN
    sta print_char_cursor
    lda #>MENU_SCREEN
    sta print_char_cursor+1
    lda #<str
    sta print_str_ln.str
    lda #>str
    sta print_str_ln.str+1
    jsr print_str_ln
    lda print_line_cursor
    sta print_char_cursor
    lda print_line_cursor+1
    sta print_char_cursor+1
    lda #<str1
    sta print_str_ln.str
    lda #>str1
    sta print_str_ln.str+1
    jsr print_str_ln
    lda print_line_cursor
    sta print_char_cursor
    lda print_line_cursor+1
    sta print_char_cursor+1
    lda #<str2
    sta print_str_ln.str
    lda #>str2
    sta print_str_ln.str+1
    jsr print_str_ln
    lda print_line_cursor
    sta print_char_cursor
    lda print_line_cursor+1
    sta print_char_cursor+1
    lda #<str3
    sta print_str_ln.str
    lda #>str3
    sta print_str_ln.str+1
    jsr print_str_ln
    lda print_line_cursor
    sta print_char_cursor
    lda print_line_cursor+1
    sta print_char_cursor+1
    lda #<str4
    sta print_str_ln.str
    lda #>str4
    sta print_str_ln.str+1
    jsr print_str_ln
    lda print_line_cursor
    sta print_char_cursor
    lda print_line_cursor+1
    sta print_char_cursor+1
    lda #<str5
    sta print_str_ln.str
    lda #>str5
    sta print_str_ln.str+1
    jsr print_str_ln
    lda print_line_cursor
    sta print_char_cursor
    lda print_line_cursor+1
    sta print_char_cursor+1
    lda #<str6
    sta print_str_ln.str
    lda #>str6
    sta print_str_ln.str+1
    jsr print_str_ln
    lda print_line_cursor
    sta print_char_cursor
    lda print_line_cursor+1
    sta print_char_cursor+1
    lda #<str7
    sta print_str_ln.str
    lda #>str7
    sta print_str_ln.str+1
    jsr print_str_ln
    lda print_line_cursor
    sta print_char_cursor
    lda print_line_cursor+1
    sta print_char_cursor+1
    lda #<str8
    sta print_str_ln.str
    lda #>str8
    sta print_str_ln.str+1
    jsr print_str_ln
    lda print_line_cursor
    sta print_char_cursor
    lda print_line_cursor+1
    sta print_char_cursor+1
    lda #<str9
    sta print_str_ln.str
    lda #>str9
    sta print_str_ln.str+1
    jsr print_str_ln
    lda print_line_cursor
    sta print_char_cursor
    lda print_line_cursor+1
    sta print_char_cursor+1
    lda #<str10
    sta print_str_ln.str
    lda #>str10
    sta print_str_ln.str+1
    jsr print_str_ln
    lda print_line_cursor
    sta print_char_cursor
    lda print_line_cursor+1
    sta print_char_cursor+1
    lda #<str11
    sta print_str_ln.str
    lda #>str11
    sta print_str_ln.str+1
    jsr print_str_ln
    lda print_line_cursor
    sta print_char_cursor
    lda print_line_cursor+1
    sta print_char_cursor+1
    lda #<str12
    sta print_str_ln.str
    lda #>str12
    sta print_str_ln.str+1
    jsr print_str_ln
    lda print_line_cursor
    sta print_char_cursor
    lda print_line_cursor+1
    sta print_char_cursor+1
    lda #<str13
    sta print_str_ln.str
    lda #>str13
    sta print_str_ln.str+1
    jsr print_str_ln
    lda print_line_cursor
    sta print_char_cursor
    lda print_line_cursor+1
    sta print_char_cursor+1
    lda #<str14
    sta print_str_ln.str
    lda #>str14
    sta print_str_ln.str+1
    jsr print_str_ln
    lda print_line_cursor
    sta print_char_cursor
    lda print_line_cursor+1
    sta print_char_cursor+1
    lda #<str15
    sta print_str_ln.str
    lda #>str15
    sta print_str_ln.str+1
    jsr print_str_ln
    lda print_line_cursor
    sta print_char_cursor
    lda print_line_cursor+1
    sta print_char_cursor+1
    lda #<str16
    sta print_str_ln.str
    lda #>str16
    sta print_str_ln.str+1
    jsr print_str_ln
    lda print_line_cursor
    sta print_char_cursor
    lda print_line_cursor+1
    sta print_char_cursor+1
    lda #<str17
    sta print_str_ln.str
    lda #>str17
    sta print_str_ln.str+1
    jsr print_str_ln
    lda print_line_cursor
    sta print_char_cursor
    lda print_line_cursor+1
    sta print_char_cursor+1
    lda #<str18
    sta print_str_ln.str
    lda #>str18
    sta print_str_ln.str+1
    jsr print_str_ln
    lda print_line_cursor
    sta print_char_cursor
    lda print_line_cursor+1
    sta print_char_cursor+1
    lda #<str19
    sta print_str_ln.str
    lda #>str19
    sta print_str_ln.str+1
    jsr print_str_ln
    lda print_line_cursor
    sta print_char_cursor
    lda print_line_cursor+1
    sta print_char_cursor+1
    lda #<str20
    sta print_str_ln.str
    lda #>str20
    sta print_str_ln.str+1
    jsr print_str_ln
    jmp b3
  breturn:
    rts
  b3:
    ldx #KEY_C
    jsr keyboard_key_pressed
    cmp #0
    beq b5
    jsr mode_twoplanebitmap
    jmp breturn
  b5:
    inc last
    jmp b3
    str: .text "C64DTV Graphics Modes            EMBLHCC@"
    str1: .text "                                 CCMIIHO@"
    str2: .text "                                 MMMNCUL@"
    str3: .text "----------------------------------------@"
    str4: .text "1. Standard Char             (V) 0000000@"
    str5: .text "2. Extended Color Char       (V) 1000000@"
    str6: .text "3. Multicolor Char           (V) 0100000@"
    str7: .text "4. Standard Bitmap           (V) 0010000@"
    str8: .text "5. Multicolor Bitmap         (V) 0110000@"
    str9: .text "6. High Color Standard Char  (H) 0000100@"
    str10: .text "7. High Extended Color Char  (H) 1000100@"
    str11: .text "8. High Multicolor Char      (H) 0100100@"
    str12: .text "9. High Multicolor Bitmap    (H) 0110100@"
    str13: .text "a. Sixs Fred                 (D) 1111100@"
    str14: .text "b. Sixs Fred 2               (D) 1111000@"
    str15: .text "c. Two Plane Bitmap          (D) 1011100@"
    str16: .text "d. Two Plane Multicol Bitmap (D) 1111100@"
    str17: .text "e. 8bpp Pixel Cell           (D) 1101110@"
    str18: .text "f. Chunky 8bpp Bitmap        (D) 1101111@"
    str19: .text "----------------------------------------@"
    str20: .text "    (V) vicII (H) vicII+hicol (D) c64dtv@"
}
mode_twoplanebitmap: {
    .label c = 2
    .label gfxa = 2
    .label ay = 4
    .label gfxb = 2
    .label by = 4
    lda #DTV_CONTROL_HIGHCOLOR_ON|DTV_CONTROL_LINEAR_ADDRESSING_ON
    sta DTV_CONTROL
    lda #VIC_ECM|VIC_BMM|VIC_DEN|VIC_RSEL|3
    sta D011
    lda #VIC_CSEL
    sta D016
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
    sta BORDERCOL
    lda #GREEN
    sta BGCOL1
    lda #BLUE
    sta BGCOL2
    lda #<COLS
    sta c
    lda #>COLS
    sta c+1
  b1:
    lda c
    ldy #0
    sta (c),y
    inc c
    bne !+
    inc c+1
  !:
    lda c+1
    cmp #>COLS+$3e8
    bne b1
    lda c
    cmp #<COLS+$3e8
    bne b1
    lda #<TWOPLANE_PLANEA
    sta gfxa
    lda #>TWOPLANE_PLANEA
    sta gfxa+1
    lda #0
    sta ay
  b2:
    ldx #0
  b3:
    lda #4
    and ay
    cmp #0
    bne b4
    lda #0
    tay
    sta (gfxa),y
    inc gfxa
    bne !+
    inc gfxa+1
  !:
  b5:
    inx
    cpx #$28
    bne b3
    inc ay
    lda ay
    cmp #$c8
    bne b2
    lda #0
    sta by
    lda #<TWOPLANE_PLANEB
    sta gfxb
    lda #>TWOPLANE_PLANEB
    sta gfxb+1
  b6:
    ldx #0
  b7:
    lda #$f
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
  b4:
    lda #$ff
    ldy #0
    sta (gfxa),y
    inc gfxa
    bne !+
    inc gfxa+1
  !:
    jmp b5
}
keyboard_key_pressed: {
    txa
    lsr
    lsr
    lsr
    jsr keyboard_matrix_read
    tay
    txa
    and #7
    tax
    tya
    and keyboard_matrix_col_bitmask,x
    rts
}
keyboard_matrix_read: {
    tay
    lda keyboard_matrix_row_bitmask,y
    sta CIA1_PORT_A
    lda CIA1_PORT_B
    eor #$ff
    rts
}
print_str_ln: {
    .label str = 2
    jsr print_str
    jsr print_ln
    rts
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
print_str: {
    .label str = 2
  b1:
    ldy #0
    lda (str),y
    cmp #'@'
    bne b2
    rts
  b2:
    ldy #0
    lda (str),y
    sta (print_char_cursor),y
    inc print_char_cursor
    bne !+
    inc print_char_cursor+1
  !:
    inc str
    bne !+
    inc str+1
  !:
    jmp b1
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
  keyboard_matrix_row_bitmask: .byte $fe, $fd, $fb, $f7, $ef, $df, $bf, $7f
  keyboard_matrix_col_bitmask: .byte 1, 2, 4, 8, $10, $20, $40, $80
