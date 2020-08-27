// Random walk with color fading for Commodore Plus/4 / C16
// Plus/4 / Commodore 16 registers and memory layout
// http://zimmers.net/anonftp/pub/cbm/schematics/computers/plus4/264_Hardware_Spec.pdf
// http://www.zimmers.net/anonftp/pub/cbm/schematics/computers/plus4/Plus_4_Technical_Docs.pdf
// http://personalpages.tds.net/~rcarlsen/cbm/c16/C16_Service_Manual_314001-03_(1984_Oct).pdf
// https://www.floodgap.com/retrobits/ckb/secret/264memory.txt
// The MOS 7360/8360 TED chip used for graphics and sound in Plus/4 and Commodore 16
// https://www.karlstechnology.com/commodore/TED7360-datasheet.pdf
// http://mclauchlan.site.net.au/scott/C=Hacking/C-Hacking12/gfx.html
  .file [name="plus4walk.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$1001]
.segmentdef Code [start=$100d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
.segment Code


  .const OFFSET_STRUCT_MOS7360_TED_BG_COLOR = $15
  .const OFFSET_STRUCT_MOS7360_TED_BORDER_COLOR = $19
  .const OFFSET_STRUCT_MOS7360_TED_RASTER_LO = $1d
  // Default address of screen luminance/color matrix
  .label DEFAULT_COLORRAM = $800
  // Default address of screen character matrix
  .label DEFAULT_SCREEN = $c00
  // The TED chip controlling video and sound on the Plus/4 and Commodore 16
  .label TED = $ff00
  // The random state variable
  .label rand_state = 3
.segment Code
main: {
    .label __3 = 5
    .label __5 = 9
    .label __6 = $b
    .label __8 = 5
    .label __10 = $d
    .label __24 = 5
    .label offset = 5
    .label y = 2
    .label __29 = 7
    .label __30 = 5
    // memset(DEFAULT_SCREEN, 0xa0, 1000)
    ldx #$a0
    lda #<DEFAULT_SCREEN
    sta.z memset.str
    lda #>DEFAULT_SCREEN
    sta.z memset.str+1
    jsr memset
    // memset(DEFAULT_COLORRAM, 0, 1000)
    ldx #0
    lda #<DEFAULT_COLORRAM
    sta.z memset.str
    lda #>DEFAULT_COLORRAM
    sta.z memset.str+1
    jsr memset
    // memset(VISITS, 0, 1000)
    ldx #0
    lda #<VISITS
    sta.z memset.str
    lda #>VISITS
    sta.z memset.str+1
    jsr memset
    // TED->BG_COLOR = 0
    lda #0
    sta TED+OFFSET_STRUCT_MOS7360_TED_BG_COLOR
    // TED->BORDER_COLOR = 0
    sta TED+OFFSET_STRUCT_MOS7360_TED_BORDER_COLOR
    lda #<1
    sta.z rand_state
    lda #>1
    sta.z rand_state+1
    ldx #$14
    lda #$c
    sta.z y
  __b2:
    // (unsigned int)y*40
    lda.z y
    sta.z __24
    lda #0
    sta.z __24+1
    lda.z __24
    asl
    sta.z __29
    lda.z __24+1
    rol
    sta.z __29+1
    asl.z __29
    rol.z __29+1
    lda.z __30
    clc
    adc.z __29
    sta.z __30
    lda.z __30+1
    adc.z __29+1
    sta.z __30+1
    asl.z __3
    rol.z __3+1
    asl.z __3
    rol.z __3+1
    asl.z __3
    rol.z __3+1
    // offset = (unsigned int)y*40+x
    txa
    clc
    adc.z offset
    sta.z offset
    bcc !+
    inc.z offset+1
  !:
    // VISITS+offset
    lda.z offset
    clc
    adc #<VISITS
    sta.z __5
    lda.z offset+1
    adc #>VISITS
    sta.z __5+1
    // cnt = ++*(VISITS+offset)
    ldy #0
    lda (__5),y
    clc
    adc #1
    sta (__5),y
    // VISITS+offset
    lda.z offset
    clc
    adc #<VISITS
    sta.z __6
    lda.z offset+1
    adc #>VISITS
    sta.z __6+1
    // cnt = ++*(VISITS+offset)
    lda (__6),y
    tay
    // DEFAULT_COLORRAM+offset
    clc
    lda.z __8
    adc #<DEFAULT_COLORRAM
    sta.z __8
    lda.z __8+1
    adc #>DEFAULT_COLORRAM
    sta.z __8+1
    // cnt&0xf
    tya
    and #$f
    // *(DEFAULT_COLORRAM+offset) = FADE[cnt&0xf]
    tay
    lda FADE,y
    ldy #0
    sta (__8),y
    // rand()
    jsr rand
    // rnd = >rand()
    ldy.z __10+1
    // rnd & 0x80
    tya
    and #$80
    // if(rnd & 0x80)
    cmp #0
    bne __b3
    // rnd & 0x40
    tya
    and #$40
    // if(rnd & 0x40)
    cmp #0
    bne __b4
    // y--;
    dec.z y
    // if(y==0xff)
    lda #$ff
    cmp.z y
    bne __b6
    lda #0
    sta.z y
  __b6:
    // while(TED->RASTER_LO!=0xff)
    lda #$ff
    cmp TED+OFFSET_STRUCT_MOS7360_TED_RASTER_LO
    bne __b6
    jmp __b2
  __b4:
    // y++;
    inc.z y
    // if(y==25)
    lda #$19
    cmp.z y
    bne __b6
    lda #$18
    sta.z y
    jmp __b6
  __b3:
    // rnd& 0x40
    tya
    and #$40
    // if(rnd& 0x40)
    cmp #0
    bne __b5
    // x--;
    dex
    // if(x==0xff)
    cpx #$ff
    bne __b6
    ldx #0
    jmp __b6
  __b5:
    // x++;
    inx
    // if(x==40)
    cpx #$28
    bne __b6
    ldx #$27
    jmp __b6
}
// Copies the character c (an unsigned char) to the first num characters of the object pointed to by the argument str.
// memset(void* zp(3) str, byte register(X) c)
memset: {
    .label end = $f
    .label dst = 3
    .label str = 3
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
// Returns a pseudo-random number in the range of 0 to RAND_MAX (65535)
// Uses an xorshift pseudorandom number generator that hits all different values
// Information https://en.wikipedia.org/wiki/Xorshift
// Source http://www.retroprogramming.com/2017/07/xorshift-pseudorandom-numbers-in-z80.html
rand: {
    .label __0 = $f
    .label __1 = $11
    .label __2 = $13
    .label return = $d
    // rand_state << 7
    lda.z rand_state+1
    lsr
    lda.z rand_state
    ror
    sta.z __0+1
    lda #0
    ror
    sta.z __0
    // rand_state ^= rand_state << 7
    lda.z rand_state
    eor.z __0
    sta.z rand_state
    lda.z rand_state+1
    eor.z __0+1
    sta.z rand_state+1
    // rand_state >> 9
    lsr
    sta.z __1
    lda #0
    sta.z __1+1
    // rand_state ^= rand_state >> 9
    lda.z rand_state
    eor.z __1
    sta.z rand_state
    lda.z rand_state+1
    eor.z __1+1
    sta.z rand_state+1
    // rand_state << 8
    lda.z rand_state
    sta.z __2+1
    lda #0
    sta.z __2
    // rand_state ^= rand_state << 8
    lda.z rand_state
    eor.z __2
    sta.z rand_state
    lda.z rand_state+1
    eor.z __2+1
    sta.z rand_state+1
    // return rand_state;
    lda.z rand_state
    sta.z return
    lda.z rand_state+1
    sta.z return+1
    // }
    rts
}
.segment Data
  // Colors to fade up/down when visiting a char multiple times
  FADE: .byte 2, $12, $22, $32, $42, $52, $62, $72, $76, $66, $56, $46, $36, $26, $16, 6
  // The number of times each character has been visited
  VISITS: .fill $3e8, 0
