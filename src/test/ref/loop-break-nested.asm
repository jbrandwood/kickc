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
  __b1:
    lda.z line+1
    cmp #>$400+$28*$19
    bcc !+
    bne __breturn
    lda.z line
    cmp #<$400+$28*$19
    bcs __breturn
  !:
    ldy #0
    lda (line),y
    cmp #'a'
    bne b1
  __breturn:
    rts
  b1:
    ldy #0
  __b3:
    lda (line),y
    cmp #'a'
    beq __b5
    lda #'a'
    sta (line),y
    iny
    cpy #$28
    bne __b3
  __b5:
    lda #$28
    clc
    adc.z line
    sta.z line
    bcc !+
    inc.z line+1
  !:
    jmp __b1
}
