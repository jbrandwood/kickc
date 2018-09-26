.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label PROCPORT_DDR = 0
  .const PROCPORT_DDR_MEMORY_MASK = 7
  .label PROCPORT = 1
  .const PROCPORT_RAM_IO = $35
  .const PROCPORT_RAM_CHARROM = $31
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
  .label CIA2_PORT_A = $dd00
  .label CIA2_PORT_A_DDR = $dd02
  .const BLACK = 0
  .const GREEN = 5
  .const BLUE = 6
  .const LIGHT_GREEN = $d
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
  .const KEY_3 = 8
  .const KEY_A = $a
  .const KEY_4 = $b
  .const KEY_E = $e
  .const KEY_D = $12
  .const KEY_6 = $13
  .const KEY_C = $14
  .const KEY_7 = $18
  .const KEY_8 = $1b
  .const KEY_B = $1c
  .const KEY_H = $1d
  .const KEY_U = $1e
  .const KEY_0 = $23
  .const KEY_O = $26
  .const KEY_L = $2a
  .const KEY_1 = $38
  .const KEY_2 = $3b
  .const KEY_SPACE = $3c
  .label print_char_cursor = 5
  .label dtv_control = 4
  .label print_line_cursor = $d
  jsr main
main: {
    sei
    lda #PROCPORT_DDR_MEMORY_MASK
    sta PROCPORT_DDR
    lda #PROCPORT_RAM_IO
    sta PROCPORT
    lda #DTV_FEATURE_ENABLE
    sta DTV_FEATURE
  b2:
    jsr menu
    jmp b2
}
menu: {
    .label SCREEN = $8000
    .label CHARSET = $9800
    .label c = 2
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
  b4:
    ldy #KEY_1
    jsr keyboard_key_pressed
    cmp #0
    beq b6
    jsr mode_stdchar
  breturn:
    rts
  b6:
    ldy #KEY_2
    jsr keyboard_key_pressed
    cmp #0
    beq b7
    jsr mode_ecmchar
    jmp breturn
  b7:
    ldy #KEY_3
    jsr keyboard_key_pressed
    cmp #0
    beq b8
    jsr mode_mcchar
    jmp breturn
  b8:
    ldy #KEY_4
    jsr keyboard_key_pressed
    cmp #0
    beq b9
    jsr mode_stdbitmap
    jmp breturn
  b9:
    ldy #KEY_6
    jsr keyboard_key_pressed
    cmp #0
    beq b10
    jsr mode_hicolstdchar
    jmp breturn
  b10:
    ldy #KEY_7
    jsr keyboard_key_pressed
    cmp #0
    beq b11
    jsr mode_hicolecmchar
    jmp breturn
  b11:
    ldy #KEY_8
    jsr keyboard_key_pressed
    cmp #0
    beq b12
    jsr mode_hicolmcchar
    jmp breturn
  b12:
    ldy #KEY_A
    jsr keyboard_key_pressed
    cmp #0
    beq b13
    jsr mode_sixsfred2
    jmp breturn
  b13:
    ldy #KEY_B
    jsr keyboard_key_pressed
    cmp #0
    beq b14
    jsr mode_twoplanebitmap
    jmp breturn
  b14:
    ldy #KEY_C
    jsr keyboard_key_pressed
    cmp #0
    beq b15
    jsr mode_sixsfred
    jmp breturn
  b15:
    ldy #KEY_D
    jsr keyboard_key_pressed
    cmp #0
    beq b16
    jsr mode_8bpppixelcell
    jmp breturn
  b16:
    ldy #KEY_E
    jsr keyboard_key_pressed
    cmp #0
    bne !b4+
    jmp b4
  !b4:
    jsr mode_8bppchunkybmm
    jmp breturn
}
mode_8bppchunkybmm: {
    .const PLANEB = $20000
    .label _23 = $d
    .label gfxb = 5
    .label x = 2
    .label y = 4
    lda #DTV_HIGHCOLOR|DTV_LINEAR|DTV_CHUNKY|DTV_COLORRAM_OFF
    sta DTV_CONTROL
    lda #VIC_ECM|VIC_DEN|VIC_RSEL|3
    sta VIC_CONTROL
    lda #VIC_MCM|VIC_CSEL
    sta VIC_CONTROL2
    lda #PLANEB&$ffff
    sta DTV_PLANEB_START_LO
    lda #0
    sta DTV_PLANEB_START_MI
    lda #PLANEB>>$10
    sta DTV_PLANEB_START_HI
    lda #8
    sta DTV_PLANEB_STEP
    lda #0
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
    lda #PLANEB/$4000
    jsr dtvSetCpuBankSegment1
    ldx #PLANEB/$4000+1
    lda #0
    sta y
    lda #<$4000
    sta gfxb
    lda #>$4000
    sta gfxb+1
  b2:
    lda #<0
    sta x
    sta x+1
  b3:
    lda gfxb+1
    cmp #>$8000
    bne b4
    lda gfxb
    cmp #<$8000
    bne b4
    txa
    jsr dtvSetCpuBankSegment1
    inx
    lda #<$4000
    sta gfxb
    lda #>$4000
    sta gfxb+1
  b4:
    lda y
    clc
    adc x
    sta _23
    lda #0
    adc x+1
    sta _23+1
    lda _23
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
    bne b3
    lda x
    cmp #<$140
    bne b3
    inc y
    lda y
    cmp #$c8
    bne b2
    lda #$4000/$4000
    jsr dtvSetCpuBankSegment1
    lda #DTV_HIGHCOLOR|DTV_LINEAR|DTV_CHUNKY|DTV_COLORRAM_OFF
    sta dtv_control
    jsr mode_ctrl
    rts
}
mode_ctrl: {
  b4:
    lda RASTER
    cmp #$ff
    bne b4
    ldy #KEY_SPACE
    jsr keyboard_key_pressed
    cmp #0
    beq b7
    rts
  b7:
    ldx dtv_control
    ldy #KEY_L
    jsr keyboard_key_pressed
    cmp #0
    beq b8
    txa
    ora #DTV_LINEAR
    tax
  b8:
    ldy #KEY_H
    jsr keyboard_key_pressed
    cmp #0
    beq b9
    txa
    ora #DTV_HIGHCOLOR
    tax
  b9:
    ldy #KEY_O
    jsr keyboard_key_pressed
    cmp #0
    beq b10
    txa
    ora #DTV_OVERSCAN
    tax
  b10:
    ldy #KEY_B
    jsr keyboard_key_pressed
    cmp #0
    beq b11
    txa
    ora #DTV_BORDER_OFF
    tax
  b11:
    ldy #KEY_U
    jsr keyboard_key_pressed
    cmp #0
    beq b12
    txa
    ora #DTV_CHUNKY
    tax
  b12:
    ldy #KEY_C
    jsr keyboard_key_pressed
    cmp #0
    beq b13
    txa
    ora #DTV_COLORRAM_OFF
    tax
  b13:
    ldy #KEY_0
    jsr keyboard_key_pressed
    cmp #0
    beq b14
    ldx #0
  b14:
    cpx dtv_control
    beq b4
    stx dtv_control
    stx DTV_CONTROL
    stx BORDERCOL
    jmp b4
}
keyboard_key_pressed: {
    .label colidx = 7
    tya
    and #7
    sta colidx
    tya
    lsr
    lsr
    lsr
    tay
    jsr keyboard_matrix_read
    ldy colidx
    and keyboard_matrix_col_bitmask,y
    rts
}
keyboard_matrix_read: {
    lda keyboard_matrix_row_bitmask,y
    sta CIA1_PORT_A
    lda CIA1_PORT_B
    eor #$ff
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
mode_8bpppixelcell: {
    .label PLANEA = $3c00
    .label PLANEB = $4000
    .label _14 = 7
    .label gfxa = 2
    .label ay = 4
    .label bits = 8
    .label chargen = 2
    .label gfxb = 5
    .label col = 9
    .label cr = 7
    .label ch = 4
    lda #DTV_HIGHCOLOR|DTV_LINEAR|DTV_CHUNKY
    sta DTV_CONTROL
    lda #VIC_ECM|VIC_DEN|VIC_RSEL|3
    sta VIC_CONTROL
    lda #VIC_MCM|VIC_CSEL
    sta VIC_CONTROL2
    lda #<PLANEA
    sta DTV_PLANEA_START_LO
    lda #>PLANEA
    sta DTV_PLANEA_START_MI
    lda #0
    sta DTV_PLANEA_START_HI
    lda #1
    sta DTV_PLANEA_STEP
    lda #0
    sta DTV_PLANEA_MODULO_LO
    sta DTV_PLANEA_MODULO_HI
    lda #<PLANEB
    sta DTV_PLANEB_START_LO
    lda #>PLANEB
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
    lda #<PLANEA
    sta gfxa
    lda #>PLANEA
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
    sta _14
    txa
    and #$f
    ora _14
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
    lda #PROCPORT_RAM_CHARROM
    sta PROCPORT
    lda #0
    sta ch
    sta col
    lda #<PLANEB
    sta gfxb
    lda #>PLANEB
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
    beq b8
    lda col
    jmp b7
  b8:
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
    lda #PROCPORT_RAM_IO
    sta PROCPORT
    lda #DTV_HIGHCOLOR|DTV_LINEAR|DTV_CHUNKY
    sta dtv_control
    jsr mode_ctrl
    rts
}
mode_sixsfred: {
    .label PLANEA = $4000
    .label PLANEB = $6000
    .label COLORS = $8000
    .label col = 2
    .label cy = 4
    .label gfxa = 2
    .label ay = 4
    .label gfxb = 2
    .label by = 4
    lda #DTV_HIGHCOLOR|DTV_LINEAR
    sta DTV_CONTROL
    lda #VIC_ECM|VIC_BMM|VIC_DEN|VIC_RSEL|3
    sta VIC_CONTROL
    lda #VIC_MCM|VIC_CSEL
    sta VIC_CONTROL2
    lda #<PLANEA
    sta DTV_PLANEA_START_LO
    lda #>PLANEA
    sta DTV_PLANEA_START_MI
    lda #0
    sta DTV_PLANEA_START_HI
    lda #1
    sta DTV_PLANEA_STEP
    lda #0
    sta DTV_PLANEA_MODULO_LO
    sta DTV_PLANEA_MODULO_HI
    lda #<PLANEB
    sta DTV_PLANEB_START_LO
    lda #>PLANEB
    sta DTV_PLANEB_START_MI
    lda #0
    sta DTV_PLANEB_START_HI
    lda #1
    sta DTV_PLANEB_STEP
    lda #0
    sta DTV_PLANEB_MODULO_LO
    sta DTV_PLANEB_MODULO_HI
    lda #<COLORS/$400
    sta DTV_COLOR_BANK_LO
    lda #>COLORS/$400
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
    lda #<COLORS
    sta col
    lda #>COLORS
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
    lda #<PLANEA
    sta gfxa
    lda #>PLANEA
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
    lda #<PLANEB
    sta gfxb
    lda #>PLANEB
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
    lda #DTV_HIGHCOLOR|DTV_LINEAR
    sta dtv_control
    jsr mode_ctrl
    rts
    row_bitmask: .byte 0, $55, $aa, $ff
}
mode_twoplanebitmap: {
    .label PLANEA = $4000
    .label PLANEB = $6000
    .label COLORS = $8000
    .label _16 = 7
    .label col = 2
    .label cy = 4
    .label gfxa = 2
    .label ay = 4
    .label gfxb = 2
    .label by = 4
    lda #DTV_HIGHCOLOR|DTV_LINEAR
    sta DTV_CONTROL
    lda #VIC_ECM|VIC_BMM|VIC_DEN|VIC_RSEL|3
    sta VIC_CONTROL
    lda #VIC_CSEL
    sta VIC_CONTROL2
    lda #<PLANEA
    sta DTV_PLANEA_START_LO
    lda #>PLANEA
    sta DTV_PLANEA_START_MI
    lda #0
    sta DTV_PLANEA_START_HI
    lda #1
    sta DTV_PLANEA_STEP
    lda #0
    sta DTV_PLANEA_MODULO_LO
    sta DTV_PLANEA_MODULO_HI
    lda #<PLANEB
    sta DTV_PLANEB_START_LO
    lda #>PLANEB
    sta DTV_PLANEB_START_MI
    lda #0
    sta DTV_PLANEB_START_HI
    lda #1
    sta DTV_PLANEB_STEP
    lda #0
    sta DTV_PLANEB_MODULO_LO
    sta DTV_PLANEB_MODULO_HI
    lda #<COLORS/$400
    sta DTV_COLOR_BANK_LO
    lda #>COLORS/$400
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
    lda #$70
    sta BGCOL1
    lda #$d4
    sta BGCOL2
    lda #<COLORS
    sta col
    lda #>COLORS
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
    sta _16
    txa
    and #$f
    ora _16
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
    lda #<PLANEA
    sta gfxa
    lda #>PLANEA
    sta gfxa+1
    lda #0
    sta ay
  b4:
    ldx #0
  b5:
    lda #4
    and ay
    cmp #0
    beq b6
    lda #$ff
    ldy #0
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
    lda #<PLANEB
    sta gfxb
    lda #>PLANEB
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
    lda #DTV_HIGHCOLOR|DTV_LINEAR
    sta dtv_control
    jsr mode_ctrl
    rts
  b6:
    lda #0
    tay
    sta (gfxa),y
    inc gfxa
    bne !+
    inc gfxa+1
  !:
    jmp b7
}
mode_sixsfred2: {
    .label PLANEA = $4000
    .label PLANEB = $6000
    .label COLORS = $8000
    .label _15 = 7
    .label col = 2
    .label cy = 4
    .label gfxa = 2
    .label ay = 4
    .label gfxb = 2
    .label by = 4
    lda #DTV_LINEAR
    sta DTV_CONTROL
    lda #VIC_ECM|VIC_BMM|VIC_DEN|VIC_RSEL|3
    sta VIC_CONTROL
    lda #VIC_MCM|VIC_CSEL
    sta VIC_CONTROL2
    lda #<PLANEA
    sta DTV_PLANEA_START_LO
    lda #>PLANEA
    sta DTV_PLANEA_START_MI
    lda #0
    sta DTV_PLANEA_START_HI
    lda #1
    sta DTV_PLANEA_STEP
    lda #0
    sta DTV_PLANEA_MODULO_LO
    sta DTV_PLANEA_MODULO_HI
    lda #<PLANEB
    sta DTV_PLANEB_START_LO
    lda #>PLANEB
    sta DTV_PLANEB_START_MI
    lda #0
    sta DTV_PLANEB_START_HI
    lda #1
    sta DTV_PLANEB_STEP
    lda #0
    sta DTV_PLANEB_MODULO_LO
    sta DTV_PLANEB_MODULO_HI
    lda #<COLORS/$400
    sta DTV_COLOR_BANK_LO
    lda #>COLORS/$400
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
    lda #<COLORS
    sta col
    lda #>COLORS
    sta col+1
    lda #0
    sta cy
  b2:
    ldx #0
  b3:
    txa
    and #3
    asl
    asl
    asl
    asl
    sta _15
    lda #3
    and cy
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
    lda #<PLANEA
    sta gfxa
    lda #>PLANEA
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
    lda #<PLANEB
    sta gfxb
    lda #>PLANEB
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
    lda #DTV_LINEAR
    sta dtv_control
    jsr mode_ctrl
    rts
    row_bitmask: .byte 0, $55, $aa, $ff
}
mode_hicolmcchar: {
    .label SCREEN = $8000
    .label CHARSET = $9000
    .label COLORS = $8400
    .label _26 = 7
    .label col = 2
    .label ch = 5
    .label cy = 4
    lda #($ffffffff&CHARSET)/$10000
    sta DTV_GRAPHICS_VIC_BANK
    lda #COLORS/$400
    sta DTV_COLOR_BANK_LO
    lda #0
    sta DTV_COLOR_BANK_HI
    lda #DTV_HIGHCOLOR
    sta DTV_CONTROL
    lda #3
    sta CIA2_PORT_A_DDR
    lda #3^CHARSET/$4000
    sta CIA2_PORT_A
    lda #VIC_DEN|VIC_RSEL|3
    sta VIC_CONTROL
    lda #VIC_CSEL|VIC_MCM
    sta VIC_CONTROL2
    lda #(SCREEN&$3fff)/$40|(CHARSET&$3fff)/$400
    sta VIC_MEMORY
    ldx #0
  b1:
    txa
    sta DTV_PALETTE,x
    inx
    cpx #$10
    bne b1
    lda #0
    sta BORDERCOL
    lda #$50
    sta BGCOL1
    lda #$54
    sta BGCOL2
    lda #$58
    sta BGCOL3
    lda #<SCREEN
    sta ch
    lda #>SCREEN
    sta ch+1
    lda #<COLORS
    sta col
    lda #>COLORS
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
    sta _26
    txa
    and #$f
    ora _26
    ldy #0
    sta (col),y
    inc col
    bne !+
    inc col+1
  !:
    ldy #0
    sta (ch),y
    inc ch
    bne !+
    inc ch+1
  !:
    inx
    cpx #$28
    bne b3
    inc cy
    lda cy
    cmp #$19
    bne b2
    lda #DTV_HIGHCOLOR
    sta dtv_control
    jsr mode_ctrl
    rts
}
mode_hicolecmchar: {
    .label SCREEN = $8000
    .label CHARSET = $9000
    .label COLORS = $8400
    .label _26 = 7
    .label col = 2
    .label ch = 5
    .label cy = 4
    lda #($ffffffff&CHARSET)/$10000
    sta DTV_GRAPHICS_VIC_BANK
    lda #COLORS/$400
    sta DTV_COLOR_BANK_LO
    lda #0
    sta DTV_COLOR_BANK_HI
    lda #DTV_HIGHCOLOR
    sta DTV_CONTROL
    lda #3
    sta CIA2_PORT_A_DDR
    lda #3^CHARSET/$4000
    sta CIA2_PORT_A
    lda #VIC_DEN|VIC_RSEL|VIC_ECM|3
    sta VIC_CONTROL
    lda #VIC_CSEL
    sta VIC_CONTROL2
    lda #(SCREEN&$3fff)/$40|(CHARSET&$3fff)/$400
    sta VIC_MEMORY
    ldx #0
  b1:
    txa
    sta DTV_PALETTE,x
    inx
    cpx #$10
    bne b1
    lda #0
    sta BORDERCOL
    lda #$50
    sta BGCOL1
    lda #$54
    sta BGCOL2
    lda #$58
    sta BGCOL3
    lda #$5c
    sta BGCOL4
    lda #<SCREEN
    sta ch
    lda #>SCREEN
    sta ch+1
    lda #<COLORS
    sta col
    lda #>COLORS
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
    sta _26
    txa
    and #$f
    ora _26
    ldy #0
    sta (col),y
    inc col
    bne !+
    inc col+1
  !:
    ldy #0
    sta (ch),y
    inc ch
    bne !+
    inc ch+1
  !:
    inx
    cpx #$28
    bne b3
    inc cy
    lda cy
    cmp #$19
    bne b2
    lda #DTV_HIGHCOLOR
    sta dtv_control
    jsr mode_ctrl
    rts
}
mode_hicolstdchar: {
    .label SCREEN = $8000
    .label CHARSET = $9000
    .label COLORS = $8400
    .label _25 = 7
    .label col = 2
    .label ch = 5
    .label cy = 4
    lda #($ffffffff&CHARSET)/$10000
    sta DTV_GRAPHICS_VIC_BANK
    lda #COLORS/$400
    sta DTV_COLOR_BANK_LO
    lda #0
    sta DTV_COLOR_BANK_HI
    lda #DTV_HIGHCOLOR
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
    txa
    sta DTV_PALETTE,x
    inx
    cpx #$10
    bne b1
    lda #0
    sta BGCOL
    sta BORDERCOL
    lda #<SCREEN
    sta ch
    lda #>SCREEN
    sta ch+1
    lda #<COLORS
    sta col
    lda #>COLORS
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
    sta _25
    txa
    and #$f
    ora _25
    ldy #0
    sta (col),y
    inc col
    bne !+
    inc col+1
  !:
    ldy #0
    sta (ch),y
    inc ch
    bne !+
    inc ch+1
  !:
    inx
    cpx #$28
    bne b3
    inc cy
    lda cy
    cmp #$19
    bne b2
    lda #DTV_HIGHCOLOR
    sta dtv_control
    jsr mode_ctrl
    rts
}
mode_stdbitmap: {
    .label SCREEN = $4000
    .label BITMAP = $6000
    .const lines_cnt = 9
    .label col2 = 7
    .label ch = 2
    .label cy = 4
    .label l = 4
    lda #($ffffffff&BITMAP)/$10000
    sta DTV_GRAPHICS_VIC_BANK
    lda #0
    sta DTV_CONTROL
    lda #3
    sta CIA2_PORT_A_DDR
    lda #3^BITMAP/$4000
    sta CIA2_PORT_A
    lda #VIC_BMM|VIC_DEN|VIC_RSEL|3
    sta VIC_CONTROL
    lda #VIC_CSEL
    sta VIC_CONTROL2
    lda #(SCREEN&$3fff)/$40|(BITMAP&$3fff)/$400
    sta VIC_MEMORY
    ldx #0
  b1:
    lda DTV_PALETTE_DEFAULT,x
    sta DTV_PALETTE,x
    inx
    cpx #$10
    bne b1
    lda #BLACK
    sta BGCOL
    sta BORDERCOL
    lda #<SCREEN
    sta ch
    lda #>SCREEN
    sta ch+1
    lda #0
    sta cy
  b2:
    ldx #0
  b3:
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
    bne b3
    inc cy
    lda cy
    cmp #$19
    bne b2
    jsr bitmap_init
    jsr bitmap_clear
    lda #0
    sta l
  b4:
    ldy l
    lda lines_x,y
    sta bitmap_line.x0
    lda lines_x+1,y
    sta bitmap_line.x1
    lda lines_y,y
    sta bitmap_line.y0
    ldx l
    ldy lines_y+1,x
    jsr bitmap_line
    inc l
    lda l
    cmp #lines_cnt
    bcc b4
    lda #0
    sta dtv_control
    jsr mode_ctrl
    rts
    lines_x: .byte 0, $ff, $ff, 0, 0, $80, $ff, $80, 0, $80
    lines_y: .byte 0, 0, $c7, $c7, 0, 0, $64, $c7, $64, 0
}
bitmap_line: {
    .label xd = 8
    .label yd = 7
    .label x0 = 9
    .label x1 = $c
    .label y0 = $b
    lda x0
    cmp x1
    bcc b1
    sec
    sbc x1
    sta xd
    tya
    cmp y0
    beq !+
    bcs b2
  !:
    tya
    eor #$ff
    sec
    adc y0
    sta yd
    cmp xd
    bcc b3
    sty bitmap_line_ydxi.y
    ldx x1
    jsr bitmap_line_ydxi
  breturn:
    rts
  b3:
    lda x1
    sta bitmap_line_xdyi.x
    sty bitmap_line_xdyi.y
    jsr bitmap_line_xdyi
    jmp breturn
  b2:
    tya
    sec
    sbc y0
    sta yd
    cmp xd
    bcc b6
    lda y0
    sta bitmap_line_ydxd.y
    ldx x0
    sty bitmap_line_ydxd.y1
    jsr bitmap_line_ydxd
    jmp breturn
  b6:
    lda x1
    sta bitmap_line_xdyd.x
    sty bitmap_line_xdyd.y
    lda x0
    sta bitmap_line_xdyd.x1
    jsr bitmap_line_xdyd
    jmp breturn
  b1:
    lda x1
    sec
    sbc x0
    sta xd
    tya
    cmp y0
    beq !+
    bcs b9
  !:
    tya
    eor #$ff
    sec
    adc y0
    sta yd
    cmp xd
    bcc b10
    sty bitmap_line_ydxd.y
    ldx x1
    jsr bitmap_line_ydxd
    jmp breturn
  b10:
    lda x0
    sta bitmap_line_xdyd.x
    jsr bitmap_line_xdyd
    jmp breturn
  b9:
    tya
    sec
    sbc y0
    sta yd
    cmp xd
    bcc b13
    lda y0
    sta bitmap_line_ydxi.y
    ldx x0
    sty bitmap_line_ydxi.y1
    jsr bitmap_line_ydxi
    jmp breturn
  b13:
    lda x0
    sta bitmap_line_xdyi.x
    lda x1
    sta bitmap_line_xdyi.x1
    jsr bitmap_line_xdyi
    jmp breturn
}
bitmap_line_xdyi: {
    .label x = $a
    .label y = $b
    .label x1 = 9
    .label xd = 8
    .label yd = 7
    .label e = $c
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
bitmap_plot: {
    .label _0 = 2
    .label plotter_x = 2
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
bitmap_line_ydxi: {
    .label y = $a
    .label y1 = $b
    .label yd = 7
    .label xd = 8
    .label e = 9
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
bitmap_line_xdyd: {
    .label x = $a
    .label y = $b
    .label x1 = $c
    .label xd = 8
    .label yd = 7
    .label e = 9
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
bitmap_line_ydxd: {
    .label y = $a
    .label y1 = $b
    .label yd = 7
    .label xd = 8
    .label e = 9
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
bitmap_clear: {
    .label bitmap = 2
    .label y = 4
    .label _3 = 2
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
bitmap_init: {
    .label _6 = 4
    .label yoffs = 2
    ldy #$80
    ldx #0
  b1:
    txa
    and #$f8
    sta bitmap_plot_xlo,x
    lda #>mode_stdbitmap.BITMAP
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
mode_mcchar: {
    .label SCREEN = $8000
    .label CHARSET = $9000
    .label COLORS = $d800
    .label _28 = 7
    .label col = 2
    .label ch = 5
    .label cy = 4
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
    lda #VIC_CSEL|VIC_MCM
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
    sta BORDERCOL
    lda #BLACK
    sta BGCOL1
    lda #GREEN
    sta BGCOL2
    lda #BLUE
    sta BGCOL3
    lda #<SCREEN
    sta ch
    lda #>SCREEN
    sta ch+1
    lda #<COLORS
    sta col
    lda #>COLORS
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
    lda #$f
    and cy
    asl
    asl
    asl
    asl
    sta _28
    txa
    and #$f
    ora _28
    ldy #0
    sta (ch),y
    inc ch
    bne !+
    inc ch+1
  !:
    inx
    cpx #$28
    bne b3
    inc cy
    lda cy
    cmp #$19
    bne b2
    lda #0
    sta dtv_control
    jsr mode_ctrl
    rts
}
mode_ecmchar: {
    .label SCREEN = $8000
    .label CHARSET = $9000
    .label COLORS = $d800
    .label _28 = 7
    .label col = 2
    .label ch = 5
    .label cy = 4
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
    lda #VIC_DEN|VIC_RSEL|VIC_ECM|3
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
    sta BORDERCOL
    sta BGCOL1
    lda #2
    sta BGCOL2
    lda #5
    sta BGCOL3
    lda #6
    sta BGCOL4
    lda #<SCREEN
    sta ch
    lda #>SCREEN
    sta ch+1
    lda #<COLORS
    sta col
    lda #>COLORS
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
    lda #$f
    and cy
    asl
    asl
    asl
    asl
    sta _28
    txa
    and #$f
    ora _28
    ldy #0
    sta (ch),y
    inc ch
    bne !+
    inc ch+1
  !:
    inx
    cpx #$28
    bne b3
    inc cy
    lda cy
    cmp #$19
    bne b2
    lda #0
    sta dtv_control
    jsr mode_ctrl
    rts
}
mode_stdchar: {
    .label SCREEN = $8000
    .label CHARSET = $9000
    .label COLORS = $d800
    .label _27 = 7
    .label col = 2
    .label ch = 5
    .label cy = 4
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
    lda #<SCREEN
    sta ch
    lda #>SCREEN
    sta ch+1
    lda #<COLORS
    sta col
    lda #>COLORS
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
    lda #$f
    and cy
    asl
    asl
    asl
    asl
    sta _27
    txa
    and #$f
    ora _27
    ldy #0
    sta (ch),y
    inc ch
    bne !+
    inc ch+1
  !:
    inx
    cpx #$28
    bne b3
    inc cy
    lda cy
    cmp #$19
    bne b2
    lda #0
    sta dtv_control
    jsr mode_ctrl
    rts
}
print_str_lines: {
    .label str = 2
    lda #<menu.SCREEN
    sta print_line_cursor
    lda #>menu.SCREEN
    sta print_line_cursor+1
    lda #<menu.SCREEN
    sta print_char_cursor
    lda #>menu.SCREEN
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
    lda #<menu.SCREEN
    sta sc
    lda #>menu.SCREEN
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
    cmp #>menu.SCREEN+$3e8
    bne b1
    lda sc
    cmp #<menu.SCREEN+$3e8
    bne b1
    rts
}
print_set_screen: {
    rts
}
  DTV_PALETTE_DEFAULT: .byte 0, $f, $36, $be, $58, $db, $86, $ff, $29, $26, $3b, 5, 7, $df, $9a, $a
  keyboard_matrix_row_bitmask: .byte $fe, $fd, $fb, $f7, $ef, $df, $bf, $7f
  keyboard_matrix_col_bitmask: .byte 1, 2, 4, 8, $10, $20, $40, $80
  bitmap_plot_xlo: .fill $100, 0
  bitmap_plot_xhi: .fill $100, 0
  bitmap_plot_ylo: .fill $100, 0
  bitmap_plot_yhi: .fill $100, 0
  bitmap_plot_bit: .fill $100, 0
  MENU_TEXT: .text "C64DTV Graphics Modes            CCLHBME@"+"                                 OHIIMCC@"+"                                 LUNCMMM@"+"----------------------------------------@"+"1. Standard Char             (V) 0000000@"+"2. Extended Color Char       (V) 0000001@"+"3. Multicolor Char           (V) 0000010@"+"4. Standard Bitmap           (V) 0000100@"+"5. Multicolor Bitmap         (V) 0000110@"+"6. High Color Standard Char  (H) 0001000@"+"7. High Extended Color Char  (H) 0001001@"+"8. High Multicolor Char      (H) 0001010@"+"9. High Multicolor Bitmap    (H) 0001110@"+"a. Sixs Fred 2               (D) 0010111@"+"b. Two Plane Bitmap          (D) 0011101@"+"c. Sixs Fred (2 Plane MC BM) (D) 0011111@"+"d. 8bpp Pixel Cell           (D) 0111011@"+"e. Chunky 8bpp Bitmap        (D) 1111011@"+"----------------------------------------@"+"    (V) vicII (H) vicII+hicol (D) c64dtv@"+"@"
