// Tests optimization of identical sub-expressions
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .label screen = 3
    .label i = 2
    lda #<$400
    sta.z screen
    lda #>$400
    sta.z screen+1
    lda #0
    sta.z i
  __b1:
    // i+1
    lda.z i
    clc
    adc #1
    // (i+1)*2
    asl
    // *screen++ = (i+1)*2
    ldy #0
    sta (screen),y
    // *screen++ = (i+1)*2;
    inc.z screen
    bne !+
    inc.z screen+1
  !:
    // i+1
    lda.z i
    clc
    adc #1
    // (i+1)*2
    asl
    // *screen++ = (i+1)*2
    ldy #0
    sta (screen),y
    // *screen++ = (i+1)*2;
    inc.z screen
    bne !+
    inc.z screen+1
  !:
    // for( byte i: 0..2)
    inc.z i
    lda #3
    cmp.z i
    bne __b1
    // }
    rts
}
