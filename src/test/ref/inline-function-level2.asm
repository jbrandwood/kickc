// Inline functions in two levels
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label cur_line = 2
  .label cur_line_3 = 6
  .label cur_line_10 = 6
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
    sta sc
    lda #>$400
    sta sc+1
  b1:
    lda sc+1
    cmp #>$400+$3e8
    bcc b2
    bne !+
    lda sc
    cmp #<$400+$3e8
    bcc b2
  !:
    lda #<$400
    sta cur_line
    lda #>$400
    sta cur_line+1
    lda #<line1_xpos*$100
    sta line1_pos
    lda #>line1_xpos*$100
    sta line1_pos+1
    ldx #0
  line1_b1:
    cpx #line1_ysize
    bcc line1_b2
    lda #<$400
    sta cur_line_10
    lda #>$400
    sta cur_line_10+1
    lda #<line2_xpos*$100
    sta line2_pos
    lda #>line2_xpos*$100
    sta line2_pos+1
    ldx #0
  line2_b1:
    cpx #line2_ysize
    bcc line2_b2
    rts
  line2_b2:
    lda line2_pos+1
    tay
    lda #line2_ch
    sta (cur_line_10),y
    lda #line2_xadd
    clc
    adc line2_pos
    sta line2_pos
    bcc !+
    inc line2_pos+1
  !:
    lda #$28
    clc
    adc cur_line_3
    sta cur_line_3
    bcc !+
    inc cur_line_3+1
  !:
    inx
    jmp line2_b1
  line1_b2:
    lda line1_pos+1
    tay
    lda #line1_ch
    sta (cur_line),y
    lda #line1_xadd
    clc
    adc line1_pos
    sta line1_pos
    bcc !+
    inc line1_pos+1
  !:
    lda #$28
    clc
    adc cur_line
    sta cur_line
    bcc !+
    inc cur_line+1
  !:
    inx
    jmp line1_b1
  b2:
    lda #' '
    ldy #0
    sta (sc),y
    inc sc
    bne !+
    inc sc+1
  !:
    jmp b1
}
