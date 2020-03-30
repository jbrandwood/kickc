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
    // for(byte* line = $400; line<$400+40*25;line+=40 )
    lda.z line+1
    cmp #>$400+$28*$19
    bcc !+
    bne __breturn
    lda.z line
    cmp #<$400+$28*$19
    bcs __breturn
  !:
    // if(*line=='a')
    ldy #0
    lda (line),y
    cmp #'a'
    bne __b2
  __breturn:
    // }
    rts
  __b2:
    ldy #0
  __b3:
    // if(line[i]=='a')
    lda #'a'
    cmp (line),y
    beq __b5
    // line[i] = 'a'
    sta (line),y
    // for( byte i: 0..39)
    iny
    cpy #$28
    bne __b3
  __b5:
    // line+=40
    lda #$28
    clc
    adc.z line
    sta.z line
    bcc !+
    inc.z line+1
  !:
    jmp __b1
}
