// Tests optimization of identical sub-expressions
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .label screen = 2
    lda #<$400
    sta.z screen
    lda #>$400
    sta.z screen+1
    ldx #0
  __b1:
    // i&1
    txa
    and #1
    // (i&1)?i+3:i*4
    cmp #0
    bne __b2
    txa
    asl
    asl
  __b4:
    // *screen++ = (i&1)?i+3:i*4
    ldy #0
    sta (screen),y
    // *screen++ = (i&1)?i+3:i*4;
    inc.z screen
    bne !+
    inc.z screen+1
  !:
    // i&1
    txa
    and #1
    // (i&1)?i+3:i*4
    cmp #0
    bne __b5
    txa
    asl
    asl
  __b7:
    // *screen++ = (i&1)?i+3:i*4
    ldy #0
    sta (screen),y
    // *screen++ = (i&1)?i+3:i*4;
    inc.z screen
    bne !+
    inc.z screen+1
  !:
    // for( byte i: 0..2)
    inx
    cpx #3
    bne __b1
    // }
    rts
  __b5:
    // (i&1)?i+3:i*4
    txa
    clc
    adc #3
    jmp __b7
  __b2:
    txa
    clc
    adc #3
    jmp __b4
}
