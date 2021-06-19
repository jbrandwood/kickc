/// @file
/// @brief Commodore 64 Registers and Constants
/// @file
/// @brief The MOS 6526 Complex Interface Adapter (CIA)
///
/// http://archive.6502.org/datasheets/mos_6526_cia_recreated.pdf
  // Commodore 64 PRG executable file
.file [name="scroll.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .const OFFSET_STRUCT_MOS6569_VICII_RASTER = $12
  .const OFFSET_STRUCT_MOS6569_VICII_BG_COLOR = $21
  .const OFFSET_STRUCT_MOS6569_VICII_CONTROL2 = $16
  /// The VIC-II MOS 6567/6569
  .label VICII = $d000
  .label SCREEN = $400
.segment Code
main: {
    .label line = SCREEN+$28
    .label nxt = 2
    // fillscreen(SCREEN, $20)
    jsr fillscreen
    lda #<TEXT
    sta.z nxt
    lda #>TEXT
    sta.z nxt+1
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
    // if(--scroll==$ff)
    dex
    cpx #$ff
    bne __b4
    ldx #0
  // Hard scroll
  __b5:
    // for(char i=0;i!=39;i++)
    cpx #$27
    bne __b6
    // char c = *nxt
    // Render next char
    ldy #0
    lda (nxt),y
    tax
    // if(c==0)
    cpx #0
    bne __b9
    // c = *nxt
    ldx TEXT
    lda #<TEXT
    sta.z nxt
    lda #>TEXT
    sta.z nxt+1
  __b9:
    // line[39] = c
    stx line+$27
    // nxt++;
    inc.z nxt
    bne !+
    inc.z nxt+1
  !:
    ldx #7
  __b4:
    // VICII->CONTROL2 = scroll
    stx VICII+OFFSET_STRUCT_MOS6569_VICII_CONTROL2
    // --VICII->BG_COLOR;
    dec VICII+OFFSET_STRUCT_MOS6569_VICII_BG_COLOR
    jmp __b1
  __b6:
    // line[i]=line[i+1]
    lda line+1,x
    sta line,x
    // for(char i=0;i!=39;i++)
    inx
    jmp __b5
}
fillscreen: {
    .const fill = $20
    .label cursor = 4
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
.segment Data
  TEXT: .text "-= this is rex of camelot testing a scroller created in kickc. kickc is an optimizing c-compiler for 6502 assembler. =-     "
  .byte 0
