// Test that plus creates the expected type for all legal combinations of bytes (signed/unsigned - constant/variable)
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .const TYPEID_BYTE = 1
  .const TYPEID_SIGNED_BYTE = 2
  .label SCREEN = $400
  .label SSCREEN = $400
main: {
    jsr testUnsigned
    jsr testUnsignedVals
    jsr testSigned
    jsr testSignedVals
    rts
}
testSignedVals: {
    .const sbc1 = -$78
    .label sbv1 = 5
    lda #-$78
    sta sbv1
    sta SSCREEN+$b+$28+1+1+1+1+1+1+1+1+1+1+1+$28+1+1+1+1+1+1+1+1+1+1+1+$28
    lda #sbc1
    sta SSCREEN+$b+$28+1+1+1+1+1+1+1+1+1+1+1+$28+1+1+1+1+1+1+1+1+1+1+1+$28+1
    lda sbv1
    sta SSCREEN+$b+$28+1+1+1+1+1+1+1+1+1+1+1+$28+1+1+1+1+1+1+1+1+1+1+1+$28+1+1
    lda #-$46+-$32
    sta SSCREEN+$b+$28+1+1+1+1+1+1+1+1+1+1+1+$28+1+1+1+1+1+1+1+1+1+1+1+$28+1+1+1
    lda #sbc1+-$78
    sta SSCREEN+$b+$28+1+1+1+1+1+1+1+1+1+1+1+$28+1+1+1+1+1+1+1+1+1+1+1+$28+1+1+1+1
    lda #-$78+sbc1
    sta SSCREEN+$b+$28+1+1+1+1+1+1+1+1+1+1+1+$28+1+1+1+1+1+1+1+1+1+1+1+$28+1+1+1+1+1
    lda #-$78
    clc
    adc sbv1
    sta SSCREEN+$b+$28+1+1+1+1+1+1+1+1+1+1+1+$28+1+1+1+1+1+1+1+1+1+1+1+$28+1+1+1+1+1+1
    lda #-$78
    clc
    adc sbv1
    sta SSCREEN+$b+$28+1+1+1+1+1+1+1+1+1+1+1+$28+1+1+1+1+1+1+1+1+1+1+1+$28+1+1+1+1+1+1+1
    lda #sbc1
    clc
    adc sbv1
    sta SSCREEN+$b+$28+1+1+1+1+1+1+1+1+1+1+1+$28+1+1+1+1+1+1+1+1+1+1+1+$28+1+1+1+1+1+1+1+1
    lda #sbc1
    clc
    adc sbv1
    sta SSCREEN+$b+$28+1+1+1+1+1+1+1+1+1+1+1+$28+1+1+1+1+1+1+1+1+1+1+1+$28+1+1+1+1+1+1+1+1+1
    lda sbv1
    asl
    sta SSCREEN+$b+$28+1+1+1+1+1+1+1+1+1+1+1+$28+1+1+1+1+1+1+1+1+1+1+1+$28+1+1+1+1+1+1+1+1+1+1
    rts
}
testSigned: {
    .label sbv1 = 4
    lda #-$78
    sta sbv1
    lda #0
    sta SCREEN+$b+$28+1+1+1+1+1+1+1+1+1+1+1+$28
    lda #TYPEID_SIGNED_BYTE
    sta SCREEN+$b+$28+1+1+1+1+1+1+1+1+1+1+1+$28+1
    sta SCREEN+$b+$28+1+1+1+1+1+1+1+1+1+1+1+$28+1+1
    lda #0
    sta SCREEN+$b+$28+1+1+1+1+1+1+1+1+1+1+1+$28+1+1+1
    lda #TYPEID_SIGNED_BYTE
    sta SCREEN+$b+$28+1+1+1+1+1+1+1+1+1+1+1+$28+1+1+1+1
    sta SCREEN+$b+$28+1+1+1+1+1+1+1+1+1+1+1+$28+1+1+1+1+1
    sta SCREEN+$b+$28+1+1+1+1+1+1+1+1+1+1+1+$28+1+1+1+1+1+1
    sta SCREEN+$b+$28+1+1+1+1+1+1+1+1+1+1+1+$28+1+1+1+1+1+1+1
    sta SCREEN+$b+$28+1+1+1+1+1+1+1+1+1+1+1+$28+1+1+1+1+1+1+1+1
    sta SCREEN+$b+$28+1+1+1+1+1+1+1+1+1+1+1+$28+1+1+1+1+1+1+1+1+1
    sta SCREEN+$b+$28+1+1+1+1+1+1+1+1+1+1+1+$28+1+1+1+1+1+1+1+1+1+1
    rts
}
testUnsignedVals: {
    .const ubc1 = $fa
    .label ubv1 = 3
    lda #$fa
    sta ubv1
    sta SCREEN+$b+$28
    lda #ubc1
    sta SCREEN+$b+$28+1
    lda ubv1
    sta SCREEN+$b+$28+1+1
    lda #$78+$82
    sta SCREEN+$b+$28+1+1+1
    lda #ubc1+$fa
    sta SCREEN+$b+$28+1+1+1+1
    lda #$fa+ubc1
    sta SCREEN+$b+$28+1+1+1+1+1
    lax ubv1
    axs #-[$fa]
    stx SCREEN+$b+$28+1+1+1+1+1+1
    lax ubv1
    axs #-[$fa]
    stx SCREEN+$b+$28+1+1+1+1+1+1+1
    lda #ubc1
    clc
    adc ubv1
    sta SCREEN+$b+$28+1+1+1+1+1+1+1+1
    lda #ubc1
    clc
    adc ubv1
    sta SCREEN+$b+$28+1+1+1+1+1+1+1+1+1
    lda ubv1
    asl
    sta SCREEN+$b+$28+1+1+1+1+1+1+1+1+1+1
    rts
}
testUnsigned: {
    .label ubv1 = 2
    lda #$fa
    sta ubv1
    lda #0
    sta SCREEN
    lda #TYPEID_BYTE
    sta SCREEN+1
    sta SCREEN+2
    lda #0
    sta SCREEN+3
    lda #TYPEID_BYTE
    sta SCREEN+4
    sta SCREEN+5
    sta SCREEN+6
    sta SCREEN+7
    sta SCREEN+8
    sta SCREEN+9
    sta SCREEN+$a
    rts
}
