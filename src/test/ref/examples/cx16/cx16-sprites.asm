// Example program for the Commander X16
// Displays 32 64*64 TUT sprites
.cpu _65c02
  // Commodore 64 PRG executable file
.file [name="cx16-sprites.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(__start)
  .const VERA_INC_1 = $10
  .const VERA_DCSEL = 2
  .const VERA_ADDRSEL = 1
  .const VERA_VSYNC = 1
  .const VERA_SPRITES_ENABLE = $40
  // VERA Palette address in VRAM  $1FA00 - $1FBFF
  // 256 entries of 2 bytes
  // byte 0 bits 4-7: Green
  // byte 0 bits 0-3: Blue
  // byte 1 bits 0-3: Red
  .const VERA_PALETTE = $1fa00
  // Sprite Attributes address in VERA VRAM $1FC00 - $1FFFF
  .const VERA_SPRITE_ATTR = $1fc00
  // 8BPP sprite mode (add to VERA_SPRITE.ADDR to enable)
  .const VERA_SPRITE_8BPP = $8000
  // Address to use for sprite pixels in VRAM
  .const SPRITE_PIXELS_VRAM = $8000
  // X sine [0;640-64]
  .const SINX_LEN = $f1
  // Y sine [0;480-64]
  .const SINY_LEN = $fb
  .const SIZEOF_STRUCT_VERA_SPRITE = 8
  .const OFFSET_STRUCT_VERA_SPRITE_X = 2
  .const OFFSET_STRUCT_VERA_SPRITE_Y = 4
  // $9F20 VRAM Address (7:0)
  .label VERA_ADDRX_L = $9f20
  // $9F21 VRAM Address (15:8)
  .label VERA_ADDRX_M = $9f21
  // $9F22 VRAM Address (7:0)
  // Bit 4-7: Address Increment  The following is the amount incremented per value value:increment
  //                             0:0, 1:1, 2:2, 3:4, 4:8, 5:16, 6:32, 7:64, 8:128, 9:256, 10:512, 11:40, 12:80, 13:160, 14:320, 15:640
  // Bit 3: DECR Setting the DECR bit, will decrement instead of increment by the value set by the 'Address Increment' field.
  // Bit 0: VRAM Address (16)
  .label VERA_ADDRX_H = $9f22
  // $9F23	DATA0	VRAM Data port 0
  .label VERA_DATA0 = $9f23
  // $9F25	CTRL Control
  // Bit 7: Reset
  // Bit 1: DCSEL
  // Bit 2: ADDRSEL
  .label VERA_CTRL = $9f25
  // $9F26	IEN		Interrupt Enable
  // Bit 7: IRQ line (8)
  // Bit 3: AFLOW
  // Bit 2: SPRCOL
  // Bit 1: LINE
  // Bit 0: VSYNC
  .label VERA_IEN = $9f26
  // $9F27	ISR     Interrupt Status
  // Interrupts will be generated for the interrupt sources set in the lower 4 bits of IEN. ISR will indicate the interrupts that have occurred.
  // Writing a 1 to one of the lower 3 bits in ISR will clear that interrupt status. AFLOW can only be cleared by filling the audio FIFO for at least 1/4.
  // Bit 4-7: Sprite Collisions. This field indicates which groups of sprites have collided.
  // Bit 3: AFLOW
  // Bit 2: SPRCOL
  // Bit 1: LINE
  // Bit 0: VSYNC
  .label VERA_ISR = $9f27
  // $9F29	DC_VIDEO (DCSEL=0)
  // Bit 7: Current Field     Read-only bit which reflects the active interlaced field in composite and RGB modes. (0: even, 1: odd)
  // Bit 6: Sprites Enable	Enable output from the Sprites renderer
  // Bit 5: Layer1 Enable	    Enable output from the Layer1 renderer
  // Bit 4: Layer0 Enable	    Enable output from the Layer0 renderer
  // Bit 2: Chroma Disable    Setting 'Chroma Disable' disables output of chroma in NTSC composite mode and will give a better picture on a monochrome display. (Setting this bit will also disable the chroma output on the S-video output.)
  // Bit 0-1: Output Mode     0: Video disabled, 1: VGA output, 2: NTSC composite, 3: RGB interlaced, composite sync (via VGA connector)
  .label VERA_DC_VIDEO = $9f29
  // $0314	(RAM) IRQ vector - The vector used when the KERNAL serves IRQ interrupts
  .label KERNEL_IRQ = $314
  // X sine index
  .label sin_idx_x = $12
  // Y sine index
  .label sin_idx_y = $14
.segment Code
__start: {
    // volatile unsigned int sin_idx_x = 119
    lda #<$77
    sta.z sin_idx_x
    lda #>$77
    sta.z sin_idx_x+1
    // volatile unsigned int sin_idx_y = 79
    lda #<$4f
    sta.z sin_idx_y
    lda #>$4f
    sta.z sin_idx_y+1
    jsr main
    rts
}
// VSYNC Interrupt Routine
irq_vsync: {
    .const vram_sprite_attr_bank = VERA_SPRITE_ATTR>>$10
    .label __11 = $16
    .label __12 = $18
    .label i_x = 3
    .label i_y = 5
    .label vram_sprite_pos = 7
    .label s = 2
    .label __13 = $16
    .label __14 = $18
    // if(++sin_idx_x==SINX_LEN)
    inc.z sin_idx_x
    bne !+
    inc.z sin_idx_x+1
  !:
    lda.z sin_idx_x+1
    cmp #>SINX_LEN
    bne __b1
    lda.z sin_idx_x
    cmp #<SINX_LEN
    bne __b1
    // sin_idx_x = 0
    lda #<0
    sta.z sin_idx_x
    sta.z sin_idx_x+1
  __b1:
    // if(--sin_idx_y==0xffff)
    lda.z sin_idx_y
    bne !+
    dec.z sin_idx_y+1
  !:
    dec.z sin_idx_y
    lda.z sin_idx_y+1
    cmp #>$ffff
    bne __b2
    lda.z sin_idx_y
    cmp #<$ffff
    bne __b2
    // sin_idx_y = SINY_LEN-1
    lda #<SINY_LEN-1
    sta.z sin_idx_y
    lda #>SINY_LEN-1
    sta.z sin_idx_y+1
  __b2:
    // unsigned int i_x = sin_idx_x
    lda.z sin_idx_x
    sta.z i_x
    lda.z sin_idx_x+1
    sta.z i_x+1
    // unsigned int i_y = sin_idx_y
    lda.z sin_idx_y
    sta.z i_y
    lda.z sin_idx_y+1
    sta.z i_y+1
    lda #<VERA_SPRITE_ATTR+2&$ffff
    sta.z vram_sprite_pos
    lda #>VERA_SPRITE_ATTR+2&$ffff
    sta.z vram_sprite_pos+1
    lda #0
    sta.z s
  __b5:
    // for(char s=0;s<NUM_SPRITES;s++)
    lda.z s
    cmp #$20
    bcc __b6
    // *VERA_ISR = VERA_VSYNC
    // Reset the VSYNC interrupt
    lda #VERA_VSYNC
    sta VERA_ISR
    // }
    jmp $e034
  __b6:
    // SPRITE_ATTR.X = SINX[i_x]
    lda.z i_x
    asl
    sta.z __11
    lda.z i_x+1
    rol
    sta.z __11+1
    clc
    lda.z __13
    adc #<SINX
    sta.z __13
    lda.z __13+1
    adc #>SINX
    sta.z __13+1
    ldy #0
    lda (__13),y
    sta SPRITE_ATTR+OFFSET_STRUCT_VERA_SPRITE_X
    iny
    lda (__13),y
    sta SPRITE_ATTR+OFFSET_STRUCT_VERA_SPRITE_X+1
    // SPRITE_ATTR.Y = SINY[i_y]
    lda.z i_y
    asl
    sta.z __12
    lda.z i_y+1
    rol
    sta.z __12+1
    clc
    lda.z __14
    adc #<SINY
    sta.z __14
    lda.z __14+1
    adc #>SINY
    sta.z __14+1
    ldy #0
    lda (__14),y
    sta SPRITE_ATTR+OFFSET_STRUCT_VERA_SPRITE_Y
    iny
    lda (__14),y
    sta SPRITE_ATTR+OFFSET_STRUCT_VERA_SPRITE_Y+1
    // memcpy_to_vram(vram_sprite_attr_bank, vram_sprite_pos, &SPRITE_ATTR+2, 4)
    lda.z vram_sprite_pos
    sta.z memcpy_to_vram.vdest
    lda.z vram_sprite_pos+1
    sta.z memcpy_to_vram.vdest+1
  // Copy sprite positions to VRAM (the 4 relevant bytes in VERA_SPRITE_ATTR)
    lda #<4
    sta.z memcpy_to_vram.num
    lda #>4
    sta.z memcpy_to_vram.num+1
    lda #<SPRITE_ATTR+2
    sta.z memcpy_to_vram.src
    lda #>SPRITE_ATTR+2
    sta.z memcpy_to_vram.src+1
    ldx #vram_sprite_attr_bank
    jsr memcpy_to_vram
    // vram_sprite_pos += sizeof(SPRITE_ATTR)
    lda #SIZEOF_STRUCT_VERA_SPRITE
    clc
    adc.z vram_sprite_pos
    sta.z vram_sprite_pos
    bcc !+
    inc.z vram_sprite_pos+1
  !:
    // i_x += 25
    lda #$19
    clc
    adc.z i_x
    sta.z i_x
    bcc !+
    inc.z i_x+1
  !:
    // if(i_x>=SINX_LEN)
    lda.z i_x+1
    bne !+
    lda.z i_x
    cmp #SINX_LEN
    bcc __b8
  !:
    // i_x -= SINX_LEN
    sec
    lda.z i_x
    sbc #SINX_LEN
    sta.z i_x
    lda.z i_x+1
    sbc #0
    sta.z i_x+1
  __b8:
    // i_y += 19
    lda #$13
    clc
    adc.z i_y
    sta.z i_y
    bcc !+
    inc.z i_y+1
  !:
    // if(i_y>=SINY_LEN)
    lda.z i_y+1
    bne !+
    lda.z i_y
    cmp #SINY_LEN
    bcc __b9
  !:
    // i_y -= SINY_LEN
    sec
    lda.z i_y
    sbc #SINY_LEN
    sta.z i_y
    lda.z i_y+1
    sbc #0
    sta.z i_y+1
  __b9:
    // for(char s=0;s<NUM_SPRITES;s++)
    inc.z s
    jmp __b5
}
main: {
    // Copy 8* sprite attributes to VRAM    
    .label vram_sprite_attr = $a
    .label s = 9
    // memcpy_to_vram((char)>SPRITE_PIXELS_VRAM, (char*)<SPRITE_PIXELS_VRAM, SPRITE_PIXELS, 64*64)
  // Copy sprite data to VRAM
    lda #<$40*$40
    sta.z memcpy_to_vram.num
    lda #>$40*$40
    sta.z memcpy_to_vram.num+1
    lda #<SPRITE_PIXELS
    sta.z memcpy_to_vram.src
    lda #>SPRITE_PIXELS
    sta.z memcpy_to_vram.src+1
    ldx #0
    lda #<SPRITE_PIXELS_VRAM&$ffff
    sta.z memcpy_to_vram.vdest
    lda #>SPRITE_PIXELS_VRAM&$ffff
    sta.z memcpy_to_vram.vdest+1
    jsr memcpy_to_vram
    // memcpy_to_vram((char)>VERA_PALETTE, (char*)<VERA_PALETTE, SPRITE_PIXELS+64*64, 0x200)
  // Copy sprite palette to VRAM
    lda #<$200
    sta.z memcpy_to_vram.num
    lda #>$200
    sta.z memcpy_to_vram.num+1
    lda #<SPRITE_PIXELS+$40*$40
    sta.z memcpy_to_vram.src
    lda #>SPRITE_PIXELS+$40*$40
    sta.z memcpy_to_vram.src+1
    ldx #VERA_PALETTE>>$10
    lda #<VERA_PALETTE&$ffff
    sta.z memcpy_to_vram.vdest
    lda #>VERA_PALETTE&$ffff
    sta.z memcpy_to_vram.vdest+1
    jsr memcpy_to_vram
    lda #<VERA_SPRITE_ATTR&$ffff
    sta.z vram_sprite_attr
    lda #>VERA_SPRITE_ATTR&$ffff
    sta.z vram_sprite_attr+1
    lda #0
    sta.z s
  __b1:
    // for(char s=0;s<NUM_SPRITES;s++)
    lda.z s
    cmp #$20
    bcc __b2
    // *VERA_CTRL &= ~VERA_DCSEL
    // Enable sprites
    lda #VERA_DCSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // *VERA_DC_VIDEO |= VERA_SPRITES_ENABLE
    lda #VERA_SPRITES_ENABLE
    ora VERA_DC_VIDEO
    sta VERA_DC_VIDEO
    // asm
    sei
    // *KERNEL_IRQ = &irq_vsync
    lda #<irq_vsync
    sta KERNEL_IRQ
    lda #>irq_vsync
    sta KERNEL_IRQ+1
    // *VERA_IEN = VERA_VSYNC
    lda #VERA_VSYNC
    sta VERA_IEN
    // asm
    cli
    // }
    rts
  __b2:
    // SPRITE_ATTR.X += 10
    lda #<$a
    clc
    adc SPRITE_ATTR+OFFSET_STRUCT_VERA_SPRITE_X
    sta SPRITE_ATTR+OFFSET_STRUCT_VERA_SPRITE_X
    lda #>$a
    adc SPRITE_ATTR+OFFSET_STRUCT_VERA_SPRITE_X+1
    sta SPRITE_ATTR+OFFSET_STRUCT_VERA_SPRITE_X+1
    // SPRITE_ATTR.Y += 10
    lda #<$a
    clc
    adc SPRITE_ATTR+OFFSET_STRUCT_VERA_SPRITE_Y
    sta SPRITE_ATTR+OFFSET_STRUCT_VERA_SPRITE_Y
    lda #>$a
    adc SPRITE_ATTR+OFFSET_STRUCT_VERA_SPRITE_Y+1
    sta SPRITE_ATTR+OFFSET_STRUCT_VERA_SPRITE_Y+1
    // memcpy_to_vram((char)>VERA_SPRITE_ATTR, vram_sprite_attr, &SPRITE_ATTR, sizeof(SPRITE_ATTR))
    lda.z vram_sprite_attr
    sta.z memcpy_to_vram.vdest
    lda.z vram_sprite_attr+1
    sta.z memcpy_to_vram.vdest+1
    lda #<SIZEOF_STRUCT_VERA_SPRITE
    sta.z memcpy_to_vram.num
    lda #>SIZEOF_STRUCT_VERA_SPRITE
    sta.z memcpy_to_vram.num+1
    lda #<SPRITE_ATTR
    sta.z memcpy_to_vram.src
    lda #>SPRITE_ATTR
    sta.z memcpy_to_vram.src+1
    ldx #VERA_SPRITE_ATTR>>$10
    jsr memcpy_to_vram
    // vram_sprite_attr += sizeof(SPRITE_ATTR)
    lda #SIZEOF_STRUCT_VERA_SPRITE
    clc
    adc.z vram_sprite_attr
    sta.z vram_sprite_attr
    bcc !+
    inc.z vram_sprite_attr+1
  !:
    // for(char s=0;s<NUM_SPRITES;s++)
    inc.z s
    jmp __b1
}
// Copy block of memory (from RAM to VRAM)
// Copies the values of num bytes from the location pointed to by source directly to the memory block pointed to by destination in VRAM.
// - vbank: Which 64K VRAM bank to put data into (0/1)
// - vdest: The destination address in VRAM
// - src: The source address in RAM
// - num: The number of bytes to copy
// memcpy_to_vram(byte register(X) vbank, void* zp($c) vdest, void* zp($e) src, word zp($10) num)
memcpy_to_vram: {
    .label end = $10
    .label s = $e
    .label vdest = $c
    .label src = $e
    .label num = $10
    // *VERA_CTRL &= ~VERA_ADDRSEL
    // Select DATA0
    lda #VERA_ADDRSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // <vdest
    lda.z vdest
    // *VERA_ADDRX_L = <vdest
    // Set address
    sta VERA_ADDRX_L
    // >vdest
    lda.z vdest+1
    // *VERA_ADDRX_M = >vdest
    sta VERA_ADDRX_M
    // VERA_INC_1 | vbank
    txa
    ora #VERA_INC_1
    // *VERA_ADDRX_H = VERA_INC_1 | vbank
    sta VERA_ADDRX_H
    // char *end = (char*)src+num
    lda.z end
    clc
    adc.z src
    sta.z end
    lda.z end+1
    adc.z src+1
    sta.z end+1
  __b1:
    // for(char *s = src; s!=end; s++)
    lda.z s+1
    cmp.z end+1
    bne __b2
    lda.z s
    cmp.z end
    bne __b2
    // }
    rts
  __b2:
    // *VERA_DATA0 = *s
    ldy #0
    lda (s),y
    sta VERA_DATA0
    // for(char *s = src; s!=end; s++)
    inc.z s
    bne !+
    inc.z s+1
  !:
    jmp __b1
}
.segment Data
  // A 64*64 8bpp TUT sprite and palette
  .align $400
SPRITE_PIXELS:
.var pic = LoadPicture("tut.png")
    // palette: rgb->idx
    .var palette = Hashtable()
    // RGB value for each palette index
    .var palList = List()
    // Next palette index
    .var nxt_idx = 0;
    // Extract palette while outputting pixels as palete index values
    .for (var y=0; y<64; y++) {
    	.for (var x=0;x<64; x++) {
            // Find palette index (add if not known)
            .var rgb = pic.getPixel(x,y);
            .var idx = palette.get(rgb)
            .if(idx==null) {
                .eval idx = nxt_idx++;
                .eval palette.put(rgb,idx);
                .eval palList.add(rgb)
            }
            // Output pixel as palette index
            .byte idx
        }
    }
    .if(nxt_idx>256) .error "Image has too many colours "+nxt_idx
    // Output sprite palette (at offset 64*64 bytes)
    .for(var i=0;i<256;i++) {
        .var rgb = palList.get(i)
        .var red = floor(rgb / [256*256])
        .var green = floor(rgb/256) & 255
        .var blue = rgb & 255
        // bits 4-8: green, bits 0-3 blue
        .byte green&$f0  | blue/16
        // bits bits 0-3 red
        .byte red/16
    }

  .align $100
SINX:
.fillword 256, 288+288*sin(i*2*PI/SINX_LEN)

  .align $100
SINY:
.fillword 256, 208+208*sin(i*2*PI/SINY_LEN)

  // Sprite attributes: 8bpp, in front, 64x64, address SPRITE_PIXELS_VRAM
  SPRITE_ATTR: .word (SPRITE_PIXELS_VRAM/$20&$ffff)|VERA_SPRITE_8BPP, $140-$20, $f0-$20
  .byte $c, $f0
