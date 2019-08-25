// Illustrates a problem with a missing fragment - pbuc1_derefidx_vwuz1=vbuz2
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SPRITES_XMSB = $d010
  .label SPRITES_ENABLE = $d015
  .label SPRITES_EXPAND_Y = $d017
  .label SPRITES_MC = $d01c
  .label SPRITES_EXPAND_X = $d01d
  .label BORDERCOL = $d020
  .label BGCOL1 = $d021
  .label BGCOL2 = $d022
  .label BGCOL3 = $d023
  .label BGCOL4 = $d024
  .label SPRITES_COLS = $d027
  .label D018 = $d018
  // The colors of the C64
  .const BLACK = 0
  .const WHITE = 1
  .const RED = 2
  .const GREEN = 5
  .const BLUE = 6
  .const YELLOW = 7
  .label screen = $400
  .label charset = $2000
  .label tileset = $2800
  .label colors = $d800
  .label level_address = $3000
main: {
    .label y = 3
    .label x = 2
    jsr init
    lda #0
    sta.z x
  b1:
    lda.z x
    cmp #$10
    bcc b4
  b5:
    jmp b5
  b4:
    lda #0
    sta.z y
  b2:
    lda.z y
    cmp #9
    bcc b3
    inc.z x
    jmp b1
  b3:
    lda.z x
    clc
    adc.z y
    tay
    lda level_address,y
    ldy.z x
    ldx.z y
    jsr draw_block
    inc.z y
    jmp b2
}
// draw_block(byte register(A) tileno, byte register(Y) x, byte register(X) y)
draw_block: {
    .label tileno = 6
    .label x1 = $15
    .label z = 4
    .label z_1 = $15
    .label _11 = 7
    .label _12 = 9
    .label _13 = $b
    .label _14 = $d
    .label _15 = $f
    .label _16 = $11
    .label _17 = $13
    .label _18 = $15
    asl
    asl
    sta.z tileno
    tya
    asl
    sta.z x1
    lda #0
    rol
    sta.z x1+1
    txa
    asl
    tax
    jsr mul8u
    lda.z z_1
    clc
    adc.z z
    sta.z z_1
    lda.z z_1+1
    adc.z z+1
    sta.z z_1+1
    ldy.z tileno
    ldx tileset,y
    lda.z z_1
    clc
    adc #<screen
    sta.z _11
    lda.z z_1+1
    adc #>screen
    sta.z _11+1
    txa
    ldy #0
    sta (_11),y
    lda.z z_1
    clc
    adc #<colors
    sta.z _12
    lda.z z_1+1
    adc #>colors
    sta.z _12+1
    lda #YELLOW
    sta (_12),y
    lda.z z_1
    clc
    adc #<screen+1
    sta.z _13
    lda.z z_1+1
    adc #>screen+1
    sta.z _13+1
    lda #1
    sta (_13),y
    lda.z z_1
    clc
    adc #<colors+1
    sta.z _14
    lda.z z_1+1
    adc #>colors+1
    sta.z _14+1
    lda #YELLOW
    sta (_14),y
    lda.z z_1
    clc
    adc #<screen+$28
    sta.z _15
    lda.z z_1+1
    adc #>screen+$28
    sta.z _15+1
    lda #2
    sta (_15),y
    lda.z z_1
    clc
    adc #<colors+$28
    sta.z _16
    lda.z z_1+1
    adc #>colors+$28
    sta.z _16+1
    lda #YELLOW
    sta (_16),y
    lda.z z_1
    clc
    adc #<screen+$29
    sta.z _17
    lda.z z_1+1
    adc #>screen+$29
    sta.z _17+1
    lda #3
    sta (_17),y
    clc
    lda.z _18
    adc #<colors+$29
    sta.z _18
    lda.z _18+1
    adc #>colors+$29
    sta.z _18+1
    lda #YELLOW
    sta (_18),y
    rts
}
// Perform binary multiplication of two unsigned 8-bit bytes into a 16-bit unsigned word
// mul8u(byte register(X) a)
mul8u: {
    .const b = $28
    .label mb = 7
    .label res = 4
    .label return = 4
    lda #<b
    sta.z mb
    lda #>b
    sta.z mb+1
    lda #<0
    sta.z res
    sta.z res+1
  b1:
    cpx #0
    bne b2
    rts
  b2:
    txa
    and #1
    cmp #0
    beq b3
    lda.z res
    clc
    adc.z mb
    sta.z res
    lda.z res+1
    adc.z mb+1
    sta.z res+1
  b3:
    txa
    lsr
    tax
    asl.z mb
    rol.z mb+1
    jmp b1
}
init: {
    .const toD0181_return = (>(screen&$3fff)*4)|(>charset)/4&$f
    jsr init_sprites
    ldx #0
    lda #<screen
    sta.z memset.str
    lda #>screen
    sta.z memset.str+1
    jsr memset
    ldx #BLACK
    lda #<colors
    sta.z memset.str
    lda #>colors
    sta.z memset.str+1
    jsr memset
    lda #toD0181_return
    sta D018
    lda #$5b
    sta $d011
    lda #BLACK
    sta BORDERCOL
    sta BGCOL1
    lda #RED
    sta BGCOL2
    lda #BLUE
    sta BGCOL3
    lda #GREEN
    sta BGCOL4
    rts
}
// Copies the character c (an unsigned char) to the first num characters of the object pointed to by the argument str.
// memset(void* zeropage(4) str, byte register(X) c)
memset: {
    .label end = $15
    .label dst = 4
    .label str = 4
    lda.z str
    clc
    adc #<$3e8
    sta.z end
    lda.z str+1
    adc #>$3e8
    sta.z end+1
  b2:
    lda.z dst+1
    cmp.z end+1
    bne b3
    lda.z dst
    cmp.z end
    bne b3
    rts
  b3:
    txa
    ldy #0
    sta (dst),y
    inc.z dst
    bne !+
    inc.z dst+1
  !:
    jmp b2
}
init_sprites: {
    lda #1
    sta SPRITES_ENABLE
    // one sprite enabled
    lda #0
    sta SPRITES_EXPAND_X
    sta SPRITES_EXPAND_Y
    sta SPRITES_XMSB
    lda #WHITE
    sta SPRITES_COLS
    lda #0
    sta SPRITES_MC
    rts
}
