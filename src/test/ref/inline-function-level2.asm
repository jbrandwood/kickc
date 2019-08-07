// Inline functions in two levels
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label cur_line = 2
  .label cur_line_10 = 6
  .label cur_line_22 = 6
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
    .label line1_pos = 6
    .label line2_pos = 4
    lda #<$400
    sta.z sc
    lda #>$400
    sta.z sc+1
  b2:
    lda #' '
    ldy #0
    sta (sc),y
    inc.z sc
    bne !+
    inc.z sc+1
  !:
    lda.z sc+1
    cmp #>$400+$3e8
    bcc b2
    bne !+
    lda.z sc
    cmp #<$400+$3e8
    bcc b2
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
  line1_b2:
    lda.z line1_pos+1
    tay
    lda #line1_ch
    sta (cur_line),y
    lda #line1_xadd
    clc
    adc.z line1_pos
    sta.z line1_pos
    bcc !+
    inc.z line1_pos+1
  !:
    lda #$28
    clc
    adc.z cur_line
    sta.z cur_line
    bcc !+
    inc.z cur_line+1
  !:
    inx
    cpx #line1_ysize
    bcc line1_b2
    lda #<$400
    sta.z cur_line_22
    lda #>$400
    sta.z cur_line_22+1
    lda #<line2_xpos*$100
    sta.z line2_pos
    lda #>line2_xpos*$100
    sta.z line2_pos+1
    ldx #0
  line2_b2:
    lda.z line2_pos+1
    tay
    lda #line2_ch
    sta (cur_line_22),y
    lda #line2_xadd
    clc
    adc.z line2_pos
    sta.z line2_pos
    bcc !+
    inc.z line2_pos+1
  !:
    lda #$28
    clc
    adc.z cur_line_10
    sta.z cur_line_10
    bcc !+
    inc.z cur_line_10+1
  !:
    inx
    cpx #line2_ysize
    bcc line2_b2
    rts
}
