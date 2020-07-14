// A full-screen x/y-scroller
// World space is a 16-bit signed coordinate system [-32768, 32767] x [-32768, 32767]
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  // The colors of the C64
  .const BLACK = 0
  .const WHITE = 1
  // The number of sinus values in the table
  .const SINSIZE = $800
  .const OFFSET_STRUCT_MOS6569_VICII_MEMORY = $18
  .const OFFSET_STRUCT_MOS6569_VICII_RASTER = $12
  .const OFFSET_STRUCT_MOS6569_VICII_BORDER_COLOR = $20
  .const OFFSET_STRUCT_MOS6569_VICII_CONTROL1 = $11
  .const OFFSET_STRUCT_MOS6569_VICII_CONTROL2 = $16
  // The VIC-II MOS 6567/6569
  .label VICII = $d000
  // Display screen #0 (double buffered)
  .label MAIN_SCREEN0 = $3800
  // Display screen #1 (double buffered)
  .label MAIN_SCREEN1 = $3c00
  // Display charset
  .label MAIN_CHARSET = $1000
  // The current screen displayed (0/1)
  .label screen = 2
  // Current index into the sinus
  .label x_sin_idx = 9
  .label y_sin_idx = $b
  // Current x/y-position (the center of the screen)
  .label x_pos = $16
  .label y_pos = $18
  // The current scroll fine values [0-7] (converted to unsigned)
  .label x_pos_fine = $1a
  // The current scroll coarse values (converted to unsigned)
  .label x_pos_coarse = $16
  .label y_pos_fine = $1b
  .label y_pos_coarse = $18
main: {
    .const toD0181_return = (>(MAIN_SCREEN0&$3fff)*4)|(>MAIN_CHARSET)/4&$f
    .const toD0182_return = (>(MAIN_SCREEN1&$3fff)*4)|(>MAIN_CHARSET)/4&$f
    .const toD0183_return = (>(MAIN_SCREEN0&$3fff)*4)|(>MAIN_CHARSET)/4&$f
    .label __5 = $f
    .label __9 = $d
    .label __13 = 3
    .label __45 = $13
    .label __48 = $1b
    .label x_pos_coarse_old = $d
    .label y_pos_coarse_old = $f
    .label y_movement = $11
    .label x_movement = $12
    .label screen_active = 3
    .label screen_hidden = 7
    .label petscii1 = 5
    .label scrn1 = $14
    .label petscii = 5
    .label petscii3 = 5
    .label scrn3 = 7
    .label petscii2 = 5
    .label scrn2 = 7
    // asm
    sei
    // memset(MAIN_SCREEN0, ' ', 1000)
  // Clear screen
    jsr memset
    // VICII->MEMORY = toD018(MAIN_SCREEN0, MAIN_CHARSET)
    // Display initial screen
    lda #toD0181_return
    sta VICII+OFFSET_STRUCT_MOS6569_VICII_MEMORY
    // next_position()
  // Find initial position
    lda #<SINSIZE/4
    sta.z y_sin_idx
    lda #>SINSIZE/4
    sta.z y_sin_idx+1
    lda #<0
    sta.z x_sin_idx
    sta.z x_sin_idx+1
    jsr next_position
    lda #0
    sta.z screen
  __b1:
    // x_pos_coarse_old = x_pos_coarse
    // The old coarse values x/y-positions
    lda.z x_pos_coarse
    sta.z x_pos_coarse_old
    lda.z x_pos_coarse+1
    sta.z x_pos_coarse_old+1
    // y_pos_coarse_old = y_pos_coarse
    lda.z y_pos_coarse
    sta.z y_pos_coarse_old
    lda.z y_pos_coarse+1
    sta.z y_pos_coarse_old+1
    // next_position()
  // Update the position
    jsr next_position
    // y_pos_coarse_old-y_pos_coarse
    lda.z __5
    sec
    sbc.z y_pos_coarse
    sta.z __5
    lda.z __5+1
    sbc.z y_pos_coarse+1
    sta.z __5+1
    // y_movement = (signed char)(y_pos_coarse_old-y_pos_coarse)
    // Detect the need for coarse scrolling (moving chars on the entire screen) and the direction of the scroll 
    // Movement is the offset that the screen data should be moved (-40: down, 40: up, -1: right, 1: left, 0: none)
    lda.z __5
    sta.z y_movement
    // if(y_movement==1)
    lda #1
    cmp.z y_movement
    beq __b20
    // if(y_movement==-1)
    lda #-1
    cmp.z y_movement
    bne __b19
    ldx #$28
    jmp __b2
  __b19:
    ldx #0
    jmp __b2
  __b20:
    ldx #-$28
  __b2:
    // x_pos_coarse_old-x_pos_coarse
    lda.z __9
    sec
    sbc.z x_pos_coarse
    sta.z __9
    lda.z __9+1
    sbc.z x_pos_coarse+1
    sta.z __9+1
    // x_movement = (signed char)(x_pos_coarse_old-x_pos_coarse)
    lda.z __9
    sta.z x_movement
    // movement -= x_movement
    // will be -1/0/1
    txa
    sec
    sbc.z x_movement
    tax
    // if(movement)
    cpx #0
    bne !__b21+
    jmp __b21
  !__b21:
    // screen?MAIN_SCREEN1:MAIN_SCREEN0
    lda #0
    cmp.z screen
    bne __b3
    lda #<MAIN_SCREEN0
    sta.z __13
    lda #>MAIN_SCREEN0
    sta.z __13+1
    jmp __b4
  __b3:
    // screen?MAIN_SCREEN1:MAIN_SCREEN0
    lda #<MAIN_SCREEN1
    sta.z __13
    lda #>MAIN_SCREEN1
    sta.z __13+1
  __b4:
    // screen_active = (screen?MAIN_SCREEN1:MAIN_SCREEN0) + movement
    txa
    pha
    clc
    adc.z screen_active
    sta.z screen_active
    pla
    ora #$7f
    bmi !+
    lda #0
  !:
    adc.z screen_active+1
    sta.z screen_active+1
    // screen?MAIN_SCREEN0:MAIN_SCREEN1
    lda #0
    cmp.z screen
    bne __b5
    lda #<MAIN_SCREEN1
    sta.z screen_hidden
    lda #>MAIN_SCREEN1
    sta.z screen_hidden+1
    jmp __b6
  __b5:
    // screen?MAIN_SCREEN0:MAIN_SCREEN1
    lda #<MAIN_SCREEN0
    sta.z screen_hidden
    lda #>MAIN_SCREEN0
    sta.z screen_hidden+1
  __b6:
    // screencpy(screen_hidden, screen_active)
    jsr screencpy
    // if(y_movement==-1)
    // Update any new row if needed
    lda #-1
    cmp.z y_movement
    bne !__b7+
    jmp __b7
  !__b7:
    // if(y_movement==1)
    lda #1
    cmp.z y_movement
    bne __b10
    // petscii_ptr(x_pos_coarse-20, y_pos_coarse-12)
    sec
    lda.z x_pos_coarse
    sbc #$14
    sta.z petscii_ptr.row_x
    lda.z x_pos_coarse+1
    sbc #0
    sta.z petscii_ptr.row_x+1
    sec
    lda.z y_pos_coarse
    sbc #$c
    sta.z petscii_ptr.row_y
    lda.z y_pos_coarse+1
    sbc #0
    sta.z petscii_ptr.row_y+1
    jsr petscii_ptr
    // petscii_ptr(x_pos_coarse-20, y_pos_coarse-12)
    // petscii = petscii_ptr(x_pos_coarse-20, y_pos_coarse-12)
    ldy #0
  __b8:
    // for(char i=0;i<40;i++)
    cpy #$28
    bcs !__b9+
    jmp __b9
  !__b9:
  __b10:
    // if(x_movement==-1)
    // Update any new column if needed
    lda #-1
    cmp.z x_movement
    bne !__b13+
    jmp __b13
  !__b13:
    // if(x_movement==1)
    lda #1
    cmp.z x_movement
    bne __b16
    // petscii_ptr(x_pos_coarse-20, y_pos_coarse-12)
    sec
    lda.z x_pos_coarse
    sbc #$14
    sta.z petscii_ptr.row_x
    lda.z x_pos_coarse+1
    sbc #0
    sta.z petscii_ptr.row_x+1
    sec
    lda.z y_pos_coarse
    sbc #$c
    sta.z petscii_ptr.row_y
    lda.z y_pos_coarse+1
    sbc #0
    sta.z petscii_ptr.row_y+1
    jsr petscii_ptr
    // petscii_ptr(x_pos_coarse-20, y_pos_coarse-12)
    // petscii = petscii_ptr(x_pos_coarse-20, y_pos_coarse-12)
    ldx #0
  __b14:
    // for(char i=0;i<25;i++)
    cpx #$19
    bcc __b15
  __b16:
    // screen ^=1
    // Change current screen
    lda #1
    eor.z screen
    sta.z screen
  __b21:
  // Update the display - wait for the raster
    // while(VICII->RASTER!=0xfe)
    lda #$fe
    cmp VICII+OFFSET_STRUCT_MOS6569_VICII_RASTER
    bne __b21
  __b24:
    // while(VICII->RASTER!=0xff)
    lda #$ff
    cmp VICII+OFFSET_STRUCT_MOS6569_VICII_RASTER
    bne __b24
    // VICII->BORDER_COLOR = WHITE
    lda #WHITE
    sta VICII+OFFSET_STRUCT_MOS6569_VICII_BORDER_COLOR
    // VICII->CONTROL1 & 0xf0
    lda #$f0
    and VICII+OFFSET_STRUCT_MOS6569_VICII_CONTROL1
    sta.z __45
    // 7-y_pos_fine
    lda #7
    sec
    sbc.z y_pos_fine
    // VICII->CONTROL1 & 0xf0 | (7-y_pos_fine)
    ora.z __45
    // VICII->CONTROL1 = VICII->CONTROL1 & 0xf0 | (7-y_pos_fine)
    // Y-scroll fine
    sta VICII+OFFSET_STRUCT_MOS6569_VICII_CONTROL1
    // VICII->CONTROL2 & 0xf0
    lda #$f0
    and VICII+OFFSET_STRUCT_MOS6569_VICII_CONTROL2
    sta.z __48
    // 7-x_pos_fine
    lda #7
    sec
    sbc.z x_pos_fine
    // VICII->CONTROL2 & 0xf0 | (7-x_pos_fine)
    ora.z __48
    // VICII->CONTROL2 = VICII->CONTROL2 & 0xf0 | (7-x_pos_fine)
    // X-scroll fine
    sta VICII+OFFSET_STRUCT_MOS6569_VICII_CONTROL2
    // if(screen)
    // Display current screen
    lda #0
    cmp.z screen
    bne __b32
    // VICII->MEMORY = toD018(MAIN_SCREEN0, MAIN_CHARSET)
    lda #toD0183_return
    sta VICII+OFFSET_STRUCT_MOS6569_VICII_MEMORY
  __b26:
    // VICII->BORDER_COLOR = BLACK
    lda #BLACK
    sta VICII+OFFSET_STRUCT_MOS6569_VICII_BORDER_COLOR
    jmp __b1
  __b32:
    // VICII->MEMORY = toD018(MAIN_SCREEN1, MAIN_CHARSET)
    lda #toD0182_return
    sta VICII+OFFSET_STRUCT_MOS6569_VICII_MEMORY
    jmp __b26
  __b15:
    // *scrn = *petscii
    ldy #0
    lda (petscii2),y
    sta (scrn2),y
    // scrn += 40
    lda #$28
    clc
    adc.z scrn2
    sta.z scrn2
    bcc !+
    inc.z scrn2+1
  !:
    // petscii += 140
    lda #$8c
    clc
    adc.z petscii2
    sta.z petscii2
    bcc !+
    inc.z petscii2+1
  !:
    // for(char i=0;i<25;i++)
    inx
    jmp __b14
  __b13:
    // petscii_ptr(x_pos_coarse+19, y_pos_coarse-12)
    lda #$13
    clc
    adc.z x_pos_coarse
    sta.z petscii_ptr.row_x
    lda #0
    adc.z x_pos_coarse+1
    sta.z petscii_ptr.row_x+1
    sec
    lda.z y_pos_coarse
    sbc #$c
    sta.z petscii_ptr.row_y
    lda.z y_pos_coarse+1
    sbc #0
    sta.z petscii_ptr.row_y+1
    jsr petscii_ptr
    // petscii_ptr(x_pos_coarse+19, y_pos_coarse-12)
    // petscii = petscii_ptr(x_pos_coarse+19, y_pos_coarse-12)
    // scrn = screen_hidden+39
    lda #$27
    clc
    adc.z scrn3
    sta.z scrn3
    bcc !+
    inc.z scrn3+1
  !:
    ldx #0
  __b17:
    // for(char i=0;i<25;i++)
    cpx #$19
    bcc __b18
    jmp __b16
  __b18:
    // *scrn = *petscii
    ldy #0
    lda (petscii3),y
    sta (scrn3),y
    // scrn += 40
    lda #$28
    clc
    adc.z scrn3
    sta.z scrn3
    bcc !+
    inc.z scrn3+1
  !:
    // petscii += 140
    lda #$8c
    clc
    adc.z petscii3
    sta.z petscii3
    bcc !+
    inc.z petscii3+1
  !:
    // for(char i=0;i<25;i++)
    inx
    jmp __b17
  __b9:
    // scrn[i] = petscii[i]
    lda (petscii),y
    sta (screen_hidden),y
    // for(char i=0;i<40;i++)
    iny
    jmp __b8
  __b7:
    // petscii_ptr(x_pos_coarse-20, y_pos_coarse+12)
    sec
    lda.z x_pos_coarse
    sbc #$14
    sta.z petscii_ptr.row_x
    lda.z x_pos_coarse+1
    sbc #0
    sta.z petscii_ptr.row_x+1
    lda #$c
    clc
    adc.z y_pos_coarse
    sta.z petscii_ptr.row_y
    lda #0
    adc.z y_pos_coarse+1
    sta.z petscii_ptr.row_y+1
    jsr petscii_ptr
    // petscii_ptr(x_pos_coarse-20, y_pos_coarse+12)
    // petscii = petscii_ptr(x_pos_coarse-20, y_pos_coarse+12)
    // scrn = screen_hidden+24*40
    lda.z screen_hidden
    clc
    adc #<$18*$28
    sta.z scrn1
    lda.z screen_hidden+1
    adc #>$18*$28
    sta.z scrn1+1
    ldy #0
  __b11:
    // for(char i=0;i<40;i++)
    cpy #$28
    bcc __b12
    jmp __b10
  __b12:
    // scrn[i] = petscii[i]
    lda (petscii1),y
    sta (scrn1),y
    // for(char i=0;i<40;i++)
    iny
    jmp __b11
}
// Copies the character c (an unsigned char) to the first num characters of the object pointed to by the argument str.
memset: {
    .const c = ' '
    .const num = $3e8
    .label str = MAIN_SCREEN0
    .label end = str+num
    .label dst = 9
    lda #<str
    sta.z dst
    lda #>str
    sta.z dst+1
  __b1:
    // for(char* dst = str; dst!=end; dst++)
    lda.z dst+1
    cmp #>end
    bne __b2
    lda.z dst
    cmp #<end
    bne __b2
    // }
    rts
  __b2:
    // *dst = c
    lda #c
    ldy #0
    sta (dst),y
    // for(char* dst = str; dst!=end; dst++)
    inc.z dst
    bne !+
    inc.z dst+1
  !:
    jmp __b1
}
// Update the x_pos, y_pos variables to reflect the next position on the curve 
// The position represents the center of the screen
next_position: {
    .label __4 = $16
    .label __8 = $18
    .label __12 = $16
    .label __13 = $18
    .label x_pos_u = $16
    .label y_pos_u = $18
    .label __18 = $16
    .label __19 = $18
    // x_sin_idx++;
    inc.z x_sin_idx
    bne !+
    inc.z x_sin_idx+1
  !:
    // if(x_sin_idx>=SINSIZE)
    lda.z x_sin_idx+1
    cmp #>SINSIZE
    bcc __b1
    bne !+
    lda.z x_sin_idx
    cmp #<SINSIZE
    bcc __b1
  !:
    // x_sin_idx-=SINSIZE
    lda.z x_sin_idx
    sec
    sbc #<SINSIZE
    sta.z x_sin_idx
    lda.z x_sin_idx+1
    sbc #>SINSIZE
    sta.z x_sin_idx+1
  __b1:
    // y_sin_idx++;
    inc.z y_sin_idx
    bne !+
    inc.z y_sin_idx+1
  !:
    // if(y_sin_idx>=SINSIZE)
    lda.z y_sin_idx+1
    cmp #>SINSIZE
    bcc __b2
    bne !+
    lda.z y_sin_idx
    cmp #<SINSIZE
    bcc __b2
  !:
    // y_sin_idx-=SINSIZE
    lda.z y_sin_idx
    sec
    sbc #<SINSIZE
    sta.z y_sin_idx
    lda.z y_sin_idx+1
    sbc #>SINSIZE
    sta.z y_sin_idx+1
  __b2:
    // x_pos = SINTAB[x_sin_idx]
    lda.z x_sin_idx
    asl
    sta.z __12
    lda.z x_sin_idx+1
    rol
    sta.z __12+1
    clc
    lda.z __18
    adc #<SINTAB
    sta.z __18
    lda.z __18+1
    adc #>SINTAB
    sta.z __18+1
    // Find the next point
    ldy #0
    lda (x_pos),y
    pha
    iny
    lda (x_pos),y
    sta.z x_pos+1
    pla
    sta.z x_pos
    // y_pos = SINTAB[y_sin_idx]
    lda.z y_sin_idx
    asl
    sta.z __13
    lda.z y_sin_idx+1
    rol
    sta.z __13+1
    clc
    lda.z __19
    adc #<SINTAB
    sta.z __19
    lda.z __19+1
    adc #>SINTAB
    sta.z __19+1
    ldy #0
    lda (y_pos),y
    pha
    iny
    lda (y_pos),y
    sta.z y_pos+1
    pla
    sta.z y_pos
    // (unsigned int)x_pos + 400
    // x_pos_u = (unsigned int)x_pos + 400 + 20*8
    clc
    lda.z x_pos_u
    adc #<$190+$14*8
    sta.z x_pos_u
    lda.z x_pos_u+1
    adc #>$190+$14*8
    sta.z x_pos_u+1
    // (unsigned char)x_pos_u & 7
    lda.z x_pos_u
    and #7
    sta.z x_pos_fine
    // x_pos_u/8
    lsr.z x_pos_coarse+1
    ror.z x_pos_coarse
    lsr.z x_pos_coarse+1
    ror.z x_pos_coarse
    lsr.z x_pos_coarse+1
    ror.z x_pos_coarse
    // (unsigned int)y_pos + 400
    // y_pos_u = (unsigned int)y_pos + 400 + 12*8
    clc
    lda.z y_pos_u
    adc #<$190+$c*8
    sta.z y_pos_u
    lda.z y_pos_u+1
    adc #>$190+$c*8
    sta.z y_pos_u+1
    // (unsigned char)y_pos_u & 7
    lda.z y_pos_u
    and #7
    sta.z y_pos_fine
    // y_pos_u/8
    lsr.z y_pos_coarse+1
    ror.z y_pos_coarse
    lsr.z y_pos_coarse+1
    ror.z y_pos_coarse
    lsr.z y_pos_coarse+1
    ror.z y_pos_coarse
    // }
    rts
}
// Copy an entire screen (40x25 = 1000 chars)
// - dst - destination
// - src - source
// screencpy(byte* zp(7) dst, byte* zp(3) src)
screencpy: {
    .label dst = 7
    .label src = 3
    .label src_250 = $26
    .label dst_250 = $1c
    .label src_500 = $1e
    .label dst_500 = $20
    .label src_750 = $22
    .label dst_750 = $24
    // src_250 = src+250
    lda #$fa
    clc
    adc.z src
    sta.z src_250
    lda #0
    adc.z src+1
    sta.z src_250+1
    // dst_250 = dst+250
    lda #$fa
    clc
    adc.z dst
    sta.z dst_250
    lda #0
    adc.z dst+1
    sta.z dst_250+1
    // src_500 = src+500
    lda.z src
    clc
    adc #<$1f4
    sta.z src_500
    lda.z src+1
    adc #>$1f4
    sta.z src_500+1
    // dst_500 = dst+500
    lda.z dst
    clc
    adc #<$1f4
    sta.z dst_500
    lda.z dst+1
    adc #>$1f4
    sta.z dst_500+1
    // src_750 = src+750
    lda.z src
    clc
    adc #<$2ee
    sta.z src_750
    lda.z src+1
    adc #>$2ee
    sta.z src_750+1
    // dst_750 = dst+750
    lda.z dst
    clc
    adc #<$2ee
    sta.z dst_750
    lda.z dst+1
    adc #>$2ee
    sta.z dst_750+1
    ldy #0
  __b1:
    // for( char i=0;i<250;i++)
    cpy #$fa
    bcc __b2
    // }
    rts
  __b2:
    // dst[i] = src[i]
    lda (src),y
    sta (dst),y
    // dst_250[i] = src_250[i]
    lda (src_250),y
    sta (dst_250),y
    // dst_500[i] = src_500[i]
    lda (src_500),y
    sta (dst_500),y
    // dst_750[i] = src_750[i]
    lda (src_750),y
    sta (dst_750),y
    // for( char i=0;i<250;i++)
    iny
    jmp __b1
}
// Get a pointer to a specific x,y-position in the PETSCII art
// petscii_ptr(word zp(5) row_x, word zp($d) row_y)
petscii_ptr: {
    .label __0 = $d
    .label __1 = $d
    .label row_x = 5
    .label row_y = $d
    .label return = 5
    .label __3 = $26
    .label __4 = $26
    .label __5 = $26
    .label __6 = $d
    // row_y * 140
    lda.z row_y
    asl
    sta.z __3
    lda.z row_y+1
    rol
    sta.z __3+1
    asl.z __3
    rol.z __3+1
    asl.z __3
    rol.z __3+1
    asl.z __3
    rol.z __3+1
    lda.z __4
    clc
    adc.z row_y
    sta.z __4
    lda.z __4+1
    adc.z row_y+1
    sta.z __4+1
    asl.z __5
    rol.z __5+1
    lda.z __6
    clc
    adc.z __5
    sta.z __6
    lda.z __6+1
    adc.z __5+1
    sta.z __6+1
    asl.z __0
    rol.z __0+1
    asl.z __0
    rol.z __0+1
    // PETSCII_ART + row_y * 140
    clc
    lda.z __1
    adc #<PETSCII_ART
    sta.z __1
    lda.z __1+1
    adc #>PETSCII_ART
    sta.z __1+1
    // PETSCII_ART + row_y * 140 + row_x
    lda.z return
    clc
    adc.z __1
    sta.z return
    lda.z return+1
    adc.z __1+1
    sta.z return+1
    // }
    rts
}
// Sinus table [-399,399]
SINTAB:
.fillword SINSIZE, 399*sin(i*2*PI/SINSIZE)

.pc = $4000 "PETSCII_ART"
// 140x125 PETSCII art
PETSCII_ART:
.var petsciiPic = LoadPicture("cml.png")
    .print "width: "+petsciiPic.width + " height: "+petsciiPic.height
    .for (var y=0; y<petsciiPic.height; y++)
        .for (var x=0; x<petsciiPic.width; x++)
            .byte petsciiPic.getPixel(x,y)==0?' ':$a0;

