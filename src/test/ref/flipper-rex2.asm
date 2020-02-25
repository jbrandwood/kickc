.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label RASTER = $d012
  .label SCREEN = $400
main: {
    // prepare()
    jsr prepare
  b1:
    ldx #$19
  __b1:
    // while(*RASTER!=254)
    lda #$fe
    cmp RASTER
    bne __b1
  __b2:
    // while(*RASTER!=255)
    lda #$ff
    cmp RASTER
    bne __b2
    // for( byte c : 25..1)
    dex
    cpx #0
    bne __b1
    // flip()
    jsr flip
    // plot()
    jsr plot
    jmp b1
}
// Plot buffer on screen
plot: {
    .label line = 2
    .label y = 4
    lda #$10
    sta.z y
    lda #<SCREEN+5*$28+$c
    sta.z line
    lda #>SCREEN+5*$28+$c
    sta.z line+1
    ldx #0
  __b1:
    ldy #0
  __b2:
    // for(byte x=0; x<16; x++ )
    cpy #$10
    bcc __b3
    // line = line+40
    lda #$28
    clc
    adc.z line
    sta.z line
    bcc !+
    inc.z line+1
  !:
    // for(byte y : 16..1)
    dec.z y
    lda.z y
    cmp #0
    bne __b1
    // }
    rts
  __b3:
    // line[x] = buffer1[i++]
    lda buffer1,x
    sta (line),y
    // line[x] = buffer1[i++];
    inx
    // for(byte x=0; x<16; x++ )
    iny
    jmp __b2
}
// Flip buffer
flip: {
    .label c = 5
    .label r = 4
    lda #$10
    sta.z r
    ldx #$f
    ldy #0
  __b1:
    lda #$10
    sta.z c
  __b2:
    // buffer2[dstIdx] = buffer1[srcIdx++]
    lda buffer1,y
    sta buffer2,x
    // buffer2[dstIdx] = buffer1[srcIdx++];
    iny
    // dstIdx = dstIdx+16
    txa
    axs #-[$10]
    // for( byte c : 16..1)
    dec.z c
    lda.z c
    cmp #0
    bne __b2
    // dstIdx--;
    dex
    // for( byte r : 16..1)
    dec.z r
    lda.z r
    cmp #0
    bne __b1
    ldx #0
  __b4:
    // buffer1[i] = buffer2[i]
    lda buffer2,x
    sta buffer1,x
    // for(byte i : 0..255)
    inx
    cpx #0
    bne __b4
    // }
    rts
}
// Prepare buffer
prepare: {
    ldx #0
  __b1:
    // buffer1[i] = i
    txa
    sta buffer1,x
    // for( byte i : 0..255)
    inx
    cpx #0
    bne __b1
    // }
    rts
}
  buffer1: .fill $10*$10, 0
  buffer2: .fill $10*$10, 0
