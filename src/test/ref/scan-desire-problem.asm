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
    .label tileno = 8
    .label x1 = 9
    .label z = 4
    .label z_1 = 9
    asl
    asl
    sta tileno
    tya
    asl
    sta x1
    lda #0
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
    lda tileset,y
    sta !v++1
    lda #<screen
    clc
    adc z_1
    sta !a++1
    lda #>screen
    adc z_1+1
    sta !a++2
  !v:
    lda #0
  !a:
    sta screen
    lda #<colors
    clc
    adc z_1
    sta !++1
    lda #>colors
    adc z_1+1
    sta !++2
    lda #YELLOW
  !:
    sta colors
    lda #<screen+1
    clc
    adc z_1
    sta !++1
    lda #>screen+1
    adc z_1+1
    sta !++2
    lda #1
  !:
    sta screen+1
    lda #<colors+1
    clc
    adc z_1
    sta !++1
    lda #>colors+1
    adc z_1+1
    sta !++2
    lda #YELLOW
  !:
    sta colors+1
    lda #<screen+$28
    clc
    adc z_1
    sta !++1
    lda #>screen+$28
    adc z_1+1
    sta !++2
    lda #2
  !:
    sta screen+$28
    lda #<colors+$28
    clc
    adc z_1
    sta !++1
    lda #>colors+$28
    adc z_1+1
    sta !++2
    lda #YELLOW
  !:
    sta colors+$28
    lda #<screen+$29
    clc
    adc z_1
    sta !++1
    lda #>screen+$29
    adc z_1+1
    sta !++2
    lda #3
  !:
    sta screen+$29
    lda #<colors+$29
    clc
    adc z_1
    sta !++1
    lda #>colors+$29
    adc z_1+1
    sta !++2
    lda #YELLOW
  !:
    sta colors+$29
    rts
}
// Perform binary multiplication of two unsigned 8-bit bytes into a 16-bit unsigned word
// mul8u(byte register(X) a)
mul8u: {
    .const b = $28
    .label mb = 6
    .label res = 4
    .label return = 4
    lda #b
    sta mb
    lda #0
    sta mb+1
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
    sta fill.addr
    lda #>screen
    sta fill.addr+1
    jsr fill
    ldx #BLACK
    lda #<colors
    sta fill.addr
    lda #>colors
    sta fill.addr+1
    jsr fill
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
// Fill some memory with a value
// fill(byte register(X) val)
fill: {
    .label end = 6
    .label addr = 4
    lda addr
    clc
    adc #<$3e8
    sta end
    lda addr+1
    adc #>$3e8
    sta end+1
  b1:
    txa
    ldy #0
    sta (addr),y
    inc addr
    bne !+
    inc addr+1
  !:
    lda addr+1
    cmp end+1
    bne b1
    lda addr
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
