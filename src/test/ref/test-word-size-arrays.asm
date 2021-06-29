  // Commodore 64 PRG executable file
.file [name="test-word-size-arrays.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
.segment Code
main: {
    .label screen = $400
    .label __4 = 6
    .label __6 = 4
    .label line = 2
    .label __7 = 8
    .label __8 = 6
    .label __9 = 4
    lda #<0
    sta.z line
    sta.z line+1
  __b1:
    // for (line = 0; line < 40*24; line += 40)
    lda.z line+1
    cmp #>$28*$18
    bcc __b4
    bne !+
    lda.z line
    cmp #<$28*$18
    bcc __b4
  !:
    ldx #0
  // Cleare the bottom line
  __b5:
    // for (byte c=0; c<40; ++c)
    cpx #$28
    bcc __b6
    // }
    rts
  __b6:
    // line+c
    txa
    clc
    adc.z line
    sta.z __6
    lda #0
    adc.z line+1
    sta.z __6+1
    // screen[line+c] = ' '
    lda.z __9
    clc
    adc #<screen
    sta.z __9
    lda.z __9+1
    adc #>screen
    sta.z __9+1
    lda #' '
    ldy #0
    sta (__9),y
    // for (byte c=0; c<40; ++c)
    inx
    jmp __b5
  __b4:
    ldx #0
  __b2:
    // for (byte c=0; c<40; ++c)
    cpx #$28
    bcc __b3
    // line += 40
    lda #$28
    clc
    adc.z line
    sta.z line
    bcc !+
    inc.z line+1
  !:
    jmp __b1
  __b3:
    // line+c
    txa
    clc
    adc.z line
    sta.z __4
    lda #0
    adc.z line+1
    sta.z __4+1
    // screen[line+c] = screen[line+c+40]
    lda.z __4
    clc
    adc #<screen+$28
    sta.z __7
    lda.z __4+1
    adc #>screen+$28
    sta.z __7+1
    lda.z __8
    clc
    adc #<screen
    sta.z __8
    lda.z __8+1
    adc #>screen
    sta.z __8+1
    ldy #0
    lda (__7),y
    sta (__8),y
    // for (byte c=0; c<40; ++c)
    inx
    jmp __b2
}
