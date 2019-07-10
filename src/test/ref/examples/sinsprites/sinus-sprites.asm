.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  // Processor Port Register controlling RAM/ROM configuration and the datasette
  .label PROCPORT = 1
  // The address of the CHARGEN character set
  .label CHARGEN = $d000
  .label SPRITES_XPOS = $d000
  .label SPRITES_YPOS = $d001
  .label SPRITES_XMSB = $d010
  .label RASTER = $d012
  .label SPRITES_ENABLE = $d015
  .label SPRITES_EXPAND_Y = $d017
  .label SPRITES_EXPAND_X = $d01d
  .label BORDERCOL = $d020
  .label SPRITES_COLS = $d027
  // Color Ram
  .label COLS = $d800
  // Zeropage addresses used to hold lo/hi-bytes of addresses of float numbers in MEM
  .label memLo = $fe
  .label memHi = $ff
  .const sinlen_x = $dd
  .const sinlen_y = $c5
  .label sprites = $2000
  .label SCREEN = $400
  .label progress_idx = $10
  .label progress_cursor = $11
  .label sin_idx_x = 2
  .label sin_idx_y = 3
main: {
    jsr init
    lda #0
    sta sin_idx_y
    sta sin_idx_x
  b1:
    lda #$ff
    cmp RASTER
    bne b1
    jsr anim
    jmp b1
}
anim: {
    .label _6 = 5
    .label xidx = 4
    .label yidx = 7
    .label x = $24
    .label x_msb = 5
    .label j2 = 6
    .label j = 8
    inc BORDERCOL
    lda sin_idx_x
    sta xidx
    lda sin_idx_y
    sta yidx
    lda #0
    sta j
    lda #$c
    sta j2
    lda #0
    sta x_msb
  b3:
    ldy xidx
    lda sintab_x,y
    clc
    adc #<$1e
    sta x
    lda #>$1e
    adc #0
    sta x+1
    asl _6
    ora x_msb
    sta x_msb
    lda x
    ldy j2
    sta SPRITES_XPOS,y
    ldy yidx
    lda sintab_y,y
    ldy j2
    sta SPRITES_YPOS,y
    lax xidx
    axs #-[$a]
    stx xidx
    txa
    cmp #sinlen_x
    bcc b4
    lax xidx
    axs #sinlen_x
    stx xidx
  b4:
    lax yidx
    axs #-[8]
    stx yidx
    txa
    cmp #sinlen_y
    bcc b5
    lax yidx
    axs #sinlen_y
    stx yidx
  b5:
    dec j2
    dec j2
    inc j
    lda #7
    cmp j
    bne b3
    lda x_msb
    sta SPRITES_XMSB
    inc sin_idx_x
    lda sin_idx_x
    cmp #sinlen_x
    bcc b1
    lda #0
    sta sin_idx_x
  b1:
    inc sin_idx_y
    lda sin_idx_y
    cmp #sinlen_y
    bcc b2
    lda #0
    sta sin_idx_y
  b2:
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
    .label sc = 9
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
// Generate a sinus table using BASIC floats
// - sintab is a pointer to the table to fill
// - length is the length of the sine table
// - min is the minimum value of the generated sinus
// - max is the maximum value of the generated sinus
// gen_sintab(byte* zeropage($d) sintab, byte zeropage($c) length, byte zeropage($b) min, byte register(X) max)
gen_sintab: {
    // amplitude/2
    .label f_2pi = $e2e5
    .label _23 = $26
    .label i = $f
    .label min = $b
    .label length = $c
    .label sintab = $d
    txa
    sta setFAC.w
    lda #0
    sta setFAC.w+1
    jsr setFAC
    jsr setARGtoFAC
    lda min
    sta setFAC.w
    lda #0
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
    lda #<2
    sta setFAC.w
    lda #>2
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
    jsr addMEMtoFAC
    lda #<f_min
    sta setMEMtoFAC.mem
    lda #>f_min
    sta setMEMtoFAC.mem+1
    jsr setMEMtoFAC
    lda #0
    sta progress_idx
    sta i
  // f_min = min + (max - min) / 2
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
    jsr addMEMtoFAC
    jsr getFAC
    lda _23
    // fac =  sin( i * 2 * PI / length ) * (max - min) / 2 + min + (max - min) / 2
    ldy i
    sta (sintab),y
    jsr progress_inc
    inc i
    lda i
    cmp length
    bcc b1
    rts
    f_i: .byte 0, 0, 0, 0, 0
    // i * 2 * PI
    f_min: .byte 0, 0, 0, 0, 0
    // amplitude/2 + min
    f_amp: .byte 0, 0, 0, 0, 0
}
// Increase PETSCII progress one bit
// Done by increasing the character until the idx is 8 and then moving to the next char
progress_inc: {
    inc progress_idx
    lda #8
    cmp progress_idx
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
    ldy progress_idx
    lda progress_chars,y
    ldy #0
    sta (progress_cursor),y
    rts
    // Progress characters
    progress_chars: .byte $20, $65, $74, $75, $61, $f6, $e7, $ea, $e0
}
// word = FAC
// Get the value of the FAC (floating point accumulator) as an integer 16bit word
// Destroys the value in the FAC in the process
getFAC: {
    .label return = $26
    // Load FAC (floating point accumulator) integer part into word register Y,A
    jsr $b1aa
    sty $fe
    sta $ff
    lda memLo
    sta return
    lda memHi
    sta return+1
    rts
}
// FAC = MEM+FAC
// Set FAC to MEM (float saved in memory) plus FAC (float accumulator)
// Reads 5 bytes from memory
addMEMtoFAC: {
    lda #<gen_sintab.f_min
    sta prepareMEM.mem
    lda #>gen_sintab.f_min
    sta prepareMEM.mem+1
    jsr prepareMEM
    lda $fe
    ldy $ff
    jsr $b867
    rts
}
// Prepare MEM pointers for operations using MEM
// prepareMEM(byte* zeropage($13) mem)
prepareMEM: {
    .label mem = $13
    lda mem
    sta memLo
    lda mem+1
    sta memHi
    rts
}
// FAC = MEM*FAC
// Set FAC to MEM (float saved in memory) multiplied by FAC (float accumulator)
// Reads 5 bytes from memory
// mulFACbyMEM(byte* zeropage($13) mem)
mulFACbyMEM: {
    .label mem = $13
    jsr prepareMEM
    lda $fe
    ldy $ff
    jsr $ba28
    rts
}
// FAC = sin(FAC)
// Set FAC to sinus of the FAC - sin(FAC)
// Sinus is calculated on radians (0-2*PI)
sinFAC: {
    jsr $e26b
    rts
}
// FAC = MEM/FAC
// Set FAC to MEM (float saved in memory) divided by FAC (float accumulator)
// Reads 5 bytes from memory
// divMEMbyFAC(byte* zeropage($13) mem)
divMEMbyFAC: {
    .label mem = $13
    jsr prepareMEM
    lda $fe
    ldy $ff
    jsr $bb0f
    rts
}
// FAC = word
// Set the FAC (floating point accumulator) to the integer value of a 16bit word
// setFAC(word zeropage($13) w)
setFAC: {
    .label w = $13
    jsr prepareMEM
    // Load word register Y,A into FAC (floating point accumulator)
    ldy $fe
    lda $ff
    jsr $b391
    rts
}
// MEM = FAC
// Stores the value of the FAC to memory
// Stores 5 bytes (means it is necessary to allocate 5 bytes to avoid clobbering other data using eg. byte[] mem = {0, 0, 0, 0, 0};)
// setMEMtoFAC(byte* zeropage($13) mem)
setMEMtoFAC: {
    .label mem = $13
    jsr prepareMEM
    ldx $fe
    ldy $ff
    jsr $bbd4
    rts
}
// FAC = ARG-FAC
// Set FAC to ARG minus FAC
subFACfromARG: {
    jsr $b853
    rts
}
// ARG = FAC
// Set the ARG (floating point argument) to the value of the FAC (floating point accumulator)
setARGtoFAC: {
    jsr $bc0f
    rts
}
// Initialize the PETSCII progress bar
// progress_init(byte* zeropage($11) line)
progress_init: {
    .label line = $11
    rts
}
gen_sprites: {
    .label spr = $16
    .label i = $15
    lda #<sprites
    sta spr
    lda #>sprites
    sta spr+1
    lda #0
    sta i
  b1:
    ldy i
    ldx cml,y
    lda spr
    sta gen_chargen_sprite.sprite
    lda spr+1
    sta gen_chargen_sprite.sprite+1
    jsr gen_chargen_sprite
    lda #$40
    clc
    adc spr
    sta spr
    bcc !+
    inc spr+1
  !:
    inc i
    lda #7
    cmp i
    bne b1
    rts
    cml: .text "camelot"
}
// Generate a sprite from a C64 CHARGEN character (by making each pixel 3x3 pixels large)
// - c is the character to generate
// - sprite is a pointer to the position of the sprite to generate
// gen_chargen_sprite(byte register(X) ch, byte* zeropage($1d) sprite)
gen_chargen_sprite: {
    .label _0 = $28
    .label _1 = $28
    .label sprite = $1d
    .label chargen = $28
    .label bits = $19
    .label s_gen = $1c
    .label x = $1a
    .label y = $18
    .label c = $1b
    txa
    sta _0
    lda #0
    sta _0+1
    asl _1
    rol _1+1
    asl _1
    rol _1+1
    asl _1
    rol _1+1
    clc
    lda chargen
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
    // current chargen line
    ldy y
    lda (chargen),y
    sta bits
    lda #0
    sta x
    tay
    sta s_gen
  b2:
    lda #$80
    and bits
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
  // generate 3 pixels in the sprite byte (s_gen)
  b4:
    lda s_gen
    asl
    ora c
    sta s_gen
    iny
    cpy #8
    bne b5
    // sprite byte filled - store and move to next byte
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
    lda #8
    cmp x
    bne b2
    lda #6
    clc
    adc sprite
    sta sprite
    bcc !+
    inc sprite+1
  !:
    inc y
    lda #8
    cmp y
    bne b1
    lda #$37
    sta PROCPORT
    cli
    rts
}
place_sprites: {
    .label sprites_ptr = SCREEN+$3f8
    .label spr_id = $1f
    .label spr_x = $21
    .label col = $23
    .label j2 = $22
    .label j = $20
    lda #$7f
    sta SPRITES_ENABLE
    sta SPRITES_EXPAND_X
    sta SPRITES_EXPAND_Y
    lda #5
    sta col
    lda #0
    sta j2
    lda #$3c
    sta spr_x
    lda #0
    sta j
    lda #sprites/$40
    sta spr_id
  b1:
    lda spr_id
    ldy j
    sta sprites_ptr,y
    inc spr_id
    lda spr_x
    ldy j2
    sta SPRITES_XPOS,y
    lda #$50
    sta SPRITES_YPOS,y
    lda col
    ldy j
    sta SPRITES_COLS,y
    lax spr_x
    axs #-[$20]
    stx spr_x
    lda #7^5
    eor col
    sta col
    ldx j2
    inx
    inx
    stx j2
    inc j
    lda #7
    cmp j
    bne b1
    rts
}
  sintab_x: .fill $dd, 0
  sintab_y: .fill $c5, 0
