.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
  .label RASTER = $d012
  .label BGCOL = $d020
  .label SCROLL = $d016
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
    // while(*RASTER!=$fe)
    lda #$fe
    cmp RASTER
    bne __b1
  __b2:
    // while(*RASTER!=$ff)
    lda #$ff
    cmp RASTER
    bne __b2
    // ++*BGCOL;
    inc BGCOL
    // if(--scroll==$ff)
    dex
    cpx #$ff
    bne __b4
    ldx #0
  // Hard scroll
  __b5:
    // for(byte i=0;i!=39;i++)
    cpx #$27
    bne __b6
    // c = *nxt
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
    // *SCROLL = scroll
    stx SCROLL
    // --*BGCOL;
    dec BGCOL
    jmp __b1
  __b6:
    // line[i]=line[i+1]
    lda line+1,x
    sta line,x
    // for(byte i=0;i!=39;i++)
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
    // for( byte* cursor = screen; cursor < screen+1000; cursor++)
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
    // for( byte* cursor = screen; cursor < screen+1000; cursor++)
    inc.z cursor
    bne !+
    inc.z cursor+1
  !:
    jmp __b1
}
  TEXT: .text "-= this is rex of camelot testing a scroller created in kickc. kickc is an optimizing c-compiler for 6502 assembler. =-     "
  .byte 0
