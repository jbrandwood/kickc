// Test that plus creates the expected type for all legal combinations of bytes (signed/unsigned - constant/variable)
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
  .label SSCREEN = $400
  .const TYPEID_BYTE = 1
  .const TYPEID_SIGNED_BYTE = 2
main: {
    jsr testUnsigned
    jsr testUnsignedVals
    jsr testSigned
    jsr testSignedVals
    rts
}
testSignedVals: {
    .const sbc1 = -$78
    .label sbv1 = 2
    lda #-$78
    sta.z sbv1
    sta SSCREEN+$28*3
    lda #sbc1
    sta SSCREEN+$28*3+1
    lda.z sbv1
    sta SSCREEN+$28*3+1+1
    lda #-$46+-$32
    sta SSCREEN+$28*3+1+1+1
    lda #sbc1+-$78
    sta SSCREEN+$28*3+1+1+1+1
    lda #-$78+sbc1
    sta SSCREEN+$28*3+1+1+1+1+1
    lda #-$78
    clc
    adc.z sbv1
    sta SSCREEN+$28*3+1+1+1+1+1+1
    lda #-$78
    clc
    adc.z sbv1
    sta SSCREEN+$28*3+1+1+1+1+1+1+1
    lda #sbc1
    clc
    adc.z sbv1
    sta SSCREEN+$28*3+1+1+1+1+1+1+1+1
    lda #sbc1
    clc
    adc.z sbv1
    sta SSCREEN+$28*3+1+1+1+1+1+1+1+1+1
    lda.z sbv1
    asl
    sta SSCREEN+$28*3+1+1+1+1+1+1+1+1+1+1
    rts
}
testSigned: {
    .label sbv1 = 3
    lda #-$78
    sta.z sbv1
    lda #0
    sta SCREEN+$28*2
    lda #TYPEID_SIGNED_BYTE
    sta SCREEN+$28*2+1
    sta SCREEN+$28*2+1+1
    lda #0
    sta SCREEN+$28*2+1+1+1
    lda #TYPEID_SIGNED_BYTE
    sta SCREEN+$28*2+1+1+1+1
    sta SCREEN+$28*2+1+1+1+1+1
    sta SCREEN+$28*2+1+1+1+1+1+1
    sta SCREEN+$28*2+1+1+1+1+1+1+1
    sta SCREEN+$28*2+1+1+1+1+1+1+1+1
    sta SCREEN+$28*2+1+1+1+1+1+1+1+1+1
    sta SCREEN+$28*2+1+1+1+1+1+1+1+1+1+1
    rts
}
testUnsignedVals: {
    .const ubc1 = $fa
    .label ubv1 = 4
    lda #$fa
    sta.z ubv1
    sta SCREEN+$28
    lda #ubc1
    sta SCREEN+$29
    lda.z ubv1
    sta SCREEN+$2a
    lda #$78+$82
    sta SCREEN+$2b
    lda #ubc1+$fa
    sta SCREEN+$2c
    lda #$fa+ubc1
    sta SCREEN+$2d
    lax.z ubv1
    axs #-[$fa]
    stx SCREEN+$2e
    lax.z ubv1
    axs #-[$fa]
    stx SCREEN+$2f
    lda #ubc1
    clc
    adc.z ubv1
    sta SCREEN+$30
    lda #ubc1
    clc
    adc.z ubv1
    sta SCREEN+$31
    lda.z ubv1
    asl
    sta SCREEN+$32
    rts
}
testUnsigned: {
    .label ubv1 = 5
    lda #$fa
    sta.z ubv1
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
