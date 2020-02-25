.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label RASTER = $d012
  .label BORDERCOL = $d020
  .label BGCOL = $d021
main: {
    // asm
    sei
  __b1:
    // while (*RASTER!=$a)
    lda #$a
    cmp RASTER
    bne __b1
  __b2:
    // while (*RASTER!=$b)
    lda #$b
    cmp RASTER
    bne __b2
    // raster()
    jsr raster
    jmp __b1
}
raster: {
    // asm
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    // col = rastercols[i]
    lda rastercols
    ldx #0
  __b1:
    // *BGCOL = col
    sta BGCOL
    // *BORDERCOL = col
    sta BORDERCOL
    // col  = rastercols[++i];
    inx
    // col  = rastercols[++i]
    lda rastercols,x
    // asm
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    // while (col!=$ff)
    cmp #$ff
    bne __b1
    // }
    rts
}
  rastercols: .byte $b, 0, $b, $b, $c, $b, $c, $c, $f, $c, $f, $f, 1, $f, 1, 1, $f, 1, $f, $f, $c, $f, $c, $c, $b, $c, $b, $b, 0, $b, 0, $ff
