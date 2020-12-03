// Demonstrates problem where reserved ZP addresses can still be coalesced if they are explicitly __address() assigned to variables
// https://gitlab.com/camelot/kickc/-/issues/550
  // Atari XL/XE executable XEX file with a single segment
// https://www.atarimax.com/jindroush.atari.org/afmtexe.html
.plugin "dk.camelot64.kickass.xexplugin.AtariXex"
.file [name="zp-reserve-coalesce-problem.xex", type="bin", segments="XexFile"]
.segmentdef XexFile [segments="Program", modify="XexFormat", _RunAddr=main]
.segmentdef Program [segments="Code, Data"]
.segmentdef Code [start=$2000]
.segmentdef Data [startAfter="Code"]
  .label lms = $a000
.segment Code
main: {
    // benchmarkCountdownFor()
    jsr benchmarkCountdownFor
    // benchmarkLandscape()
    jsr benchmarkLandscape
    // }
    rts
}
benchmarkCountdownFor: {
    .label a = $41
    .label b = $4b
    // a
    lda #0
    sta.z a
    // b
    sta.z b
    // a = 1
    lda #1
    sta.z a
  __b1:
    // for(a = 1; a >= 0; a--)
    lda.z a
    cmp #0
    bpl __b2
    // }
    rts
  __b2:
    // b = 9
    lda #9
    sta.z b
  __b3:
    // for(b = 9; b >= 0; b--)
    lda.z b
    cmp #0
    bpl __b4
    // for(a = 1; a >= 0; a--)
    dec.z a
    jmp __b1
  __b4:
    // for(b = 9; b >= 0; b--)
    dec.z b
    jmp __b3
}
benchmarkLandscape: {
    .label __5 = $86
    .label screenAddress = $83
    .label z = $80
    .label stop = $85
    .label x = $81
    .label c = $82
    lda #0
    sta.z z
  __b1:
    ldx #0
  __b2:
    // colHeight[i] = landscapeBase[i]
    lda landscapeBase,x
    sta colHeight,x
    // for (char i: 0..13)
    inx
    cpx #$e
    bne __b2
    lda #$27
    sta.z x
  __b3:
    // for (signed char x = 39; x >= 0; x--)
    lda.z x
    cmp #0
    bpl __b4
    // for(char z: 0..9)
    inc.z z
    lda #$a
    cmp.z z
    bne __b1
    // }
    rts
  __b4:
    // screenAddress = lms + x
    lda.z x
    clc
    adc #<lms
    sta.z screenAddress
    lda.z x
    ora #$7f
    bmi !+
    lda #0
  !:
    adc #>lms
    sta.z screenAddress+1
    ldx #0
    lda #$d
    sta.z c
  __b6:
    // for (signed char c = 13; c >= 0; c--)
    lda.z c
    cmp #0
    bpl __b7
    // for (signed char x = 39; x >= 0; x--)
    dec.z x
    jmp __b3
  __b7:
    // stop = colHeight[uc]
    ldy.z c
    lda colHeight,y
    sta.z stop
  __b9:
    // while (start < stop)
    cpx.z stop
    bcc __b10
    // for (signed char c = 13; c >= 0; c--)
    dec.z c
    ldx.z stop
    jmp __b6
  __b10:
    // (*screenAddress) & 0xf
    lda #$f
    ldy #0
    and (screenAddress),y
    sta.z __5
    // uc << 4
    lda.z c
    asl
    asl
    asl
    asl
    // ((*screenAddress) & 0xf) | (uc << 4)
    ora.z __5
    // *screenAddress = ((*screenAddress) & 0xf) | (uc << 4)
    sta (screenAddress),y
    // screenAddress += 40
    lda #$28
    clc
    adc.z screenAddress
    sta.z screenAddress
    bcc !+
    inc.z screenAddress+1
  !:
    // start++;
    inx
    jmp __b9
  .segment Data
    colHeight: .fill $e, 0
}
landscapeBase:
.fill 14, 0
	
