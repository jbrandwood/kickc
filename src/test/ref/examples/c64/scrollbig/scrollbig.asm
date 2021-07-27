// An 8x8 char letter scroller
/// @file
/// Commodore 64 Registers and Constants
/// @file
/// The MOS 6526 Complex Interface Adapter (CIA)
///
/// http://archive.6502.org/datasheets/mos_6526_cia_recreated.pdf
  // Commodore 64 PRG executable file
.file [name="scrollbig.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .const OFFSET_STRUCT_MOS6569_VICII_RASTER = $12
  .const OFFSET_STRUCT_MOS6569_VICII_BG_COLOR = $21
  .const OFFSET_STRUCT_MOS6569_VICII_CONTROL2 = $16
  /// Processor Port Register controlling RAM/ROM configuration and the datasette
  .label PROCPORT = 1
  /// The address of the CHARGEN character set
  .label CHARGEN = $d000
  /// The VIC-II MOS 6567/6569
  .label VICII = $d000
  .label SCREEN = $400
  .label current_bit = 2
  // Scroll the next bit from the current char onto the screen - trigger next char if needed
  .label current_chargen = 3
  .label nxt = 7
.segment Code
main: {
    // fillscreen(SCREEN, $20)
    jsr fillscreen
    lda #<CHARGEN
    sta.z current_chargen
    lda #>CHARGEN
    sta.z current_chargen+1
    lda #<TEXT
    sta.z nxt
    lda #>TEXT
    sta.z nxt+1
    lda #1
    sta.z current_bit
    ldx #7
  // Wait for raster
  __b1:
    // while(VICII->RASTER!=$fe)
    lda #$fe
    cmp VICII+OFFSET_STRUCT_MOS6569_VICII_RASTER
    bne __b1
  __b2:
    // while(VICII->RASTER!=$ff)
    lda #$ff
    cmp VICII+OFFSET_STRUCT_MOS6569_VICII_RASTER
    bne __b2
    // ++VICII->BG_COLOR;
    inc VICII+OFFSET_STRUCT_MOS6569_VICII_BG_COLOR
    // scroll_soft()
    jsr scroll_soft
    // --VICII->BG_COLOR;
    dec VICII+OFFSET_STRUCT_MOS6569_VICII_BG_COLOR
    jmp __b1
}
// Fill the screen with one char
fillscreen: {
    .const fill = $20
    .label cursor = 3
    lda #<SCREEN
    sta.z cursor
    lda #>SCREEN
    sta.z cursor+1
  __b1:
    // for( char* cursor = screen; cursor < screen+1000; cursor++)
    lda.z cursor+1
    cmp #>SCREEN+$3e8
    bcc __b2
    bne !+
    lda.z cursor
    cmp #<SCREEN+$3e8
    bcc __b2
  !:
    // }
    rts
  __b2:
    // *cursor = fill
    lda #fill
    ldy #0
    sta (cursor),y
    // for( char* cursor = screen; cursor < screen+1000; cursor++)
    inc.z cursor
    bne !+
    inc.z cursor+1
  !:
    jmp __b1
}
scroll_soft: {
    // if(--scroll==$ff)
    dex
    cpx #$ff
    bne __b1
    // scroll_bit()
    jsr scroll_bit
    ldx #7
  __b1:
    // VICII->CONTROL2 = scroll
    stx VICII+OFFSET_STRUCT_MOS6569_VICII_CONTROL2
    // }
    rts
}
scroll_bit: {
    .label __7 = 3
    .label c = 3
    .label sc = 5
    // current_bit = current_bit/2
    lsr.z current_bit
    // if(current_bit==0)
    lda.z current_bit
    bne __b1
    // unsigned int c = next_char()
    jsr next_char
    txa
    sta.z c
    lda #0
    sta.z c+1
    // c*8
    asl.z __7
    rol.z __7+1
    asl.z __7
    rol.z __7+1
    asl.z __7
    rol.z __7+1
    // current_chargen = CHARGEN+c*8
    lda.z current_chargen
    clc
    adc #<CHARGEN
    sta.z current_chargen
    lda.z current_chargen+1
    adc #>CHARGEN
    sta.z current_chargen+1
    lda #$80
    sta.z current_bit
  __b1:
    // scroll_hard()
    jsr scroll_hard
    // asm
    sei
    // *PROCPORT = $32
    lda #$32
    sta PROCPORT
    lda #<SCREEN+$28+$27
    sta.z sc
    lda #>SCREEN+$28+$27
    sta.z sc+1
    ldx #0
  __b3:
    // char bits = current_chargen[r]
    txa
    tay
    lda (current_chargen),y
    // bits & current_bit
    and.z current_bit
    // if((bits & current_bit) != 0)
    cmp #0
    beq __b2
    lda #$80+' '
    jmp __b4
  __b2:
    lda #' '
  __b4:
    // *sc = b
    ldy #0
    sta (sc),y
    // sc = sc+40
    lda #$28
    clc
    adc.z sc
    sta.z sc
    bcc !+
    inc.z sc+1
  !:
    // for(char r:0..7)
    inx
    cpx #8
    bne __b3
    // *PROCPORT = $37
    lda #$37
    sta PROCPORT
    // asm
    cli
    // }
    rts
}
// Find the next char of the scroll text
next_char: {
    // char c = *nxt
    ldy #0
    lda (nxt),y
    tax
    // if(c==0)
    cpx #0
    bne __b1
    // c = *nxt
    ldx TEXT
    lda #<TEXT
    sta.z nxt
    lda #>TEXT
    sta.z nxt+1
  __b1:
    // nxt++;
    inc.z nxt
    bne !+
    inc.z nxt+1
  !:
    // }
    rts
}
scroll_hard: {
    ldx #0
  // Hard scroll
  __b1:
    // for(char i=0;i!=39;i++)
    cpx #$27
    bne __b2
    // }
    rts
  __b2:
    // (SCREEN+40*0)[i]=(SCREEN+40*0)[i+1]
    lda SCREEN+1,x
    sta SCREEN,x
    // (SCREEN+40*1)[i]=(SCREEN+40*1)[i+1]
    lda SCREEN+$28*1+1,x
    sta SCREEN+$28*1,x
    // (SCREEN+40*2)[i]=(SCREEN+40*2)[i+1]
    lda SCREEN+$28*2+1,x
    sta SCREEN+$28*2,x
    // (SCREEN+40*3)[i]=(SCREEN+40*3)[i+1]
    lda SCREEN+$28*3+1,x
    sta SCREEN+$28*3,x
    // (SCREEN+40*4)[i]=(SCREEN+40*4)[i+1]
    lda SCREEN+$28*4+1,x
    sta SCREEN+$28*4,x
    // (SCREEN+40*5)[i]=(SCREEN+40*5)[i+1]
    lda SCREEN+$28*5+1,x
    sta SCREEN+$28*5,x
    // (SCREEN+40*6)[i]=(SCREEN+40*6)[i+1]
    lda SCREEN+$28*6+1,x
    sta SCREEN+$28*6,x
    // (SCREEN+40*7)[i]=(SCREEN+40*7)[i+1]
    lda SCREEN+$28*7+1,x
    sta SCREEN+$28*7,x
    // for(char i=0;i!=39;i++)
    inx
    jmp __b1
}
.segment Data
  TEXT: .text "-= this is rex of camelot testing a scroller created in kickc. kickc is an optimizing c-compiler for 6502 assembler. =-     "
  .byte 0
