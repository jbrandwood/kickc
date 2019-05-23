// Tests break statement in a simple loop
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .label line = 2
    lda #<$400
    sta line
    lda #>$400
    sta line+1
  b1:
    ldy #0
    lda (line),y
    cmp #'a'
    bne b3
  breturn:
    rts
  b3:
    ldy #0
  b2:
    lda (line),y
    cmp #'a'
    beq b4
    lda #'a'
    sta (line),y
    iny
    cpy #$28
    bne b2
  b4:
    lda #$28
    clc
    adc line
    sta line
    bcc !+
    inc line+1
  !:
    lda line+1
    cmp #>$400+$28*$19
    bcc !+
    bne breturn
    lda line
    cmp #<$400+$28*$19
    bcs breturn
  !:
    jmp b1
}
