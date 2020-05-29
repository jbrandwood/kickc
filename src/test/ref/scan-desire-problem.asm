// Illustrates a problem with a missing fragment - pbuc1_derefidx_vwuz1=vbuz2
// Commodore 64 Registers and Constants
// The MOS 6526 Complex Interface Adapter (CIA)
// http://archive.6502.org/datasheets/mos_6526_cia_recreated.pdf
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  // The colors of the C64
  .const BLACK = 0
  .const WHITE = 1
  .const RED = 2
  .const GREEN = 5
  .const BLUE = 6
  .const YELLOW = 7
  .label SPRITES_XMSB = $d010
  .label SPRITES_COLOR = $d027
  .label SPRITES_ENABLE = $d015
  .label SPRITES_EXPAND_Y = $d017
  .label SPRITES_MC = $d01c
  .label SPRITES_EXPAND_X = $d01d
  .label BORDER_COLOR = $d020
  .label BG_COLOR = $d021
  .label BG_COLOR1 = $d022
  .label BG_COLOR2 = $d023
  .label BG_COLOR3 = $d024
  .label D018 = $d018
  .label screen = $400
  .label charset = $2000
  .label tileset = $2800
  .label colors = $d800
  .label level_address = $3000
main: {
    .label y = 3
    .label x = 2
    // init()
    jsr init
    lda #0
    sta.z x
  __b1:
    // for (byte x = 0; x < 16; x++ )
    lda.z x
    cmp #$10
    bcc __b4
  __b5:
    jmp __b5
  __b4:
    lda #0
    sta.z y
  __b2:
    // for (byte y = 0; y < 9; y++)
    lda.z y
    cmp #9
    bcc __b3
    // for (byte x = 0; x < 16; x++ )
    inc.z x
    jmp __b1
  __b3:
    // z = x+y
    lda.z x
    clc
    adc.z y
    // tile = level_address[z]
    tax
    ldy level_address,x
    // draw_block(tile,x,y,YELLOW)
    ldx.z x
    jsr draw_block
    // for (byte y = 0; y < 9; y++)
    inc.z y
    jmp __b2
}
// draw_block(byte register(Y) tileno, byte register(X) x, byte zp(3) y)
draw_block: {
    .label y = 3
    .label x1 = $14
    .label z = 4
    .label z_1 = $14
    .label __11 = 6
    .label __12 = 8
    .label __13 = $a
    .label __14 = $c
    .label __15 = $e
    .label __16 = $10
    .label __17 = $12
    .label __18 = $14
    // tileno = tileno << 2
    tya
    asl
    asl
    tay
    // x1 = x << 1
    txa
    asl
    sta.z x1
    lda #0
    rol
    sta.z x1+1
    // y = y << 1
    lda.z y
    asl
    // mul8u(y,40)
    tax
    jsr mul8u
    // mul8u(y,40)
    // z = mul8u(y,40)
    // z = z + x1
    lda.z z_1
    clc
    adc.z z
    sta.z z_1
    lda.z z_1+1
    adc.z z+1
    sta.z z_1+1
    // drawtile = tileset[tileno]
    ldx tileset,y
    // screen[z] = drawtile
    lda.z z_1
    clc
    adc #<screen
    sta.z __11
    lda.z z_1+1
    adc #>screen
    sta.z __11+1
    txa
    ldy #0
    sta (__11),y
    // colors[z] = YELLOW
    lda.z z_1
    clc
    adc #<colors
    sta.z __12
    lda.z z_1+1
    adc #>colors
    sta.z __12+1
    lda #YELLOW
    sta (__12),y
    // screen[z+1] = 1
    lda.z z_1
    clc
    adc #<screen+1
    sta.z __13
    lda.z z_1+1
    adc #>screen+1
    sta.z __13+1
    lda #1
    sta (__13),y
    // colors[z+1] = YELLOW
    lda.z z_1
    clc
    adc #<colors+1
    sta.z __14
    lda.z z_1+1
    adc #>colors+1
    sta.z __14+1
    lda #YELLOW
    sta (__14),y
    // screen[z+40] = 2
    lda.z z_1
    clc
    adc #<screen+$28
    sta.z __15
    lda.z z_1+1
    adc #>screen+$28
    sta.z __15+1
    lda #2
    sta (__15),y
    // colors[z+40] = YELLOW
    lda.z z_1
    clc
    adc #<colors+$28
    sta.z __16
    lda.z z_1+1
    adc #>colors+$28
    sta.z __16+1
    lda #YELLOW
    sta (__16),y
    // screen[z+41] = 3
    lda.z z_1
    clc
    adc #<screen+$29
    sta.z __17
    lda.z z_1+1
    adc #>screen+$29
    sta.z __17+1
    lda #3
    sta (__17),y
    // colors[z+41] = YELLOW
    clc
    lda.z __18
    adc #<colors+$29
    sta.z __18
    lda.z __18+1
    adc #>colors+$29
    sta.z __18+1
    lda #YELLOW
    sta (__18),y
    // }
    rts
}
// Perform binary multiplication of two unsigned 8-bit chars into a 16-bit unsigned int
// mul8u(byte register(X) a)
mul8u: {
    .const b = $28
    .label mb = 6
    .label res = 4
    .label return = 4
    lda #<b
    sta.z mb
    lda #>b
    sta.z mb+1
    lda #<0
    sta.z res
    sta.z res+1
  __b1:
    // while(a!=0)
    cpx #0
    bne __b2
    // }
    rts
  __b2:
    // a&1
    txa
    and #1
    // if( (a&1) != 0)
    cmp #0
    beq __b3
    // res = res + mb
    lda.z res
    clc
    adc.z mb
    sta.z res
    lda.z res+1
    adc.z mb+1
    sta.z res+1
  __b3:
    // a = a>>1
    txa
    lsr
    tax
    // mb = mb<<1
    asl.z mb
    rol.z mb+1
    jmp __b1
}
init: {
    .const toD0181_return = (>(screen&$3fff)*4)|(>charset)/4&$f
    // init_sprites()
    jsr init_sprites
    // memset(screen, 0, 1000)
    ldx #0
    lda #<screen
    sta.z memset.str
    lda #>screen
    sta.z memset.str+1
    jsr memset
    // memset(colors, BLACK, 1000)
    ldx #BLACK
    lda #<colors
    sta.z memset.str
    lda #>colors
    sta.z memset.str+1
    jsr memset
    // *D018 = toD018(screen, charset)
    lda #toD0181_return
    sta D018
    // asm
    lda #$5b
    sta $d011
    // *BORDER_COLOR = BLACK
    lda #BLACK
    sta BORDER_COLOR
    // *BG_COLOR = BLACK
    sta BG_COLOR
    // *BG_COLOR1 = RED
    lda #RED
    sta BG_COLOR1
    // *BG_COLOR2 = BLUE
    lda #BLUE
    sta BG_COLOR2
    // *BG_COLOR3 = GREEN
    lda #GREEN
    sta BG_COLOR3
    // }
    rts
}
// Copies the character c (an unsigned char) to the first num characters of the object pointed to by the argument str.
// memset(void* zp(4) str, byte register(X) c)
memset: {
    .label end = $14
    .label dst = 4
    .label str = 4
    // end = (char*)str + num
    lda.z str
    clc
    adc #<$3e8
    sta.z end
    lda.z str+1
    adc #>$3e8
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
    txa
    ldy #0
    sta (dst),y
    // for(char* dst = str; dst!=end; dst++)
    inc.z dst
    bne !+
    inc.z dst+1
  !:
    jmp __b2
}
init_sprites: {
    // *SPRITES_ENABLE = %00000001
    lda #1
    sta SPRITES_ENABLE
    // *SPRITES_EXPAND_X = 0
    // one sprite enabled
    lda #0
    sta SPRITES_EXPAND_X
    // *SPRITES_EXPAND_Y = 0
    sta SPRITES_EXPAND_Y
    // *SPRITES_XMSB = 0
    sta SPRITES_XMSB
    // *SPRITES_COLOR = WHITE
    lda #WHITE
    sta SPRITES_COLOR
    // *SPRITES_MC = 0
    lda #0
    sta SPRITES_MC
    // }
    rts
}
