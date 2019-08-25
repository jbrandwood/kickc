// Tests break statement in a simple loop
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .label line = 2
    lda #<$400
    sta.z line
    lda #>$400
    sta.z line+1
  b1:
    lda.z line+1
    cmp #>$400+$28*$19
    bcc !+
    bne breturn
    lda.z line
    cmp #<$400+$28*$19
    bcs breturn
  !:
    ldy #0
    lda (line),y
    cmp #'a'
    bne b2
  breturn:
    rts
  b2:
    ldy #0
  b3:
    lda (line),y
    cmp #'a'
    beq b5
    lda #'a'
    sta (line),y
    iny
    cpy #$28
    bne b3
  b5:
    lda #$28
    clc
    adc.z line
    sta.z line
    bcc !+
    inc.z line+1
  !:
    jmp b1
}
