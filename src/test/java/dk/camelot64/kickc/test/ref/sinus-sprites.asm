.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .const PROCPORT = 1
  .const CHARGEN = $d000
  .const SPRITES_XPOS = $d000
  .const SPRITES_YPOS = $d001
  .const SPRITES_XMSB = $d010
  .const RASTER = $d012
  .const SPRITES_ENABLE = $d015
  .const SPRITES_EXPAND_Y = $d017
  .const SPRITES_EXPAND_X = $d01d
  .const BORDERCOL = $d020
  .const SPRITES_COLS = $d027
  .const COLS = $d800
  .const memLo = $fe
  .const memHi = $ff
  .const SCREEN = $400
  .const sinlen_x = $dd
  .const sinlen_y = $c5
  .const sprites = $2000
  .label progress_idx = 4
  .label progress_cursor = $a
  .label sin_idx_x = 2
  .label sin_idx_y = 3
  jsr main
main: {
    jsr init
    lda #0
    sta sin_idx_y
    sta sin_idx_x
  b2:
    lda RASTER
    cmp #$ff
    bne b2
    jsr anim
    jmp b2
}
anim: {
    .label xidx = 4
    .label x = 8
    .label x_msb = 5
    .label j2 = 6
    .label j = 7
    inc BORDERCOL
    lda sin_idx_x
    sta xidx
    ldy sin_idx_y
    lda #0
    sta j
    lda #$c
    sta j2
    lda #0
    sta x_msb
  b1:
    ldx xidx
    lda sintab_x,x
    clc
    adc #<$1e
    sta x
    lda #>$1e
    adc #0
    sta x+1
    lda x_msb
    asl
    ora x+1
    sta x_msb
    lda x
    ldx j2
    sta SPRITES_XPOS,x
    lda sintab_y,y
    sta SPRITES_YPOS,x
    lda xidx
    clc
    adc #$a
    sta xidx
    cmp #sinlen_x
    bcc b2
    sec
    sbc #sinlen_x
    sta xidx
  b2:
    tya
    clc
    adc #8
    tay
    cpy #sinlen_y
    bcc b3
    tya
    sec
    sbc #sinlen_y
    tay
  b3:
    lda j2
    sec
    sbc #2
    sta j2
    inc j
    lda j
    cmp #7
    bne b1
    lda x_msb
    sta SPRITES_XMSB
    inc sin_idx_x
    lda sin_idx_x
    cmp #sinlen_x
    bcc b4
    lda #0
    sta sin_idx_x
  b4:
    inc sin_idx_y
    lda sin_idx_y
    cmp #sinlen_y
    bcc b5
    lda #0
    sta sin_idx_y
  b5:
    dec BORDERCOL
    rts
}
init: {
    jsr clear_screen
    ldx #0
  b1:
    lda #0
    sta COLS,x
    lda #$b
    sta COLS+$28,x
    inx
    cpx #$28
    bne b1
    jsr place_sprites
    jsr gen_sprites
    lda #<SCREEN
    sta progress_init.line
    lda #>SCREEN
    sta progress_init.line+1
    jsr progress_init
    lda #<sintab_x
    sta gen_sintab.sintab
    lda #>sintab_x
    sta gen_sintab.sintab+1
    lda #sinlen_x
    sta gen_sintab.length
    lda #0
    sta gen_sintab.min
    ldx #$ff
    jsr gen_sintab
    lda #<SCREEN+$28
    sta progress_init.line
    lda #>SCREEN+$28
    sta progress_init.line+1
    jsr progress_init
    lda #<sintab_y
    sta gen_sintab.sintab
    lda #>sintab_y
    sta gen_sintab.sintab+1
    lda #sinlen_y
    sta gen_sintab.length
    lda #$32
    sta gen_sintab.min
    ldx #$d0
    jsr gen_sintab
    jsr clear_screen
    rts
}
clear_screen: {
    .label sc = 8
    lda #<SCREEN
    sta sc
    lda #>SCREEN
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
    cmp #>SCREEN+$3e8
    bcc b1
    bne !+
    lda sc
    cmp #<SCREEN+$3e8
    bcc b1
  !:
    rts
}
gen_sintab: {
    .const f_2pi = $e2e5
    .label _23 = $c
    .label i = 2
    .label min = 2
    .label length = 3
    .label sintab = 8
    txa
    sta setFAC.w
    lda #0
    sta setFAC.w+1
    jsr setFAC
    jsr setARGtoFAC
    lda #0
    tax
    tay
    lda min
    sta setFAC.w
    txa
    sta setFAC.w+1
    jsr setFAC
    lda #<f_min
    sta setMEMtoFAC.mem
    lda #>f_min
    sta setMEMtoFAC.mem+1
    jsr setMEMtoFAC
    jsr subFACfromARG
    lda #<f_amp
    sta setMEMtoFAC.mem
    lda #>f_amp
    sta setMEMtoFAC.mem+1
    jsr setMEMtoFAC
    lda #2
    sta setFAC.w
    lda #0
    sta setFAC.w+1
    jsr setFAC
    lda #<f_amp
    sta divMEMbyFAC.mem
    lda #>f_amp
    sta divMEMbyFAC.mem+1
    jsr divMEMbyFAC
    lda #<f_amp
    sta setMEMtoFAC.mem
    lda #>f_amp
    sta setMEMtoFAC.mem+1
    jsr setMEMtoFAC
    lda #<f_min
    sta addMEMtoFAC.mem
    lda #>f_min
    sta addMEMtoFAC.mem+1
    jsr addMEMtoFAC
    lda #<f_min
    sta setMEMtoFAC.mem
    lda #>f_min
    sta setMEMtoFAC.mem+1
    jsr setMEMtoFAC
    lda #0
    sta progress_idx
    sta i
  b1:
    lda i
    sta setFAC.w
    lda #0
    sta setFAC.w+1
    jsr setFAC
    lda #<f_2pi
    sta mulFACbyMEM.mem
    lda #>f_2pi
    sta mulFACbyMEM.mem+1
    jsr mulFACbyMEM
    lda #<f_i
    sta setMEMtoFAC.mem
    lda #>f_i
    sta setMEMtoFAC.mem+1
    jsr setMEMtoFAC
    lda length
    sta setFAC.w
    lda #0
    sta setFAC.w+1
    jsr setFAC
    lda #<f_i
    sta divMEMbyFAC.mem
    lda #>f_i
    sta divMEMbyFAC.mem+1
    jsr divMEMbyFAC
    jsr sinFAC
    lda #<f_amp
    sta mulFACbyMEM.mem
    lda #>f_amp
    sta mulFACbyMEM.mem+1
    jsr mulFACbyMEM
    lda #<f_min
    sta addMEMtoFAC.mem
    lda #>f_min
    sta addMEMtoFAC.mem+1
    jsr addMEMtoFAC
    jsr getFAC
    lda _23
    ldy i
    sta (sintab),y
    jsr progress_inc
    inc i
    lda i
    cmp length
    bcc b1
    rts
    f_i: .byte 0, 0, 0, 0, 0
    f_min: .byte 0, 0, 0, 0, 0
    f_amp: .byte 0, 0, 0, 0, 0
}
progress_inc: {
    inc progress_idx
    lda progress_idx
    cmp #8
    bne b1
    lda progress_chars+8
    ldy #0
    sta (progress_cursor),y
    inc progress_cursor
    bne !+
    inc progress_cursor+1
  !:
    lda #0
    sta progress_idx
  b1:
    ldx progress_idx
    lda progress_chars,x
    ldy #0
    sta (progress_cursor),y
    rts
    progress_chars: .byte $20, $65, $74, $75, $61, $f6, $e7, $ea, $e0
}
getFAC: {
    .label return = $c
    jsr $b1aa
    sty $fe
    sta $ff
    lda memLo
    sta return
    lda memHi
    sta return+1
    rts
}
addMEMtoFAC: {
    .label mem = $c
    jsr prepareMEM
    lda $fe
    ldy $ff
    jsr $b867
    rts
}
prepareMEM: {
    .label mem = $c
    lda mem
    sta memLo
    lda mem+1
    sta memHi
    rts
}
mulFACbyMEM: {
    .label mem = $c
    jsr prepareMEM
    lda $fe
    ldy $ff
    jsr $ba28
    rts
}
sinFAC: {
    jsr $e26b
    rts
}
divMEMbyFAC: {
    .label mem = $c
    jsr prepareMEM
    lda $fe
    ldy $ff
    jsr $bb0f
    rts
}
setFAC: {
    .label w = $c
    jsr prepareMEM
    ldy $fe
    lda $ff
    jsr $b391
    rts
}
setMEMtoFAC: {
    .label mem = $c
    jsr prepareMEM
    ldx $fe
    ldy $ff
    jsr $bbd4
    rts
}
subFACfromARG: {
    jsr $b853
    rts
}
setARGtoFAC: {
    jsr $bc0f
    rts
}
progress_init: {
    .label line = $a
    rts
}
gen_sprites: {
    .label spr = 8
    .label i = 2
    lda #<sprites
    sta spr
    lda #>sprites
    sta spr+1
    lda #0
    sta i
  b1:
    ldx i
    ldy cml,x
    lda spr
    sta gen_chargen_sprite.sprite
    lda spr+1
    sta gen_chargen_sprite.sprite+1
    jsr gen_chargen_sprite
    lda spr
    clc
    adc #$40
    sta spr
    bcc !+
    inc spr+1
  !:
    inc i
    lda i
    cmp #7
    bne b1
    rts
    cml: .text "camelot"
}
gen_chargen_sprite: {
    .label _0 = $c
    .label _1 = $c
    .label sprite = $a
    .label chargen = $c
    .label bits = 4
    .label s_gen = 7
    .label x = 5
    .label y = 3
    .label c = 6
    tya
    sta _0
    lda #0
    sta _0+1
    asl _1
    rol _1+1
    asl _1
    rol _1+1
    asl _1
    rol _1+1
    lda chargen
    clc
    adc #<CHARGEN
    sta chargen
    lda chargen+1
    adc #>CHARGEN
    sta chargen+1
    sei
    lda #$32
    sta PROCPORT
    lda #0
    sta y
  b1:
    ldy y
    lda (chargen),y
    sta bits
    lda #0
    sta x
    tay
    sta s_gen
  b2:
    lda bits
    and #$80
    cmp #0
    beq b6
    lda #1
    sta c
    jmp b3
  b6:
    lda #0
    sta c
  b3:
    ldx #0
  b4:
    lda s_gen
    asl
    ora c
    sta s_gen
    iny
    cpy #8
    bne b5
    ldy #0
    sta (sprite),y
    ldy #3
    sta (sprite),y
    ldy #6
    sta (sprite),y
    inc sprite
    bne !+
    inc sprite+1
  !:
    ldy #0
    tya
    sta s_gen
  b5:
    inx
    cpx #3
    bne b4
    asl bits
    inc x
    lda x
    cmp #8
    bne b2
    lda sprite
    clc
    adc #6
    sta sprite
    bcc !+
    inc sprite+1
  !:
    inc y
    lda y
    cmp #8
    bne b1
    lda #$37
    sta PROCPORT
    cli
    rts
}
place_sprites: {
    .const sprites_ptr = SCREEN+$3f8
    .label spr_id = 2
    .label spr_x = 3
    .label col = 4
    lda #$7f
    sta SPRITES_ENABLE
    sta SPRITES_EXPAND_X
    sta SPRITES_EXPAND_Y
    lda #5
    sta col
    ldx #0
    lda #$3c
    sta spr_x
    ldy #0
    lda #$ff & sprites/$40
    sta spr_id
  b1:
    lda spr_id
    sta sprites_ptr,y
    inc spr_id
    lda spr_x
    sta SPRITES_XPOS,x
    lda #$50
    sta SPRITES_YPOS,x
    lda col
    sta SPRITES_COLS,y
    lda spr_x
    clc
    adc #$20
    sta spr_x
    lda col
    eor #7^5
    sta col
    inx
    inx
    iny
    cpy #7
    bne b1
    rts
}
  sintab_x: .fill $dd, 0
  sintab_y: .fill $c5, 0
