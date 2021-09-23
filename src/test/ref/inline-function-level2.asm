// Inline functions in two levels
  // Commodore 64 PRG executable file
.file [name="inline-function-level2.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .label cur_line = 2
  .label cur_line_1 = 4
.segment Code
main: {
    .const line1_xpos = 2
    .const line1_xadd = $40
    .const line1_ysize = $a
    .const line1_ch = '*'
    .const line2_xpos = 4
    .const line2_xadd = $80
    .const line2_ysize = $f
    .const line2_ch = '.'
    .label sc = 2
    .label line1_pos = 4
    .label line2_pos = 6
    lda #<$400
    sta.z sc
    lda #>$400
    sta.z sc+1
  __b1:
    // for(byte* sc = (byte*)$400;sc<$400+1000;sc++)
    lda.z sc+1
    cmp #>$400+$3e8
    bcc __b2
    bne !+
    lda.z sc
    cmp #<$400+$3e8
    bcc __b2
  !:
    lda #<$400
    sta.z cur_line
    lda #>$400
    sta.z cur_line+1
    lda #<line1_xpos*$100
    sta.z line1_pos
    lda #>line1_xpos*$100
    sta.z line1_pos+1
    ldx #0
  line1___b1:
    // for( byte i=0;i<ysize; i++)
    cpx #line1_ysize
    bcc line1___b2
    lda #<$400
    sta.z cur_line_1
    lda #>$400
    sta.z cur_line_1+1
    lda #<line2_xpos*$100
    sta.z line2_pos
    lda #>line2_xpos*$100
    sta.z line2_pos+1
    ldx #0
  line2___b1:
    // for( byte i=0;i<ysize; i++)
    cpx #line2_ysize
    bcc line2___b2
    // }
    rts
  line2___b2:
    // plot(BYTE1(pos), ch)
    ldy.z line2_pos+1
    // *(cur_line+xpos) = ch
    lda #line2_ch
    sta (cur_line_1),y
    // pos += xadd
    lda #line2_xadd
    clc
    adc.z line2_pos
    sta.z line2_pos
    bcc !+
    inc.z line2_pos+1
  !:
    // cur_line += 40
    lda #$28
    clc
    adc.z cur_line_1
    sta.z cur_line_1
    bcc !+
    inc.z cur_line_1+1
  !:
    // for( byte i=0;i<ysize; i++)
    inx
    jmp line2___b1
  line1___b2:
    // plot(BYTE1(pos), ch)
    lda.z line1_pos+1
    // *(cur_line+xpos) = ch
    tay
    lda #line1_ch
    sta (cur_line),y
    // pos += xadd
    lda #line1_xadd
    clc
    adc.z line1_pos
    sta.z line1_pos
    bcc !+
    inc.z line1_pos+1
  !:
    // cur_line += 40
    lda #$28
    clc
    adc.z cur_line
    sta.z cur_line
    bcc !+
    inc.z cur_line+1
  !:
    // for( byte i=0;i<ysize; i++)
    inx
    jmp line1___b1
  __b2:
    // *sc = ' '
    lda #' '
    ldy #0
    sta (sc),y
    // for(byte* sc = (byte*)$400;sc<$400+1000;sc++)
    inc.z sc
    bne !+
    inc.z sc+1
  !:
    jmp __b1
}
