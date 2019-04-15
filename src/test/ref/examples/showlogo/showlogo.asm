.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label BORDERCOL = $d020
  .label BGCOL = $d021
  .label BGCOL2 = $d022
  .label BGCOL3 = $d023
  .label D016 = $d016
  .const VIC_MCM = $10
  .const VIC_CSEL = 8
  .label D018 = $d018
  // Color Ram
  .label COLS = $d800
  // The colors of the C64
  .const BLACK = 0
  .const WHITE = 1
  .const DARK_GREY = $b
  .label SCREEN = $400
  .label LOGO = $2000
main: {
    .const toD0181_return = (>(SCREEN&$3fff)*4)|(>LOGO)/4&$f
    lda #WHITE
    sta BORDERCOL
    lda #DARK_GREY
    sta BGCOL2
    sta BGCOL
    lda #BLACK
    sta BGCOL3
    lda #toD0181_return
    sta D018
    lda #VIC_MCM|VIC_CSEL
    sta D016
    ldx #BLACK
    lda #<$28*$19
    sta fill.size
    lda #>$28*$19
    sta fill.size+1
    lda #<SCREEN
    sta fill.addr
    lda #>SCREEN
    sta fill.addr+1
    jsr fill
    ldx #WHITE|8
    lda #<$28*$19
    sta fill.size
    lda #>$28*$19
    sta fill.size+1
    lda #<COLS
    sta fill.addr
    lda #>COLS
    sta fill.addr+1
    jsr fill
    ldx #0
  b1:
    txa
    sta SCREEN,x
    inx
    cpx #$f0
    bne b1
  b2:
    inc SCREEN+$3e7
    inc $d020 
    jmp b2
}
// Fill some memory with a value
// fill(word zeropage(2) size, byte register(X) val)
fill: {
    .label end = 2
    .label addr = 4
    .label size = 2
    lda end
    clc
    adc addr
    sta end
    lda end+1
    adc addr+1
    sta end+1
  b1:
    txa
    ldy #0
    sta (addr),y
    inc addr
    bne !+
    inc addr+1
  !:
    lda addr+1
    cmp end+1
    bne b1
    lda addr
    cmp end
    bne b1
    rts
}
.pc = LOGO "LOGO"
  .var logoPic = LoadPicture("logo.png", List().add($444444, $808080, $000000, $ffffff))
    .for (var y=0; y<6	; y++)
        .for (var x=0;x<40; x++)
            .for(var cp=0; cp<8; cp++)
                .byte logoPic.getMulticolorByte(x,cp+y*8)

