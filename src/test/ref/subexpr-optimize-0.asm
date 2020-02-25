// Tests optimization of identical sub-expressions
// The two examples of i*2 is detected as identical leading to optimized ASM where *2 is only calculated once
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .label __1 = 4
    .label screen = 2
    lda #<$400
    sta.z screen
    lda #>$400
    sta.z screen+1
    ldx #0
  __b1:
    // i*2
    txa
    asl
    sta.z __1
    // *screen++ = i*2
    ldy #0
    sta (screen),y
    // *screen++ = i*2;
    inc.z screen
    bne !+
    inc.z screen+1
  !:
    // *screen++ = i*2
    lda.z __1
    ldy #0
    sta (screen),y
    // *screen++ = i*2;
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
}
