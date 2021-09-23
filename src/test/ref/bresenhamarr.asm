  // Commodore 64 PRG executable file
.file [name="bresenhamarr.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
.segment Code
main: {
    .const STAR = $51
    .const x0 = 0
    .const y0 = 0
    .const x1 = $27
    .const y1 = $18
    .label screen = $400
    .label x = 7
    .label idx = 2
    .label y = 4
    .label __15 = 5
    lda #y0
    sta.z y
    ldx #y1/2
    lda #x0
    sta.z x
    lda #<0
    sta.z idx
    sta.z idx+1
  __b1:
    // screen[idx] = STAR
    lda.z idx
    clc
    adc #<screen
    sta.z __15
    lda.z idx+1
    adc #>screen
    sta.z __15+1
    lda #STAR
    ldy #0
    sta (__15),y
    // x = x + 1
    inc.z x
    // idx = idx + 1
    inc.z idx
    bne !+
    inc.z idx+1
  !:
    // e = e+yd
    txa
    axs #-[y1]
    // if(xd<e)
    cpx #x1
    bcc __b2
    beq __b2
    // y = y+1
    inc.z y
    // idx  = idx + 40
    lda #$28
    clc
    adc.z idx
    sta.z idx
    bcc !+
    inc.z idx+1
  !:
    // e = e - xd
    txa
    axs #x1
  __b2:
    // while (x<(x1+1))
    lda.z x
    cmp #x1+1
    bcc __b1
    // }
    rts
}
