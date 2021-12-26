/// @file
/// Commodore 64 Registers and Constants
/// @file
/// The MOS 6526 Complex Interface Adapter (CIA)
///
/// http://archive.6502.org/datasheets/mos_6526_cia_recreated.pdf
  // Commodore 64 PRG executable file
.file [name="sinus-sprites.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .const sinlen_x = $dd
  .const sinlen_y = $c5
  .const OFFSET_STRUCT_MOS6569_VICII_RASTER = $12
  .const OFFSET_STRUCT_MOS6569_VICII_BORDER_COLOR = $20
  .const OFFSET_STRUCT_MOS6569_VICII_SPRITES_XMSB = $10
  .const OFFSET_STRUCT_MOS6569_VICII_SPRITES_ENABLE = $15
  .const OFFSET_STRUCT_MOS6569_VICII_SPRITES_EXPAND_X = $1d
  .const OFFSET_STRUCT_MOS6569_VICII_SPRITES_EXPAND_Y = $17
  /// Sprite X position register for sprite #0
  .label SPRITES_XPOS = $d000
  /// Sprite Y position register for sprite #0
  .label SPRITES_YPOS = $d001
  /// Sprite colors register for sprite #0
  .label SPRITES_COLOR = $d027
  /// Processor Port Register controlling RAM/ROM configuration and the datasette
  .label PROCPORT = 1
  /// The address of the CHARGEN character set
  .label CHARGEN = $d000
  /// The VIC-II MOS 6567/6569
  .label VICII = $d000
  /// Color Ram
  .label COLS = $d800
  // Zeropage addresses used to hold lo/hi-bytes of addresses of float numbers in MEM
  .label memLo = $fe
  .label memHi = $ff
  .label sprites = $2000
  .label SCREEN = $400
  // Current index within the progress cursor (0-7)
  .label progress_idx = 5
  // Current position of the progress cursor
  .label progress_cursor = 3
  .label sin_idx_x = 9
  .label sin_idx_y = 6
.segment Code
main: {
    // init()
    jsr init
    lda #0
    sta.z sin_idx_y
    sta.z sin_idx_x
  __b1:
    // while (VICII->RASTER!=$ff)
    lda #$ff
    cmp VICII+OFFSET_STRUCT_MOS6569_VICII_RASTER
    bne __b1
    // anim()
    jsr anim
    jmp __b1
}
init: {
    // clear_screen()
    jsr clear_screen
    ldx #0
  __b1:
    // COLS[i] = $0
    lda #0
    sta COLS,x
    // COLS[40+i] = $b
    lda #$b
    sta COLS+$28,x
    // for( char i : 0..39)
    inx
    cpx #$28
    bne __b1
    // place_sprites()
    jsr place_sprites
    // gen_sprites()
    jsr gen_sprites
    // progress_init(SCREEN)
    lda #<SCREEN
    sta.z progress_init.line
    lda #>SCREEN
    sta.z progress_init.line+1
    jsr progress_init
    // gen_sintab(sintab_x, sinlen_x, $00, $ff)
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
    // progress_init(SCREEN+40)
    lda #<SCREEN+$28
    sta.z progress_init.line
    lda #>SCREEN+$28
    sta.z progress_init.line+1
    jsr progress_init
    // gen_sintab(sintab_y, sinlen_y, $32, $d0)
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
    // clear_screen()
    jsr clear_screen
    // }
    rts
}
anim: {
    .label __7 = 8
    .label xidx = 5
    .label yidx = $c
    .label x = $13
    .label x_msb = 8
    .label j2 = 2
    .label j = $11
    // (VICII->BORDER_COLOR)++;
    inc VICII+OFFSET_STRUCT_MOS6569_VICII_BORDER_COLOR
    // char xidx = sin_idx_x
    lda.z sin_idx_x
    sta.z xidx
    // char yidx = sin_idx_y
    lda.z sin_idx_y
    sta.z yidx
    lda #0
    sta.z j
    lda #$c
    sta.z j2
    lda #0
    sta.z x_msb
  __b3:
    // unsigned int x = (unsigned int)$1e + sintab_x[xidx]
    ldy.z xidx
    lda sintab_x,y
    clc
    adc #<$1e
    sta.z x
    lda #>$1e
    adc #0
    sta.z x+1
    // x_msb*2
    asl.z __7
    // BYTE1(x)
    // x_msb = x_msb*2 | BYTE1(x)
    ora.z x_msb
    sta.z x_msb
    // BYTE0(x)
    lda.z x
    // SPRITES_XPOS[j2] = BYTE0(x)
    ldy.z j2
    sta SPRITES_XPOS,y
    // SPRITES_YPOS[j2] = sintab_y[yidx]
    ldy.z yidx
    lda sintab_y,y
    ldy.z j2
    sta SPRITES_YPOS,y
    // xidx = xidx+10
    lax.z xidx
    axs #-[$a]
    stx.z xidx
    // if(xidx>=sinlen_x)
    txa
    cmp #sinlen_x
    bcc __b4
    // xidx = xidx-sinlen_x
    lax.z xidx
    axs #sinlen_x
    stx.z xidx
  __b4:
    // yidx = yidx+8
    lax.z yidx
    axs #-[8]
    stx.z yidx
    // if(yidx>=sinlen_y)
    txa
    cmp #sinlen_y
    bcc __b5
    // yidx = yidx-sinlen_y
    lax.z yidx
    axs #sinlen_y
    stx.z yidx
  __b5:
    // j2 = j2-2
    dec.z j2
    dec.z j2
    // for( char j : 0..6)
    inc.z j
    lda #7
    cmp.z j
    bne __b3
    // VICII->SPRITES_XMSB = x_msb
    lda.z x_msb
    sta VICII+OFFSET_STRUCT_MOS6569_VICII_SPRITES_XMSB
    // if(++sin_idx_x>=sinlen_x)
    inc.z sin_idx_x
    lda.z sin_idx_x
    cmp #sinlen_x
    bcc __b1
    lda #0
    sta.z sin_idx_x
  __b1:
    // if(++sin_idx_y>=sinlen_y)
    inc.z sin_idx_y
    lda.z sin_idx_y
    cmp #sinlen_y
    bcc __b2
    lda #0
    sta.z sin_idx_y
  __b2:
    // (VICII->BORDER_COLOR)--;
    dec VICII+OFFSET_STRUCT_MOS6569_VICII_BORDER_COLOR
    // }
    rts
}
clear_screen: {
    .label sc = $f
    lda #<SCREEN
    sta.z sc
    lda #>SCREEN
    sta.z sc+1
  __b1:
    // for(char* sc = SCREEN; sc<SCREEN+1000; sc++)
    lda.z sc+1
    cmp #>SCREEN+$3e8
    bcc __b2
    bne !+
    lda.z sc
    cmp #<SCREEN+$3e8
    bcc __b2
  !:
    // }
    rts
  __b2:
    // *sc = ' '
    lda #' '
    ldy #0
    sta (sc),y
    // for(char* sc = SCREEN; sc<SCREEN+1000; sc++)
    inc.z sc
    bne !+
    inc.z sc+1
  !:
    jmp __b1
}
place_sprites: {
    .label sprites_ptr = SCREEN+$3f8
    .label spr_id = 9
    .label spr_x = 5
    .label col = 2
    .label j2 = 8
    .label j = 6
    // VICII->SPRITES_ENABLE = %01111111
    lda #$7f
    sta VICII+OFFSET_STRUCT_MOS6569_VICII_SPRITES_ENABLE
    // VICII->SPRITES_EXPAND_X = %01111111
    sta VICII+OFFSET_STRUCT_MOS6569_VICII_SPRITES_EXPAND_X
    // VICII->SPRITES_EXPAND_Y = %01111111
    sta VICII+OFFSET_STRUCT_MOS6569_VICII_SPRITES_EXPAND_Y
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
    // sprites_ptr[j] = spr_id++
    lda.z spr_id
    ldy.z j
    sta sprites_ptr,y
    // sprites_ptr[j] = spr_id++;
    inc.z spr_id
    // SPRITES_XPOS[j2] = spr_x
    lda.z spr_x
    ldy.z j2
    sta SPRITES_XPOS,y
    // SPRITES_YPOS[j2] = 80
    lda #$50
    sta SPRITES_YPOS,y
    // SPRITES_COLOR[j] = col
    lda.z col
    ldy.z j
    sta SPRITES_COLOR,y
    // spr_x = spr_x + 32
    lax.z spr_x
    axs #-[$20]
    stx.z spr_x
    // col = col^($7^$5)
    lda #7^5
    eor.z col
    sta.z col
    // j2++;
    ldx.z j2
    inx
    inx
    stx.z j2
    // for( char j : 0..6)
    inc.z j
    lda #7
    cmp.z j
    bne __b1
    // }
    rts
}
gen_sprites: {
    .label spr = $f
    .label i = $c
    lda #<sprites
    sta.z spr
    lda #>sprites
    sta.z spr+1
    lda #0
    sta.z i
  __b1:
    // gen_chargen_sprite(cml[i], spr)
    ldy.z i
    ldx cml,y
    lda.z spr
    sta.z gen_chargen_sprite.sprite
    lda.z spr+1
    sta.z gen_chargen_sprite.sprite+1
    jsr gen_chargen_sprite
    // spr = spr + $40
    lda #$40
    clc
    adc.z spr
    sta.z spr
    bcc !+
    inc.z spr+1
  !:
    // for( char i : 0..6 )
    inc.z i
    lda #7
    cmp.z i
    bne __b1
    // }
    rts
  .segment Data
    cml: .text "camelot"
}
.segment Code
// Initialize the PETSCII progress bar
// void progress_init(__zp(3) char *line)
progress_init: {
    .label line = 3
    // progress_cursor = line
    // }
    rts
}
// Generate a sine table using BASIC floats
// - sintab is a pointer to the table to fill
// - length is the length of the sine table
// - min is the minimum value of the generated sine
// - max is the maximum value of the generated sine
// void gen_sintab(__zp($13) char *sintab, __zp(9) char length, __zp($11) char min, __register(X) char max)
gen_sintab: {
    // amplitude/2
    .label f_2pi = $e2e5
    .label __20 = $a
    .label i = 6
    .label min = $11
    .label length = 9
    .label sintab = $13
    // setFAC((unsigned int)max)
    txa
    sta.z setFAC.w
    lda #0
    sta.z setFAC.w+1
  // 2 * PI
    jsr setFAC
    // setARGtoFAC()
    // fac = max
    jsr setARGtoFAC
    // setFAC((unsigned int)min)
    lda.z min
    sta.z setFAC.w
    lda #0
    sta.z setFAC.w+1
  // arg = max
    jsr setFAC
    // setMEMtoFAC(f_min)
  // fac = min
    lda #<f_min
    sta.z setMEMtoFAC.mem
    lda #>f_min
    sta.z setMEMtoFAC.mem+1
    jsr setMEMtoFAC
    // subFACfromARG()
    // f_min = min
    jsr subFACfromARG
    // setMEMtoFAC(f_amp)
  // fac = max - min
    lda #<f_amp
    sta.z setMEMtoFAC.mem
    lda #>f_amp
    sta.z setMEMtoFAC.mem+1
    jsr setMEMtoFAC
    // setFAC(2)
  // f_amp = max - min
    lda #<2
    sta.z setFAC.prepareMEM1_mem
    lda #>2
    sta.z setFAC.prepareMEM1_mem+1
    jsr setFAC
    // divMEMbyFAC(f_amp)
  // fac = 2
    lda #<f_amp
    sta.z divMEMbyFAC.mem
    lda #>f_amp
    sta.z divMEMbyFAC.mem+1
    jsr divMEMbyFAC
    // setMEMtoFAC(f_amp)
  // fac = (max - min) / 2
    lda #<f_amp
    sta.z setMEMtoFAC.mem
    lda #>f_amp
    sta.z setMEMtoFAC.mem+1
    jsr setMEMtoFAC
    // addMEMtoFAC(f_min)
  // f_amp = (max - min) / 2
    jsr addMEMtoFAC
    // setMEMtoFAC(f_min)
  // fac = min + (max - min) / 2
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
    // for(char i =0; i<length; i++)
    lda.z i
    cmp.z length
    bcc __b2
    // }
    rts
  __b2:
    // setFAC((unsigned int)i)
    lda.z i
    sta.z setFAC.w
    lda #0
    sta.z setFAC.w+1
    jsr setFAC
    // mulFACbyMEM(f_2pi)
  // fac = i
    lda #<f_2pi
    sta.z mulFACbyMEM.mem
    lda #>f_2pi
    sta.z mulFACbyMEM.mem+1
    jsr mulFACbyMEM
    // setMEMtoFAC(f_i)
  // fac = i * 2 * PI
    lda #<f_i
    sta.z setMEMtoFAC.mem
    lda #>f_i
    sta.z setMEMtoFAC.mem+1
    jsr setMEMtoFAC
    // setFAC((unsigned int)length)
    lda.z length
    sta.z setFAC.w
    lda #0
    sta.z setFAC.w+1
  // f_i = i * 2 * PI
    jsr setFAC
    // divMEMbyFAC(f_i)
  // fac = length
    lda #<f_i
    sta.z divMEMbyFAC.mem
    lda #>f_i
    sta.z divMEMbyFAC.mem+1
    jsr divMEMbyFAC
    // sinFAC()
    // fac = i * 2 * PI / length
    jsr sinFAC
    // mulFACbyMEM(f_amp)
  // fac = sin( i * 2 * PI / length )
    lda #<f_amp
    sta.z mulFACbyMEM.mem
    lda #>f_amp
    sta.z mulFACbyMEM.mem+1
    jsr mulFACbyMEM
    // addMEMtoFAC(f_min)
  // fac =  sin( i * 2 * PI / length ) * (max - min) / 2
    jsr addMEMtoFAC
    // getFAC()
    jsr getFAC
    // sintab[i] = (char)getFAC()
    // fac =  sin( i * 2 * PI / length ) * (max - min) / 2 + min + (max - min) / 2
    lda.z __20
    ldy.z i
    sta (sintab),y
    // progress_inc()
    jsr progress_inc
    // for(char i =0; i<length; i++)
    inc.z i
    jmp __b1
  .segment Data
    f_i: .byte 0, 0, 0, 0, 0
    // i * 2 * PI
    f_min: .byte 0, 0, 0, 0, 0
    // amplitude/2 + min
    f_amp: .byte 0, 0, 0, 0, 0
}
.segment Code
// Generate a sprite from a C64 CHARGEN character (by making each pixel 3x3 pixels large)
// - c is the character to generate
// - sprite is a pointer to the position of the sprite to generate
// void gen_chargen_sprite(__register(X) char ch, __zp(3) char *sprite)
gen_chargen_sprite: {
    .label __0 = $a
    .label __14 = $a
    .label sprite = 3
    .label chargen = $a
    .label bits = 6
    // current sprite char
    .label s_gen = 2
    .label x = 5
    .label y = 9
    // Find the current chargen pixel (c)
    .label c = 8
    // ((unsigned int)ch)*8
    txa
    sta.z __14
    lda #0
    sta.z __14+1
    asl.z __0
    rol.z __0+1
    asl.z __0
    rol.z __0+1
    asl.z __0
    rol.z __0+1
    // char* chargen = CHARGEN+((unsigned int)ch)*8
    lda.z chargen
    clc
    adc #<CHARGEN
    sta.z chargen
    lda.z chargen+1
    adc #>CHARGEN
    sta.z chargen+1
    // asm
    sei
    // *PROCPORT = $32
    lda #$32
    sta.z PROCPORT
    lda #0
    sta.z y
  __b1:
    // char bits = chargen[y]
    // current chargen line
    ldy.z y
    lda (chargen),y
    sta.z bits
    lda #0
    sta.z x
    tay
    sta.z s_gen
  __b2:
    // bits & $80
    lda #$80
    and.z bits
    // if((bits & $80) != 0)
    cmp #0
    beq __b6
    lda #1
    sta.z c
    jmp __b3
  __b6:
    lda #0
    sta.z c
  __b3:
    ldx #0
  // generate 3 pixels in the sprite char (s_gen)
  __b4:
    // s_gen*2
    lda.z s_gen
    asl
    // s_gen = s_gen*2 | c
    ora.z c
    sta.z s_gen
    // if(++s_gen_cnt==8)
    iny
    cpy #8
    bne __b5
    // sprite[0] = s_gen
    // sprite char filled - store and move to next char
    ldy #0
    sta (sprite),y
    // sprite[3] = s_gen
    ldy #3
    sta (sprite),y
    // sprite[6] = s_gen
    ldy #6
    sta (sprite),y
    // sprite++;
    inc.z sprite
    bne !+
    inc.z sprite+1
  !:
    ldy #0
    tya
    sta.z s_gen
  __b5:
    // for(char b : 0..2)
    inx
    cpx #3
    bne __b4
    // bits = bits*2
    asl.z bits
    // for(char x:0..7)
    inc.z x
    lda #8
    cmp.z x
    bne __b2
    // sprite = sprite + 6
    lda #6
    clc
    adc.z sprite
    sta.z sprite
    bcc !+
    inc.z sprite+1
  !:
    // for(char y:0..7)
    inc.z y
    lda #8
    cmp.z y
    bne __b1
    // *PROCPORT = $37
    lda #$37
    sta.z PROCPORT
    // asm
    cli
    // }
    rts
}
// FAC = unsigned int
// Set the FAC (floating point accumulator) to the integer value of a 16bit unsigned int
// void setFAC(__zp($f) unsigned int w)
setFAC: {
    .label prepareMEM1_mem = $f
    .label w = $f
    // BYTE0(mem)
    lda.z prepareMEM1_mem
    // *memLo = BYTE0(mem)
    sta.z memLo
    // BYTE1(mem)
    lda.z prepareMEM1_mem+1
    // *memHi = BYTE1(mem)
    sta.z memHi
    // asm
    // Load unsigned int register Y,A into FAC (floating point accumulator)
    ldy memLo
    jsr $b391
    // }
    rts
}
// ARG = FAC
// Set the ARG (floating point argument) to the value of the FAC (floating point accumulator)
setARGtoFAC: {
    // asm
    jsr $bc0f
    // }
    rts
}
// MEM = FAC
// Stores the value of the FAC to memory
// Stores 5 chars (means it is necessary to allocate 5 chars to avoid clobbering other data using eg. char[] mem = {0, 0, 0, 0, 0};)
// void setMEMtoFAC(__zp($f) char *mem)
setMEMtoFAC: {
    .label mem = $f
    // BYTE0(mem)
    lda.z mem
    // *memLo = BYTE0(mem)
    sta.z memLo
    // BYTE1(mem)
    lda.z mem+1
    // *memHi = BYTE1(mem)
    sta.z memHi
    // asm
    ldx memLo
    tay
    jsr $bbd4
    // }
    rts
}
// FAC = ARG-FAC
// Set FAC to ARG minus FAC
subFACfromARG: {
    // asm
    jsr $b853
    // }
    rts
}
// FAC = MEM/FAC
// Set FAC to MEM (float saved in memory) divided by FAC (float accumulator)
// Reads 5 chars from memory
// void divMEMbyFAC(__zp($a) char *mem)
divMEMbyFAC: {
    .label mem = $a
    // BYTE0(mem)
    lda.z mem
    // *memLo = BYTE0(mem)
    sta.z memLo
    // BYTE1(mem)
    lda.z mem+1
    // *memHi = BYTE1(mem)
    sta.z memHi
    // asm
    lda memLo
    ldy memHi
    jsr $bb0f
    // }
    rts
}
// FAC = MEM+FAC
// Set FAC to MEM (float saved in memory) plus FAC (float accumulator)
// Reads 5 chars from memory
// void addMEMtoFAC(char *mem)
addMEMtoFAC: {
    // *memLo = BYTE0(mem)
    lda #<gen_sintab.f_min
    sta.z memLo
    // *memHi = BYTE1(mem)
    lda #>gen_sintab.f_min
    sta.z memHi
    // asm
    lda memLo
    ldy memHi
    jsr $b867
    // }
    rts
}
// FAC = MEM*FAC
// Set FAC to MEM (float saved in memory) multiplied by FAC (float accumulator)
// Reads 5 chars from memory
// void mulFACbyMEM(__zp($a) char *mem)
mulFACbyMEM: {
    .label mem = $a
    // BYTE0(mem)
    lda.z mem
    // *memLo = BYTE0(mem)
    sta.z memLo
    // BYTE1(mem)
    lda.z mem+1
    // *memHi = BYTE1(mem)
    sta.z memHi
    // asm
    lda memLo
    ldy memHi
    jsr $ba28
    // }
    rts
}
// FAC = sin(FAC)
// Set FAC to sine of the FAC - sin(FAC)
// Sine is calculated on radians (0-2*PI)
sinFAC: {
    // asm
    jsr $e26b
    // }
    rts
}
// unsigned int = FAC
// Get the value of the FAC (floating point accumulator) as an integer 16bit unsigned int
// Destroys the value in the FAC in the process
getFAC: {
    .label return = $a
    // asm
    // Load FAC (floating point accumulator) integer part into unsigned int register Y,A
    jsr $b1aa
    sty memLo
    sta memHi
    // unsigned int w = MAKEWORD( *memHi, *memLo )
    sta.z return+1
    tya
    sta.z return
    // }
    rts
}
// Increase PETSCII progress one bit
// Done by increasing the character until the idx is 8 and then moving to the next char
progress_inc: {
    // if(++progress_idx==8)
    inc.z progress_idx
    lda #8
    cmp.z progress_idx
    bne __b1
    // *progress_cursor = progress_chars[8]
    lda progress_chars+8
    ldy #0
    sta (progress_cursor),y
    // progress_cursor++;
    inc.z progress_cursor
    bne !+
    inc.z progress_cursor+1
  !:
    lda #0
    sta.z progress_idx
  __b1:
    // *progress_cursor = progress_chars[progress_idx]
    ldy.z progress_idx
    lda progress_chars,y
    ldy #0
    sta (progress_cursor),y
    // }
    rts
  .segment Data
    // Progress characters
    progress_chars: .byte $20, $65, $74, $75, $61, $f6, $e7, $ea, $e0
}
  sintab_x: .fill $dd, 0
  sintab_y: .fill $c5, 0
