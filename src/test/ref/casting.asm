  // Commodore 64 PRG executable file
.file [name="casting.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .label SCREEN = $400
  .label SCREEN2 = SCREEN+$28*3
  .label SCREEN3 = SCREEN+$28*6
  .label SCREEN4 = SCREEN+$28*9
.segment Code
main: {
    ldx #0
  __b1:
    // b2 = 200-b
    txa
    eor #$ff
    sec
    adc #$c8
    // SCREEN[b] = b2
    sta SCREEN,x
    // sb = - (signed byte)b
    txa
    eor #$ff
    clc
    adc #1
    // SCREEN2[b] = (byte)sb
    sta SCREEN2,x
    // for( byte b: 0..100)
    inx
    cpx #$65
    bne __b1
    // w()
    jsr w
    // }
    rts
}
w: {
    .const w1 = $514
    .const w2 = $4e2
    .const b = w1-w2
    ldy #0
  __b1:
    // b2 = 1400-1350+i
    tya
    tax
    axs #-[$578-$546]
    // SCREEN3[i] = b
    lda #b
    sta SCREEN3,y
    // SCREEN4[i] = b2
    txa
    sta SCREEN4,y
    // for(byte i : 0..10)
    iny
    cpy #$b
    bne __b1
    // }
    rts
}
