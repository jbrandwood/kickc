// Raster65 Demo Implementation in C 
// Based on RASTER65 assembler demo
// https://mega.scryptos.com/sharefolder/MEGA/MEGA65+filehost
// https://www.forum64.de/index.php?thread/104591-xemu-vic-iv-implementation-update/&postID=1560511#post1560511
.cpu _45gs02
  // MEGA65 platform executable starting in C64 mode.
.file [name="raster65.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$080d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(__start)
.segment Code


  // Value that disables all CIA interrupts when stored to the CIA Interrupt registers
  .const CIA_INTERRUPT_CLEAR = $7f
  // Bits for the VICII IRQ Status/Enable Registers
  .const IRQ_RASTER = 1
  // Mask for PROCESSOR_PORT_DDR which allows only memory configuration to be written
  .const PROCPORT_DDR_MEMORY_MASK = 7
  // RAM in 0xA000, 0xE000 I/O in 0xD000
  .const PROCPORT_RAM_IO = 5
  // The number of greetings
  .const GREETCOUNT = $10
  // The number of raster lines
  .const NUMBERL = $e0
  .const OFFSET_STRUCT_MOS4569_VICIII_KEY = $2f
  .const OFFSET_STRUCT_MEGA65_VICIV_CONTROLB = $31
  .const OFFSET_STRUCT_MEGA65_VICIV_CONTROLC = $54
  .const OFFSET_STRUCT_MOS6526_CIA_INTERRUPT = $d
  .const OFFSET_STRUCT_MOS6569_VICII_RASTER = $12
  .const OFFSET_STRUCT_MOS6569_VICII_CONTROL1 = $11
  .const OFFSET_STRUCT_MOS6569_VICII_IRQ_ENABLE = $1a
  .const OFFSET_STRUCT_MEGA65_VICIV_SIDBDRWD_LO = $5c
  .const OFFSET_STRUCT_MEGA65_VICIV_RASLINE0 = $6f
  .const OFFSET_STRUCT_MOS6569_VICII_IRQ_STATUS = $19
  .const OFFSET_STRUCT_MOS6569_VICII_CONTROL2 = $16
  .const OFFSET_STRUCT_MOS4569_VICIII_BORDER_COLOR = $20
  .const OFFSET_STRUCT_MOS4569_VICIII_BG_COLOR = $21
  .const OFFSET_STRUCT_MEGA65_VICIV_TEXTXPOS_LO = $4c
  .const OFFSET_STRUCT_MEGA65_VICIV_CHRXSCL = $5a
  .const SIZEOF_BYTE = 1
  // Processor port data direction register
  .label PROCPORT_DDR = 0
  // Processor Port Register controlling RAM/ROM configuration and the datasette
  .label PROCPORT = 1
  // The VIC-II MOS 6567/6569
  .label VICII = $d000
  // The VIC III MOS 4567/4569
  .label VICIII = $d000
  // The VIC IV
  .label VICIV = $d000
  // Palette RED
  .label PALETTE_RED = $d100
  // Palette GREEN
  .label PALETTE_GREEN = $d200
  // Palette BLUE
  .label PALETTE_BLUE = $d300
  // The CIA#1: keyboard matrix, joystick #1/#2
  .label CIA1 = $dc00
  // The vector used when the HARDWARE serves IRQ interrupts
  .label HARDWARE_IRQ = $fffe
  .label SCREEN = $400
  // Pointer to the song init routine
  .label songInit = SONG
  // Pointer to the song play routine
  .label songPlay = SONG+3
  // Sinus Position
  .label sinpos = 6
  // Zoom Position
  .label zoomx = 7
  // soft scroll position of text scrolly (0-7)
  .label xpos = 8
  // The greeting currently being shown
  .label greetnm = 9
.segment Code
__start: {
    // sinpos
    lda #0
    sta.z sinpos
    // zoomx
    sta.z zoomx
    // xpos = 7
    lda #7
    sta.z xpos
    // greetnm
    lda #0
    sta.z greetnm
    jsr main
    rts
}
// BIG INTERRUPT LOOP
irq1: {
    // y rasterline where scrolly starts
    .const scrollypos = $66
    // size of raster behind scrolly
    .const blackbar = $13
    .label barsin = 3
    .label barcnt = 2
    pha
    txa
    pha
    tya
    pha
    // VICIV->RASLINE0 |= 0x80
    // force NTSC every frame (hehe)
    lda #$80
    ora VICIV+OFFSET_STRUCT_MEGA65_VICIV_RASLINE0
    sta VICIV+OFFSET_STRUCT_MEGA65_VICIV_RASLINE0
    // VICII->IRQ_STATUS = IRQ_RASTER
    // Acknowledge the IRQ
    lda #IRQ_RASTER
    sta VICII+OFFSET_STRUCT_MOS6569_VICII_IRQ_STATUS
    // VICII->CONTROL2 = 0
    // reset x scroll
    lda #0
    sta VICII+OFFSET_STRUCT_MOS6569_VICII_CONTROL2
    // wobblepos = ++sinpos
    inc.z sinpos
    // Generate Raster Bars and more
    ldx.z sinpos
    ldz #0
  __b1:
    // for(char line=0;line!=NUMBERL;line++)
    cpz #NUMBERL
    bne __b2
    ldx #0
  // Set all raster bars to black
  __b15:
    // for(char l=0;l!=NUMBERL;l++)
    cpx #NUMBERL
    bne __b16
    // (*songPlay)()
    // play music
    jsr songPlay
    // barsin = sinpos
    // Big block of bars (16)
    lda.z sinpos
    sta.z barsin
    lda #0
    sta.z barcnt
  __b18:
    // for(char barcnt=0; barcnt<16; barcnt++)
    lda.z barcnt
    cmp #$10
    bcc __b19
    ldx #0
  // Produce dark area behind text
  __b25:
    // for(char i=0;i<19;i++)
    cpx #$13
    bcc __b26
    // }
    pla
    tay
    pla
    tax
    pla
    rti
  __b26:
    // rasters[scrollypos+i] /2
    lda rasters+scrollypos,x
    lsr
    // rasters[scrollypos+i] /2 & 7
    and #7
    // rasters[scrollypos+i] = rasters[scrollypos+i] /2 & 7
    sta rasters+scrollypos,x
    // for(char i=0;i<19;i++)
    inx
    jmp __b25
  __b19:
    // idx = SINUS[barsin]
    ldx.z barsin
    ldy SINUS,x
    // barcol = barcnt*16
    lda.z barcnt
    asl
    asl
    asl
    asl
    taz
    ldx #0
  __b20:
    // for(char i=0;i<16;i++)
    cpx #$10
    bcc __b21
    ldx #0
  __b22:
    // for(char i=0;i<15;i++)
    cpx #$f
    bcc __b23
    // barsin += 10
    lda #$a
    clc
    adc.z barsin
    sta.z barsin
    // for(char barcnt=0; barcnt<16; barcnt++)
    inc.z barcnt
    jmp __b18
  __b23:
    // rasters[idx++] = --barcol;
    dez
    // rasters[idx++] = --barcol
    tza
    sta rasters,y
    // rasters[idx++] = --barcol;
    iny
    // for(char i=0;i<15;i++)
    inx
    jmp __b22
  __b21:
    // rasters[idx++] = barcol++
    tza
    sta rasters,y
    // rasters[idx++] = barcol++;
    iny
    inz
    // for(char i=0;i<16;i++)
    inx
    jmp __b20
  __b16:
    // rasters[l] = 0
    lda #0
    sta rasters,x
    // for(char l=0;l!=NUMBERL;l++)
    inx
    jmp __b15
  __b2:
    // col = rasters[line]
    tza
    tay
    lda rasters,y
    // VICIII->BORDER_COLOR = col
    sta VICIII+OFFSET_STRUCT_MOS4569_VICIII_BORDER_COLOR
    // VICIII->BG_COLOR = col
    sta VICIII+OFFSET_STRUCT_MOS4569_VICIII_BG_COLOR
    // if(line < scrollypos)
    cpz #scrollypos
    bcc __b3
    // if(line == scrollypos)
    cpz #scrollypos
    beq __b4
    // if(line == scrollypos+blackbar)
    cpz #scrollypos+blackbar
    beq __b5
    // if(line == scrollypos+blackbar+1)
    cpz #scrollypos+blackbar+1
    bne __b6
    // zoomval = SINUS[zoomx++]
    // if raster position > scrolly pos do zoom
    ldy.z zoomx
    lda SINUS,y
    inc.z zoomx
    // VICIV->CHRXSCL = zoomval
    sta VICIV+OFFSET_STRUCT_MEGA65_VICIV_CHRXSCL
    // zoomval+1
    inc
    // VICIV->TEXTXPOS_LO = zoomval+1
    sta VICIV+OFFSET_STRUCT_MEGA65_VICIV_TEXTXPOS_LO
    // if(zoomx==0)
    lda.z zoomx
    cmp #0
    bne __b6
    // if(++greetnm==GREETCOUNT)
    inc.z greetnm
    lda #GREETCOUNT
    cmp.z greetnm
    bne __b6
    // greetnm =0
    lda #0
    sta.z greetnm
  __b6:
    // raster = VICII->RASTER
    // Wait for the next raster line
    lda VICII+OFFSET_STRUCT_MOS6569_VICII_RASTER
  __b7:
    // while(raster == VICII->RASTER)
    cmp VICII+OFFSET_STRUCT_MOS6569_VICII_RASTER
    beq __b7
    // for(char line=0;line!=NUMBERL;line++)
    inz
    jmp __b1
  __b5:
    // VICIV->TEXTXPOS_LO = 0x50
    // if raster position > scrolly pos do nozoom
    // default value
    lda #$50
    sta VICIV+OFFSET_STRUCT_MEGA65_VICIV_TEXTXPOS_LO
    jmp __b6
  __b4:
    // if raster position = scrolly pos do scrolly
    // no wobbling from this point
    lda #$50
    sta VICIV+OFFSET_STRUCT_MEGA65_VICIV_TEXTXPOS_LO
    // VICII->CONTROL2 = xpos
    // set softscroll
    lda.z xpos
    sta VICII+OFFSET_STRUCT_MOS6569_VICII_CONTROL2
    jmp __b6
  __b3:
    // 0x28 + SINUS[wobblepos++]
    lda #$28
    clc
    adc SINUS,x
    // VICIV->TEXTXPOS_LO = 0x28 + SINUS[wobblepos++]
    // if raster position < scrolly pos do wobble Logo!
    sta VICIV+OFFSET_STRUCT_MEGA65_VICIV_TEXTXPOS_LO
    // VICIV->TEXTXPOS_LO = 0x28 + SINUS[wobblepos++];
    inx
    // VICIV->CHRXSCL = 0x66
    // No zooming
    lda #$66
    sta VICIV+OFFSET_STRUCT_MEGA65_VICIV_CHRXSCL
    jmp __b6
}
main: {
    // VICIII->KEY = 0x47
    // Enable MEGA65 features
    lda #$47
    sta VICIII+OFFSET_STRUCT_MOS4569_VICIII_KEY
    // VICIII->KEY = 0x53
    lda #$53
    sta VICIII+OFFSET_STRUCT_MOS4569_VICIII_KEY
    // VICIV->CONTROLB |= 0x40
    // Enable 48MHz fast mode
    lda #$40
    ora VICIV+OFFSET_STRUCT_MEGA65_VICIV_CONTROLB
    sta VICIV+OFFSET_STRUCT_MEGA65_VICIV_CONTROLB
    // VICIV->CONTROLC |= 0x40
    lda #$40
    ora VICIV+OFFSET_STRUCT_MEGA65_VICIV_CONTROLC
    sta VICIV+OFFSET_STRUCT_MEGA65_VICIV_CONTROLC
    // memset(SCREEN, ' ', 40*25)
  // Clear screen 
    jsr memset
    // asm
    // Initialize music
    lda #0
    // (*songInit)()
    jsr songInit
    ldx #0
  // Put MEGA logo on screen
  __b1:
    // for( char i=0; i<sizeof(MEGA_LOGO); i++)
    cpx #$bc*SIZEOF_BYTE
    bcc __b2
    ldx #0
  __b3:
    // PALETTE_RED[i] = PAL_RED[i]
    lda PAL_RED,x
    sta PALETTE_RED,x
    // PALETTE_GREEN[i] = PAL_GREEN[i]
    lda PAL_GREEN,x
    sta PALETTE_GREEN,x
    // PALETTE_BLUE[i] = PAL_BLUE[i]
    lda PAL_BLUE,x
    sta PALETTE_BLUE,x
    // while(++i!=0)
    inx
    cpx #0
    bne __b3
    // asm
    // Set up raster interrupts C64 style
    sei
    // CIA1->INTERRUPT = CIA_INTERRUPT_CLEAR
    // Disable CIA 1 Timer IRQ
    lda #CIA_INTERRUPT_CLEAR
    sta CIA1+OFFSET_STRUCT_MOS6526_CIA_INTERRUPT
    // VICII->RASTER = 0x16
    // Set raster line to 0x16
    lda #$16
    sta VICII+OFFSET_STRUCT_MOS6569_VICII_RASTER
    // VICII->CONTROL1 &= 0x7f
    lda #$7f
    and VICII+OFFSET_STRUCT_MOS6569_VICII_CONTROL1
    sta VICII+OFFSET_STRUCT_MOS6569_VICII_CONTROL1
    // VICII->IRQ_ENABLE = IRQ_RASTER
    // Enable Raster Interrupt
    lda #IRQ_RASTER
    sta VICII+OFFSET_STRUCT_MOS6569_VICII_IRQ_ENABLE
    // *HARDWARE_IRQ = &irq1
    // Set the IRQ routine
    lda #<irq1
    sta HARDWARE_IRQ
    lda #>irq1
    sta HARDWARE_IRQ+1
    // *PROCPORT_DDR = PROCPORT_DDR_MEMORY_MASK
    // no kernal or BASIC rom visible
    lda #PROCPORT_DDR_MEMORY_MASK
    sta PROCPORT_DDR
    // *PROCPORT = PROCPORT_RAM_IO
    lda #PROCPORT_RAM_IO
    sta PROCPORT
    // VICIV->SIDBDRWD_LO = 1
    // open sideborder
    lda #1
    sta VICIV+OFFSET_STRUCT_MEGA65_VICIV_SIDBDRWD_LO
    // asm
    // Enable IRQ
    cli
  __b5:
    jmp __b5
  __b2:
    // (SCREEN+3*40)[i] = MEGA_LOGO[i]
    lda MEGA_LOGO,x
    sta SCREEN+3*$28,x
    // for( char i=0; i<sizeof(MEGA_LOGO); i++)
    inx
    jmp __b1
}
// Copies the character c (an unsigned char) to the first num characters of the object pointed to by the argument str.
memset: {
    .const c = ' '
    .const num = $28*$19
    .label str = SCREEN
    .label end = str+num
    .label dst = 4
    lda #<str
    sta.z dst
    lda #>str
    sta.z dst+1
  __b1:
    // for(char* dst = str; dst!=end; dst++)
    lda.z dst+1
    cmp #>end
    bne __b2
    lda.z dst
    cmp #<end
    bne __b2
    // }
    rts
  __b2:
    // *dst = c
    lda #c
    ldy #0
    sta (dst),y
    // for(char* dst = str; dst!=end; dst++)
    inw.z dst
    jmp __b1
}
.segment Data
  // Sinus Values 0-183
SINUS:
.fill 256, 91.5 + 91.5*sin(i*2*PI/256)

  // Moving Raster Bars
  rasters: .fill $100, 0
  // A MEGA logo
  MEGA_LOGO: .byte $20, $20, $20, $20, $20, $cf, $cf, $cf, $20, $cf, $cf, $20, $20, $cf, $cf, $cf, $20, $20, $cf, $cf, $cf, $20, $20, $20, $cf, $cf, $cf, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $cf, $cf, $20, $cf, $cf, $20, $cf, $20, $cf, $20, $20, $20, $cf, $cf, $20, $20, $20, $20, $cf, $cf, $20, $20, $20, $cf, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $cf, $cf, $20, $20, $cf, $20, $cf, $cf, $cf, $cf, $cf, $20, $cf, $cf, $20, $cf, $cf, $cf, $cf, $cf, $20, $20, $20, $cf, $cf, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $cf, $cf, $cf, $20, $20, $20, $cf, $cf, $cf, $20, $20, $20, $20, $cf, $20, $20, $20, $cf, $cf, $cf, $20, $cf, $cf, $cf, $cf, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $cf, $20, $20, $20, $20, $cf, $cf, $20, $cf, $cf, $cf, $20, $20, $cf, $cf, $cf, $20, $20, $cf, $20, $20, $20, $cf
  PAL_RED: .byte 0, $f3, $d4, $b5, $a6, $97, $88, $79, $1a, $fa, $eb, $ec, $bd, $be, $af, $ff, $16, $c6, $a7, $88, $49, $5a, $2b, $1c, $ac, $ad, $8e, $8f, $ff, $ff, $ff, $ff, $c6, $77, $48, $29, $e9, $fa, $cb, $cc, $5d, $4e, $2f, $ff, $ff, $ff, $ff, $ff, $57, $18, $f8, $d9, $aa, $8b, $6c, $5d, $ed, $de, $cf, $ff, $ff, $ff, $ff, $ff, $26, $e6, $b7, $a8, $69, $5a, $3b, $3c, $dc, $cd, $ae, $9f, $ff, $ff, $ff, $ff, $65, $16, $17, $f7, $d8, $b9, $9a, $8b, $2c, $d, $fd, $ee, $cf, $ff, $ff, $ff, $64, $15, 6, $e6, $c7, $a8, $99, $8a, $1b, $c, $fc, $fd, $ee, $cf, $ff, $ff, $12, $d2, $d3, $b4, $95, $86, $77, $78, 9, $69, $ea, $fb, $dc, $ad, $ae, $af, $f0, $c1, $c2, $a3, $84, $85, $76, $67, 8, $f8, $e9, $da, $db, $bc, $bd, $ae, $40, $11, $12, $f2, $e3, $d4, $c5, $c6, $47, $38, $39, $2a, $1b, $c, $d, $ed, 0, 0, $f0, $d1, $c2, $b3, $a4, $95, $36, $27, $28, $29, $f9, $ea, $eb, $ec, $70, $41, $22, $23, $f3, $f4, $e5, $e6, $77, $78, $69, $7a, $3b, $3c, $3d, $3e, $a1, $82, $63, $54, $35, $26, 7, 8, $98, $99, $8a, $7b, $5c, $5d, $3e, $3f, $33, 4, $d4, $d5, $a6, $a7, $88, $89, $1a, $ab, $fb, $ec, $cd, $be, $af, $ff, $b4, $85, $56, $47, $18, 9, $f9, $ea, $7b, $7c, $5d, $5e, $2f, $ef, $ff, $ff, 6, $d6, $a7, $98, $59, $4a, $2b, $2c, $bc, $ad, $8e, $8f, $ff, $ff, $ff, $ff
  PAL_GREEN: .byte 0, $e3, $c4, $b5, $96, $87, $78, $79, $a, $fa, $eb, $dc, $bd, $ae, $af, $ff, $e2, $b3, $a4, $85, $76, $67, $48, $49, $d9, $da, $bb, $bc, $8d, $8e, $7f, $ff, $42, 3, 4, $e4, $d5, $c6, $b7, $a8, $39, $3a, $1b, $2c, $fc, $fd, $de, $df, $61, $32, $13, 4, $e4, $e5, $d6, $d7, $78, $59, $4a, $4b, $2c, $1d, $e, $fe, $e0, $b1, $a2, $93, $74, $75, $56, $57, $e7, $d8, $79, $ca, $ab, $9c, $9d, $8e, $f0, $d1, $c2, $a3, $84, $85, $76, $77, 8, 9, $f9, $fa, $db, $cc, $bd, $ae, $61, $22, $23, $14, $f4, $e5, $d6, $c7, $58, $59, $3a, $3b, $1c, $d, $fd, $fe, $92, $53, $44, $35, $16, $f6, $e7, $e8, $79, $6a, $5b, $4c, $2d, $3e, $1f, $ef, $53, $14, 5, $e5, $c6, $b7, $a8, $99, $2a, $2b, $c, $d, $dd, $ce, $cf, $ff, $f3, $b4, $95, $86, $57, $38, $29, $1a, $ba, $ab, $9c, $8d, $6e, $5f, $ff, $ff, $95, $56, $27, $18, $e8, $d9, $ca, $bb, $4c, $3d, $2e, $1f, $ef, $ff, $ff, $ff, $c5, $86, $57, $38, $19, $a, $ea, $db, $6c, $5d, $3e, $3f, $ef, $ff, $ff, $ff, $65, $26, 7, $e7, $c8, $b9, $9a, $9b, $2c, $1d, $fd, $fe, $cf, $ff, $ff, $ff, $b4, $75, $56, $37, $28, $19, $e9, $ea, $7b, $6c, $5d, $4e, $2f, $ff, $ff, $ff, $c3, $94, $75, $56, $47, $38, $19, $1a, $aa, $ab, $7c, $7d, $5e, $4f, $ff, $ff, $e2, $a3, $94, $85, $76, $67, $38, $49, $d9, $ca, $ab, $bc, $7d, $7e, $6f, $ff
  PAL_BLUE: .byte 0, $f3, $d4, $b5, $a6, $97, $88, $79, $1a, $fa, $eb, $ec, $bd, $be, $af, $ff, 0, 0, 0, 0, $c0, $b1, $a2, $a3, $34, $35, $26, $27, $f7, $f8, $f9, $ea, 0, 0, $30, $11, $22, $13, $14, 5, $b5, $96, $97, $98, $79, $6a, $5b, $4c, $81, $42, $43, $34, 5, 6, $f6, $f7, $78, $69, $5a, $5b, $4c, $3d, $1e, $f, $17, $c7, $a8, $89, $5a, $5b, $3c, $1d, $ad, $9e, $7f, $ff, $ff, $ff, $ff, $ff, $78, 9, $e9, $ca, $ab, $7c, $5d, $5e, $de, $cf, $ff, $ff, $ff, $ff, $ff, $ff, $59, $a, $ca, $bb, $8c, $6d, $3e, $2f, $bf, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $49, $f9, $da, $ab, $7c, $5d, $2e, $2f, $af, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $48, $d8, $b9, $aa, $7b, $5c, $2d, $2e, $be, $9f, $ff, $ff, $ff, $ff, $ff, $ff, 7, $97, $88, $69, $4a, $2b, $1c, $2d, $9d, $7e, $6f, $ff, $ff, $ff, $ff, $ff, $81, $62, $53, $44, 5, 6, $f6, $e7, $78, $69, $5a, $5b, $3c, $2d, $2e, $1f, 0, 0, 0, 0, $b0, $b1, $a2, $b3, $44, $35, $36, $37, 8, $f8, $a, $b, 0, 0, 0, 0, 0, $70, $61, $62, $f2, $e3, $d4, $c5, $b6, $b7, $b8, $99, 0, 0, 0, 0, 0, 0, $f0, $f1, $82, $83, $84, $85, $66, $57, $58, $59, 0, 0, 0, 0, 0, $70, $61, $62, $e2, $e3, $d4, $d5, $b6, $a7, $b8, $a9, 0, 0, 0, 0, $a0, $b1, $a2, $a3, $44, $35, $26, $37, $f7, $19, $f9, $fa
.pc = $fc0 "SONG"
// Music at an absolute address
SONG:
.import c64 "DiscoZak_2SID_patched.prg"

