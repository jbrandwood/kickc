// An 8x8 char letter scroller
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label PROCPORT = 1
  .label CHARGEN = $d000
  .label SCREEN = $400
  .label RASTER = $d012
  .label BGCOL = $d020
  .label SCROLL = $d016
  // Soft-scroll using $d016 - trigger bit-scroll/char-scroll when needed
  .label scroll = 2
  .label current_bit = 3
  // Scroll the next bit from the current char onto the screen - trigger next char if needed
  .label current_chargen = 4
  .label nxt = 6
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
    lda #7
    sta.z scroll
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
    // scroll_soft()
    jsr scroll_soft
    // --*BGCOL;
    dec BGCOL
    jmp __b1
}
scroll_soft: {
    // if(--scroll==$ff)
    dec.z scroll
    lda #$ff
    cmp.z scroll
    bne __b1
    // scroll_bit()
    jsr scroll_bit
    lda #7
    sta.z scroll
  __b1:
    // *SCROLL = scroll
    lda.z scroll
    sta SCROLL
    // }
    rts
}
scroll_bit: {
    .label __7 = 4
    .label c = 4
    .label sc = 8
    // current_bit = current_bit/2
    lsr.z current_bit
    // if(current_bit==0)
    lda.z current_bit
    cmp #0
    bne __b1
    // next_char()
    jsr next_char
    txa
    // c = next_char()
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
    clc
    lda.z current_chargen
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
    // bits = current_chargen[r]
    txa
    tay
    lda (current_chargen),y
    // bits & current_bit
    and.z current_bit
    // if((bits & current_bit) != 0)
    cmp #0
    beq b1
    lda #$80+' '
    jmp __b4
  b1:
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
    // for(byte r:0..7)
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
scroll_hard: {
    ldx #0
  // Hard scroll
  __b1:
    // for(byte i=0;i!=39;i++)
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
    // for(byte i=0;i!=39;i++)
    inx
    jmp __b1
}
// Find the next char of the scroll text
next_char: {
    // c = *nxt
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
// Fill the screen with one char
fillscreen: {
    .const fill = $20
    .label cursor = 8
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
