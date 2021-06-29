  // Commodore 64 PRG executable file
.file [name="bitmap-plotter.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .const BMM = $20
  .const DEN = $10
  .const RSEL = 8
  .const plots_cnt = 8
  .label BITMAP = $2000
  .label D011 = $d011
  .label RASTER = $d012
  .label D018 = $d018
  .label BG_COLOR = $d020
  .label FGCOL = $d021
  .label SCREEN = $400
.segment Code
main: {
    // *BG_COLOR = 0
    lda #0
    sta BG_COLOR
    // *FGCOL = 0
    sta FGCOL
    // *D011 = BMM|DEN|RSEL|3
    lda #BMM|DEN|RSEL|3
    sta D011
    // *D018 = (byte)(((word)SCREEN/$40)|((word)BITMAP/$400))
    lda #SCREEN/$40|BITMAP/$400
    sta D018
    // init_screen()
    jsr init_screen
    // init_plot_tables()
    jsr init_plot_tables
  __b1:
    // while (*RASTER!=$ff)
    lda #$ff
    cmp RASTER
    bne __b1
    // (*BG_COLOR)++;
    inc BG_COLOR
    // plots()
    jsr plots
    // (*BG_COLOR)--;
    dec BG_COLOR
    jmp __b1
}
init_screen: {
    .label b = 6
    .label c = 4
    lda #<BITMAP
    sta.z b
    lda #>BITMAP
    sta.z b+1
  __b1:
    // for(byte* b = BITMAP; b!=BITMAP+$2000; b++)
    lda.z b+1
    cmp #>BITMAP+$2000
    bne __b2
    lda.z b
    cmp #<BITMAP+$2000
    bne __b2
    lda #<SCREEN
    sta.z c
    lda #>SCREEN
    sta.z c+1
  __b3:
    // for(byte* c = SCREEN; c!=SCREEN+$400;c++)
    lda.z c+1
    cmp #>SCREEN+$400
    bne __b4
    lda.z c
    cmp #<SCREEN+$400
    bne __b4
    // }
    rts
  __b4:
    // *c = $14
    lda #$14
    ldy #0
    sta (c),y
    // for(byte* c = SCREEN; c!=SCREEN+$400;c++)
    inc.z c
    bne !+
    inc.z c+1
  !:
    jmp __b3
  __b2:
    // *b = 0
    lda #0
    tay
    sta (b),y
    // for(byte* b = BITMAP; b!=BITMAP+$2000; b++)
    inc.z b
    bne !+
    inc.z b+1
  !:
    jmp __b1
}
init_plot_tables: {
    .label __9 = 2
    .label yoffs = 6
    ldy #$80
    ldx #0
  __b1:
    // x&$f8
    txa
    and #$f8
    // plot_xlo[x] = x&$f8
    sta plot_xlo,x
    // plot_xhi[x] = BYTE1(BITMAP)
    lda #>BITMAP
    sta plot_xhi,x
    // plot_bit[x] = bits
    tya
    sta plot_bit,x
    // bits = bits/2
    tya
    lsr
    tay
    // if(bits==0)
    cpy #0
    bne __b2
    ldy #$80
  __b2:
    // for(byte x : 0..255)
    inx
    cpx #0
    bne __b1
    lda #<0
    sta.z yoffs
    sta.z yoffs+1
    tax
  __b3:
    // y&$7
    lda #7
    sax.z __9
    // BYTE0(yoffs)
    lda.z yoffs
    // y&$7 | BYTE0(yoffs)
    ora.z __9
    // plot_ylo[y] = y&$7 | BYTE0(yoffs)
    sta plot_ylo,x
    // BYTE1(yoffs)
    lda.z yoffs+1
    // plot_yhi[y] = BYTE1(yoffs)
    sta plot_yhi,x
    // if((y&$7)==7)
    lda #7
    cmp.z __9
    bne __b4
    // yoffs = yoffs + 40*8
    lda.z yoffs
    clc
    adc #<$28*8
    sta.z yoffs
    lda.z yoffs+1
    adc #>$28*8
    sta.z yoffs+1
  __b4:
    // for(byte y : 0..255)
    inx
    cpx #0
    bne __b3
    // }
    rts
}
plots: {
    ldx #0
  __b1:
    // for(byte i=0; i<plots_cnt;i++)
    cpx #plots_cnt
    bcc __b2
    // }
    rts
  __b2:
    // plot(plots_x[i], plots_y[i])
    lda plots_x,x
    sta.z plot.x
    lda plots_y,x
    sta.z plot.y
    jsr plot
    // for(byte i=0; i<plots_cnt;i++)
    inx
    jmp __b1
}
// plot(byte zp(2) x, byte zp(3) y)
plot: {
    .label x = 2
    .label y = 3
    .label plotter_x = 4
    .label plotter_y = 6
    .label plotter = 4
    // BYTE1(plotter_x) = plot_xhi[x]
    ldy.z x
    lda plot_xhi,y
    sta.z plotter_x+1
    lda #<0
    sta.z plotter_x
    // BYTE0(plotter_x) = plot_xlo[x]
    lda plot_xlo,y
    sta.z plotter_x
    // BYTE1(plotter_y) = plot_yhi[y]
    ldy.z y
    lda plot_yhi,y
    sta.z plotter_y+1
    lda #<0
    sta.z plotter_y
    // BYTE0(plotter_y) = plot_ylo[y]
    lda plot_ylo,y
    sta.z plotter_y
    // byte* plotter = plotter_x+plotter_y
    clc
    lda.z plotter
    adc.z plotter_y
    sta.z plotter
    lda.z plotter+1
    adc.z plotter_y+1
    sta.z plotter+1
    // *plotter | plot_bit[x]
    ldy #0
    lda (plotter),y
    ldy.z x
    ora plot_bit,y
    // *plotter = *plotter | plot_bit[x]
    ldy #0
    sta (plotter),y
    // }
    rts
}
.segment Data
  plots_x: .byte $3c, $50, $6e, $50, $3c, $28, $a, $28
  plots_y: .byte $a, $28, $3c, $50, $6e, $50, $3c, $28
  plot_xlo: .fill $100, 0
  plot_xhi: .fill $100, 0
  plot_ylo: .fill $100, 0
  plot_yhi: .fill $100, 0
  plot_bit: .fill $100, 0
