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
    sta x
  b1:
    lda #0
    sta y
  b2:
    lda x
    clc
    adc y
    tay
    lda level_address,y
    ldy x
    ldx y
    jsr draw_block
    inc y
    lda y
    cmp #9
    bcc b2
    inc x
    lda x
    cmp #$10
    bcc b1
  b4:
    jmp b4
}
// draw_block(byte register(A) tileno, byte register(Y) x, byte register(X) y)
draw_block: {
    .label tileno = $a
    .label x1 = $b
    .label z = 4
    .label z_1 = $b
    .label _11 = $d
    .label _12 = $f
    .label _13 = $11
    .label _14 = $13
    .label _15 = $15
    .label _16 = $17
    .label _17 = $19
    .label _18 = $b
    asl
    asl
    sta tileno
    tya
    asl
    sta x1
    lda #0
    rol
    sta x1+1
    txa
    asl
    tax
    jsr mul8u
    lda z_1
    clc
    adc z
    sta z_1
    lda z_1+1
    adc z+1
    sta z_1+1
    ldy tileno
    ldx tileset,y
    lda z_1
    clc
    adc #<screen
    sta _11
    lda z_1+1
    adc #>screen
    sta _11+1
    txa
    ldy #0
    sta (_11),y
    lda z_1
    clc
    adc #<colors
    sta _12
    lda z_1+1
    adc #>colors
    sta _12+1
    lda #YELLOW
    sta (_12),y
    lda z_1
    clc
    adc #<screen+1
    sta _13
    lda z_1+1
    adc #>screen+1
    sta _13+1
    lda #1
    sta (_13),y
    lda z_1
    clc
    adc #<colors+1
    sta _14
    lda z_1+1
    adc #>colors+1
    sta _14+1
    lda #YELLOW
    sta (_14),y
    lda z_1
    clc
    adc #<screen+$28
    sta _15
    lda z_1+1
    adc #>screen+$28
    sta _15+1
    lda #2
    sta (_15),y
    lda z_1
    clc
    adc #<colors+$28
    sta _16
    lda z_1+1
    adc #>colors+$28
    sta _16+1
    lda #YELLOW
    sta (_16),y
    lda z_1
    clc
    adc #<screen+$29
    sta _17
    lda z_1+1
    adc #>screen+$29
    sta _17+1
    lda #3
    sta (_17),y
    clc
    lda _18
    adc #<colors+$29
    sta _18
    lda _18+1
    adc #>colors+$29
    sta _18+1
    lda #YELLOW
    sta (_18),y
    rts
}
// Perform binary multiplication of two unsigned 8-bit bytes into a 16-bit unsigned word
// mul8u(byte register(X) a)
mul8u: {
    .const b = $28
    .label mb = 6
    .label res = 4
    .label return = 4
    lda #<b
    sta mb
    lda #>b
    sta mb+1
    lda #<0
    sta res
    sta res+1
  b1:
    cpx #0
    bne b2
    rts
  b2:
    txa
    and #1
    cmp #0
    beq b3
    lda res
    clc
    adc mb
    sta res
    lda res+1
    adc mb+1
    sta res+1
  b3:
    txa
    lsr
    tax
    asl mb
    rol mb+1
    jmp b1
}
init: {
    .const toD0181_return = (>(screen&$3fff)*4)|(>charset)/4&$f
    jsr init_sprites
    ldx #0
    lda #<screen
    sta memset.str
    lda #>screen
    sta memset.str+1
    jsr memset
    ldx #BLACK
    lda #<colors
    sta memset.str
    lda #>colors
    sta memset.str+1
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
// memset(void* zeropage(8) str, byte register(X) c)
memset: {
    .label end = $1b
    .label dst = 8
    .label str = 8
    lda str
    clc
    adc #<$3e8
    sta end
    lda str+1
    adc #>$3e8
    sta end+1
  b1:
    txa
    ldy #0
    sta (dst),y
    inc dst
    bne !+
    inc dst+1
  !:
    lda dst+1
    cmp end+1
    bne b1
    lda dst
    cmp end
    bne b1
    rts
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
