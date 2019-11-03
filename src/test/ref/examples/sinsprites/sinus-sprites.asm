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
  .label progress_idx = $a
  .label progress_cursor = 2
  .label sin_idx_x = 6
  .label sin_idx_y = 8
main: {
    jsr init
    lda #0
    sta.z sin_idx_y
    sta.z sin_idx_x
  __b1:
    lda #$ff
    cmp RASTER
    bne __b1
    jsr anim
    jmp __b1
}
anim: {
    .label __7 = $a
    .label xidx = 9
    .label yidx = 4
    .label x = $f
    .label x_msb = $a
    .label j2 = $b
    .label j = 5
    inc BORDERCOL
    lda.z sin_idx_x
    sta.z xidx
    lda.z sin_idx_y
    sta.z yidx
    lda #0
    sta.z j
    lda #$c
    sta.z j2
    lda #0
    sta.z x_msb
  __b3:
    ldy.z xidx
    lda sintab_x,y
    clc
    adc #<$1e
    sta.z x
    lda #>$1e
    adc #0
    sta.z x+1
    asl.z __7
    ora.z x_msb
    sta.z x_msb
    lda.z x
    ldy.z j2
    sta SPRITES_XPOS,y
    ldy.z yidx
    lda sintab_y,y
    ldy.z j2
    sta SPRITES_YPOS,y
    lax.z xidx
    axs #-[$a]
    stx.z xidx
    txa
    cmp #sinlen_x
    bcc __b4
    lax.z xidx
    axs #sinlen_x
    stx.z xidx
  __b4:
    lax.z yidx
    axs #-[8]
    stx.z yidx
    txa
    cmp #sinlen_y
    bcc __b5
    lax.z yidx
    axs #sinlen_y
    stx.z yidx
  __b5:
    dec.z j2
    dec.z j2
    inc.z j
    lda #7
    cmp.z j
    bne __b3
    lda.z x_msb
    sta SPRITES_XMSB
    inc.z sin_idx_x
    lda.z sin_idx_x
    cmp #sinlen_x
    bcc __b1
    lda #0
    sta.z sin_idx_x
  __b1:
    inc.z sin_idx_y
    lda.z sin_idx_y
    cmp #sinlen_y
    bcc __b2
    lda #0
    sta.z sin_idx_y
  __b2:
    dec BORDERCOL
    rts
}
init: {
    jsr clear_screen
    ldx #0
  __b1:
    lda #0
    sta COLS,x
    lda #$b
    sta COLS+$28,x
    inx
    cpx #$28
    bne __b1
    jsr place_sprites
    jsr gen_sprites
    lda #<SCREEN
    sta.z progress_init.line
    lda #>SCREEN
    sta.z progress_init.line+1
    jsr progress_init
    lda #<sintab_x
    sta.z gen_sintab.sintab
    lda #>sintab_x
    sta.z gen_sintab.sintab+1
    lda #sinlen_x
    sta.z gen_sintab.length
    lda #0
    sta.z gen_sintab.min
    ldx #$ff
    jsr gen_sintab
    lda #<SCREEN+$28
    sta.z progress_init.line
    lda #>SCREEN+$28
    sta.z progress_init.line+1
    jsr progress_init
    lda #<sintab_y
    sta.z gen_sintab.sintab
    lda #>sintab_y
    sta.z gen_sintab.sintab+1
    lda #sinlen_y
    sta.z gen_sintab.length
    lda #$32
    sta.z gen_sintab.min
    ldx #$d0
    jsr gen_sintab
    jsr clear_screen
    rts
}
clear_screen: {
    .label sc = $f
    lda #<SCREEN
    sta.z sc
    lda #>SCREEN
    sta.z sc+1
  __b1:
    lda.z sc+1
    cmp #>SCREEN+$3e8
    bcc __b2
    bne !+
    lda.z sc
    cmp #<SCREEN+$3e8
    bcc __b2
  !:
    rts
  __b2:
    lda #' '
    ldy #0
    sta (sc),y
    inc.z sc
    bne !+
    inc.z sc+1
  !:
    jmp __b1
}
// Generate a sinus table using BASIC floats
// - sintab is a pointer to the table to fill
// - length is the length of the sine table
// - min is the minimum value of the generated sinus
// - max is the maximum value of the generated sinus
// gen_sintab(byte* zeropage($f) sintab, byte zeropage(8) length, byte zeropage(6) min, byte register(X) max)
gen_sintab: {
    // amplitude/2
    .label f_2pi = $e2e5
    .label __24 = $13
    .label i = 9
    .label min = 6
    .label length = 8
    .label sintab = $f
    txa
    sta.z setFAC.w
    lda #0
    sta.z setFAC.w+1
    jsr setFAC
    jsr setARGtoFAC
    lda.z min
    sta.z setFAC.w
    lda #0
    sta.z setFAC.w+1
    jsr setFAC
    lda #<f_min
    sta.z setMEMtoFAC.mem
    lda #>f_min
    sta.z setMEMtoFAC.mem+1
    jsr setMEMtoFAC
    jsr subFACfromARG
    lda #<f_amp
    sta.z setMEMtoFAC.mem
    lda #>f_amp
    sta.z setMEMtoFAC.mem+1
    jsr setMEMtoFAC
    lda #<2
    sta.z setFAC.prepareMEM1_mem
    lda #>2
    sta.z setFAC.prepareMEM1_mem+1
    jsr setFAC
    lda #<f_amp
    sta.z divMEMbyFAC.mem
    lda #>f_amp
    sta.z divMEMbyFAC.mem+1
    jsr divMEMbyFAC
    lda #<f_amp
    sta.z setMEMtoFAC.mem
    lda #>f_amp
    sta.z setMEMtoFAC.mem+1
    jsr setMEMtoFAC
    jsr addMEMtoFAC
    lda #<f_min
    sta.z setMEMtoFAC.mem
    lda #>f_min
    sta.z setMEMtoFAC.mem+1
    jsr setMEMtoFAC
    lda #0
    sta.z progress_idx
    sta.z i
  // f_min = min + (max - min) / 2
  __b1:
    lda.z i
    cmp.z length
    bcc __b2
    rts
  __b2:
    lda.z i
    sta.z setFAC.w
    lda #0
    sta.z setFAC.w+1
    jsr setFAC
    lda #<f_2pi
    sta.z mulFACbyMEM.mem
    lda #>f_2pi
    sta.z mulFACbyMEM.mem+1
    jsr mulFACbyMEM
    lda #<f_i
    sta.z setMEMtoFAC.mem
    lda #>f_i
    sta.z setMEMtoFAC.mem+1
    jsr setMEMtoFAC
    lda.z length
    sta.z setFAC.w
    lda #0
    sta.z setFAC.w+1
    jsr setFAC
    lda #<f_i
    sta.z divMEMbyFAC.mem
    lda #>f_i
    sta.z divMEMbyFAC.mem+1
    jsr divMEMbyFAC
    jsr sinFAC
    lda #<f_amp
    sta.z mulFACbyMEM.mem
    lda #>f_amp
    sta.z mulFACbyMEM.mem+1
    jsr mulFACbyMEM
    jsr addMEMtoFAC
    jsr getFAC
    lda.z __24
    // fac =  sin( i * 2 * PI / length ) * (max - min) / 2 + min + (max - min) / 2
    ldy.z i
    sta (sintab),y
    jsr progress_inc
    inc.z i
    jmp __b1
    f_i: .byte 0, 0, 0, 0, 0
    // i * 2 * PI
    f_min: .byte 0, 0, 0, 0, 0
    // amplitude/2 + min
    f_amp: .byte 0, 0, 0, 0, 0
}
// Increase PETSCII progress one bit
// Done by increasing the character until the idx is 8 and then moving to the next char
progress_inc: {
    inc.z progress_idx
    lda #8
    cmp.z progress_idx
    bne __b1
    lda progress_chars+8
    ldy #0
    sta (progress_cursor),y
    inc.z progress_cursor
    bne !+
    inc.z progress_cursor+1
  !:
    lda #0
    sta.z progress_idx
  __b1:
    ldy.z progress_idx
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
    .label return = $13
    // Load FAC (floating point accumulator) integer part into word register Y,A
    jsr $b1aa
    sty memLo
    sta memHi
    tya
    sta.z return
    lda memHi
    sta.z return+1
    rts
}
// FAC = MEM+FAC
// Set FAC to MEM (float saved in memory) plus FAC (float accumulator)
// Reads 5 bytes from memory
addMEMtoFAC: {
    lda #<gen_sintab.f_min
    sta memLo
    lda #>gen_sintab.f_min
    sta memHi
    lda memLo
    ldy memHi
    jsr $b867
    rts
}
// FAC = MEM*FAC
// Set FAC to MEM (float saved in memory) multiplied by FAC (float accumulator)
// Reads 5 bytes from memory
// mulFACbyMEM(byte* zeropage($13) mem)
mulFACbyMEM: {
    .label mem = $13
    lda.z mem
    sta memLo
    lda.z mem+1
    sta memHi
    lda memLo
    ldy memHi
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
    lda.z mem
    sta memLo
    lda.z mem+1
    sta memHi
    lda memLo
    ldy memHi
    jsr $bb0f
    rts
}
// FAC = word
// Set the FAC (floating point accumulator) to the integer value of a 16bit word
// setFAC(word zeropage($13) w)
setFAC: {
    .label prepareMEM1_mem = $13
    .label w = $13
    lda.z prepareMEM1_mem
    sta memLo
    lda.z prepareMEM1_mem+1
    sta memHi
    // Load word register Y,A into FAC (floating point accumulator)
    ldy memLo
    jsr $b391
    rts
}
// MEM = FAC
// Stores the value of the FAC to memory
// Stores 5 bytes (means it is necessary to allocate 5 bytes to avoid clobbering other data using eg. byte[] mem = {0, 0, 0, 0, 0};)
// setMEMtoFAC(byte* zeropage($13) mem)
setMEMtoFAC: {
    .label mem = $13
    lda.z mem
    sta memLo
    lda.z mem+1
    sta memHi
    ldx memLo
    tay
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
// progress_init(byte* zeropage(2) line)
progress_init: {
    .label line = 2
    rts
}
gen_sprites: {
    .label spr = 2
    .label i = $b
    lda #<sprites
    sta.z spr
    lda #>sprites
    sta.z spr+1
    lda #0
    sta.z i
  __b1:
    ldy.z i
    ldx cml,y
    lda.z spr
    sta.z gen_chargen_sprite.sprite
    lda.z spr+1
    sta.z gen_chargen_sprite.sprite+1
    jsr gen_chargen_sprite
    lda #$40
    clc
    adc.z spr
    sta.z spr
    bcc !+
    inc.z spr+1
  !:
    inc.z i
    lda #7
    cmp.z i
    bne __b1
    rts
    cml: .text "camelot"
}
// Generate a sprite from a C64 CHARGEN character (by making each pixel 3x3 pixels large)
// - c is the character to generate
// - sprite is a pointer to the position of the sprite to generate
// gen_chargen_sprite(byte register(X) ch, byte* zeropage($f) sprite)
gen_chargen_sprite: {
    .label __0 = $13
    .label __1 = $13
    .label sprite = $f
    .label chargen = $13
    .label bits = 5
    .label s_gen = 9
    .label x = 6
    .label y = 4
    .label c = 8
    txa
    sta.z __0
    lda #0
    sta.z __0+1
    asl.z __1
    rol.z __1+1
    asl.z __1
    rol.z __1+1
    asl.z __1
    rol.z __1+1
    clc
    lda.z chargen
    adc #<CHARGEN
    sta.z chargen
    lda.z chargen+1
    adc #>CHARGEN
    sta.z chargen+1
    sei
    lda #$32
    sta PROCPORT
    lda #0
    sta.z y
  __b1:
    // current chargen line
    ldy.z y
    lda (chargen),y
    sta.z bits
    lda #0
    sta.z x
    tay
    sta.z s_gen
  __b2:
    lda #$80
    and.z bits
    cmp #0
    beq b1
    lda #1
    sta.z c
    jmp __b3
  b1:
    lda #0
    sta.z c
  __b3:
    ldx #0
  // generate 3 pixels in the sprite byte (s_gen)
  __b4:
    lda.z s_gen
    asl
    ora.z c
    sta.z s_gen
    iny
    cpy #8
    bne __b5
    // sprite byte filled - store and move to next byte
    ldy #0
    sta (sprite),y
    ldy #3
    sta (sprite),y
    ldy #6
    sta (sprite),y
    inc.z sprite
    bne !+
    inc.z sprite+1
  !:
    ldy #0
    tya
    sta.z s_gen
  __b5:
    inx
    cpx #3
    bne __b4
    asl.z bits
    inc.z x
    lda #8
    cmp.z x
    bne __b2
    lda #6
    clc
    adc.z sprite
    sta.z sprite
    bcc !+
    inc.z sprite+1
  !:
    inc.z y
    lda #8
    cmp.z y
    bne __b1
    lda #$37
    sta PROCPORT
    cli
    rts
}
place_sprites: {
    .label sprites_ptr = SCREEN+$3f8
    .label spr_id = 6
    .label spr_x = 9
    .label col = $b
    .label j2 = $a
    .label j = 8
    lda #$7f
    sta SPRITES_ENABLE
    sta SPRITES_EXPAND_X
    sta SPRITES_EXPAND_Y
    lda #5
    sta.z col
    lda #0
    sta.z j2
    lda #$3c
    sta.z spr_x
    lda #0
    sta.z j
    lda #sprites/$40
    sta.z spr_id
  __b1:
    lda.z spr_id
    ldy.z j
    sta sprites_ptr,y
    inc.z spr_id
    lda.z spr_x
    ldy.z j2
    sta SPRITES_XPOS,y
    lda #$50
    sta SPRITES_YPOS,y
    lda.z col
    ldy.z j
    sta SPRITES_COLS,y
    lax.z spr_x
    axs #-[$20]
    stx.z spr_x
    lda #7^5
    eor.z col
    sta.z col
    ldx.z j2
    inx
    inx
    stx.z j2
    inc.z j
    lda #7
    cmp.z j
    bne __b1
    rts
}
  sintab_x: .fill $dd, 0
  sintab_y: .fill $c5, 0
